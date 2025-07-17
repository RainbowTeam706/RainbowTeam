package com.pq.entity;

import java.util.List;

public class QuestionBank {
    private Integer id;
    private Integer activityId;
    private String content; // 题目内容
    private String options; // JSON字符串，建议用List<String>接收
    private String answer;  // 正确答案

    // getter/setter
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getActivityId() { return activityId; }
    public void setActivityId(Integer activityId) { this.activityId = activityId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getOptions() { return options; }
    public void setOptions(String options) { this.options = options; }
    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }
} 