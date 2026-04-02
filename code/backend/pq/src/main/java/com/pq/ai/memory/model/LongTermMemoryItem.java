package com.pq.ai.memory.model;

import lombok.Data;

import java.util.List;

@Data
public class LongTermMemoryItem {
    private String id;
    private long createdAt;

    /** 原文本摘要 */
    private String textSummary;

    /** 最好题 */
    private String bestQuestion;


    /** 向量（用于相似度检索） */
    private List<Double> vector;
}
