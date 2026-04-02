package com.pq.ai.ingest;

import com.pq.ai.ingest.extractor.TextExtractor;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.io.ByteArrayInputStream;
import java.util.List;

@Component
@RequiredArgsConstructor
public class FileParserRouter {

    private final List<TextExtractor> extractors;

    public String extractText(byte[] fileBytes, String fileName) throws Exception {
        String extension = getExtension(fileName);
        for (TextExtractor extractor : extractors) {
            if (extractor.supports(extension)) {
                try (ByteArrayInputStream inputStream = new ByteArrayInputStream(fileBytes)) {
                    return extractor.extract(inputStream, fileName);
                }
            }
        }
        throw new IllegalArgumentException("Unsupported file type: " + extension);
    }

    public String detectFileType(String filename) {
        return getExtension(filename);
    }

    private String getExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "";
        }
        return filename.substring(filename.lastIndexOf('.') + 1).toLowerCase();
    }
}
