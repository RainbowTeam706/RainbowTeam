package com.pq.ai.gateway;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pq.dto.doubao.DoubaoRequest;
import com.pq.dto.doubao.DoubaoResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

/**
 * 豆包模型网关实现。
 *
 * 职责：
 * 1) 封装豆包 HTTP 请求细节；
 * 2) 统一模型参数（temperature/maxTokens）；
 * 3) 返回标准化文本内容给上层编排器。
 */
@Slf4j
@Component
public class DoubaoGatewayImpl implements LLMGateway {

    @Resource
    private CloseableHttpClient httpClient;

    @Value("${doubao.api.key}")
    private String doubaoApiKey;

    @Value("${doubao.api.url}")
    private String doubaoApiUrl;

    @Value("${doubao.model}")
    private String doubaoModel;

    private final ObjectMapper objectMapper = new ObjectMapper()
            .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
            .configure(DeserializationFeature.ACCEPT_EMPTY_STRING_AS_NULL_OBJECT, true);

    /**
     * 调用豆包生成文本内容。
     *
     * @param prompt               本次请求的完整提示词
     * @param expectedQuestionCount 期望题量，用于动态估算 maxTokens
     */
    @Override
    public String generateContent(String prompt, int expectedQuestionCount) {
        if (doubaoApiKey == null || doubaoApiKey.trim().isEmpty()) {
            throw new IllegalStateException("Doubao API key is not configured");
        }

        try {
            // 构造请求体
            DoubaoRequest request = new DoubaoRequest();
            request.setModel(doubaoModel);
            request.setTemperature(0.4);
            request.setMaxTokens(Math.min(1500, Math.max(400, expectedQuestionCount * 220)));
            request.setMessages(Arrays.asList(new DoubaoRequest.Message("user", prompt)));

            String requestJson = objectMapper.writeValueAsString(request);

            HttpPost httpPost = new HttpPost(doubaoApiUrl);
            httpPost.setHeader("Content-Type", "application/json");
            httpPost.setHeader("Authorization", "Bearer " + doubaoApiKey);
            httpPost.setEntity(new StringEntity(requestJson, StandardCharsets.UTF_8));

            try (CloseableHttpResponse response = httpClient.execute(httpPost)) {
                int statusCode = response.getStatusLine().getStatusCode();
                String responseBody = EntityUtils.toString(response.getEntity(), StandardCharsets.UTF_8);

                // 非 200 直接抛出异常，由上层决定 fallback
                if (statusCode != 200) {
                    throw new IllegalStateException("Doubao API error, status=" + statusCode + ", body=" + responseBody);
                }

                DoubaoResponse doubaoResponse = objectMapper.readValue(responseBody, DoubaoResponse.class);
                if (doubaoResponse.getError() != null) {
                    throw new IllegalStateException("Doubao API response error: " + doubaoResponse.getError().getMessage());
                }
                if (doubaoResponse.getChoices() == null || doubaoResponse.getChoices().isEmpty()) {
                    throw new IllegalStateException("Doubao API returned empty choices");
                }

                String content = doubaoResponse.getChoices().get(0).getMessage().getContent();
                if (content == null || content.trim().isEmpty()) {
                    throw new IllegalStateException("Doubao API returned empty content");
                }
                return content;
            }
        } catch (Exception e) {
            log.error("Doubao gateway generate content failed: {}", e.getMessage(), e);
            throw new RuntimeException(e);
        }
    }
}
