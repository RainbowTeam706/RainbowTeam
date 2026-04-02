package com.pq.ai.memory;

/**
 * 活动级 AI 记忆服务。
 *
 * 记忆按 activityId 隔离，活动结束后清理。
 */
public interface ActivityMemoryService {

    /**
     * 获取可注入 Prompt 的活动记忆（已做长度裁剪，避免 token 过大）。
     */
    String getMemoryForPrompt(Integer activityId);

    /**
     * 基于本次文本和已生成题目更新活动记忆摘要。
     */
    void updateMemory(Integer activityId, String topicText, String generatedQuestionsJson);

    /**
     * 删除活动记忆（活动结束时调用）。
     */
    void deleteMemory(Integer activityId);
}
