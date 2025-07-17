package com.pq.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.pq.dto.Result;
import com.pq.entity.Activity;
import com.pq.entity.ActivityMember;

public interface IActivityService extends IService<Activity> {
    void addMember(ActivityMember activityMember, int id);
    void updateStatus();

}
