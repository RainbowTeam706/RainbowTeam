package com.pq.ai.ingest;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.pq.entity.AiFileTask;
import com.pq.enums.FileTaskStatus;
import com.pq.entity.PopQuiz;
import com.pq.entity.QuestionBank;
import com.pq.service.IAIQuestionService;
import com.pq.service.IAiFileTaskService;
import com.pq.service.IPopQuizService;
import com.pq.service.IQuestionBankService;
import com.pq.utils.WebSocketService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class FileIngestAsyncService {

    private final FileParserRouter parserRouter;
    private final TextNormalizeService normalizeService;
    private final IAiFileTaskService aiFileTaskService;
    private final IPopQuizService popQuizService;
    private final IQuestionBankService questionBankService;
    private final IAIQuestionService aiQuestionService;
    private final WebSocketService webSocketService;

    @Async("taskExecutor")
    public void processAsync(String taskId, String fileName, byte[] fileBytes) {
        AiFileTask task = aiFileTaskService.getOne(new QueryWrapper<AiFileTask>().eq("task_id", taskId), false);
        if (task == null) {
            return;
        }

        try {
            task.setStatus(FileTaskStatus.PROCESSING.name()).setUpdatedAt(new Date());
            aiFileTaskService.updateById(task);
            pushStatus(task, FileTaskStatus.PROCESSING.name(), null, null);

            // 1) 创建 PopQuiz 记录（先创建，再生成题）
            Date now = new Date();
            PopQuiz popQuiz = new PopQuiz()
                    .setActivityId(task.getActivityId())
                    .setStartTime(now)
                    .setEndTime(new Date(now.getTime() + 10L * 60L * 1000L))
                    .setStatus(0)
                    .setTaskId(task.getTaskId())
                    .setSent(0);
            popQuizService.save(popQuiz);

            // 2) 文件转文本
            String extracted = parserRouter.extractText(fileBytes, fileName);
            String normalized = normalizeService.normalize(extracted);

            // 3) 调用 AI 出题（题量固定 10）
            java.util.List<QuestionBank> questions = aiQuestionService.generateQuestions(normalized, 10, popQuiz.getId(), task.getActivityId());
            if (questions != null && !questions.isEmpty()) {
                questionBankService.saveBatch(questions);
            }

            // 4) 回填任务关联的 popQuizId
            task.setPopQuizId(popQuiz.getId())
                    .setStatus(FileTaskStatus.SUCCESS.name())
                    .setTextLength(normalized.length())
                    .setUpdatedAt(new Date())
                    .setErrorCode(null)
                    .setErrorMessage(null);
            aiFileTaskService.updateById(task);

            log.info("[FILE-INGEST] success taskId={}, textLength={}", taskId, normalized.length());
            pushStatus(task, FileTaskStatus.SUCCESS.name(), null, null);
        } catch (Exception e) {
            task.setStatus(FileTaskStatus.FAILED.name())
                    .setUpdatedAt(new Date())
                    .setErrorCode("PARSE_FAILED")
                    .setErrorMessage(e.getMessage());
            aiFileTaskService.updateById(task);
            log.error("[FILE-INGEST] failed taskId={}, message={}", taskId, e.getMessage(), e);
            pushStatus(task, FileTaskStatus.FAILED.name(), "PARSE_FAILED", e.getMessage());
        }
    }

    private void pushStatus(AiFileTask task, String status, String errorCode, String errorMessage) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("type", "FILE_INGEST_STATUS");
        payload.put("taskId", task.getTaskId());
        payload.put("activityId", task.getActivityId());
        payload.put("status", status);
        payload.put("textLength", task.getTextLength());
        payload.put("popQuizId", task.getPopQuizId());
        payload.put("errorCode", errorCode);
        payload.put("errorMessage", errorMessage);
        webSocketService.sendFileIngestStatus(task.getActivityId(), payload);
    }
}
