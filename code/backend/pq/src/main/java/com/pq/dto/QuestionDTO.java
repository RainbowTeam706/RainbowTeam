package com.pq.dto;

import java.util.List;

public class QuestionDTO {
    private String content;
    private List<String> options;
    private String answer;
    private Integer activityId;
    // getter/setter
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public List<String> getOptions() { return options; }
    public void setOptions(List<String> options) { this.options = options; }
    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }
    public Integer getActivityId() { return activityId; }
    public void setActivityId(Integer activityId) { this.activityId = activityId; }
} 