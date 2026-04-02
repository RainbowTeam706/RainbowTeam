package com.pq.ai.preprocess;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@Service
public class TextPreprocessServiceImpl implements TextPreprocessService {

    private static final Pattern MULTI_SPACE = Pattern.compile("\\s+");

    @Override
    public String preprocess(String rawText) {
        if (rawText == null) {
            return "";
        }
        String cleaned = rawText
                .replace("\r", "\n")
                .replaceAll("[\t\f\u000B]+", " ")
                .replaceAll("[ ]+", " ")
                .replaceAll("\n{2,}", "\n")
                .trim();

        cleaned = MULTI_SPACE.matcher(cleaned).replaceAll(" ").trim();
        return cleaned;
    }

    @Override
    public String truncateIfNeeded(String processedText, int threshold) {
        if (processedText == null || processedText.length() <= threshold) {
            return processedText == null ? "" : processedText;
        }

        List<String> sentences = splitSentences(processedText);
        String head = pickHead(sentences, 3);
        String tail = pickTail(sentences, 2);
        String middle = pickByKeyword(sentences, threshold / 2);

        String merged = head + "\n" + middle + "\n" + tail;
        if (merged.length() > threshold) {
            return merged.substring(0, threshold);
        }
        return merged;
    }

    private List<String> splitSentences(String text) {
        String[] parts = text.split("(?<=[。！？.!?])");
        List<String> sentences = new ArrayList<>();
        for (String part : parts) {
            String trimmed = part.trim();
            if (!trimmed.isEmpty()) {
                sentences.add(trimmed);
            }
        }
        return sentences;
    }

    private String pickHead(List<String> sentences, int count) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < Math.min(count, sentences.size()); i++) {
            sb.append(sentences.get(i));
        }
        return sb.toString();
    }

    private String pickTail(List<String> sentences, int count) {
        StringBuilder sb = new StringBuilder();
        for (int i = Math.max(0, sentences.size() - count); i < sentences.size(); i++) {
            sb.append(sentences.get(i));
        }
        return sb.toString();
    }

    private String pickByKeyword(List<String> sentences, int budget) {
        String[] keywords = {"因此", "所以", "原因", "导致", "影响", "对比", "区别", "优缺点", "应用", "场景", "总结"};
        StringBuilder sb = new StringBuilder();
        for (String s : sentences) {
            for (String keyword : keywords) {
                if (s.contains(keyword)) {
                    sb.append(s);
                    break;
                }
            }
            if (sb.length() >= budget) {
                break;
            }
        }
        return sb.toString();
    }
}
