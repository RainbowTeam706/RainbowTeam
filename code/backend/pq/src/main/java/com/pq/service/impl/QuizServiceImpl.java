package com.pq.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.google.gson.Gson;
import com.pq.entity.ActivityMember;
import com.pq.entity.PopQuiz;
import com.pq.entity.QuestionBank;
import com.pq.entity.UserAnswer;
import com.pq.service.*;
import com.pq.utils.WebSocketService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class QuizServiceImpl implements IQuizService {
    @Resource
    private WebSocketService webSocketService;

    @Resource
    private IPopQuizService popQuizService;

    @Resource
    private IQuestionBankService questionBankService;

    @Resource
    private IUserAnswerService userAnswerService;

    @Resource
    private IActivityMemberService activityMemberService;

    @Override
    @Transactional
    public void createAndSendQuiz(Integer activityId, Integer questionCount,int lastTime, String text) {

        // 1. 创建 PopQuiz
        Date startTime = new Date();
        Date endTime = new Date(startTime.getTime() + lastTime * 60 * 1000L);
        PopQuiz popQuiz = new PopQuiz()
                .setActivityId(activityId)
                .setStartTime(startTime)
                .setEndTime(endTime)
                .setStatus(0);
        popQuizService.save(popQuiz);

        // 2. 静态生成题目并插入 question_bank
        List<QuestionBank> questionList = new ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            QuestionBank q = new QuestionBank()
                    .setPopQuizId(popQuiz.getId())
                    .setContent("题目" + i + "：" + text + "（示例）")
                    .setOptions("[\"A选项\",\"B选项\",\"C选项\",\"D选项\"]")
                    .setAnswer("A");
            questionList.add(q);
        }
        questionBankService.saveBatch(questionList);

        // 3. 查询所有参与学生
        List<Integer> studentIds = activityMemberService
                .list(new QueryWrapper<ActivityMember>().eq("activityId", activityId))
                .stream().map(ActivityMember::getUserId).collect(Collectors.toList());

        // 4. 为每个学生分配不同试题并推送
        for (Integer userId : studentIds) {
            // 随机抽取题目
            List<QuestionBank> randomQuestions = new ArrayList<>(questionList);
            Collections.shuffle(randomQuestions);
            List<QuestionBank> assigned = randomQuestions.subList(0, questionCount);

            // 组装题目id、options
            String questionIds = assigned.stream().map(q -> q.getId().toString()).collect(Collectors.joining(","));
            String options = assigned.stream().map(q -> "").collect(Collectors.joining(","));
            String isCorrect = assigned.stream().map(q -> "").collect(Collectors.joining(","));

            // 写入 user_answer
            UserAnswer userAnswer = new UserAnswer()
                    .setUserId(userId)
                    .setPopQuizId(popQuiz.getId())
                    .setQuestionIds(questionIds)
                    .setOptions(options)
                    .setIsCorrect(isCorrect);
            userAnswerService.save(userAnswer);

            // 推送题目给学生
            List<Map<String, Object>> pushQuestions = assigned.stream().map(q -> {
                Map<String, Object> map = new HashMap<>();
                map.put("id", q.getId());
                map.put("content", q.getContent());
                map.put("options", new Gson().fromJson(q.getOptions(), List.class));
                return map;
            }).collect(Collectors.toList());
            System.out.println("用户ID: " + userId + " 分配到的题目：");
            for (QuestionBank q : assigned) {
                System.out.println("  题目ID: " + q.getId() + " 内容: " + q.getContent() + " 选项: " + q.getOptions());
            }
            System.out.println("--------------------------------------------------");
            webSocketService.sendQuizToStudent(userId, pushQuestions);
        }
    }
}

