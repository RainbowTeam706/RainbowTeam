package com.pq.service.impl;

import com.pq.entity.QuestionBank;
import com.pq.mapper.QuestionBankMapper;
import com.pq.service.IQuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class QuestionServiceImpl implements IQuestionService {
    @Autowired
    private QuestionBankMapper questionBankMapper;

    @Override
    public QuestionBank generateQuestion(String content, String options, String answer, Integer activityId) {
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("题干不能为空");
        }
        if (options == null || options.trim().isEmpty()) {
            throw new IllegalArgumentException("选项不能为空");
        }
        if (answer == null || answer.trim().isEmpty()) {
            throw new IllegalArgumentException("答案不能为空");
        }
        if (activityId == null) {
            throw new IllegalArgumentException("活动ID不能为空");
        }
        QuestionBank question = new QuestionBank();
        question.setContent(content);
        question.setOptions(options);
        question.setAnswer(answer);
        question.setActivityId(activityId);
        questionBankMapper.insert(question);
        return question;
    }

    @Override
    public List<QuestionBank> getQuestionsByActivity(Integer activityId) {
        if (activityId == null) {
            throw new IllegalArgumentException("活动ID不能为空");
        }
        return questionBankMapper.selectByActivityId(activityId);
    }
} 