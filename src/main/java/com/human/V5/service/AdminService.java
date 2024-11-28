package com.human.V5.service;

import java.util.List;
import java.util.Map;

import com.human.V5.entity.NoticeEntity;
import com.human.V5.entity.PostEntity;
import com.human.V5.entity.UserEntity;
import com.human.V5.entity.VisitorEntity;

public interface AdminService {

	List<UserEntity> getAllUsers();

	VisitorEntity save(VisitorEntity entity);

	List<Map<String, Object>> getRecentVisitorStats(int i);

	long getUserCount();

	long getPostCount();

	NoticeEntity save(NoticeEntity ent);

	long getNoticeCount();

	boolean deleteUserByIdx(int userIdx);

	boolean updateUserStatus(int userIdx, int i);

	List<UserEntity> searchByKeyword(String keyword);
	List<PostEntity> psearchByKeyword(String keyword);
    List<UserEntity> searchByCarStatus(Integer carStatus);
    List<UserEntity> searchByKeywordAndCarStatus(String keyword, Integer carStatus);

	List<PostEntity> getAllpost();

	boolean deletePostByIndex(int postIndex);

}
