package com.pq.ai.quality;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.pq.ai.dto.QuestionIssueTag;
import com.pq.ai.dto.QuestionQualityScore;
import com.pq.ai.gateway.LLMGateway;
import com.pq.dto.doubao.AIQuestionDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;


/**
 * 题目质量评估引擎（规则门禁 + LLM主评分）。
 *
 * 评分策略：
 * 1) 规则不满足（存在 issues）=> 直接 0 分；
 * 2) 规则满足 => 以 LLM 评审分为准；
 * 3) 若 LLM 评审失败 => 降级使用 ruleScore。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class QualityEngineImpl implements QualityEngine {

    private final LLMGateway llmGateway;
    private final Gson gson = new Gson();

    @Override
    public List<QuestionQualityScore> evaluate(String topicText, List<AIQuestionDTO> questions) {
        List<QuestionQualityScore> scores = buildRuleScores(topicText, questions);
        List<Integer> llmScores = evaluateByLLM(topicText, questions);

        for (int i = 0; i < scores.size(); i++) {
            QuestionQualityScore score = scores.get(i);
            int ruleScore = score.getRuleScore();
            int llmScore = i < llmScores.size() ? llmScores.get(i) : 0;
            score.setLlmJudgeScore(llmScore);

            int total;
            // 规则门禁不通过，直接判 0 分
            if (!score.getIssues().isEmpty()) {
                total = 0;
            } else if (llmScores.isEmpty()) {
                // LLM 评审失败时降级为规则分
                total = ruleScore;
            } else {
                // 规则通过后，以 LLM 评审分为准
                total = llmScore;
            }
            score.setTotalScore(Math.max(0, Math.min(100, total)));
        }

        return scores;
    }

    private List<QuestionQualityScore> buildRuleScores(String topicText, List<AIQuestionDTO> questions) {
        List<QuestionQualityScore> scores = new ArrayList<>();

        for (int i = 0; i < questions.size(); i++) {
            AIQuestionDTO q = questions.get(i);
            QuestionQualityScore score = new QuestionQualityScore();
            score.setIndex(i);
            score.setQuestion(q);

            // 当前策略：规则层仅做“格式门禁”
            int ruleTotal = 0;
            if (!isValidFormat(q)) {
                score.getIssues().add(QuestionIssueTag.INVALID_FORMAT);
                ruleTotal = 0;
            } else {
                ruleTotal = 100;
            }

            score.setRuleScore(ruleTotal);
            score.setTotalScore(ruleTotal);
            scores.add(score);
        }

        return scores;
    }

    private List<Integer> evaluateByLLM(String topicText, List<AIQuestionDTO> questions) {
        if (questions == null || questions.isEmpty()) {
            return Collections.emptyList();
        }

        try {
            String prompt = buildJudgePrompt(topicText, questions);
            String raw = llmGateway.generateContent(prompt, questions.size());
            String cleaned = raw.replace("```json", "").replace("```", "").trim();

            int start = cleaned.indexOf('[');
            int end = cleaned.lastIndexOf(']');
            if (start >= 0 && end > start) {
                cleaned = cleaned.substring(start, end + 1);
            }

            List<Integer> scores = gson.fromJson(cleaned, new TypeToken<List<Integer>>() {
            }.getType());
            if (scores == null || scores.isEmpty()) {
                return Collections.emptyList();
            }

            List<Integer> normalized = new ArrayList<>();
            for (Integer s : scores) {
                int v = s == null ? 0 : Math.max(0, Math.min(100, s));
                normalized.add(v);
            }
            return normalized;
        } catch (Exception e) {
            log.warn("LLM judge failed, fallback to rule-only quality score: {}", e.getMessage());
            return Collections.emptyList();
        }
    }

    private String buildJudgePrompt(String topicText, List<AIQuestionDTO> questions) {
        return "你是一名严格的题目质量评审员。请对每道单选题按0-100评分，评分维度：" +
                "与文本相关性、清晰度、推理深度、唯一正确性。\n" +
                "只输出一个JSON整数数组，长度必须与题目数量一致。\n" +
                "例如：[82,76,91]\n" +
                "不要输出任何解释文字。\n\n" +
                "文本：\n" + topicText + "\n\n" +
                "题目：\n" + gson.toJson(questions);
    }

    private boolean isValidFormat(AIQuestionDTO q) {
        return q != null
                && q.getContent() != null && !q.getContent().trim().isEmpty()
                && q.getOptions() != null && q.getOptions().size() == 4
                && q.getAnswer() != null && q.getAnswer().toUpperCase(Locale.ROOT).matches("[ABCD]");
    }

}
