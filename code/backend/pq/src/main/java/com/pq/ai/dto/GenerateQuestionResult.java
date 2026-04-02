package com.pq.ai.dto;

import com.pq.entity.QuestionBank;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class GenerateQuestionResult {
    private List<QuestionBank> questions = new ArrayList<>();
    private int initialValidCount;
    private int refinedCount;
    private boolean fallbackUsed;
    private double avgQualityScore;
    private long elapsedMs;
}
