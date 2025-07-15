package com.pq.controller;

import cn.hutool.core.util.RandomUtil;
import com.pq.dto.Result;
import com.pq.entity.Activity;
import com.pq.entity.ActivityMember;
import com.pq.service.IActivityMemberService;
import com.pq.service.IActivityService;
import com.pq.utils.UserHolder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequestMapping("/activity")
public class ActivityController {

    @Resource
    private IActivityService activityService;

    @Resource
    private IActivityMemberService activityMemberService;

    @PostMapping("/create")
    public Result createActivity(@RequestBody Activity activity) {
        activity.setCreateId(UserHolder.getUser().getId());
        activity.setInviteCode(RandomUtil.randomNumbers(6));
        activity.setCurNum(1);
        activityService.save(activity);
        return Result.ok(activity.getInviteCode());
    }

    @PostMapping("createQ")
    public Result createActivityQuickly(int lastTime) {
        Activity activity = new Activity();
        activity.setCreateId(UserHolder.getUser().getId())
                .setTitle(UserHolder.getUser().getNickname() + "的小课堂")
                .setInviteCode(RandomUtil.randomNumbers(6))
                .setStartTime(new Date())
                .setCurNum(1)
                .setStatus(1);
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.MINUTE, lastTime);
        activity.setStartTime(new Date());
        activity.setEndTime(calendar.getTime());
        activityService.save(activity);
        return Result.ok(activity.getInviteCode());
    }

    @PostMapping("add")
    public Result addActivity(String inviteCode) {
        Activity activity = activityService.query().eq("inviteCode", inviteCode).one();
        if (activity == null || activity.getEndTime().before(new Date())) {
            return Result.fail("无效的邀请码");
        }
        ActivityMember activityMember = new ActivityMember()
                .setActivityId(activity.getId())
                .setUserId(UserHolder.getUser().getId())
                .setNickname(UserHolder.getUser().getNickname());
        activityService.addMember(activityMember,activity.getId());
        return Result.ok();
    }

    @GetMapping("listByMe")
    public Result listByMe(){
        List<Activity> activityList = activityService.query().eq("createId",UserHolder.getUser().getId()).list();
        return Result.ok(activityList);
    }

    @GetMapping("listWithMe")
    public Result listWithMe(){
        List<ActivityMember> activityMemberList = activityMemberService.query().select("activityId")
                .eq("userId",UserHolder.getUser().getId())
                .list();
        List<Integer> ids = activityMemberList.stream()
                .map(ActivityMember::getActivityId)
                .collect(Collectors.toList());
        List<Activity> activityList = activityService.query().in("id", ids).list();
        return Result.ok(activityList);
    }

}
