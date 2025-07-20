package com.pq.service;

import com.pq.entity.QuestionBank;
import java.util.List;

public interface IAIQuestionService {
    /**
     * 使用豆包AI生成题目
     * @param topic 题目主题/文本内容
     * @param questionCount 题目数量
     * @param popQuizId PopQuiz ID
     * @return 生成的题目列表
     */
    List<QuestionBank> generateQuestions(String topic, int questionCount, Integer popQuizId);
}