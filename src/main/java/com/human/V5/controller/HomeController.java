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
	
	//이용약관
	@GetMapping("/clause")
	public String clause() {
		return "Components/clause";
	}
	
	//광고성 정보 수신동의
	@GetMapping("/marketing")
	public String marketing() {
		return "Components/marketing";
	}
	
	//개인정보 처리방침
	@GetMapping("/privacy")
	public String privacy() {
		return "Components/privacy";
	}
	
	//개인정보 제3자 제공동의
	@GetMapping("/thirdparty")
	public String thirdparty() {
		return "Components/thirdparty";
	}
	
	//저작권 정책
	@GetMapping("/copyright")
	public String copyright() {
		return "Components/copyright";
	}
	
}
