package com.human.V5.controller;

import java.io.IOException;
import java.util.Base64;

import javax.servlet.http.HttpSession;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

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

    @PostMapping(value = "/save", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<String> saveCarInfo(
            @RequestParam("carType") String carType,
            @RequestParam("carNumber") String carNumber,
            @RequestParam("fuelType") String fuelType,
            @RequestParam(value = "carImage", required = false) MultipartFile carImage,
            @RequestParam(value = "existingCarImage", required = false) String existingCarImage, // 기존 이미지 추가
            HttpSession session) {
        // 세션에서 UserEntity 객체를 가져옴
        UserEntity user = (UserEntity) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(401).body("로그인이 필요합니다.");
        }

        try {
        	CarInfoEntity carInfo = carInfoService.getCarInfo((long) user.getCarIdx()); // int를 long으로 변환

            carInfo.setCarType(carType);
            carInfo.setCarNumber(carNumber);
            carInfo.setFuelType(fuelType);

            if (carImage != null && !carImage.isEmpty()) {
                // 새 이미지가 있을 경우
                carInfo.setCarImage(carImage.getBytes());
            } else if (existingCarImage != null && !existingCarImage.isEmpty()) {
                // 새 이미지가 없을 경우 기존 이미지를 유지
                carInfo.setCarImage(Base64.getDecoder().decode(existingCarImage));
            }

            carInfoService.saveCarInfo(carInfo); // Service를 통해 저장
            return ResponseEntity.ok()
                    .header("Content-Type", "text/plain; charset=UTF-8")
                    .body("차량 정보가 성공적으로 저장되었습니다.");
        } catch (IOException e) {
            return ResponseEntity.status(500).body("이미지 저장 중 오류가 발생했습니다.");
        }
    }


    @GetMapping("/{carIdx}")
    public ResponseEntity<CarInfoEntity> getCarInfo(@PathVariable Long carIdx) {
        CarInfoEntity carInfo = carInfoService.getCarInfo(carIdx);

        // 이미지 데이터를 Base64 문자열로 변환
        if (carInfo.getCarImage() != null) {
            String base64Image = Base64.getEncoder().encodeToString(carInfo.getCarImage());
            carInfo.setCarImage(null); // 원래 바이너리 데이터를 제거 (필요시 제거)
            carInfo.setBase64Image(base64Image); // Base64 문자열 필드에 저장 (새로 추가)
        }

        return ResponseEntity.ok(carInfo);
    }
    

}
