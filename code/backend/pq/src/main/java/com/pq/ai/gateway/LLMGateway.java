package com.pq.ai.gateway;

public interface LLMGateway {
    String generateContent(String prompt, int expectedQuestionCount);
}
