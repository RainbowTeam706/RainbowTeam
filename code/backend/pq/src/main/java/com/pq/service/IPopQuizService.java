package com.pq.service;

import com.pq.entity.PopQuiz;
import com.pq.entity.QuestionBank;
import java.util.Date;
import java.util.List;

public interface IPopQuizService {
    PopQuiz createPopQuiz(Integer activityId, Date startTime, Date endTime, Integer time);
    void addQuestionToPopQuiz(Integer popQuizId, Integer questionId);
    List<QuestionBank> getQuestionsForPopQuiz(Integer popQuizId);
} 