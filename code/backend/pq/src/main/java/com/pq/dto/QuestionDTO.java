package com.pq.dto;

import lombok.Data;

import java.util.List;

@Data
public class QuestionDTO {
    private String content;
    private List<String> options;
    private String answer;
    private Integer activityId;

} 