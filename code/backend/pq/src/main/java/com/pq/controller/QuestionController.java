package com.pq.controller;

import com.pq.dto.QuestionDTO;
import com.pq.entity.QuestionBank;
import com.pq.service.IQuestionService;
import com.pq.dto.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping("/question")
public class QuestionController {
    @Autowired
    private IQuestionService questionService;

    @PostMapping("/generate")
    public Result generate(@RequestBody QuestionDTO dto) {
        // dto包含content, options, answer, activityId
        // 这里options需要转为json字符串
        ObjectMapper objectMapper = new ObjectMapper();
        String optionsJson;
        try {
            optionsJson = objectMapper.writeValueAsString(dto.getOptions());
        } catch (JsonProcessingException e) {
            return Result.fail("选项序列化失败");
        }
        QuestionBank question = questionService.generateQuestion(dto.getContent(), optionsJson, dto.getAnswer(), dto.getActivityId());
        return Result.ok(question);
    }

    @GetMapping("/list")
    public Result list(@RequestParam Integer activityId) {
        List<QuestionBank> list = questionService.getQuestionsByActivity(activityId);
        return Result.ok(list);
    }
} 