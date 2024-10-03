package com.thehangingpen.examples.api.hello;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/hello")
public class HelloWorld {

    @Autowired
    private HelloConfig config;

    @GetMapping("/world")
    public String getWorld(){
        return "{\"greeting\":\"hello, " + config.getWorld()+"\"}";
    }

}
