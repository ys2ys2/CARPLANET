package com.human.V5.vo;


import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserVO {

	private int carIdx;

	private String carName;

	private String phone;

	private String carId;

	private String carPw;

	private String email;

	private String birthday;
	
	private Integer carstatus;
	
	private String carNickname;
}
