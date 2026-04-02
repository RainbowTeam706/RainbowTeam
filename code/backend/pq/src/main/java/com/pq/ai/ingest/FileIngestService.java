package com.pq.ai.ingest;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.pq.ai.ingest.model.FileIngestAcceptedResponse;
import com.pq.ai.ingest.model.FileIngestStatusResponse;
import com.pq.entity.AiFileTask;
import com.pq.entity.PopQuiz;
import com.pq.enums.FileTaskStatus;
import com.pq.service.IAiFileTaskService;
import com.pq.service.IPopQuizService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FileIngestService {

    private final IAiFileTaskService aiFileTaskService;
    private final IPopQuizService popQuizService;
    private final FileParserRouter parserRouter;
    private final FileIngestAsyncService asyncService;

    private static final List<String> ALLOWED_TYPES = Arrays.asList("txt", "pdf", "pptx", "docx", "webm", "wav", "mp3", "m4a", "ogg");

    public FileIngestAcceptedResponse accept(MultipartFile file, Integer activityId) {
        validate(file);

        String taskId = UUID.randomUUID().toString();
        Date now = new Date();

        AiFileTask task = new AiFileTask()
                .setTaskId(taskId)
                .setActivityId(activityId)
                .setFileName(file.getOriginalFilename())
                .setFileType(parserRouter.detectFileType(file.getOriginalFilename()))
                .setFileSize(file.getSize())
                .setStatus(FileTaskStatus.PENDING.name())
                .setTextLength(0)
                .setCreatedAt(now)
                .setUpdatedAt(now);
        aiFileTaskService.save(task);

        try {
            byte[] fileBytes = file.getBytes();
            asyncService.processAsync(taskId, file.getOriginalFilename(), fileBytes);
        } catch (Exception e) {
            throw new IllegalStateException("read upload file bytes failed", e);
        }

        FileIngestAcceptedResponse response = new FileIngestAcceptedResponse();
        response.setTaskId(taskId);
        response.setStatus(FileTaskStatus.PENDING.name());
        return response;
    }

    public FileIngestStatusResponse getStatus(String taskId) {
        AiFileTask task = aiFileTaskService.getOne(
                new com.baomidou.mybatisplus.core.conditions.query.QueryWrapper<AiFileTask>().eq("task_id", taskId),
                false
        );
        if (task == null) {
            return null;
        }

        FileIngestStatusResponse response = new FileIngestStatusResponse();
        response.setTaskId(task.getTaskId());
        response.setFileName(task.getFileName());
        response.setStatus(task.getStatus());
        response.setErrorCode(task.getErrorCode());
        response.setErrorMessage(task.getErrorMessage());
        response.setTextLength(task.getTextLength());
        response.setCreatedAt(task.getCreatedAt() == null ? null : task.getCreatedAt().getTime());

        if (task.getPopQuizId() != null) {
            PopQuiz popQuiz = popQuizService.getById(task.getPopQuizId());
            if (popQuiz != null) {
                response.setPopQuizId(popQuiz.getId());
                response.setSent(popQuiz.getSent() == null ? 0 : popQuiz.getSent());
            }
        }
        return response;
    }

    public List<FileIngestStatusResponse> listByActivityId(Integer activityId) {
        List<AiFileTask> tasks = aiFileTaskService.list(
                new QueryWrapper<AiFileTask>()
                        .eq("activity_id", activityId)
                        .orderByDesc("created_at")
        );

        return tasks.stream().map(task -> {
            FileIngestStatusResponse response = new FileIngestStatusResponse();
            response.setTaskId(task.getTaskId());
            response.setFileName(task.getFileName());
            response.setStatus(task.getStatus());
            response.setErrorCode(task.getErrorCode());
            response.setErrorMessage(task.getErrorMessage());
            response.setTextLength(task.getTextLength());
            response.setCreatedAt(task.getCreatedAt() == null ? null : task.getCreatedAt().getTime());

            if (task.getPopQuizId() != null) {
                PopQuiz popQuiz = popQuizService.getById(task.getPopQuizId());
                if (popQuiz != null) {
                    response.setPopQuizId(popQuiz.getId());
                    response.setSent(popQuiz.getSent() == null ? 0 : popQuiz.getSent());
                }
            }
            return response;
        }).collect(Collectors.toList());
    }


    private void validate(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("file is empty");
        }

        String ext = parserRouter.detectFileType(file.getOriginalFilename());
        if (!ALLOWED_TYPES.contains(ext)) {
            throw new IllegalArgumentException("unsupported file type: " + ext);
        }

        if (file.getSize() > 30L * 1024 * 1024) {
            throw new IllegalArgumentException("file too large, max 30MB");
        }
    }
}
