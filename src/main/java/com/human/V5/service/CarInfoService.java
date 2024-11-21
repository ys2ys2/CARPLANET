package com.human.V5.service;

import com.human.V5.entity.CarInfoEntity;

public interface CarInfoService {
    void saveCarInfo(CarInfoEntity carInfo); // 차량 정보 저장
    CarInfoEntity getCarInfo(Long carIdx);  // 차량 정보 조회
}
