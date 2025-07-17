package com.pq.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.pq.dto.Result;
import com.pq.entity.Activity;
import com.pq.entity.ActivityMember;
import com.pq.enums.ActivityStatus;
import com.pq.mapper.ActivityMapper;
import com.pq.mapper.ActivityMemberMapper;
import com.pq.service.IActivityService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service
@Slf4j
public class ActivityServiceImpl extends ServiceImpl<ActivityMapper, Activity> implements IActivityService {

    @Resource
    private ActivityMemberMapper activityMemberMapper;

    @Override
    @Transactional
    public void addMember(ActivityMember activityMember, int id) {
        baseMapper.incrementCount(id);
        activityMemberMapper.insert(activityMember);
    }

    @Override
    public void updateStatus() {
        log.info("开始执行活动状态更新定时任务");
        List<Activity> activities = query().in("status",0,1).list();  //查询所有状态为0（未开始） 和1（进行中） 的活动
        Date now = new Date();
        for (Activity activity : activities) {
            try {
                ActivityStatus newStatus = calculateNewStatus(activity, now);
                if (newStatus != null && newStatus.getCode() != activity.getStatus()) {
                    update().eq("id", activity.getId()).set("status", newStatus.getCode()).update();
                    log.info("活动ID: {}, 状态从 {} 更新为 {}",
                            activity.getId(),
                            ActivityStatus.fromCode(activity.getStatus()).getDescription(),
                            newStatus.getDescription());
                }
            } catch (Exception e) {
                log.error("更新活动状态失败，活动ID: {}, 错误: {}", activity.getId(), e.getMessage());
            }
        }
        log.info("活动状态更新定时任务执行完成");
    }



    //    List<Integer> ids = activityService.lambdaQuery()
//            .eq(Activity::getStatus, "ACTIVE")
//            .select(Activity::getId)
//            .list()
//            .stream()
//            .map(Activity::getId)
//            .collect(Collectors.toList());

    /**
     * 计算活动的新状态
     */
    private ActivityStatus calculateNewStatus(Activity activity, Date now) {
        Date beginTime = activity.getStartTime();
        Date endTime =activity.getEndTime();

        // 当前时间超过endTime，状态变为2（活动已结束）
        if (now.after(endTime)) {
            return ActivityStatus.ENDED;
        }

        if (now.after(beginTime)) {
            return ActivityStatus.RUNNING;
        }
        // 其他情况保持当前状态
        return ActivityStatus.fromCode(activity.getStatus());
    }

}
