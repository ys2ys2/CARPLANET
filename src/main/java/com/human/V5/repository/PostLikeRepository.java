package com.human.V5.repository;

import com.human.V5.entity.PostLikeEntity;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PostLikeRepository extends JpaRepository<PostLikeEntity, Integer> {
  List<PostLikeEntity> findAllByPostIndexIn(List<Integer> postIndex);
  List<PostLikeEntity> findAllByPostIndexAndCarId(Integer postIndex, String carId);
  PostLikeEntity findByPostIndexAndCarIdAndType(Integer postIndex, String carId, Boolean type);

  long countByPostIndexAndType(Integer postIndex, Boolean type);
}
