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
//注册
    @Override
    public Result register(User user) {
        if(user == null || user.getUsername() == null || user.getPassword() == null) {
            return Result.fail("用户名和密码不能为空");
        }
        // 检查用户名是否已存在
        User exist = query().eq("username", user.getUsername()).one();
        if(exist != null) {
            return Result.fail("用户名已存在");
        }
        // 昵称为空时自动生成
        if(user.getNickname() == null || user.getNickname().trim().isEmpty()) {
            user.setNickname(RandomUtil.randomString(8));
        }
        boolean saved = save(user);
        if(saved) {
            return Result.ok();
        } else {
            return Result.fail("注册失败");
        }
    }
//修改昵称：前端传token，刷新redis缓存，否则会导致刷新重新获取/user/me时，userDTO从redis中获取到旧昵称
    @Override
    public Result updateNickname(String username, String nickname, String token) {
        if(username == null || nickname == null || nickname.trim().isEmpty()) {
            return Result.fail("用户名和昵称不能为空");
        }
        User user = query().eq("username", username).one();
        if(user == null) {
            return Result.fail("用户不存在");
        }
        user.setNickname(nickname);
        boolean updated = updateById(user);
        if(updated) {
            // 更新缓存
            if(token != null && !token.isEmpty()) {
                String tokenKey = "login:user:" + token;
                UserDTO userDTO = BeanUtil.copyProperties(user, UserDTO.class);
                stringRedisTemplate.opsForHash().putAll(tokenKey, BeanUtil.beanToMap(userDTO, new HashMap<>(), CopyOptions.create().setIgnoreNullValue(true).setFieldValueEditor((key,value)->value.toString())));
            }
            return Result.ok();
        } else {
            return Result.fail("修改失败");
        }
    }
}
