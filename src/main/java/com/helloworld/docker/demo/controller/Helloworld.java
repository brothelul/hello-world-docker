package com.helloworld.docker.demo.controller;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.helloworld.docker.demo.annotation.UserLoginToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
public class Helloworld {

    @GetMapping("/helloworld")
    public String helloworld() {
        return "helloword docker";
    }

    @GetMapping("/token")
    public String getToken() {
        return JWT.create().withAudience("1234").sign(Algorithm.HMAC256("456"));
    }

    @GetMapping("/userInfo")
    @UserLoginToken
    public String userInfo() {
        return "login success";
    }
}
