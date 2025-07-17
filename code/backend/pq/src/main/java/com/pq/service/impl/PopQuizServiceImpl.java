package com.pq.service.impl;

import com.pq.entity.PopQuiz;
import com.pq.entity.PopQuizQuestion;
import com.pq.entity.QuestionBank;
import com.pq.mapper.PopQuizMapper;
import com.pq.mapper.PopQuizQuestionMapper;
import com.pq.mapper.QuestionBankMapper;
import com.pq.service.IPopQuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PopQuizServiceImpl implements IPopQuizService {
    @Autowired
    private PopQuizMapper popQuizMapper;
    @Autowired
    private PopQuizQuestionMapper popQuizQuestionMapper;
    @Autowired
    private QuestionBankMapper questionBankMapper;

    @Override
    public PopQuiz createPopQuiz(Integer activityId, Date startTime, Date endTime, Integer time) {
        PopQuiz popQuiz = new PopQuiz();
        popQuiz.setActivityId(activityId);
        popQuiz.setStartTime(startTime);
        popQuiz.setEndTime(endTime);
        popQuiz.setTime(time);
        popQuiz.setStatus(0);
        popQuizMapper.insert(popQuiz);
        return popQuiz;
    }

    @Override
    public void addQuestionToPopQuiz(Integer popQuizId, Integer questionId) {
        PopQuizQuestion pqQuestion = new PopQuizQuestion();
        pqQuestion.setPopquizId(popQuizId);
        pqQuestion.setQuestionId(questionId);
        popQuizQuestionMapper.insert(pqQuestion);
    }

    @Override
    public List<QuestionBank> getQuestionsForPopQuiz(Integer popQuizId) {
        List<PopQuizQuestion> pqQuestions = popQuizQuestionMapper.selectByPopQuizId(popQuizId);
        List<Integer> questionIds = pqQuestions.stream().map(PopQuizQuestion::getQuestionId).collect(Collectors.toList());
        return questionIds.stream().map(questionBankMapper::selectById).collect(Collectors.toList());
    }
} 