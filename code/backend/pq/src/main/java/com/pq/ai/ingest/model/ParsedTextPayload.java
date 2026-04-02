package com.pq.ai.ingest.model;

import lombok.Data;

@Data
public class ParsedTextPayload {
    private String fileType;
    private String text;
    private Integer textLength;
}
