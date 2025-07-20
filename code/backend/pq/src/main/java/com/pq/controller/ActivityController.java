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
import org.springframework.boot.autoconfigure.freemarker.FreeMarkerAutoConfiguration;
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

    @Resource
    private com.pq.service.IUserService userService;

    @Resource
    private com.pq.service.IFeedbackActivityService feedbackActivityService;

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
        for (Activity activity : activityList) {
            com.pq.entity.User user = userService.getById(activity.getCreateId());
            activity.setCreateName(user != null ? user.getNickname() : null);
        }
        return Result.ok(activityList);
    }

    @GetMapping("listWithMe")
    public Result listWithMe(){
        List<ActivityMember> activityMemberList = activityMemberService.query().select("activityId")
                .eq("userId",UserHolder.getUser().getId())
                .list();
        if(activityMemberList.isEmpty()){
            return Result.ok();
        }
        List<Integer> ids = activityMemberList.stream()
                .map(ActivityMember::getActivityId)
                .collect(Collectors.toList());
        List<Activity> activityList = activityService.query().in("id", ids).list();
        for (Activity activity : activityList) {
            com.pq.entity.User user = userService.getById(activity.getCreateId());
            activity.setCreateName(user != null ? user.getNickname() : null);
        }
        return Result.ok(activityList);
    }

    @GetMapping("/feedbackStats")
    public Result getFeedbackStats(@RequestParam int activityId) {
        List<com.pq.entity.FeedbackActivity> feedbackList = feedbackActivityService.query().eq("activityId", activityId).list();
        // 统计
        int fast = 0, normalPace = 0, slow = 0;
        int hard = 0, normalDiff = 0, easy = 0;
        int clear = 0, confused = 0;
        for (com.pq.entity.FeedbackActivity feedback : feedbackList) {
            // pace
            if (feedback.getFeedbackData_Pace() == 0) fast++;
            else if (feedback.getFeedbackData_Pace() == 1) normalPace++;
            else if (feedback.getFeedbackData_Pace() == 2) slow++;            // difficulty
            if (feedback.getFeedbackData_Difficulty() == 0) hard++;
            else if (feedback.getFeedbackData_Difficulty() == 1) normalDiff++;
            else if (feedback.getFeedbackData_Difficulty() == 2) easy++;
            // understanding
            if (feedback.getFeedbackData_Understanding() == 0) clear++;
            else if (feedback.getFeedbackData_Understanding() == 1) confused++;
        }
        java.util.Map<String, Object> data = new java.util.HashMap<>();
        java.util.Map<String, Object> pace = new java.util.HashMap<>();
        pace.put("fast", fast);
        pace.put("normal", normalPace);
        pace.put("slow", slow);
        java.util.Map<String, Object> difficulty = new java.util.HashMap<>();
        difficulty.put("hard", hard);
        difficulty.put("normal", normalDiff);
        difficulty.put("easy", easy);
        java.util.Map<String, Object> understanding = new java.util.HashMap<>();
        understanding.put("clear", clear);
        understanding.put("confused", confused);
        data.put("pace", pace);
        data.put("difficulty", difficulty);
        data.put("understanding", understanding);
        java.util.Map<String, Object> result = new java.util.HashMap<>();
        result.put("success", true);
        result.put("data", data);
        result.put("message", "获取成功");
        return Result.ok(data);
    }

    @GetMapping("/myFeedbackHistory")
    public Result getMyFeedbackHistory(@RequestParam int activityId, @RequestParam int userId) {
        com.pq.entity.FeedbackActivity feedback = feedbackActivityService.query()
            .eq("activityId", activityId)
            .eq("userId", userId)
            .one();
        if (feedback != null) {
            java.util.Map<String, Object> data = new java.util.HashMap<>();
            data.put("pace", feedback.getFeedbackData_Pace());
            data.put("difficulty", feedback.getFeedbackData_Difficulty());
            data.put("understanding", feedback.getFeedbackData_Understanding());
            return Result.ok(data);
        } else {
            return Result.ok(null);
        }
    }

    @GetMapping("/feedbackSubmit")
    public Result feedbackSubmit(@RequestParam int activityId,
                                 @RequestParam int userId,
                                 @RequestParam int pace,
                                 @RequestParam int difficulty,
                                 @RequestParam int understanding,
                                 @RequestParam(required = false) String submitTime) {
        // 查找是否已存在反馈
        com.pq.entity.FeedbackActivity feedback = feedbackActivityService.query()
            .eq("activityId", activityId)
            .eq("userId", userId)
            .one();
        if (feedback == null) {
            feedback = new com.pq.entity.FeedbackActivity();
            feedback.setActivityId(activityId);
            feedback.setUserId(userId);
        }
        feedback.setFeedbackData_Pace(pace);
        feedback.setFeedbackData_Difficulty(difficulty);
        feedback.setFeedbackData_Understanding(understanding);
        // 可选：保存提交时间字段（如有）
        // 保存或更新
        feedbackActivityService.saveOrUpdate(feedback);
        return Result.ok();
    }
}
