package com.pq.controller;

import com.pq.dto.Result;
import com.pq.service.IQuizService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

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


} 