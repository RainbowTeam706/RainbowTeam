package com.pq.utils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Service
public class WebSocketService {
    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    // 推送题目给指定学生
    public void sendQuizToStudent(Integer userId, Object quizData) {
        messagingTemplate.convertAndSend("/topic/quiz/" + userId, quizData);
    }
}
