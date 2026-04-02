package com.pq.controller;

import com.pq.ai.ingest.FileIngestService;
import com.pq.ai.ingest.model.FileIngestAcceptedResponse;
import com.pq.ai.ingest.model.FileIngestStatusResponse;
import com.pq.dto.Result;
import com.pq.entity.Activity;
import com.pq.service.IActivityService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/file-ingest")
@RequiredArgsConstructor
public class FileIngestController {

    private final FileIngestService fileIngestService;
    private final IActivityService activityService;

    @PostMapping("/upload")
    public Result upload(@RequestParam("file") MultipartFile file,
                         @RequestParam("activityId") Integer activityId) {
        Activity activity = activityService.getById(activityId);
        if (activity == null) {
            return Result.fail("活动不存在");
        }
        if (activity.getStatus() == 2) {
            return Result.fail("活动已结束，操作被拒绝");
        }

        FileIngestAcceptedResponse response = fileIngestService.accept(file, activityId);
        return Result.ok(response);
    }

    @GetMapping("/status/{taskId}")
    public Result status(@PathVariable("taskId") String taskId) {
        FileIngestStatusResponse response = fileIngestService.getStatus(taskId);
        if (response == null) {
            return Result.fail("task not found");
        }
        return Result.ok(response);
    }

    @GetMapping("/list/{activityId}")
    public Result listByActivity(@PathVariable("activityId") Integer activityId) {
        return Result.ok(fileIngestService.listByActivityId(activityId));
    }


}
