package com.pq.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.pq.entity.DiscussionComment;
import com.pq.mapper.DiscussionCommentMapper;
import com.pq.service.IDiscussionCommentService;
import org.springframework.stereotype.Service;

@Service
public class DiscussionCommentServiceImpl extends ServiceImpl<DiscussionCommentMapper, DiscussionComment> implements IDiscussionCommentService {
} 