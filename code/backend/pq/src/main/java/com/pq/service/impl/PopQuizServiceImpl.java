package com.pq.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.pq.entity.Activity;
import com.pq.entity.PopQuiz;
import com.pq.enums.ActivityStatus;
import com.pq.enums.ExamStatus;
import com.pq.mapper.PopQuizMapper;
import com.pq.service.IPopQuizService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Slf4j
@Service
public class PopQuizServiceImpl extends ServiceImpl<PopQuizMapper, PopQuiz> implements IPopQuizService {
    @Override
    public void updateStatus() {
        log.info("开始执行测试更新定时任务");
        List<PopQuiz> popQuizs = query().in("status",0).list();  //查询所有状态为0（进行中）
        Date now = new Date();
        for (PopQuiz popQuiz : popQuizs) {
            try {
                ExamStatus newStatus = calculateNewStatus(popQuiz, now);
                if (newStatus != null && newStatus.getCode() != popQuiz.getStatus()) {
                    update().eq("id", popQuiz.getId()).set("status", newStatus.getCode()).update();
                    log.info("测试ID: {}, 状态从 {} 更新为 {}",
                            popQuiz.getId(),
                            ActivityStatus.fromCode(popQuiz.getStatus()).getDescription(),
                            newStatus.getDescription());
                }
            } catch (Exception e) {
                log.error("更新测试状态失败，测试ID: {}, 错误: {}", popQuiz.getId(), e.getMessage());
            }
        }
        log.info("测试状态更新定时任务执行完成");
    }

    /**
     * 计算活动的新状态
     */
    private ExamStatus calculateNewStatus(PopQuiz popQuiz, Date now) {
        Date endTime =popQuiz.getEndTime();

        // 当前时间超过endTime，状态变为1（活动已结束）
        if (now.after(endTime)) {
            return ExamStatus.ENDED;
        }

        // 其他情况保持当前状态
        return ExamStatus.fromCode(popQuiz.getStatus());
    }
}
