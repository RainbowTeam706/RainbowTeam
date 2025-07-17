package com.pq.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.pq.entity.ActivityMember;
import com.pq.mapper.ActivityMemberMapper;
import com.pq.service.IActivityMemberService;
import org.springframework.stereotype.Service;

@Service
public class ActivityMemberServiceImpl extends ServiceImpl<ActivityMemberMapper, ActivityMember> implements IActivityMemberService {
}
