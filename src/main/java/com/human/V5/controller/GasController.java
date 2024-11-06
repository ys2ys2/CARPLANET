package com.human.V5.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/Gas") // 공통 URL 정의
public class GasController {
	
	
	@GetMapping("Gasmap.do")
	public String Gas() {
		return "GAS_Map/gasmap";
	}
}
