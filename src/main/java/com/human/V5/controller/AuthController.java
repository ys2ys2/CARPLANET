package com.human.V5.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/Auth") // 공통 URL 정의
public class AuthController {
	
	@GetMapping("Login.do")
	public String Login() {
		return "Auth/Login";
	}
}
