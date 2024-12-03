package com.human.V5.service;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.human.V5.entity.NoticeEntity;
import com.human.V5.entity.PostEntity;
import com.human.V5.entity.UserEntity;
import com.human.V5.entity.VisitorEntity;
import com.human.V5.repository.NoticeRepository;
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
	private NoticeRepository noticerepository;
	
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

	@Override
	public NoticeEntity save(NoticeEntity ent) {
		// TODO Auto-generated method stub
		return noticerepository.save(ent);
	}

	@Override
	public long getNoticeCount() {
		// TODO Auto-generated method stub
		return noticerepository.count();
	}

	@Override
	public boolean deleteUserByIdx(int userIdx) {
		boolean result = false;
		try {
			userRepository.deleteById(userIdx);
			result = true;
		} catch (Exception e) {
			System.out.println("삭제중 에러발생"+e);
		} 
		return result;
	}
	
	@Override
	public boolean deletePostByIndex(int postIndex) {
		boolean result =false;
		
		try {
			postrepository.deleteById(postIndex);
			result = true;
		} catch (Exception e) {
			System.out.println("삭제중 에러발생"+e);
		}
		return result;
	}

	public boolean updateUserStatus(int userIdx, int status) {
	    try {
	        UserEntity user = userRepository.findById(userIdx).orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));
	        user.setUserStatus(status); // userStatus를 업데이트
	        userRepository.save(user); // 변경사항 저장
	        return true;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}

	@Override
    public List<UserEntity> searchByKeyword(String keyword) {
        return userRepository.findByCarIdContainingOrCarNicknameContaining(keyword, keyword);
    }

    @Override
    public List<UserEntity> searchByCarStatus(Integer carStatus) {
        return userRepository.findByCarStatus(carStatus);
    }

    @Override
    public List<UserEntity> searchByKeywordAndCarStatus(String keyword, Integer carStatus) {
        return userRepository.findByCarIdContainingOrCarNicknameContainingAndCarStatus(keyword, keyword, carStatus);
    }

	@Override
	public List<PostEntity> getAllpost() {
		// TODO Auto-generated method stub
		return postrepository.findAll();
	}

	@Override
	public List<PostEntity> psearchByKeyword(String keyword) {
		// TODO Auto-generated method stub
		return postrepository.findByTitleContainingOrContentContaining(keyword,keyword);
	}



}
