package com.pq.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.pq.entity.PopQuiz;
import com.pq.mapper.PopQuizMapper;
import com.pq.service.IPopQuizService;
import org.springframework.stereotype.Service;

@Service
public class PopQuizServiceImpl extends ServiceImpl<PopQuizMapper, PopQuiz> implements IPopQuizService {
}
