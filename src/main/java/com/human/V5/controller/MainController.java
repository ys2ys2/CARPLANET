package com.human.V5.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
public class MainController {
		
	//희진- 메인페이지 경로: localhost:9090/CarPlanet/
    @GetMapping("/") 
    public String home() {
        return "MainPage/mainpage";
    }
    
    @GetMapping("/mypage")
    public String mypage() {
    	return "MyPage/mypage";
    }
    
    @GetMapping("/community")
    public String community() {
    	return "Community/community";
    }
    
    
}
