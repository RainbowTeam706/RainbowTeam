package com.pq.ai.memory;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.pq.ai.memory.model.LongTermMemoryItem;
import com.pq.ai.vector.TextVectorizer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class LongTermMemoryServiceImpl implements LongTermMemoryService {

    private static final String LONG_MEMORY_KEY = "ai:memory:longterm:global";

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    private final TextVectorizer textVectorizer;
    private final Gson gson = new Gson();

    @Override
    public List<LongTermMemoryItem> retrieveTopK(String queryText, int k) {
        if (k <= 0) {
            return Collections.emptyList();
        }

        List<LongTermMemoryItem> all = loadAll();
        if (all.isEmpty()) {
            return Collections.emptyList();
        }

        List<Double> queryVector = textVectorizer.vectorize(queryText);

        List<ScoredItem> scored = new ArrayList<>();
        for (LongTermMemoryItem item : all) {
            double score = cosine(queryVector, safeVector(item));
            scored.add(new ScoredItem(item, score));
            log.info("[AI-QGEN] long_memory_candidate id={}, score={}, summaryPreview={}",
                    nullSafe(item.getId()),
                    score,
                    preview(item.getTextSummary(), 80));
        }

        scored.sort((a, b) -> Double.compare(b.score, a.score));

        List<LongTermMemoryItem> topK = new ArrayList<>();
        int limit = Math.min(k, scored.size());
        for (int i = 0; i < limit; i++) {
            ScoredItem s = scored.get(i);
            topK.add(s.item);
            log.info("[AI-QGEN] long_memory_selected rank={}, id={}, score={}, summaryPreview={}",
                    i + 1,
                    nullSafe(s.item.getId()),
                    s.score,
                    preview(s.item.getTextSummary(), 80));
        }

        return topK;
    }

    @Override
    public void saveMemoryItem(LongTermMemoryItem item, int maxItems) {
        if (item == null) {
            return;
        }

        List<LongTermMemoryItem> all = loadAll();
        if (item.getId() == null || item.getId().trim().isEmpty()) {
            item.setId(UUID.randomUUID().toString());
        }
        if (item.getCreatedAt() <= 0) {
            item.setCreatedAt(System.currentTimeMillis());
        }
        if (item.getVector() == null || item.getVector().isEmpty()) {
            item.setVector(textVectorizer.vectorize(nullSafe(item.getTextSummary())));
        }

        all.add(item);
        all.sort(Comparator.comparingLong(LongTermMemoryItem::getCreatedAt).reversed());

        int limit = Math.max(1, maxItems);
        if (all.size() > limit) {
            all = new ArrayList<>(all.subList(0, limit));
        }

        stringRedisTemplate.opsForValue().set(LONG_MEMORY_KEY, gson.toJson(all));
        log.info("[AI-QGEN] long_memory_saved size={}, maxItems={}", all.size(), limit);
    }

    @Override
    public String buildMemoryContext(List<LongTermMemoryItem> items) {
        if (items == null || items.isEmpty()) {
            return "";
        }

        StringBuilder sb = new StringBuilder();
        sb.append("长期记忆参考（全局经验）:\n");
        for (int i = 0; i < items.size(); i++) {
            LongTermMemoryItem item = items.get(i);
            sb.append("# 记忆").append(i + 1).append("\n")
                    .append("摘要: ").append(nullSafe(item.getTextSummary())).append("\n")
                    .append("好题: ").append(nullSafe(item.getBestQuestion())).append("\n");
        }

        return sb.toString();
    }

    private List<LongTermMemoryItem> loadAll() {
        String raw = stringRedisTemplate.opsForValue().get(LONG_MEMORY_KEY);
        if (raw == null || raw.trim().isEmpty()) {
            return new ArrayList<>();
        }

        try {
            List<LongTermMemoryItem> list = gson.fromJson(raw, new TypeToken<List<LongTermMemoryItem>>() {
            }.getType());
            return list == null ? new ArrayList<>() : new ArrayList<>(list);
        } catch (Exception e) {
            log.warn("[AI-QGEN] parse long memory failed: {}", e.getMessage());
            return new ArrayList<>();
        }
    }

    private List<Double> safeVector(LongTermMemoryItem item) {
        List<Double> v = item.getVector();
        if (v != null && !v.isEmpty()) {
            return v;
        }
        return textVectorizer.vectorize(nullSafe(item.getTextSummary()));
    }

    private String nullSafe(String s) {
        return s == null ? "" : s;
    }

    private double cosine(List<Double> a, List<Double> b) {
        int size = Math.min(a.size(), b.size());
        if (size == 0) {
            return 0;
        }

        double dot = 0;
        double na = 0;
        double nb = 0;
        for (int i = 0; i < size; i++) {
            double x = a.get(i);
            double y = b.get(i);
            dot += x * y;
            na += x * x;
            nb += y * y;
        }

        if (na == 0 || nb == 0) {
            return 0;
        }
        return dot / (Math.sqrt(na) * Math.sqrt(nb));
    }

    private String preview(String text, int maxLen) {
        if (text == null) {
            return "";
        }
        String cleaned = text.replaceAll("\\s+", " ").trim();
        if (cleaned.length() <= maxLen) {
            return cleaned;
        }
        return cleaned.substring(0, maxLen) + "...";
    }

    private static class ScoredItem {
        private final LongTermMemoryItem item;
        private final double score;

        private ScoredItem(LongTermMemoryItem item, double score) {
            this.item = item;
            this.score = score;
        }
    }
}
