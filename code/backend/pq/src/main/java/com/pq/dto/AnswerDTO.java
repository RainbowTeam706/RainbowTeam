package com.pq.dto;

import lombok.Data;

@Data
public class AnswerDTO {
    private Integer userId;
    private Integer questionId;
    private Integer selectedOption;
} 