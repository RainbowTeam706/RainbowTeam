package com.pq.ai.prompt;

import org.springframework.stereotype.Service;

/**
 * Prompt 模板服务实现。
 *
 * 负责集中维护：
 * - 首次出题 Prompt
 * - 低分题重写 Prompt
 *
 * 通过模板化减少散落拼接字符串造成的维护成本。
 */
@Service
public class PromptTemplateServiceImpl implements PromptTemplateService {


    /**
     * 构建首次出题 Prompt。
     */
    @Override
    public String buildGeneratePrompt(String topicText, int questionCount, String difficulty, String memoryContext) {
        String difficultyText = (difficulty == null || difficulty.trim().isEmpty()) ? "medium" : difficulty;
        String memoryPart = (memoryContext == null || memoryContext.trim().isEmpty())
                ? ""
                : "\n活动历史记忆（用于保持同一活动上下文一致性）：\n" + memoryContext + "\n";

        return String.format(
                "你是一名严谨的教学测验专家。请基于给定文本生成%d道高质量单选题。\n" +
                        "要求：\n" +
                        "1) 每题必须4个选项，答案只能是A/B/C/D。\n" +
                        "2) 题目必须基于文本内容，不允许脱离文本。\n" +
                        "3) 避免纯定义复述题，优先生成因果、对比、应用、推理类题目。\n" +
                        "4) 干扰项要具有迷惑性但明确错误，不能出现多解。\n" +
                        "5) 难度等级：%s。\n" +
                        "输出格式严格为JSON数组：\n" +
                        "[{\"content\":\"题干\",\"options\":[\"A选项\",\"B选项\",\"C选项\",\"D选项\"],\"answer\":\"A\"}]\n" +
                        "只输出JSON，不要输出任何解释文字。\n\n" +
                        "%s" +
                        "文本内容：\n%s",
                questionCount, difficultyText, memoryPart, topicText
        );
    }

}
