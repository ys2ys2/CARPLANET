package com.human.V5.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.human.V5.entity.UserEntity;

public interface UserRepository extends JpaRepository<UserEntity,Integer>{

	int countByCarId(String carId);

	UserEntity findByCarIdAndCarPw(String carId, String carPw);

	UserEntity findByCarId(String carId); // 카카오 ID로 조회 시 사용

	List<UserEntity> findByCarNameAndEmail(String name, String email);

	UserEntity findByCarIdAndEmail(String id, String email);

	boolean existsByCarNickname(String carNickname);


	UserEntity findByCarIdAndCarPwAndCarStatusIn(String carId, String carPw, List<Integer> carStatusList);

	List<UserEntity> findByCarIdContainingOrCarNicknameContaining(String keyword, String keyword2);

	List<UserEntity> findByCarIdContainingOrCarNicknameContainingAndCarStatus(String keyword, String keyword2,
			Integer carStatus);

	List<UserEntity> findByCarStatus(Integer carStatus);


}
