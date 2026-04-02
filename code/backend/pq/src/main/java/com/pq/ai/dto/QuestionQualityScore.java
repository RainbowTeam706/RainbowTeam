package com.pq.ai.dto;

import com.pq.dto.doubao.AIQuestionDTO;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class QuestionQualityScore {
    private int index;
    private AIQuestionDTO question;

    /** 规则引擎分（0-100） */
    private int ruleScore;

    /** LLM 评审分（0-100），评审失败时可为 0 */
    private int llmJudgeScore;

    /** 融合后总分（0-100） */
    private int totalScore;

    private List<QuestionIssueTag> issues = new ArrayList<>();

    public boolean isPass(int threshold) {
        return totalScore >= threshold && issues.isEmpty();
    }
}
