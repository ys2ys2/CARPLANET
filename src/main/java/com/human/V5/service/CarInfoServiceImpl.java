package com.human.V5.service;

import org.springframework.stereotype.Service;

import com.human.V5.entity.CarInfoEntity;
import com.human.V5.repository.CarInfoRepository;

@Service
public class CarInfoServiceImpl implements CarInfoService {
	
	private final CarInfoRepository carInfoRepository;

    public CarInfoServiceImpl(CarInfoRepository carInfoRepository) {
        this.carInfoRepository = carInfoRepository;
    }

    @Override
    public void saveCarInfo(CarInfoEntity carInfo) {
        carInfoRepository.save(carInfo); // DB에 저장
    }

    @Override
    public CarInfoEntity getCarInfo(Long carIdx) {
        return carInfoRepository.findById(carIdx)
                .orElseThrow(() -> new RuntimeException("해당 차량 정보를 찾을 수 없습니다."));
    }
	

}
