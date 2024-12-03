package com.human.V5.service;


import java.util.List;

import com.human.V5.entity.UserEntity;



public interface UserService {

	UserEntity save(UserEntity entity);

	int countByCarId(String carId);

	String authEmail(String email);

	boolean verifyCode(String email, String code);

	UserEntity findByCarIdAndCarPw(String carId, String carPw);

	UserEntity findByKakaoId(String kakaoId);

	UserEntity findByGoogleId(String googleId);

	List<UserEntity> findByNameAndEmail(String name, String email);
	
	UserEntity findByIdAndEmail(String id, String email); // 아이디와 이메일로 사용자 검색

    String generateTemporaryPassword(); // 임시 비밀번호 생성

    void updatePassword(String id, String tempPassword); // 비밀번호 업데이트

    void sendTemporaryPasswordEmail(String email, String tempPassword); // 임시 비밀번호 이메일 전송

	boolean existsByCarNickname(String carNickname);

	UserEntity findByCarId(String carId);

	void updateUser(UserEntity userEntity);

	UserEntity findByCarIdAndCarPwAndCarStatusIn(String carId, String carPw, List<Integer> carStatusList);

    void updateStatus(String carIdx, int status);

	
}
