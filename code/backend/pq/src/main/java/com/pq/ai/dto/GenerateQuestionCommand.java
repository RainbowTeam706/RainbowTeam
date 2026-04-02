package com.pq.ai.dto;

import lombok.Data;

@Data
public class GenerateQuestionCommand {
    private String topicText;
    private int questionCount;
    private Integer popQuizId;
    /** 活动ID，用于 activity 级记忆隔离 */
    private Integer activityId;
    private String difficulty;
    private String requestId;
}
