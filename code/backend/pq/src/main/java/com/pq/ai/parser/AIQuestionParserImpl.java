package com.pq.ai.parser;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.pq.dto.doubao.AIQuestionDTO;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;

/**
 * AI 题目解析器实现。
 *
 * 职责：将模型返回文本解析为题目 DTO 列表，
 * 并处理常见输出噪声（如 markdown 代码块标记）。
 */
@Component
public class AIQuestionParserImpl implements AIQuestionParser {

    private final Gson gson = new Gson();

    /**
     * 解析模型原始输出。
     *
     * 处理步骤：
     * 1) 空内容直接返回空列表
     * 2) 清理 ```json 代码块包裹
     * 3) 截取首个 JSON 数组区间
     * 4) 反序列化为 AIQuestionDTO 列表
     */
    @Override
    public List<AIQuestionDTO> parse(String rawContent) {
        if (rawContent == null || rawContent.trim().isEmpty()) {
            return Collections.emptyList();
        }

        String cleaned = rawContent.replace("```json", "")
                .replace("```", "")
                .trim();

        int start = cleaned.indexOf('[');
        int end = cleaned.lastIndexOf(']');
        if (start >= 0 && end > start) {
            cleaned = cleaned.substring(start, end + 1);
        }

        List<AIQuestionDTO> questions = gson.fromJson(cleaned, new TypeToken<List<AIQuestionDTO>>() {
        }.getType());
        return questions == null ? Collections.emptyList() : questions;
    }
}
