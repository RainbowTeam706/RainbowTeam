package com.pq.ai.ingest.model;

import lombok.Data;

@Data
public class FileIngestStatusResponse {
    private String taskId;
    private String fileName;
    private String status;
    private String errorCode;
    private String errorMessage;
    private Integer textLength;
    private Integer popQuizId;
    private Integer sent;
    private Long createdAt;
}
