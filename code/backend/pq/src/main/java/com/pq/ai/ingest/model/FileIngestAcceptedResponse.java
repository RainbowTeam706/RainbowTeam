package com.pq.ai.ingest.model;

import lombok.Data;

@Data
public class FileIngestAcceptedResponse {
    private String taskId;
    private String status;
}
