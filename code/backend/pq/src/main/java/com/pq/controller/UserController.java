package com.pq.controller;
import com.pq.dto.Result;
import com.pq.dto.UserDTO;
import com.pq.entity.User;
import com.pq.service.IUserService;
import com.pq.utils.UserHolder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import java.util.Map;


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


    @PostMapping("/register")
    public Result register(@RequestBody User user){
        return userService.register(user);
    }


    @GetMapping("/me")
    public Result me(){
        //  获取当前登录的用户并返回
        UserDTO user = UserHolder.getUser();
        return Result.ok(user);
    }

    @PostMapping("/update")
    public Result updateNickname(@RequestBody Map<String, Object> payload) {
        String username = (String) payload.get("username");
        String nickname = (String) payload.get("nickname");
        String token = (String) payload.get("token");
        return userService.updateNickname(username, nickname, token);
    }
}
