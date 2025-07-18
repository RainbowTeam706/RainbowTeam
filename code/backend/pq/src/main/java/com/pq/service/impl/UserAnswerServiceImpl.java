package com.pq.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.pq.entity.UserAnswer;
import com.pq.mapper.UserAnswerMapper;
import com.pq.service.IUserAnswerService;
import org.springframework.stereotype.Service;

@Service
public class UserAnswerServiceImpl extends ServiceImpl<UserAnswerMapper, UserAnswer> implements IUserAnswerService {
}
