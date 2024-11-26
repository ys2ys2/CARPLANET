package com.human.V5.repository;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.human.V5.entity.VisitorEntity;

public interface VisitorRepository extends JpaRepository<VisitorEntity,Integer>{

	@Query("SELECT DATE(v.timestamp) as date, COUNT(v) as count FROM VisitorEntity v " +
		       "GROUP BY DATE(v.timestamp) ORDER BY DATE(v.timestamp) DESC")
		List<Map<String, Object>> findVisitorStats(Pageable pageable);

}
