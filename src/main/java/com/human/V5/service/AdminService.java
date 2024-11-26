package com.human.V5.service;

import java.util.List;
import java.util.Map;

import com.human.V5.entity.UserEntity;
import com.human.V5.entity.VisitorEntity;

public interface AdminService {

	List<UserEntity> getAllUsers();

	VisitorEntity save(VisitorEntity entity);

	List<Map<String, Object>> getRecentVisitorStats(int i);

	long getUserCount();

	long getPostCount();

}
