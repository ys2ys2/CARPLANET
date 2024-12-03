package com.human.V5.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import com.human.V5.entity.PostLikeEntity;

public interface PostLikeRepository extends JpaRepository<PostLikeEntity, Integer> {
  List<PostLikeEntity> findAllByPostIndexIn(List<Integer> postIndex);
  //List<PostLikeEntity> findAllByPostIndexAndCarId(Integer postIndex, String carId);
  PostLikeEntity findByPostIndexAndCarId(Integer postIndex, String carId);//게시글번호와 회원번호로 좋아요 싫어요 테이블 조회
  PostLikeEntity findByPostIndexAndCarIdAndType(Integer postIndex, String carId, Boolean type);

  @Modifying
  @Query("update PostLikeEntity pe set pe.type = ?2 where pe.postIndex = ?1")
  void udpateType(Integer postLikeIndex, boolean type);//게시글 번호로 데이터의 좋아요 싫어요 값 변경
  
  long countByPostIndexAndType(Integer postIndex, Boolean type);//게시글번호와 좋아요 싫어요 값으로 개수 조회
  
}
