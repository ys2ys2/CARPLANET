package com.human.V5.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@Table(name="Car_member")
public class UserEntity {
	
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name="car_Idx", updatable=false)
	private int carIdx;
	
	@Column(name="car_Name", updatable=false, length=30)
	private String carName;

	@Column(name="phone", updatable=false, length=30)
	private String phone;
	
	@Column(name="car_id", updatable=false, length=50)
	private String carId;
	
	@Column(name="car_pw", updatable=false, length=200)
	private String carPw;
	
	@Column(name="email", updatable=false, length=50)
	private String email;
	
	@Column(name="birthday", updatable=false, length=20)
	private String birthday;
	
	@Column(name="status", columnDefinition="TINYINT DEFAULT 1")
	private String car_status;
	
	@Column(name="reg_date", columnDefinition="DATETIME DEFAULT NOW()")
	private Date regDate;//가입일
	
	@Column(name="mod_date", columnDefinition="DATETIME DEFAULT NOW()")
	private Date modDate;//수정일
	
	@Builder
	public UserEntity(String carName, String phone, String carId, String carPw,String email,String birthday) {
		this.carName = carName;
		this.phone = phone;
		this.carId = carId;
		this.carPw = carPw;
		this.email = email;
		this.birthday = birthday;
	}
	
	public void updatecIdx(int cIdx) {
		this.carIdx =cIdx;
		
	}
}
