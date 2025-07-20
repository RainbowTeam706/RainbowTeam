package com.pq.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.pq.dto.doubao.AIQuestionDTO;
import com.pq.dto.doubao.DoubaoRequest;
import com.pq.dto.doubao.DoubaoResponse;
import com.pq.entity.QuestionBank;
import com.pq.service.IAIQuestionService;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

@Slf4j
@Service
public class AIQuestionServiceImpl implements IAIQuestionService {

    @Resource
    private CloseableHttpClient httpClient;

    @Value("${doubao.api.key:45916371-4be9-4c96-85ef-36e37b23c04a}")
    private String doubaoApiKey;

    @Value("${doubao.api.url:https://ark.cn-beijing.volces.com/api/v3/chat/completions}")
    private String doubaoApiUrl;

    @Value("${doubao.model:doubao-seed-1-6-250615}")
    private String doubaoModel;

    private final ObjectMapper objectMapper = new ObjectMapper()
            .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
            .configure(DeserializationFeature.FAIL_ON_NULL_FOR_PRIMITIVES, false)
            .configure(DeserializationFeature.ACCEPT_EMPTY_STRING_AS_NULL_OBJECT, true);
    private final Gson gson = new Gson();

    @Override
    public List<QuestionBank> generateQuestions(String topic, int questionCount, Integer popQuizId) {
        log.info("开始使用豆包模型生成AI题目 - 主题: {}, 数量: {}", topic, questionCount);
        
        try {
            // 检查API密钥
            if (doubaoApiKey == null || doubaoApiKey.trim().isEmpty()) {
                log.warn("豆包API密钥未配置，使用备用题目生成");
                return generateFallbackQuestions(topic, questionCount, popQuizId);
            }

            // 构建请求
            DoubaoRequest request = buildDoubaoRequest(topic, questionCount);
            String requestJson = objectMapper.writeValueAsString(request);
            log.debug("豆包API请求: {}", requestJson);

            // 发送HTTP请求
            HttpPost httpPost = new HttpPost(doubaoApiUrl);
            httpPost.setHeader("Content-Type", "application/json");
            httpPost.setHeader("Authorization", "Bearer " + doubaoApiKey);
            httpPost.setEntity(new StringEntity(requestJson, "UTF-8"));

            try (CloseableHttpResponse response = httpClient.execute(httpPost)) {
                String responseBody = EntityUtils.toString(response.getEntity(), "UTF-8");
                log.debug("豆包API响应: {}", responseBody);

                if (response.getStatusLine().getStatusCode() == 200) {
                    return parseDoubaoResponse(responseBody, popQuizId, topic, questionCount);
                } else {
                    log.error("豆包API调用失败，状态码: {}, 响应: {}", 
                            response.getStatusLine().getStatusCode(), responseBody);
                    return generateFallbackQuestions(topic, questionCount, popQuizId);
                }
            }

        } catch (Exception e) {
            log.error("调用豆包API时发生异常: {}", e.getMessage(), e);
            return generateFallbackQuestions(topic, questionCount, popQuizId);
        }
    }

    private DoubaoRequest buildDoubaoRequest(String topic, int questionCount) {
        DoubaoRequest request = new DoubaoRequest();
        request.setModel(doubaoModel);
        request.setTemperature(0.5); // 降低temperature提高响应速度
        request.setMaxTokens(Math.min(1000, questionCount * 200)); // 动态调整token数量
        
        String prompt = buildOptimizedPrompt(topic, questionCount);
        
        List<DoubaoRequest.Message> messages = Arrays.asList(
            new DoubaoRequest.Message("user", prompt)
        );
        request.setMessages(messages);
        
        return request;
    }

    private String buildOptimizedPrompt(String topic, int questionCount) {
        return String.format(
            "基于以下内容生成%d道单选题，直接返回JSON数组：\n\n" +
            "内容：%s\n\n" +
            "要求：每题4选项(A-D)，难度适中，JSON格式：\n" +
            "[{\"content\":\"题目\",\"options\":[\"A\",\"B\",\"C\",\"D\"],\"answer\":\"A\"}]\n" +
            "只返回JSON，无其他文字。",
            questionCount, topic
        );
    }

    private List<QuestionBank> parseDoubaoResponse(String responseBody, Integer popQuizId, 
                                                  String topic, int questionCount) {
        try {
            log.debug("开始解析豆包API响应，响应长度: {}", responseBody.length());
            
            DoubaoResponse response = objectMapper.readValue(responseBody, DoubaoResponse.class);
            
            if (response.getError() != null) {
                log.error("豆包API返回错误: code={}, message={}, type={}", 
                        response.getError().getCode(),
                        response.getError().getMessage(),
                        response.getError().getType());
                return generateFallbackQuestions(topic, questionCount, popQuizId);
            }

            if (response.getChoices() == null || response.getChoices().isEmpty()) {
                log.error("豆包API响应中没有choices数据");
                return generateFallbackQuestions(topic, questionCount, popQuizId);
            }

            String content = response.getChoices().get(0).getMessage().getContent();
            log.info("豆包AI生成的内容: {}", content);

            return parseAIQuestions(content, popQuizId, topic, questionCount);

        } catch (Exception e) {
            log.error("解析豆包API响应时发生错误，响应内容: {}", responseBody, e);
            return generateFallbackQuestions(topic, questionCount, popQuizId);
        }
    }

    private List<QuestionBank> parseAIQuestions(String content, Integer popQuizId, 
                                               String topic, int questionCount) {
        try {
            // 清理可能的markdown代码块标记
            content = content.replaceAll("```json", "").replaceAll("```", "").trim();
            
            // 解析JSON数组
            List<AIQuestionDTO> aiQuestions = gson.fromJson(content, 
                new TypeToken<List<AIQuestionDTO>>(){}.getType());

            if (aiQuestions == null || aiQuestions.isEmpty()) {
                log.warn("AI生成的题目为空，使用备用方案");
                return generateFallbackQuestions(topic, questionCount, popQuizId);
            }

            List<QuestionBank> questionList = new ArrayList<>();
            for (int i = 0; i < Math.min(aiQuestions.size(), questionCount); i++) {
                AIQuestionDTO aiQuestion = aiQuestions.get(i);
                
                if (isValidAIQuestion(aiQuestion)) {
                    QuestionBank question = new QuestionBank()
                            .setPopQuizId(popQuizId)
                            .setContent(aiQuestion.getContent())
                            .setOptions(gson.toJson(aiQuestion.getOptions()))
                            .setAnswer(aiQuestion.getAnswer().toUpperCase());
                    questionList.add(question);
                } else {
                    log.warn("AI生成的第{}道题目格式不正确，跳过", i + 1);
                }
            }

            // 如果AI生成的有效题目不够，补充备用题目
            if (questionList.size() < questionCount) {
                int remainingCount = questionCount - questionList.size();
                log.info("AI生成{}道有效题目，还需补充{}道备用题目", questionList.size(), remainingCount);
                questionList.addAll(generateFallbackQuestions(topic, remainingCount, popQuizId));
            }

            log.info("成功生成{}道题目（AI生成: {}道）", questionList.size(), 
                    Math.min(aiQuestions.size(), questionCount));
            return questionList;

        } catch (Exception e) {
            log.error("解析AI题目JSON时发生错误: {}", e.getMessage(), e);
            return generateFallbackQuestions(topic, questionCount, popQuizId);
        }
    }

    private boolean isValidAIQuestion(AIQuestionDTO question) {
        return question != null 
                && question.getContent() != null && !question.getContent().trim().isEmpty()
                && question.getOptions() != null && question.getOptions().size() == 4
                && question.getAnswer() != null 
                && question.getAnswer().matches("[ABCD]");
    }

    private List<QuestionBank> generateFallbackQuestions(String topic, int questionCount, Integer popQuizId) {
        log.info("生成{}道关于'{}'的备用题目", questionCount, topic);
        
        List<QuestionBank> questionList = new ArrayList<>();
        Random random = new Random();
        
        for (int i = 1; i <= questionCount; i++) {
            char randomAnswer = (char) ('A' + random.nextInt(4));
            QuestionBank question = new QuestionBank()
                    .setPopQuizId(popQuizId)
                    .setContent(String.format("关于'%s'的第%d道题目", topic, i))
                    .setOptions("[\"选项A\",\"选项B\",\"选项C\",\"选项D\"]")
                    .setAnswer(String.valueOf(randomAnswer));
            questionList.add(question);
        }
        
        return questionList;
    }
}
