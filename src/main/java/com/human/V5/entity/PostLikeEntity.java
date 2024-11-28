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
 * 사용자 게시글 좋아요/싫어요
 */
@Entity
@Getter
@NoArgsConstructor
@Table(name="Car_Post_like")
public class PostLikeEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "post_like_index")
	private Integer postLikeIndex; // 좋아요/싫어요 고유 번호

	@Column(name = "post_index")
	private Integer postIndex; // 게시물 고유 번호

	@Column(name = "type")
	private Boolean type; // 좋아요(true) / 싫어요(false)

	@Column(name = "car_id")
	private String carId; // 좋아요/싫어요 사용자 아이디

	@Column(name="reg_date", columnDefinition="DATETIME DEFAULT NOW()")
	private Date regDate; // 좋아요/싫어요 클릭일시

	@Builder
	public PostLikeEntity(Integer postIndex, Boolean type, String carId) {
		this.postIndex = postIndex;
		this.type = type;
		this.carId = carId;
		this.regDate = new Date();
	}
}
