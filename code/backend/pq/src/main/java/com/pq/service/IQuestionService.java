package com.pq.service;

import com.pq.entity.QuestionBank;
import java.util.List;

public interface IQuestionService {
    QuestionBank generateQuestion(String content, String options, String answer, Integer activityId);
    List<QuestionBank> getQuestionsByActivity(Integer activityId);
} 