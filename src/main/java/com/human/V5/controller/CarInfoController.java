package com.human.V5.controller;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.human.V5.entity.CarInfoEntity;
import com.human.V5.entity.UserEntity;
import com.human.V5.service.CarInfoService;

@RestController
@RequestMapping("/car")
public class CarInfoController {
	
	private final CarInfoService carInfoService;

    public CarInfoController(CarInfoService carInfoService) {
        this.carInfoService = carInfoService;
    }

    @PostMapping(value = "/save", produces = "application/json; charset=UTF-8")
    public ResponseEntity<String> saveCarInfo(@RequestBody CarInfoEntity carInfo, HttpSession session) {
    	// 세션에서 UserEntity 객체를 가져옴
        UserEntity user = (UserEntity) session.getAttribute("user");
    	
        if (user == null) {
            // 세션에 user가 없으면 로그인되지 않은 상태
            return ResponseEntity.status(401).body("로그인이 필요합니다.");
        }

        // 세션에서 car_idx를 가져와 carInfo에 설정
        carInfo.setCarIdx((long) user.getCarIdx());

        // 차량 정보를 저장
        carInfoService.saveCarInfo(carInfo);

        return ResponseEntity.ok("차량 정보가 성공적으로 저장되었습니다.");
    }

    @GetMapping("/{carIdx}")
    public ResponseEntity<CarInfoEntity> getCarInfo(@PathVariable Long carIdx) {
        CarInfoEntity carInfo = carInfoService.getCarInfo(carIdx);
        return ResponseEntity.ok(carInfo);
    }

}
