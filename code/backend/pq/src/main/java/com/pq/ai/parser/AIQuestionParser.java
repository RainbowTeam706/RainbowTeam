package com.pq.ai.parser;

import com.pq.dto.doubao.AIQuestionDTO;

import java.util.List;

public interface AIQuestionParser {
    List<AIQuestionDTO> parse(String rawContent);
}
