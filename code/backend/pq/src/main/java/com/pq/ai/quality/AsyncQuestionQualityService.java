package com.pq.ai.quality;

import com.pq.ai.config.AIEngineProperties;
import com.pq.ai.dto.QuestionQualityScore;
import com.pq.ai.memory.LongTermMemoryService;
import com.pq.ai.memory.model.LongTermMemoryItem;
import com.pq.dto.doubao.AIQuestionDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class AsyncQuestionQualityService {

    private final QualityEngine qualityEngine;
    private final LongTermMemoryService longTermMemoryService;
    private final AIEngineProperties properties;

    /**
     * 异步评分并更新长期记忆，不阻塞主请求。
     */
    @Async
    public void scoreAndUpdateMemoryAsync(String requestId,
                                          String processedTopic,
                                          List<AIQuestionDTO> questions,
                                          Integer activityId,
                                          int requestedCount) {
        try {
            if (questions == null || questions.isEmpty()) {
                log.info("[AI-QGEN-ASYNC] skip requestId={}, reason=no_questions", requestId);
                return;
            }

            // 长期记忆门禁：文本长度与句子数
            int minLen = properties.getMemoryMinTextLength();
            int minSentences = properties.getMemoryMinSentenceCount();
            int sentenceCount = countSentences(processedTopic);
            if (processedTopic == null || processedTopic.length() < minLen || sentenceCount < minSentences) {
                log.info("[AI-QGEN-ASYNC] skip requestId={}, reason=text_gate_failed, textLength={}, sentenceCount={}, minLen={}, minSentences={}",
                        requestId,
                        processedTopic == null ? 0 : processedTopic.length(),
                        sentenceCount,
                        minLen,
                        minSentences);
                return;
            }

            List<QuestionQualityScore> scores = qualityEngine.evaluate(processedTopic, questions);
            if (scores == null || scores.isEmpty()) {
                log.info("[AI-QGEN-ASYNC] skip requestId={}, reason=no_scores", requestId);
                return;
            }

            int passCount = (int) scores.stream().filter(s -> s.getTotalScore() >= 75).count();
            double avgScore = scores.stream().mapToInt(QuestionQualityScore::getTotalScore).average().orElse(0);

            log.info("[AI-QGEN-ASYNC] quality_done requestId={}, activityId={}, requestedCount={}, scoredCount={}, passCount={}, avgScore={}",
                    requestId, activityId, requestedCount, scores.size(), passCount, avgScore);

            for (QuestionQualityScore s : scores) {
                String preview = s.getQuestion() == null || s.getQuestion().getContent() == null
                        ? ""
                        : (s.getQuestion().getContent().length() > 60
                        ? s.getQuestion().getContent().substring(0, 60) + "..."
                        : s.getQuestion().getContent());
                log.info("[AI-QGEN-ASYNC] quality_detail requestId={}, index={}, ruleScore={}, llmScore={}, totalScore={}, issues={}, questionPreview={}",
                        requestId,
                        s.getIndex(),
                        s.getRuleScore(),
                        s.getLlmJudgeScore(),
                        s.getTotalScore(),
                        s.getIssues(),
                        preview);
            }

            if (!passesMemoryGate(processedTopic)) {
                log.info("[AI-QGEN-ASYNC] long_memory_skip requestId={}, reason=memory_gate_failed, textLength={}, sentenceCount={}",
                        requestId,
                        processedTopic == null ? 0 : processedTopic.length(),
                        countSentences(processedTopic));
                return;
            }

            QuestionQualityScore best = scores.stream().max(Comparator.comparingInt(QuestionQualityScore::getTotalScore)).orElse(null);
            if (best == null) {
                return;
            }

            LongTermMemoryItem item = new LongTermMemoryItem();
            item.setId(UUID.randomUUID().toString());
            item.setCreatedAt(System.currentTimeMillis());
            item.setTextSummary(summarize(processedTopic, 600));
            item.setBestQuestion(extractQuestionText(best.getQuestion()));

            longTermMemoryService.saveMemoryItem(item, properties.getLongTermMaxItems());
            log.info("[AI-QGEN-ASYNC] long_memory_updated requestId={}, bestScore={}",
                    requestId, best.getTotalScore());
        } catch (Exception e) {
            log.error("[AI-QGEN-ASYNC] failed requestId={}, message={}", requestId, e.getMessage(), e);
        }
    }

    private String summarize(String text, int maxLen) {
        if (text == null) {
            return "";
        }
        String cleaned = text.replaceAll("\\s+", " ").trim();
        if (cleaned.length() <= maxLen) {
            return cleaned;
        }
        return cleaned.substring(0, maxLen);
    }

    private String extractQuestionText(AIQuestionDTO q) {
        if (q == null) {
            return "";
        }
        String content = q.getContent() == null ? "" : q.getContent();
        String options = q.getOptions() == null ? "" : q.getOptions().toString();
        String answer = q.getAnswer() == null ? "" : q.getAnswer();
        return "题干:" + content + " 选项:" + options + " 答案:" + answer;
    }

    private boolean passesMemoryGate(String text) {
        int minLen = Math.max(1, properties.getMemoryMinTextLength());
        int minSentences = Math.max(1, properties.getMemoryMinSentenceCount());

        if (text == null || text.length() < minLen) {
            return false;
        }
        return countSentences(text) >= minSentences;
    }

    private int countSentences(String text) {
        if (text == null || text.trim().isEmpty()) {
            return 0;
        }
        String[] parts = text.split("[。！？，.!?,]+");
        int count = 0;
        for (String p : parts) {
            if (!p.trim().isEmpty()) {
                count++;
            }
        }
        return count;
    }
}
