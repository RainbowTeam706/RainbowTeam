package com.pq.dto.doubao;

import lombok.Data;
import java.util.List;

@Data
public class AIQuestionDTO {
    private String content;
    private List<String> options;
    private String answer;
}