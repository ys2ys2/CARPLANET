package com.human.V5.repository;

import com.human.V5.entity.PostCommentLikeEntity;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PostCommentLikeRepository extends JpaRepository<PostCommentLikeEntity, Integer> {
  List<PostCommentLikeEntity> findAllByPostCommentIndexIn(List<Integer> postCommentIndex);
  PostCommentLikeEntity findFirstByPostCommentIndexAndCarIdAndType(Integer postCommentIndex, String carId, Boolean Type);
  long countByPostCommentIndexAndType(Integer postCommentIndex, Boolean type);
  
}
