package com.pq.service.impl;

import com.pq.ai.dto.GenerateQuestionCommand;
import com.pq.ai.dto.GenerateQuestionResult;
import com.pq.ai.orchestrator.AIQuestionOrchestrator;
import com.pq.entity.QuestionBank;
import com.pq.service.IAIQuestionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class AIQuestionServiceImpl implements IAIQuestionService {

    private final AIQuestionOrchestrator orchestrator;

    @Override
    public List<QuestionBank> generateQuestions(String topic, int questionCount, Integer popQuizId, Integer activityId) {
        GenerateQuestionCommand command = new GenerateQuestionCommand();
        command.setTopicText(topic);
        command.setQuestionCount(questionCount);
        command.setPopQuizId(popQuizId);
        command.setActivityId(activityId);
        command.setDifficulty("medium");

        GenerateQuestionResult result = orchestrator.generate(command);
        int count = result.getQuestions() == null ? 0 : result.getQuestions().size();

        log.info("AI题目生成完成: count={}, initialValid={}, refined={}, fallback={}, avgScore={}, elapsedMs={}",
                count,
                result.getInitialValidCount(),
                result.getRefinedCount(),
                result.isFallbackUsed(),
                result.getAvgQualityScore(),
                result.getElapsedMs());

        if (count == 0) {
            log.warn("AI_QGEN_EMPTY_RESULT: topicLength={}, requestedCount={}, popQuizId={}, elapsedMs={}",
                    topic == null ? 0 : topic.length(),
                    questionCount,
                    popQuizId,
                    result.getElapsedMs());
        }

        return result.getQuestions();
    }
}
