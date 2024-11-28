package com.human.V5.repository;

import com.human.V5.entity.PostSearchLogEntity;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PostSearchLogRepository extends JpaRepository<PostSearchLogEntity, Integer> {
  @Query(value = "SELECT psl.keyword " +
    "FROM car_post_search_log psl " +
    "GROUP BY psl.keyword " +
    "ORDER BY COUNT(1) DESC " +
    "LIMIT :limit",
    nativeQuery = true)
  List<String> findPopularKeywords(@Param("limit") int limit);
  
}
