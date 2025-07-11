package com.pq.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.bean.copier.CopyOptions;
import cn.hutool.core.util.RandomUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.pq.dto.Result;
import com.pq.dto.UserDTO;
import com.pq.entity.User;
import com.pq.mapper.UserMapper;
import com.pq.service.IUserService;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.UUID;
import java.util.concurrent.TimeUnit;


@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

    @Resource
    private StringRedisTemplate stringRedisTemplate;


    @Override
    public Result login(User user) {
        if(user == null){
            return Result.fail("用户为空");
        }

        User u = query().eq("username", user.getUsername()).one();
        if(u == null){
            return Result.fail("用户不存在");
        }
        if(!u.getPassword().equals(user.getPassword())){
            return Result.fail("密码不正确");
        }

        String token = UUID.randomUUID().toString();
        UserDTO userDTO = BeanUtil.copyProperties(u, UserDTO.class);
        stringRedisTemplate.opsForHash().putAll("login:user:"+token,BeanUtil.beanToMap(userDTO,
                new HashMap<>(),
                CopyOptions.create().setIgnoreNullValue(true).setFieldValueEditor((key,value)->value.toString())));
        stringRedisTemplate.expire("login:user:"+token,30, TimeUnit.MINUTES);

        return Result.ok(token);
    }
}
