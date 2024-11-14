package com.human.V5.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class HomeController {
	
	//영신- 전기차 충전소
	@GetMapping("/evmap")
	public String evmap() {
		return "EV_Map/evmap";
	
	}

	//예슬- 주차장
	@GetMapping("/parkinglot")
	public String parkinglot() {
	return "Parking_Map/parkinglot";
	
	}
	
}
