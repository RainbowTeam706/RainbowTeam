package com.pq.dto.doubao;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class DoubaoResponse {
    private String id;
    private String object;
    private Long created;
    private String model;
    private List<Choice> choices;
    private Usage usage;
    private DoubaoError error;
    @JsonProperty("service_tier")
    private String serviceTier;

    @JsonIgnoreProperties(ignoreUnknown = true)
    @Data
    public static class Choice {
        private Integer index;
        private Message message;
        @JsonProperty("finish_reason")
        private String finishReason;
        private Object logprobs;
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    @Data
    public static class Message {
        private String role;
        private String content;
        @JsonProperty("reasoning_content")
        private String reasoningContent;
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    @Data
    public static class Usage {
        @JsonProperty("prompt_tokens")
        private Integer promptTokens;
        @JsonProperty("completion_tokens")
        private Integer completionTokens;
        @JsonProperty("total_tokens")
        private Integer totalTokens;
        @JsonProperty("prompt_tokens_details")
        private TokenDetails promptTokensDetails;
        @JsonProperty("completion_tokens_details")
        private TokenDetails completionTokensDetails;
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    @Data
    public static class TokenDetails {
        @JsonProperty("cached_tokens")
        private Integer cachedTokens;
        @JsonProperty("reasoning_tokens")
        private Integer reasoningTokens;
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    @Data
    public static class DoubaoError {
        private String message;
        private String type;
        private String param;
        private String code;
    }
}