package com.pq.ai.preprocess;

public interface TextPreprocessService {

    /**
     * 默认文本预处理（不截短）。
     */
    String preprocess(String rawText);

    /**
     * 仅当文本超长时进行截短。
     */
    String truncateIfNeeded(String processedText, int threshold);
}
