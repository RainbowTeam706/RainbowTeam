package com.pq.controller;

import com.pq.dto.Result;
import com.pq.service.IQuizService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/quiz")
public class QuizController {
    @Resource
    private IQuizService quizService;

    @PostMapping("/popQuiz")
    public Result sendQuiz(@RequestBody Map<String, Object> requestBody) {
        Integer popQuizId = (Integer) requestBody.get("popQuizId");
        Integer questionCount = (Integer) requestBody.get("questionCount");
        int lastTime = (int) requestBody.get("lastTime");

        if (popQuizId == null) {
            return Result.fail("popQuizId不能为空");
        }

        if (questionCount == null || questionCount <= 0) {
            questionCount = 3;
        }

        try {
            quizService.createAndSendQuizByPopQuizId(popQuizId, questionCount, lastTime);
            return Result.ok();
        } catch (IllegalStateException e) {
            return Result.fail(e.getMessage());
        }
    }

    /**
     * 提交学生答案
     * 学生调用此接口提交答题结果
     */
    @PostMapping("/admit")
    public Result admit(@RequestParam("popQuizId") Integer popQuizId,
                        @RequestParam("userId") Integer userId,
                        @RequestBody Map<Integer, Integer> answers) {
        try {
            log.info("学生提交答案 - PopQuizID: {}, 用户ID: {}, 答案数量: {}",
                    popQuizId, userId, answers.size());

            // 调用服务层提交答案
            boolean result = quizService.admit(popQuizId, userId, answers);

            if (result) {
                return Result.ok();
            } else {
                return Result.fail("答案提交失败");
            }

        } catch (Exception e) {
            log.error("提交答案失败 - PopQuizID: {}, 用户ID: {}, 错误: {}",
                    popQuizId, userId, e.getMessage(), e);
            return Result.fail("答案提交失败");
        }
    }

    @GetMapping("/list/{activityId}")
    public Result getPopQuizList(@PathVariable Integer activityId) {
        try {
            log.info("获取PopQuiz列表 - 活动ID: {}", activityId);

            // 调用服务层获取列表
            List<Map<String, Object>> popQuizList = quizService.getPopQuizListByActivityId(activityId);

            return Result.ok(popQuizList, (long) popQuizList.size());

        } catch (Exception e) {
            log.error("获取PopQuiz列表失败 - 活动ID: {}, 错误: {}", activityId, e.getMessage(), e);
            return Result.fail("获取PopQuiz列表失败: " + e.getMessage());
        }
    }

    /**
     * 查询学生测试结果详情
     */
    @GetMapping("/result/{popQuizId}/{userId}")
    public Result getStudentTestResult(
            @PathVariable Integer popQuizId,
            @PathVariable Integer userId
    ) {
        try {
            log.info("查询学生测试结果 - PopQuizID: {}, 用户ID: {}", popQuizId, userId);

            // 调用服务层查询结果
            Map<String, Object> result = quizService.getStudentTestResult(popQuizId, userId);

            if (result != null) {
                return Result.ok(result);
            } else {
                return Result.fail("未找到该学生的测试记录");
            }

        } catch (Exception e) {
            log.error("查询学生测试结果失败 - PopQuizID: {}, 用户ID: {}, 错误: {}",
                    popQuizId, userId, e.getMessage(), e);
            return Result.fail("查询学生测试结果失败: " + e.getMessage());
        }
    }

    /**
     * 老师端：获取PopQuiz整体和每题的作答统计
     */
    @GetMapping("/stat/{popQuizId}")
    public Result getPopQuizStatistics(@PathVariable Integer popQuizId) {
        try {
            log.info("获取PopQuiz统计 - PopQuizID: {}", popQuizId);
            Map<String, Object> stat = quizService.getPopQuizStatistics(popQuizId);
            return Result.ok(stat);
        } catch (Exception e) {
            log.error("获取PopQuiz统计失败 - PopQuizID: {}, 错误: {}", popQuizId, e.getMessage(), e);
            return Result.fail("获取PopQuiz统计失败: " + e.getMessage());
        }
    }

    /**
     * 学生端刷新/重连后恢复：查询活动内当前进行中的测验
     */
    @GetMapping("/active")
    public Result getActiveQuiz(@RequestParam("activityId") Integer activityId,
                                @RequestParam("userId") Integer userId) {
        try {
            Map<String, Object> active = quizService.getActiveQuizForStudent(activityId, userId);
            return Result.ok(active);
        } catch (Exception e) {
            log.error("查询进行中测验失败 - activityId: {}, userId: {}, err: {}",
                    activityId, userId, e.getMessage(), e);
            return Result.fail("查询进行中测验失败");
        }
    }

    /**
     * 学生端草稿保存：避免刷新/断网导致答题记录丢失
     */
    @PostMapping("/draft")
    public Result saveDraft(@RequestParam("popQuizId") Integer popQuizId,
                            @RequestParam("userId") Integer userId,
                            @RequestBody Map<Integer, Integer> answers) {
        try {
            boolean ok = quizService.saveDraftAnswers(popQuizId, userId, answers);
            return ok ? Result.ok() : Result.fail("草稿保存失败");
        } catch (Exception e) {
            log.error("保存草稿失败 - popQuizId: {}, userId: {}, err: {}",
                    popQuizId, userId, e.getMessage(), e);
            return Result.fail("保存草稿失败");
        }
    }

}
