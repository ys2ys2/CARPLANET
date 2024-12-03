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
import lombok.Setter;

/**
 * 사용자 게시글 댓글
 */
@Entity
@Getter
@Setter
@NoArgsConstructor
@Table(name="Car_Post_comment")
public class PostCommentEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "post_comment_index")
	private Integer postCommentIndex; // 게시물 댓글 고유번호

	@Column(name = "post_index")
	private Integer postIndex; // 게시물 고유 번호

	@Column(name = "content", columnDefinition = "TEXT CHARACTER SET UTF8")
	private String content; // 댓글 내용

	@Column(name = "car_id")
	private String carId; // 작성자 유저 아이디

	@Column(name="reg_date", columnDefinition="DATETIME DEFAULT NOW()")
	private Date regDate; // 최초 댓글 등록일

	@Column(name="mod_date", columnDefinition="DATETIME DEFAULT NOW()")
	private Date modDate; // 최근 댓글 수정일

	@Builder
	public PostCommentEntity(Integer postIndex, String content,String carId) {
		this.postIndex = postIndex;
		this.content = content;
		this.carId = carId;
		this.regDate = new Date();
		this.modDate = new Date();
	}
}
