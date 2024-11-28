package com.human.V5.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;
import javax.persistence.Transient;

import lombok.Data;

@Entity
@Table(name = "car_info")
@Data
public class CarInfoEntity {
	@Id
	@Column(name = "car_idx") //세션에 저장된 idx값 가져오기
	private Long carIdx;
	
	@Column(name = "car_type", nullable = false) //차량 종류
	private String carType;
	
	@Column(name = "car_number", nullable = false) //차량 번호
	private String carNumber;
	
	@Column(name = "fuel_type", nullable = false) //차량 유종
	private String fuelType;
	
    @Lob // BLOB/CLOB 데이터 매핑
    @Column(name = "car_image")
    private byte[] carImage; // 이미지 데이터를 저장하는 필드

    @Transient // DB에 매핑되지 않음
    private String base64Image; // Base64 문자열로 변환된 이미지 데이터를 위한 필드
		
	}
	
