package com.human.V5.repository;

import com.human.V5.entity.PostCommentEntity;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PostCommentRepository extends JpaRepository<PostCommentEntity, Integer> {
  List<PostCommentEntity> findAllByPostIndexIn(List<Integer> postIndex);
}
