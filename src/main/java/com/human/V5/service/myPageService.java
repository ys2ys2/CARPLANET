package com.human.V5.service;

import org.springframework.stereotype.Service;

import com.human.V5.entity.UserEntity;
import com.human.V5.repository.UserRepository;

@Service
public class myPageService {

	private UserRepository repository;
	
	public UserEntity findById(String carId) {
			
		return repository.findByCarId(carId);
	}

}
