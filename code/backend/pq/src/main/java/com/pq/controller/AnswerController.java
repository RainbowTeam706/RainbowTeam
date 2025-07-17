package com.pq.controller;

import com.pq.dto.AnswerDTO;
import com.pq.service.IUserAnswerService;
import com.pq.dto.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/answer")
public class AnswerController {
    @Autowired
    private IUserAnswerService userAnswerService;

    @PostMapping("/submit")
    public Result submit(@RequestBody AnswerDTO dto) {
        userAnswerService.submitAnswer(dto.getUserId(), dto.getQuestionId(), dto.getSelectedOption());
        return Result.ok();
    }
} 