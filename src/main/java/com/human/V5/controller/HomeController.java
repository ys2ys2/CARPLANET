package com.human.V5.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class HomeController {
	
	// 메인페이지
	@GetMapping("/evmap")
	public String evmap() {
		return "EV_Map/evmap";
		
	}
	
}
