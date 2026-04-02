package com.pq.ai.ingest.extractor;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.springframework.stereotype.Component;

import java.io.InputStream;

@Component
public class DocxTextExtractor implements TextExtractor {
    @Override
    public boolean supports(String extension) {
        return "docx".equalsIgnoreCase(extension);
    }

    @Override
    public String extract(InputStream inputStream, String fileName) throws Exception {
        StringBuilder sb = new StringBuilder();
        try (XWPFDocument doc = new XWPFDocument(inputStream)) {
            for (XWPFParagraph p : doc.getParagraphs()) {
                if (p.getText() != null && !p.getText().trim().isEmpty()) {
                    sb.append(p.getText()).append("\n");
                }
            }
        }
        return sb.toString();
    }
}
