package com.pq.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.pq.entity.FeedbackActivity;
import com.pq.mapper.FeedbackActivityMapper;
import com.pq.service.IFeedbackActivityService;
import org.springframework.stereotype.Service;

@Service
public class FeedbackActivityServiceImpl extends ServiceImpl<FeedbackActivityMapper, FeedbackActivity> implements IFeedbackActivityService {
} 