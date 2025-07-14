package com.pq.service;

import com.baomidou.mybatisplus.extension.service.IService;

import com.pq.dto.Result;
import com.pq.entity.User;

import javax.servlet.http.HttpSession;


public interface IUserService extends IService<User> {

    Result login(User user);
}
