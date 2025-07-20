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
    public Result sendQuiz(@RequestParam Integer activityId,
                           @RequestParam(defaultValue = "3") Integer questionCount,
                           @RequestParam int lastTime,
                           @RequestParam String text) {
        quizService.createAndSendQuiz(activityId, questionCount,lastTime,text);
        return Result.ok();
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



} 