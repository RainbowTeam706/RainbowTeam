package com.pq.service;public interface IQuizService {
    void createAndSendQuiz(Integer activityId, Integer questionCount,int lastTime, String text);
}
