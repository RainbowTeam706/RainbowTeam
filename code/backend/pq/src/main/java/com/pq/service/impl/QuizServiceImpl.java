package com.pq.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.google.gson.Gson;
import com.pq.entity.Activity;
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

    @Resource
    private IActivityService activityService;

    @Override
    @Transactional
    public void createAndSendQuiz(Integer activityId, Integer questionCount, int lastTime, String text) {
        throw new UnsupportedOperationException("发题接口已升级，请使用 popQuizId + questionCount + lastTime");
    }

    @Override
    @Transactional
    public void createAndSendQuizByPopQuizId(Integer popQuizId, Integer questionCount, int lastTime) {
        PopQuiz popQuiz = popQuizService.getById(popQuizId);
        if (popQuiz == null) {
            throw new IllegalArgumentException("popQuiz 不存在: " + popQuizId);
        }
        if (popQuiz.getSent() != null && popQuiz.getSent() == 1) {
            throw new IllegalStateException("该测验已发题，不能重复发题");
        }

        Integer activityId = popQuiz.getActivityId();
        Activity activity = activityService.getById(activityId);
        if (activity == null) {
            throw new IllegalArgumentException("活动不存在: " + activityId);
        }
        if (activity.getStatus() == 2) {
            throw new IllegalStateException("活动已结束，操作被拒绝");
        }

        // 更新时间窗口（发题时才设置）
        Date startTime = new Date();
        Date endTime = new Date(startTime.getTime() + lastTime * 60 * 1000L);
        popQuiz.setStartTime(startTime).setEndTime(endTime).setStatus(0);
        popQuizService.updateById(popQuiz);

        // 直接读取该测验下已生成题目（文件解析阶段已生成）
        List<QuestionBank> questionList = questionBankService.list(new QueryWrapper<QuestionBank>().eq("popQuizId", popQuizId));
        if (questionList == null || questionList.isEmpty()) {
            throw new IllegalStateException("该测验暂无题目，无法发题");
        }

        // 3. 查询所有参与学生
        List<Integer> studentIds = activityMemberService
                .list(new QueryWrapper<ActivityMember>().eq("activityId", activityId))
                .stream().map(ActivityMember::getUserId).collect(Collectors.toList());

        // 4. 为每个学生分配不同试题并推送
        for (Integer userId : studentIds) {
            // 随机抽取题目
            List<QuestionBank> randomQuestions = new ArrayList<>(questionList);
            Collections.shuffle(randomQuestions);
            List<QuestionBank> assigned = randomQuestions.subList(0, Math.min(questionCount, randomQuestions.size()));

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

            // 组装完整的推送数据，包含题目和绝对截止时间
            Map<String, Object> pushData = new HashMap<>();
            pushData.put("questions", pushQuestions);
            pushData.put("lastTime", lastTime * 60); // 兼容旧前端（秒）
            pushData.put("startTime", startTime);
            pushData.put("endTime", endTime);
            pushData.put("activityId", activityId);
            pushData.put("questionCount", questionCount);
            pushData.put("popQuizId", popQuiz.getId());

            System.out.println("用户ID: " + userId + " 分配到的AI生成题目：");
            System.out.println("时间限制: " + lastTime + "分钟 (" + (lastTime * 60) + "秒)");
            for (QuestionBank q : assigned) {
                System.out.println("  题目ID: " + q.getId() + " 内容: " + q.getContent() + " 选项: " + q.getOptions());
            }
            System.out.println("--------------------------------------------------");
            webSocketService.sendQuizToStudent(userId, pushData);
        }

        // 标记已发题（一个测验只允许发一次）
        popQuiz.setSent(1);
        popQuizService.updateById(popQuiz);
    }

    @Override
    @Transactional
    public boolean admit(Integer popQuizId, Integer userId, Map<Integer, Integer> answers) {
        try {
            System.out.println("开始提交答案 - PopQuizID: " + popQuizId + ", 用户ID: " + userId);
            System.out.println("答案数据: " + answers);

            // 1. 校验测验是否已截止（以后端时间为准）
            PopQuiz popQuiz = popQuizService.getById(popQuizId);
            if (popQuiz == null) {
                System.err.println("测验不存在 - PopQuizID: " + popQuizId);
                return false;
            }
            Date now = new Date();
            if (popQuiz.getEndTime() != null && now.after(popQuiz.getEndTime())) {
                System.err.println("测验已截止，拒绝提交 - PopQuizID: " + popQuizId + ", 用户ID: " + userId);
                return false;
            }

            // 2. 查询用户的答题记录
            QueryWrapper<UserAnswer> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("popQuizId", popQuizId)
                    .eq("userId", userId);
            UserAnswer userAnswer = userAnswerService.getOne(queryWrapper);

            if (userAnswer == null) {
                System.err.println("未找到用户的答题记录 - PopQuizID: " + popQuizId + ", 用户ID: " + userId);
                return false;
            }

            // 2. 获取题目ID列表
            String[] questionIdArray = userAnswer.getQuestionIds().split(",");
            List<Integer> questionIds = Arrays.stream(questionIdArray)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());

            System.out.println("题目ID列表: " + questionIds);

            // 3. 查询题目信息，获取正确答案
            List<QuestionBank> questions = questionBankService.listByIds(questionIds);
            Map<Integer, String> correctAnswers = questions.stream()
                    .collect(Collectors.toMap(QuestionBank::getId, QuestionBank::getAnswer));

            System.out.println("正确答案映射: " + correctAnswers);

            // 4. 构建答案字符串和正确性判断
            List<String> answerList = new ArrayList<>();
            List<String> isCorrectList = new ArrayList<>();

            for (int i = 0; i < questionIds.size(); i++) {
                Integer questionId = questionIds.get(i);
                Integer selectedOption = answers.get(i);

                if (selectedOption != null) {
                    // 将选项索引转换为选项字母 (0->A, 1->B, 2->C, 3->D)
                    String selectedAnswer = String.valueOf((char) ('A' + selectedOption));
                    answerList.add(selectedAnswer);

                    // 判断是否正确
                    String correctAnswer = correctAnswers.get(questionId);
                    boolean isCorrect = selectedAnswer.equals(correctAnswer);
                    isCorrectList.add(isCorrect ? "1" : "0");

                    System.out.println("题目" + (i + 1) + " - 选择: " + selectedAnswer +
                            ", 正确答案: " + correctAnswer +
                            ", 是否正确: " + isCorrect);
                } else {
                    // 未答题
                    answerList.add("");
                    isCorrectList.add("0");
                    System.out.println("题目" + (i + 1) + " - 未答题");
                }
            }

            // 5. 更新用户答案记录
            String optionsString = String.join(",", answerList);
            String isCorrectString = String.join(",", isCorrectList);

            userAnswer.setOptions(optionsString);
            userAnswer.setIsCorrect(isCorrectString);
            userAnswer.setAnswerTime(new Date());

            boolean updateResult = userAnswerService.updateById(userAnswer);

            if (updateResult) {
                System.out.println("答案提交成功 - PopQuizID: " + popQuizId + ", 用户ID: " + userId);
                System.out.println("答案: " + optionsString);
                System.out.println("正确性: " + isCorrectString);
                return true;
            } else {
                System.err.println("答案更新失败 - PopQuizID: " + popQuizId + ", 用户ID: " + userId);
                return false;
            }

        } catch (Exception e) {
            System.err.println("提交答案时发生错误 - PopQuizID: " + popQuizId + ", 用户ID: " + userId);
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Map<String, Object>> getPopQuizListByActivityId(Integer activityId) {
        try {
            System.out.println("获取PopQuiz列表 - 活动ID: " + activityId);

            // 查询指定活动的所有PopQuiz
            QueryWrapper<PopQuiz> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("activityId", activityId)
                    .orderByDesc("startTime"); // 按开始时间倒序排列

            List<PopQuiz> popQuizList = popQuizService.list(queryWrapper);

            // 转换为Map格式返回
            List<Map<String, Object>> result = popQuizList.stream().map(popQuiz -> {
                Map<String, Object> map = new HashMap<>();
                map.put("id", popQuiz.getId());
                map.put("activityId", popQuiz.getActivityId());
                map.put("startTime", popQuiz.getStartTime());
                map.put("endTime", popQuiz.getEndTime());
                map.put("status", popQuiz.getStatus());
                map.put("taskId", popQuiz.getTaskId());
                map.put("sent", popQuiz.getSent() == null ? 0 : popQuiz.getSent());

                // 计算持续时间（分钟）
                long durationMinutes = (popQuiz.getEndTime().getTime() - popQuiz.getStartTime().getTime()) / (1000 * 60);
                map.put("durationMinutes", durationMinutes);

                return map;
            }).collect(Collectors.toList());

            System.out.println("查询到 " + result.size() + " 个PopQuiz记录");
            return result;

        } catch (Exception e) {
            System.err.println("获取PopQuiz列表失败 - 活动ID: " + activityId + ", 错误: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("获取PopQuiz列表失败", e);
        }
    }

    /**
     * 查询学生测试结果详情
     *
     * @param popQuizId PopQuiz ID
     * @param userId 学生ID
     * @return 测试结果详情
     */
    @Override
    public Map<String, Object> getStudentTestResult(Integer popQuizId, Integer userId) {
        try {
            System.out.println("查询学生测试结果 - PopQuizID: " + popQuizId + ", 用户ID: " + userId);

            // 1. 查询学生的答题记录
            QueryWrapper<UserAnswer> userAnswerQuery = new QueryWrapper<>();
            userAnswerQuery.eq("popQuizId", popQuizId)
                    .eq("userId", userId);
            UserAnswer userAnswer = userAnswerService.getOne(userAnswerQuery);

            if (userAnswer == null) {
                System.err.println("未找到学生的答题记录");
                return null;
            }

            // 2. 获取题目ID列表
            String[] questionIdArray = userAnswer.getQuestionIds().split(",");
            List<Integer> questionIds = Arrays.stream(questionIdArray)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());

            // 3. 查询题目信息，确保用 questionId 顺序
            Map<Integer, QuestionBank> questionMap = questionBankService.listByIds(questionIds)
                    .stream().collect(Collectors.toMap(QuestionBank::getId, q -> q));

            // 4. 解析学生的答案和正确性
            String[] studentAnswers = userAnswer.getOptions().split(",");
            String[] isCorrectArray = userAnswer.getIsCorrect().split(",");

            // 5. 构建返回数据
            List<Map<String, Object>> questionResults = new ArrayList<>();
            int correctCount = 0;

            for (int i = 0; i < questionIds.size(); i++) {
                Integer qid = questionIds.get(i);
                QuestionBank question = questionMap.get(qid);
                String studentAnswer = i < studentAnswers.length ? studentAnswers[i] : "";
                boolean isCorrect = i < isCorrectArray.length && "1".equals(isCorrectArray[i]);

                if (isCorrect) {
                    correctCount++;
                }

                Map<String, Object> questionResult = new HashMap<>();
                questionResult.put("questionId", qid);
                questionResult.put("content", question != null ? question.getContent() : "");
                questionResult.put("options", question != null ? new Gson().fromJson(question.getOptions(), List.class) : Collections.emptyList());
                questionResult.put("correctAnswer", question != null ? question.getAnswer() : "");
                questionResult.put("studentAnswer", studentAnswer);
                questionResult.put("isCorrect", isCorrect);

                questionResults.add(questionResult);
            }

            // 6. 计算统计信息
            int totalQuestions = questionIds.size();
            double accuracy = totalQuestions > 0 ? (double) correctCount / totalQuestions * 100 : 0;

            // 7. 构建最终返回结果
            Map<String, Object> result = new HashMap<>();
            result.put("popQuizId", popQuizId);
            result.put("userId", userId);
            result.put("totalQuestions", totalQuestions);
            result.put("correctCount", correctCount);
            result.put("accuracy", Math.round(accuracy * 100.0) / 100.0); // 保留两位小数
            result.put("submitTime", userAnswer.getAnswerTime());
            result.put("questions", questionResults);

            System.out.println("查询结果 - 总题数: " + totalQuestions +
                    ", 正确数: " + correctCount +
                    ", 正确率: " + accuracy + "%");

            return result;

        } catch (Exception e) {
            System.err.println("查询学生测试结果失败 - PopQuizID: " + popQuizId +
                    ", 用户ID: " + userId + ", 错误: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("查询学生测试结果失败", e);
        }
    }

    @Override
    public Map<String, Object> getPopQuizStatistics(Integer popQuizId) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 1. 查询该PopQuiz下所有UserAnswer
            List<UserAnswer> userAnswers = userAnswerService.list(new QueryWrapper<UserAnswer>().eq("popQuizId", popQuizId));
            if (userAnswers.isEmpty()) {
                result.put("popQuizId", popQuizId);
                result.put("totalQuestions", 0);
                result.put("totalUsers", 0);
                result.put("questions", Collections.emptyList());
                result.put("overallAccuracy", 0);
                return result;
            }

            // 2. 统计总人数
            int totalUsers = userAnswers.size();

            // 3. 获取所有题目ID
            Set<Integer> questionIdSet = new HashSet<>();
            for (UserAnswer ua : userAnswers) {
                if (ua.getQuestionIds() != null) {
                    for (String qid : ua.getQuestionIds().split(",")) {
                        if (!qid.isEmpty()) questionIdSet.add(Integer.parseInt(qid));
                    }
                }
            }
            List<Integer> questionIds = new ArrayList<>(questionIdSet);
            List<QuestionBank> questions = questionBankService.listByIds(questionIds);
            Map<Integer, QuestionBank> questionMap = questions.stream().collect(Collectors.toMap(QuestionBank::getId, q -> q));

            // 4. 统计每题作答和正确情况
            List<Map<String, Object>> questionStats = new ArrayList<>();
            int totalCorrect = 0, totalAnswered = 0;
            int totalQuestions = questionIds.size();
            for (int i = 0; i < totalQuestions; i++) {
                Integer qid = questionIds.get(i);
                QuestionBank qb = questionMap.get(qid);
                int answeredCount = 0, correctCount = 0;
                for (UserAnswer ua : userAnswers) {
                    String[] qids = ua.getQuestionIds().split(",");
                    String[] options = ua.getOptions() != null ? ua.getOptions().split(",") : new String[0];
                    String[] isCorrectArr = ua.getIsCorrect() != null ? ua.getIsCorrect().split(",") : new String[0];
                    for (int idx = 0; idx < qids.length; idx++) {
                        if (qids[idx].equals(String.valueOf(qid))) {
                            if (options.length > idx && !options[idx].isEmpty()) {
                                answeredCount++;
                                if (isCorrectArr.length > idx && "1".equals(isCorrectArr[idx])) {
                                    correctCount++;
                                }
                            }
                        }
                    }
                }
                totalAnswered += answeredCount;
                totalCorrect += correctCount;
                double accuracy = answeredCount > 0 ? (double) correctCount / answeredCount * 100 : 0;
                Map<String, Object> qstat = new HashMap<>();
                qstat.put("questionId", qid);
                qstat.put("content", qb != null ? qb.getContent() : "");
                qstat.put("options", qb != null ? new Gson().fromJson(qb.getOptions(), List.class) : Collections.emptyList());
                qstat.put("correctAnswer", qb != null ? qb.getAnswer() : "");
                qstat.put("answeredCount", answeredCount);
                qstat.put("correctCount", correctCount);
                qstat.put("accuracy", Math.round(accuracy * 100.0) / 100.0);
                questionStats.add(qstat);
            }
            double overallAccuracy = totalAnswered > 0 ? (double) totalCorrect / totalAnswered * 100 : 0;
            result.put("popQuizId", popQuizId);
            result.put("totalQuestions", totalQuestions);
            result.put("totalUsers", totalUsers);
            result.put("questions", questionStats);
            result.put("overallAccuracy", Math.round(overallAccuracy * 100.0) / 100.0);
            result.put("totalAnswered", totalAnswered);
            result.put("totalCorrect", totalCorrect);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("获取PopQuiz统计失败", e);
        }
    }

    @Override
    public Map<String, Object> getActiveQuizForStudent(Integer activityId, Integer userId) {
        Map<String, Object> result = new HashMap<>();

        // 查找该活动下进行中的测验（已发题且未截止）
        QueryWrapper<PopQuiz> popQuizQuery = new QueryWrapper<>();
        popQuizQuery.eq("activityId", activityId)
                .eq("sent", 1)
                .orderByDesc("startTime");
        List<PopQuiz> popQuizList = popQuizService.list(popQuizQuery);

        if (popQuizList == null || popQuizList.isEmpty()) {
            result.put("active", false);
            return result;
        }

        Date now = new Date();
        PopQuiz activeQuiz = popQuizList.stream()
                .filter(q -> q.getStartTime() != null && q.getEndTime() != null)
                .filter(q -> !now.before(q.getStartTime()) && now.before(q.getEndTime()))
                .findFirst()
                .orElse(null);

        if (activeQuiz == null) {
            result.put("active", false);
            return result;
        }

        QueryWrapper<UserAnswer> uaQuery = new QueryWrapper<>();
        uaQuery.eq("popQuizId", activeQuiz.getId()).eq("userId", userId);
        UserAnswer userAnswer = userAnswerService.getOne(uaQuery);
        if (userAnswer == null) {
            result.put("active", false);
            return result;
        }

        List<Integer> questionIds = Arrays.stream(userAnswer.getQuestionIds().split(","))
                .filter(s -> s != null && !s.isEmpty())
                .map(Integer::parseInt)
                .collect(Collectors.toList());

        Map<Integer, QuestionBank> questionMap = questionBankService.listByIds(questionIds)
                .stream().collect(Collectors.toMap(QuestionBank::getId, q -> q));

        List<Map<String, Object>> questions = new ArrayList<>();
        for (Integer qid : questionIds) {
            QuestionBank q = questionMap.get(qid);
            if (q == null) continue;
            Map<String, Object> map = new HashMap<>();
            map.put("id", q.getId());
            map.put("content", q.getContent());
            map.put("options", new Gson().fromJson(q.getOptions(), List.class));
            questions.add(map);
        }

        Map<String, Integer> draftAnswers = new HashMap<>();
        String options = userAnswer.getOptions();
        if (options != null && !options.isEmpty()) {
            String[] arr = options.split(",");
            for (int i = 0; i < arr.length; i++) {
                String ans = arr[i];
                if (ans == null || ans.isEmpty()) continue;
                int optionIdx = ans.charAt(0) - 'A';
                if (optionIdx >= 0) {
                    draftAnswers.put(String.valueOf(i), optionIdx);
                }
            }
        }

        long totalSeconds = Math.max(0, (activeQuiz.getEndTime().getTime() - activeQuiz.getStartTime().getTime()) / 1000);

        result.put("active", true);
        result.put("popQuizId", activeQuiz.getId());
        result.put("activityId", activityId);
        result.put("startTime", activeQuiz.getStartTime());
        result.put("endTime", activeQuiz.getEndTime());
        result.put("lastTime", totalSeconds);
        result.put("questions", questions);
        result.put("answers", draftAnswers);
        return result;
    }

    @Override
    @Transactional
    public boolean saveDraftAnswers(Integer popQuizId, Integer userId, Map<Integer, Integer> answers) {
        PopQuiz popQuiz = popQuizService.getById(popQuizId);
        if (popQuiz == null) return false;
        Date now = new Date();
        if (popQuiz.getEndTime() != null && now.after(popQuiz.getEndTime())) {
            return false;
        }

        QueryWrapper<UserAnswer> query = new QueryWrapper<>();
        query.eq("popQuizId", popQuizId).eq("userId", userId);
        UserAnswer userAnswer = userAnswerService.getOne(query);
        if (userAnswer == null) return false;

        String[] questionIdArray = userAnswer.getQuestionIds().split(",");
        List<String> answerList = new ArrayList<>();
        for (int i = 0; i < questionIdArray.length; i++) {
            Integer selectedOption = answers.get(i);
            if (selectedOption == null) {
                answerList.add("");
            } else {
                answerList.add(String.valueOf((char) ('A' + selectedOption)));
            }
        }

        userAnswer.setOptions(String.join(",", answerList));
        return userAnswerService.updateById(userAnswer);
    }
}

