package com.pq.ai.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "ai.engine")
public class AIEngineProperties {

    /** 预处理后触发截短阈值 */
    private int preprocessTruncateThreshold = 1000;

    /** 长期记忆最多保留条数 */
    private int longTermMaxItems = 5;

    /** RAG 召回条数 */
    private int ragTopK = 3;

    /** 本地向量维度 */
    private int vectorDims = 128;

    /** 长期记忆写入门槛：文本最小长度 */
    private int memoryMinTextLength = 30;

    /** 长期记忆写入门槛：最少句子数 */
    private int memoryMinSentenceCount = 3;
}
