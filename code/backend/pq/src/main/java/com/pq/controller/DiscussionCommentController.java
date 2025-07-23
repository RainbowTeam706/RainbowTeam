package com.pq.controller;

import com.pq.entity.DiscussionComment;
import com.pq.service.IDiscussionCommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;
import java.time.Instant;
import java.time.format.DateTimeParseException;

@RestController
@RequestMapping("/discussion/comments")
public class DiscussionCommentController {
    @Autowired
    private IDiscussionCommentService discussionCommentService;

    @GetMapping("/{activityId}")
    public List<Map<String, Object>> getCommentsByActivityId(@PathVariable Integer activityId) {
        List<DiscussionComment> comments = discussionCommentService.lambdaQuery()
                .eq(DiscussionComment::getActivityId, activityId)
                .orderByAsc(DiscussionComment::getTime)
                .list();
        // 直接转换为扁平化结构
        return comments.stream().map(c -> {
            Map<String, Object> m = new HashMap<>();
            m.put("id", c.getId());
            m.put("userId", c.getUserId());
            m.put("userName", c.getUserName());
            m.put("role", c.getRole());
            m.put("anonymous", c.getAnonymous());
            m.put("content", c.getContent());
            m.put("time", c.getTime());
            m.put("parentId", c.getParentId());
            m.put("replyTo", c.getReplyTo());
            return m;
        }).collect(Collectors.toList());
    }

    @PostMapping("/comment")
    public Map<String, Object> addComment(@RequestBody Map<String, Object> payload) {
        DiscussionComment comment = new DiscussionComment();
        comment.setActivityId((Integer) payload.get("activityId"));
        comment.setUserId((Integer) payload.get("userId"));
        comment.setUserName((String) payload.get("userName"));
        comment.setRole((String) payload.get("role"));
        comment.setAnonymous(payload.get("anonymous") != null && (Boolean) payload.get("anonymous"));
        comment.setContent((String) payload.get("content"));

        // 兼容 time 字段为字符串或时间戳
        Object timeObj = payload.get("time");
        Date time = new Date();
        if (timeObj != null) {
            if (timeObj instanceof Number) {
                time = new Date(((Number) timeObj).longValue());
            } else if (timeObj instanceof String) {
                String timeStr = (String) timeObj;
                try {
                    // 兼容 ISO8601 字符串
                    time = Date.from(Instant.parse(timeStr));
                } catch (DateTimeParseException e) {
                    time = new Date();
                }
            }
        }
        comment.setTime(time);

        comment.setParentId(payload.get("parentId") == null ? null : (Integer) payload.get("parentId"));
        comment.setReplyTo(payload.get("replyTo") == null ? null : (Integer) payload.get("replyTo"));
        boolean saved = discussionCommentService.save(comment);
        Map<String, Object> result = new HashMap<>();
        result.put("success", saved);
        result.put("id", comment.getId());
        return result;
    }
} 
 