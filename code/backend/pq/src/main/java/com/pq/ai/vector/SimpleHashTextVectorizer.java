package com.pq.ai.vector;

import com.pq.ai.config.AIEngineProperties;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * 轻量本地向量器（基于哈希桶）。
 *
 * 说明：这是无外部依赖的工程版向量实现，便于先落地“向量检索流程”。
 * 后续可替换为真实 embedding 模型。
 */
@Component
@RequiredArgsConstructor
public class SimpleHashTextVectorizer implements TextVectorizer {

    private final AIEngineProperties properties;

    @Override
    public List<Double> vectorize(String text) {
        int dims = Math.max(32, properties.getVectorDims());
        double[] arr = new double[dims];

        String normalized = text == null ? "" : text.toLowerCase().replaceAll("[^\\p{L}\\p{N}]+", " ");
        String[] tokens = normalized.split("\\s+");
        for (String token : tokens) {
            if (token.isEmpty()) {
                continue;
            }
            int idx = Math.abs(token.hashCode()) % dims;
            arr[idx] += 1.0;
        }

        double norm = 0;
        for (double v : arr) {
            norm += v * v;
        }
        norm = Math.sqrt(norm);
        if (norm == 0) {
            norm = 1;
        }

        List<Double> out = new ArrayList<>(dims);
        for (double v : arr) {
            out.add(v / norm);
        }
        return out;
    }
}
