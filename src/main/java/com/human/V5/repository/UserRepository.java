package com.human.V5.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.human.V5.entity.UserEntity;

public interface UserRepository extends JpaRepository<UserEntity,Integer>{

	int countByCarId(String carId);

	UserEntity findByCarIdAndCarPwAndCarStatus(String carId, String carPw, int i);

	UserEntity findByCarId(String carId); // 카카오 ID로 조회 시 사용

	UserEntity findByCarNameAndEmail(String name, String email);

	UserEntity findByCarIdAndEmail(String id, String email);
}
