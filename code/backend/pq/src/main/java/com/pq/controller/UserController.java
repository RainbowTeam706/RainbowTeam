package com.pq.controller;
import com.pq.dto.Result;
import com.pq.dto.UserDTO;
import com.pq.entity.User;
import com.pq.service.IUserService;
import com.pq.utils.UserHolder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;



@Slf4j
@RestController
@RequestMapping("/user")
public class UserController {

    @Resource
    private IUserService userService;


    @PostMapping("/login")
    public Result login(@RequestBody User user){
        return userService.login(user);
    }


    @GetMapping("/me")
    public Result me(){
        //  获取当前登录的用户并返回
        UserDTO user = UserHolder.getUser();
        return Result.ok(user);
    }

}
