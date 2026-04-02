package com.pq.ai.ingest.extractor;

import java.io.InputStream;

public interface TextExtractor {
    boolean supports(String extension);

    String extract(InputStream inputStream, String fileName) throws Exception;
}
