package com.human.V5.entity;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 게시글 검색 이력 (인기 키워드 집계용)
 */
@Entity
@Getter
@NoArgsConstructor
@Table(name="Car_Post_search_log")
public class PostSearchLogEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "post_search_log_index")
	private Integer postSearchlogIndex;

	@Column(name = "keyword", columnDefinition = "VARCHAR(255) CHARACTER SET UTF8")
	private String keyword; // 검색어
	@Column(name="reg_date", columnDefinition="DATETIME DEFAULT NOW()")
	private Date regDate; // 검색일


	@Builder
	public PostSearchLogEntity(String keyword) {
		this.keyword = keyword;
		this.regDate = new Date();
	}
}
