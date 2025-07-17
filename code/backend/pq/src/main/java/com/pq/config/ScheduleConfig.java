package com.pq.config;

import com.pq.service.IActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.Scheduled;

@Configuration
public class ScheduleConfig {
    @Autowired
    private IActivityService activityService;

    /**
     * 每分钟执行一次活动状态更新
     */
    @Scheduled(cron = "0 * * * * ?")
    public void updateActivityStatus() {
        activityService.updateStatus();
    }
}
