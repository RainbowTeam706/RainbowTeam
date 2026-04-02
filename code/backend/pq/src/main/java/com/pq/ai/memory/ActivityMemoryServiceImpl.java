package com.pq.ai.memory;

import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.Duration;

/**
 * Redis 活动级记忆实现。
 *
 * 设计目标：
 * 1) activityId 级别隔离；
 * 2) 防止记忆无限增长（长度裁剪）；
 * 3) 支持活动结束清理。
 */
@Slf4j
@Service
public class ActivityMemoryServiceImpl implements ActivityMemoryService {

    private static final String MEMORY_KEY_PREFIX = "ai:memory:activity:";

    /**
     * 记忆最大字符长度（近似 token 防爆保护）。
     */
    private static final int MAX_MEMORY_CHARS = 3000;

    /**
     * 每次用于 Prompt 注入的最大长度。
     */
    private static final int MAX_PROMPT_MEMORY_CHARS = 1200;

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Override
    public String getMemoryForPrompt(Integer activityId) {
        if (activityId == null) {
            return "";
        }
        String key = buildKey(activityId);
        String memory = stringRedisTemplate.opsForValue().get(key);
        if (memory == null || memory.trim().isEmpty()) {
            return "";
        }
        // 注入 Prompt 时再次裁剪，控制请求体积
        return trimToTail(memory, MAX_PROMPT_MEMORY_CHARS);
    }

    @Override
    public void updateMemory(Integer activityId, String topicText, String generatedQuestionsJson) {
        if (activityId == null) {
            return;
        }

        String key = buildKey(activityId);
        String oldMemory = stringRedisTemplate.opsForValue().get(key);

        StringBuilder merged = new StringBuilder();
        if (oldMemory != null && !oldMemory.isEmpty()) {
            merged.append(oldMemory).append("\n");
        }

        // 仅保存摘要信息，避免原始大段文本无限堆积
        String topicSummary = summarize(topicText, 600);
        String questionSummary = summarize(generatedQuestionsJson, 900);
        merged.append("[TOPIC]").append(topicSummary)
                .append("\n[QUESTIONS]").append(questionSummary);

        String finalMemory = trimToTail(merged.toString(), MAX_MEMORY_CHARS);
        stringRedisTemplate.opsForValue().set(key, finalMemory, Duration.ofDays(1));
    }

    @Override
    public void deleteMemory(Integer activityId) {
        if (activityId == null) {
            return;
        }
        String key = buildKey(activityId);
        Boolean deleted = stringRedisTemplate.delete(key);
        log.info("Delete activity memory: activityId={}, deleted={}", activityId, deleted);
    }

    private String buildKey(Integer activityId) {
        return MEMORY_KEY_PREFIX + activityId;
    }

    private String summarize(String text, int maxLen) {
        if (text == null) {
            return "";
        }
        String cleaned = text.replaceAll("\\s+", " ").trim();
        if (cleaned.length() <= maxLen) {
            return cleaned;
        }
        return cleaned.substring(0, maxLen);
    }

    private String trimToTail(String text, int maxLen) {
        if (text == null || text.length() <= maxLen) {
            return text == null ? "" : text;
        }
        return text.substring(text.length() - maxLen);
    }
}
