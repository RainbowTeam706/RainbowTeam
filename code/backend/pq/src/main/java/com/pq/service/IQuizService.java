package com.pq.service;

import java.util.List;
import java.util.Map;

public interface IQuizService {
    void createAndSendQuiz(Integer activityId, Integer questionCount,int lastTime, String text);

    /**
     * 提交学生答案
     *
     * @param popQuizId PopQuiz ID
     * @param userId 用户ID
     * @param answers 答案数据，格式为 Map<题目索引, 选项索引>
     * @return 提交结果
     */
    boolean admit(Integer popQuizId, Integer userId, Map<Integer, Integer> answers);

    List<Map<String, Object>> getPopQuizListByActivityId(Integer activityId);

    Map<String, Object> getStudentTestResult(Integer popQuizId, Integer userId);

    Map<String, Object> getPopQuizStatistics(Integer popQuizId);
}
