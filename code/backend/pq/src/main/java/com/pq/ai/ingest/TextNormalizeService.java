package com.pq.ai.ingest;

import org.springframework.stereotype.Service;

@Service
public class TextNormalizeService {
    public String normalize(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("\r", "\n")
                .replaceAll("[\t\f\u000B]+", " ")
                .replaceAll("[ ]+", " ")
                .replaceAll("\n{2,}", "\n")
                .trim();
    }
}
