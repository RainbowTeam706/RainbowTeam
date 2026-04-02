package com.pq.ai.orchestrator;

import com.google.gson.Gson;
import com.pq.ai.config.AIEngineProperties;
import com.pq.ai.dto.GenerateQuestionCommand;
import com.pq.ai.dto.GenerateQuestionResult;
import com.pq.ai.gateway.LLMGateway;
import com.pq.ai.memory.ActivityMemoryService;
import com.pq.ai.memory.LongTermMemoryService;
import com.pq.ai.memory.model.LongTermMemoryItem;
import com.pq.ai.parser.AIQuestionParser;
import com.pq.ai.preprocess.TextPreprocessService;
import com.pq.ai.prompt.PromptTemplateService;
import com.pq.ai.quality.AsyncQuestionQualityService;
import com.pq.dto.doubao.AIQuestionDTO;
import com.pq.entity.QuestionBank;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * AI 出题流程编排器。
 *
 * 该类负责串联完整的质量闭环：
 * 1) 生成题目 -> 2) 质量评估 -> 3) 低分题重写 -> 4) 二次评估。
 *
 * 注意：当前版本不再使用“模板兜底题”，只返回模型真实生成结果。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AIQuestionOrchestrator {

    private final TextPreprocessService textPreprocessService;
    private final PromptTemplateService promptTemplateService;
    private final LLMGateway llmGateway;
    private final ActivityMemoryService activityMemoryService;
    private final LongTermMemoryService longTermMemoryService;
    private final AsyncQuestionQualityService asyncQuestionQualityService;
    private final AIEngineProperties properties;
    private final AIQuestionParser parser;

    private final Gson gson = new Gson();

    /**
     * 执行完整出题流程并返回最终结果。
     */
    public GenerateQuestionResult generate(GenerateQuestionCommand command) {
        long start = System.currentTimeMillis();
        GenerateQuestionResult result = new GenerateQuestionResult();

        log.info("[AI-QGEN] start requestId={}, activityId={}, popQuizId={}, questionCount={}, difficulty={}, topicLength={}",
                command.getRequestId(),
                command.getActivityId(),
                command.getPopQuizId(),
                command.getQuestionCount(),
                command.getDifficulty(),
                command.getTopicText() == null ? 0 : command.getTopicText().length());

        try {
            // 1) 文本预处理（默认始终执行）
            String processedTopic = textPreprocessService.preprocess(command.getTopicText());
            log.info("[AI-QGEN] step=preprocess rawLength={}, processedLength={}",
                    command.getTopicText() == null ? 0 : command.getTopicText().length(),
                    processedTopic.length());

            // 2) 仅当预处理后文本 > 阈值时才截短（阈值配置化）
            int truncateThreshold = properties.getPreprocessTruncateThreshold();
            if (processedTopic.length() > truncateThreshold) {
                processedTopic = textPreprocessService.truncateIfNeeded(processedTopic, truncateThreshold);
                log.info("[AI-QGEN] step=truncate_applied threshold={}, truncatedLength={}", truncateThreshold, processedTopic.length());
            } else {
                log.info("[AI-QGEN] step=truncate_skipped threshold={}, currentLength={}", truncateThreshold, processedTopic.length());
            }

            // 3) 读取短期记忆 + 长期记忆（向量检索 Top-K）
            String shortMemoryContext = activityMemoryService.getMemoryForPrompt(command.getActivityId());
            List<LongTermMemoryItem> longTermTopK = longTermMemoryService.retrieveTopK(processedTopic, properties.getRagTopK());
            String longMemoryContext = longTermMemoryService.buildMemoryContext(longTermTopK);
            String memoryContext = mergeMemory(shortMemoryContext, longMemoryContext);
            log.info("[AI-QGEN] step=load_memory activityId={}, shortMemoryLength={}, longMemoryTopK={}, longMemoryLength={}",
                    command.getActivityId(),
                    shortMemoryContext == null ? 0 : shortMemoryContext.length(),
                    longTermTopK.size(),
                    longMemoryContext == null ? 0 : longMemoryContext.length());

            String prompt = promptTemplateService.buildGeneratePrompt(
                    processedTopic,
                    command.getQuestionCount(),
                    command.getDifficulty(),
                    memoryContext
            );
            log.info("[AI-QGEN] step=build_prompt promptLength={}", prompt == null ? 0 : prompt.length());
            log.debug("[AI-QGEN] promptContent={}", prompt);

            // 2) 调用模型并解析候选题
            String rawContent = llmGateway.generateContent(prompt, command.getQuestionCount());
            log.info("[AI-QGEN] step=llm_generate rawLength={}", rawContent == null ? 0 : rawContent.length());
            log.debug("[AI-QGEN] rawContent={}", rawContent);

            List<AIQuestionDTO> initialQuestions = parser.parse(rawContent);
            log.info("[AI-QGEN] step=parse_initial parsedCount={}", initialQuestions == null ? 0 : initialQuestions.size());

            // 4) 当前极速链路：生成后直接返回，不做同步评分
            List<AIQuestionDTO> finalQuestions = initialQuestions;
            result.setRefinedCount(0);
            result.setInitialValidCount(0);
            result.setAvgQualityScore(0);
            log.info("[AI-QGEN] step=quality_sync_skipped mode=async_only");

            // 5) 转为业务实体（仅保留合法题）
            List<QuestionBank> questionBanks = mapToQuestionBanks(finalQuestions, command.getPopQuizId(), command.getQuestionCount());
            result.setQuestions(questionBanks);
            result.setFallbackUsed(false);
            log.info("[AI-QGEN] step=map_question_bank mappedCount={}", questionBanks.size());

            // 7) 更新短期记忆（activity）
            activityMemoryService.updateMemory(
                    command.getActivityId(),
                    processedTopic,
                    gson.toJson(finalQuestions)
            );
            log.info("[AI-QGEN] step=update_short_memory activityId={}, finalQuestionCount={}",
                    command.getActivityId(), finalQuestions == null ? 0 : finalQuestions.size());

            // 8) 异步评分 + 异步更新长期记忆（全局）
            asyncQuestionQualityService.scoreAndUpdateMemoryAsync(
                    command.getRequestId(),
                    processedTopic,
                    finalQuestions,
                    command.getActivityId(),
                    command.getQuestionCount()
            );
            log.info("[AI-QGEN] step=quality_and_long_memory_async_triggered");
        } catch (Exception e) {
            // 当前策略：不使用伪题兜底，异常时返回空列表，由上层决定提示重试
            log.error("[AI-QGEN] failed requestId={}, activityId={}, popQuizId={}, message={}",
                    command.getRequestId(), command.getActivityId(), command.getPopQuizId(), e.getMessage(), e);
            result.setFallbackUsed(false);
            result.setQuestions(new ArrayList<>());
            result.setAvgQualityScore(0);
        } finally {
            result.setElapsedMs(System.currentTimeMillis() - start);
            log.info("[AI-QGEN] end requestId={}, activityId={}, popQuizId={}, resultCount={}, elapsedMs={}",
                    command.getRequestId(),
                    command.getActivityId(),
                    command.getPopQuizId(),
                    result.getQuestions() == null ? 0 : result.getQuestions().size(),
                    result.getElapsedMs());
        }

        return result;
    }

    /**
     * 将 AI DTO 映射为 QuestionBank。
     * 仅保留格式合法题目（4选1，答案为 A/B/C/D）。
     */
    private List<QuestionBank> mapToQuestionBanks(List<AIQuestionDTO> aiQuestions, Integer popQuizId, int expectedCount) {
        List<QuestionBank> list = new ArrayList<>();
        if (aiQuestions == null) {
            return list;
        }

        for (int i = 0; i < Math.min(aiQuestions.size(), expectedCount); i++) {
            AIQuestionDTO q = aiQuestions.get(i);
            if (q == null || q.getContent() == null || q.getOptions() == null || q.getOptions().size() != 4 || q.getAnswer() == null) {
                continue;
            }
            String answer = q.getAnswer().trim().toUpperCase(Locale.ROOT);
            if (!answer.matches("[ABCD]")) {
                continue;
            }

            QuestionBank question = new QuestionBank()
                    .setPopQuizId(popQuizId)
                    .setContent(q.getContent())
                    .setOptions(gson.toJson(q.getOptions()))
                    .setAnswer(answer);
            list.add(question);
        }
        return list;
    }

    private String mergeMemory(String shortMemory, String longMemory) {
        StringBuilder sb = new StringBuilder();
        if (shortMemory != null && !shortMemory.trim().isEmpty()) {
            sb.append("短期记忆（活动上下文）:\n").append(shortMemory).append("\n\n");
        }
        if (longMemory != null && !longMemory.trim().isEmpty()) {
            sb.append(longMemory);
        }
        return sb.toString().trim();
    }
}
