package com.pq.service;

import com.pq.entity.UserAnswer;
import java.util.List;

public interface IUserAnswerService {
    void submitAnswer(Integer userId, Integer questionId, Integer selectedOption);
    List<UserAnswer> getUserAnswers(Integer userId, Integer activityId);
} 