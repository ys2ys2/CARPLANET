package com.human.V5.service;

import com.human.V5.dto.PostCommentDto;
import com.human.V5.dto.PostLikeDto;
import com.human.V5.entity.PostCommentEntity;
import com.human.V5.entity.PostEntity;
import com.human.V5.dto.PostDto;
import java.util.List;
import org.springframework.data.domain.Pageable;

public interface CommunityService {
	PostEntity save(PostEntity entity);
	PostEntity updatePost(PostEntity entity);
	PostEntity deletePost(Integer postIndex, String userId);
	PostEntity getPost(Integer postIndex);
	List<PostDto> getPostDto(Integer postIndex);
	List<PostDto> getPostList(Pageable pageable);
	List<PostDto> searchPostList(Pageable pageable, String keyword, Integer postIndex);
	List<PostDto> getRecommendedPostList();
	PostLikeDto like(Integer postIndex, String carId);
	PostLikeDto unlike(Integer postIndex, String carId);
	PostCommentEntity saveComment(PostCommentEntity entity);
	PostCommentEntity updateComment(Integer postCommentIndex, String content, String userId);
	PostCommentEntity deleteComment(Integer postCommentIndex, String userId);
	Integer commentLike(Integer postCommentIndex, String carId);
	Integer commentUnlike(Integer postCommentIndex, String carId);
	List<String> getPopularKeywordList();
	List<PostEntity> getMyPostEntities(String carId, Pageable pageable);//얘가 안들어와
	List<PostCommentDto> getPostCommentList(Integer postIndex);
	
	
}
