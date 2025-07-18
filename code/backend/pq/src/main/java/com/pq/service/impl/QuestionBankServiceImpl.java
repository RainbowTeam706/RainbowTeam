package com.pq.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.pq.entity.QuestionBank;
import com.pq.mapper.QuestionBankMapper;
import com.pq.service.IQuestionBankService;
import org.springframework.stereotype.Service;

@Service
public class QuestionBankServiceImpl extends ServiceImpl<QuestionBankMapper, QuestionBank> implements IQuestionBankService {
}
