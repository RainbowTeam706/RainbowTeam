package com.pq.entity;

import java.util.Date;

public class PopQuiz {
    private Integer id;
    private Integer activityId;
    private Date startTime;
    private Date endTime;
    private Integer time;
    private Integer status;

    // getter/setter
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getActivityId() { return activityId; }
    public void setActivityId(Integer activityId) { this.activityId = activityId; }
    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }
    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }
    public Integer getTime() { return time; }
    public void setTime(Integer time) { this.time = time; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
} 