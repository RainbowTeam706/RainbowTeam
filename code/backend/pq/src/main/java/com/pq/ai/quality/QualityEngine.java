package com.pq.ai.quality;

import com.pq.ai.dto.QuestionQualityScore;
import com.pq.dto.doubao.AIQuestionDTO;

import java.util.List;

public interface QualityEngine {
    List<QuestionQualityScore> evaluate(String topicText, List<AIQuestionDTO> questions);
}
