package com.human.V5.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
public class MainController {
		
    @GetMapping("/") 
    public String home() {
        return "MainPage/mainpage";
    }
}
