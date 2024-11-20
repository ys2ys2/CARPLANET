package com.human.V5.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;

@Entity
@Table(name = "car_info")
@Data
public class CarInfoEntity {
	@Id
	@Column(name = "car_idx") //primary key 컬럼
	private Long carIdx;
	
	@Column(name = "car_type", nullable = false) //차량 종류
	private String carType;
	
	@Column(name = "car_number", nullable = false) //차량 번호
	private String carNumber;
	
	@Column(name = "fuel_type", nullable = false) //차량 유종
	private String fuelType;
	
}
