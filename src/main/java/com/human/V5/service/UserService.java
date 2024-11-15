package com.human.V5.service;


import com.human.V5.entity.UserEntity;



public interface UserService {

	UserEntity save(UserEntity entity);

	int countByCarId(String carId);

	String authEmail(String email);

	boolean verifyCode(String email, String code);

	UserEntity findByCarIdAndCarPwAndCarstatus(String carId, String carPw, int i);
	
}
