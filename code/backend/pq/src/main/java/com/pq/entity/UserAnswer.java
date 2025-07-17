package com.pq.entity;

import java.util.Date;

public class UserAnswer {
    private Integer id;
    private Integer userId;
    private Integer questionId;
    private Integer selectedOption;
    private Date answerTime;
    private Integer isCorret; // 建议后续数据库字段改为isCorrect

    // getter/setter
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public Integer getQuestionId() { return questionId; }
    public void setQuestionId(Integer questionId) { this.questionId = questionId; }
    public Integer getSelectedOption() { return selectedOption; }
    public void setSelectedOption(Integer selectedOption) { this.selectedOption = selectedOption; }
    public Date getAnswerTime() { return answerTime; }
    public void setAnswerTime(Date answerTime) { this.answerTime = answerTime; }
    public Integer getIsCorret() { return isCorret; }
    public void setIsCorret(Integer isCorret) { this.isCorret = isCorret; }
} 