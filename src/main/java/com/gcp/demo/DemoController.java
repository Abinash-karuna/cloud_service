package com.gcp.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DemoController {
    @GetMapping
    public String info(){
        return "hello from Ak";
    }
    @GetMapping("/gcp")
    public String myName(){
        return "My name is Ak";
    }

    @GetMapping("/service")
    public String service(){
        return "This is google cloud service"
    }
}