package com.pq.integration;

import com.pq.entity.Activity;
import com.pq.entity.ActivityMember;
import com.pq.entity.PopQuiz;
import com.pq.entity.QuestionBank;
import com.pq.service.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
class QuizIntegrationTest {

    @Resource
    private IQuizService quizService;
    
    @Resource
    private IActivityService activityService;
    
    @Resource
    private IActivityMemberService activityMemberService;
    
    @Resource
    private IPopQuizService popQuizService;
    
    @Resource
    private IQuestionBankService questionBankService;
    
    @Resource
    private IUserAnswerService userAnswerService;

    private Integer testActivityId;
    private Integer testUserId = 1001;

    @BeforeEach
    void setUp() {
        // 创建测试活动
        Activity activity = new Activity()
                .setName("AI题目生成测试活动")
                .setDescription("用于测试AI题目生成功能的活动")
                .setStartTime(new Date())
                .setEndTime(new Date(System.currentTimeMillis() + 3600000))
                .setStatus(0)
                .setCreatorId(1);
        activityService.save(activity);
        testActivityId = activity.getId();

        // 添加测试用户到活动
        ActivityMember member = new ActivityMember()
                .setActivityId(testActivityId)
                .setUserId(testUserId);
        activityMemberService.save(member);
        
        System.out.println("=== 测试环境准备完成 ===");
        System.out.println("测试活动ID: " + testActivityId);
        System.out.println("测试用户ID: " + testUserId);
    }

    @Test
    @DisplayName("完整的PopQuiz创建和AI题目生成流程测试")
    void testCompleteQuizCreationFlow() {
        // Given
        Integer questionCount = 3;
        int lastTime = 10; // 10分钟
        String text = "Java面向对象编程，包括类、对象、继承、多态、封装等核心概念";

        // When - 创建PopQuiz并生成AI题目
        System.out.println("=== 开始创建PopQuiz ===");
        quizService.createAndSendQuiz(testActivityId, questionCount, lastTime, text);

        // Then - 验证PopQuiz创建
        List<Map<String, Object>> popQuizList = quizService.getPopQuizListByActivityId(testActivityId);
        assertFalse(popQuizList.isEmpty(), "应该创建了PopQuiz");
        
        Map<String, Object> popQuiz = popQuizList.get(0);
        Integer popQuizId = (Integer) popQuiz.get("id");
        assertEquals(testActivityId, popQuiz.get("activityId"), "ActivityId应该匹配");
        assertEquals(10L, popQuiz.get("durationMinutes"), "持续时间应该匹配");

        // 验证题目生成
        List<QuestionBank> questions = questionBankService.list(
            questionBankService.query().eq("popQuizId", popQuizId).getWrapper()
        );
        assertEquals(questionCount, questions.size(), "应该生成指定数量的题目");

        // 验证题目内容
        for (QuestionBank question : questions) {
            assertNotNull(question.getContent(), "题目内容不应为空");
            assertNotNull(question.getOptions(), "题目选项不应为空");
            assertNotNull(question.getAnswer(), "题目答案不应为空");
            assertTrue(question.getAnswer().matches("[ABCD]"), "答案格式应该正确");
        }

        // 验证用户答题记录创建
        long userAnswerCount = userAnswerService.count(
            userAnswerService.query().eq("popQuizId", popQuizId).getWrapper()
        );
        assertEquals(1, userAnswerCount, "应该为测试用户创建答题记录");

        System.out.println("=== 流程测试完成 ===");
        System.out.println("PopQuizId: " + popQuizId);
        System.out.println("生成题目数量: " + questions.size());
        questions.forEach(q -> {
            System.out.println("题目: " + q.getContent());
            System.out.println("选项: " + q.getOptions());
            System.out.println("答案: " + q.getAnswer());
            System.out.println("---");
        });
    }

    @Test
    @DisplayName("测试答题提交和结果查询功能")
    void testAnswerSubmissionAndResultQuery() {
        // Given - 先创建PopQuiz
        Integer questionCount = 2;
        int lastTime = 5;
        String text = "数据库基础知识测试";
        
        quizService.createAndSendQuiz(testActivityId, questionCount, lastTime, text);
        
        // 获取创建的PopQuiz
        List<Map<String, Object>> popQuizList = quizService.getPopQuizListByActivityId(testActivityId);
        Integer popQuizId = (Integer) popQuizList.get(0).get("id");

        // When - 提交答案
        Map<Integer, Integer> answers = Map.of(
            0, 0, // 第1题选择A
            1, 1  // 第2题选择B
        );
        
        boolean submitResult = quizService.admit(popQuizId, testUserId, answers);
        assertTrue(submitResult, "答案提交应该成功");

        // Then - 查询结果
        Map<String, Object> testResult = quizService.getStudentTestResult(popQuizId, testUserId);
        assertNotNull(testResult, "应该能查询到测试结果");
        assertEquals(popQuizId, testResult.get("popQuizId"), "PopQuizId应该匹配");
        assertEquals(testUserId, testResult.get("userId"), "UserId应该匹配");
        assertEquals(questionCount, testResult.get("totalQuestions"), "题目总数应该匹配");

        System.out.println("=== 答题测试完成 ===");
        System.out.println("提交结果: " + submitResult);
        System.out.println("测试结果: " + testResult);
    }

    @Test
    @DisplayName("测试PopQuiz统计功能")
    void testPopQuizStatistics() {
        // Given - 创建PopQuiz并提交答案
        Integer questionCount = 2;
        quizService.createAndSendQuiz(testActivityId, questionCount, 5, "统计测试主题");
        
        List<Map<String, Object>> popQuizList = quizService.getPopQuizListByActivityId(testActivityId);
        Integer popQuizId = (Integer) popQuizList.get(0).get("id");
        
        // 提交答案
        Map<Integer, Integer> answers = Map.of(0, 0, 1, 1);
        quizService.admit(popQuizId, testUserId, answers);

        // When - 获取统计信息
        Map<String, Object> statistics = quizService.getPopQuizStatistics(popQuizId);

        // Then - 验证统计信息
        assertNotNull(statistics, "应该能获取统计信息");
        assertEquals(popQuizId, statistics.get("popQuizId"), "PopQuizId应该匹配");
        assertEquals(questionCount, statistics.get("totalQuestions"), "题目总数应该匹配");
        assertEquals(1, statistics.get("totalUsers"), "用户总数应该匹配");

        System.out.println("=== 统计测试完成 ===");
        System.out.println("统计信息: " + statistics);
    }
}