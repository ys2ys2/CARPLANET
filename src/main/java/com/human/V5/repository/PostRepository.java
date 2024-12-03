package com.human.V5.repository;

import com.human.V5.entity.PostEntity;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface PostRepository extends JpaRepository<PostEntity, Integer> {
  Page<PostEntity> findAllByOrderByRegDateDesc(Pageable pageable);
  Page<PostEntity> findAllByTitleLikeOrContentLikeOrderByRegDateDesc(String titleKeyword, String contentKeyword, Pageable pageable);

  @Query(value = "SELECT p.post_index, p.car_id, p.title, p.content, p.file_name, p.file_path, p.mod_date, p.reg_date FROM car_post p LEFT JOIN car_post_like pl ON p.post_index = pl.post_index GROUP BY p.post_index ORDER BY SUM(CASE WHEN pl.type = true THEN 1 ELSE 0 END) DESC LIMIT 10",  nativeQuery = true)
  List<PostEntity> findRecommendedPosts();
  
  List<PostEntity> findByTitleContainingOrContentContaining(String keyword, String keyword2);

  Page<PostEntity> findByCarId(String carId, Pageable pageable); // 충돌33
  
}