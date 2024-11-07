package com.human.V5.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
	

@GetMapping("/parkinglot")
public String parkinglot() {
	return "Parking_Map/parkinglot";
	
	}
	
}
