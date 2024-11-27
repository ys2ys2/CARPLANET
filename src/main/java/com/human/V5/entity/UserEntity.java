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
	
	@Column(name="car_Name", length=30)
	private String carName;
	
	@Column(name="car_nickname",length=20)
	private String carNickname;
	
	@Column(name="phone", length=30)
	private String phone;
	
	@Column(name="car_id", updatable=false, length=50)
	private String carId;
	
	@Column(name="car_pw", length=200)
	private String carPw;
	
	@Column(name="email", length=50)
	private String email;
	
	@Column(name="birthday", length=20)
	private String birthday;
	
	@Column(name="status", columnDefinition="TINYINT DEFAULT 1")
	private Integer carStatus;
	
	@Column(name="reg_date", columnDefinition="DATETIME DEFAULT NOW()")
	private Date regDate;//가입일
	
	@Column(name="mod_date", columnDefinition="DATETIME DEFAULT NOW()")
	private Date modDate;//수정일
	
	@Builder
    public UserEntity(String carName, String carNickname, String phone, String carId, String carPw, String email, String birthday) {
        this.carName = carName;
        this.carNickname = carNickname; // 필드 추가
        this.phone = phone;
        this.carId = carId;
        this.carPw = carPw;
        this.email = email;
        this.birthday = birthday;
        this.carStatus = 1;  // 기본 활성 상태
        this.regDate = new Date();
        this.modDate = new Date();
    }
	
	public void updatecIdx(int cIdx) {
		this.carIdx =cIdx;
		
	}
	
	public void updateNickname(String carNickname) {
	    this.carNickname = carNickname;
	}
	
	public void updatePassword(String newPassword) {
        this.carPw = newPassword;
    }

	public void setBirthday(String newBirthday) {
		this.birthday = newBirthday;
		
	}
	
	public void setcarNickname(String newcarNickname) {
		this.carNickname = newcarNickname;
	}

	public void setPhone(String newPhone) {
		this.phone = newPhone;
		
	}

	public void setEmail(String newEmail) {
		this.email = newEmail;
		
	}
	
	public void updateCarName(String carName) {
	    this.carName = carName;
	}
	
	public void setUserStatus(int status) {
		this.carStatus = status;
		
	}
}
