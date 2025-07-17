package com.pq.service.impl;

import com.pq.entity.UserAnswer;
import com.pq.mapper.UserAnswerMapper;
import com.pq.service.IUserAnswerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import com.pq.entity.QuestionBank;
import com.pq.mapper.QuestionBankMapper;

@Service
public class UserAnswerServiceImpl implements IUserAnswerService {
    @Autowired
    private UserAnswerMapper userAnswerMapper;
    @Autowired
    private QuestionBankMapper questionBankMapper;

    @Override
    public void submitAnswer(Integer userId, Integer questionId, Integer selectedOption) {
        if (userId == null || questionId == null || selectedOption == null) {
            throw new IllegalArgumentException("参数不能为空");
        }
        // 查询题目
        QuestionBank question = questionBankMapper.selectById(questionId);
        if (question == null) {
            throw new IllegalArgumentException("题目不存在");
        }
        // 判定正误
        boolean isCorrect = false;
        try {
            int correctIndex = Integer.parseInt(question.getAnswer());
            isCorrect = (selectedOption == correctIndex);
        } catch (Exception e) {
            // 兼容旧数据或异常
        }
        UserAnswer answer = new UserAnswer();
        answer.setUserId(userId);
        answer.setQuestionId(questionId);
        answer.setSelectedOption(selectedOption);
        answer.setAnswerTime(new java.util.Date());
        answer.setIsCorret(isCorrect ? 1 : 0);
        userAnswerMapper.insert(answer);
    }

    @Override
    public List<UserAnswer> getUserAnswers(Integer userId, Integer activityId) {
        return userAnswerMapper.selectByUserIdAndActivityId(userId, activityId);
    }
} 