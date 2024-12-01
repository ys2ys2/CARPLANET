package com.human.V5.entity;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.*;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 사용자 게시글 좋아요/싫어요
 */
@Entity
@Getter
@NoArgsConstructor
@Table(name = "Car_Post_comment_like")
public class PostCommentLikeEntity {
	

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "post_comment_like_index")
  private Integer postCommentLikeIndex; // 좋아요/싫어요 고유 번호

  @Column(name = "post_comment_index")
  private Integer postCommentIndex; // 게시물 댓글 고유 번호

  @Column(name = "type")
  private Boolean type; // 좋아요(true) / 싫어요(false)

  @Column(name = "car_id")
  private String carId; // 좋아요/싫어요 사용자 아이디

  @Column(name = "reg_date", columnDefinition = "DATETIME DEFAULT NOW()")
  private Date regDate; // 좋아요/싫어요 클릭일시

  @Builder
  public PostCommentLikeEntity(Integer postCommentIndex, Boolean type, String carId) {
    this.postCommentIndex = postCommentIndex;
    this.type = type;
    this.carId = carId;
    this.regDate = new Date();
  }
}
