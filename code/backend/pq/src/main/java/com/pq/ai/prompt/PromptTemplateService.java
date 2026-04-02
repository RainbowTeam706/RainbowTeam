package com.pq.ai.prompt;

public interface PromptTemplateService {
    String buildGeneratePrompt(String topicText, int questionCount, String difficulty, String memoryContext);
}
