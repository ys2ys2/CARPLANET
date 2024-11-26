package com.human.V5.service;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.human.V5.entity.UserEntity;
import com.human.V5.entity.VisitorEntity;
import com.human.V5.repository.PostRepository;
import com.human.V5.repository.UserRepository;
import com.human.V5.repository.VisitorRepository;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class AdminServiceImpl implements AdminService {
	
	private UserRepository userRepository;
	private VisitorRepository visitorRepository;
	private PostRepository postrepository;
	
	@Override
	public List<UserEntity> getAllUsers() {
	
		return userRepository.findAll();
	}

	@Override
	public VisitorEntity save(VisitorEntity entity) {
		return visitorRepository.save(entity);
	}

	@Override
	public List<Map<String, Object>> getRecentVisitorStats(int i) {
		Pageable pageable = PageRequest.of(0, i, Sort.by("date").descending());
	    return visitorRepository.findVisitorStats(pageable);
	}

	@Override
	public long getUserCount() {
		
		return userRepository.count();
	}

	@Override
	public long getPostCount() {
		// TODO Auto-generated method stub
		return postrepository.count();
	}


}
