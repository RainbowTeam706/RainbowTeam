package com.pq.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.pq.entity.AiFileTask;
import com.pq.mapper.AiFileTaskMapper;
import com.pq.service.IAiFileTaskService;
import org.springframework.stereotype.Service;

@Service
public class AiFileTaskServiceImpl extends ServiceImpl<AiFileTaskMapper, AiFileTask> implements IAiFileTaskService {
}
