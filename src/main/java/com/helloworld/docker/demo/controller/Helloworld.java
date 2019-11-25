package com.helloworld.docker.demo.controller;

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
}
