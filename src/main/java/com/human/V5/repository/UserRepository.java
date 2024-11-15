package com.human.V5.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.human.V5.entity.UserEntity;

public interface UserRepository extends JpaRepository<UserEntity,Integer>{

	int countByCarId(String carId);
}
