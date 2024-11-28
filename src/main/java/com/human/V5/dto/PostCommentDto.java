package com.human.V5.dto;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PostCommentDto {
  private Integer postCommentIndex; // 게시물 댓글 고유번호
  private Integer postIndex; // 게시물 고유 번호
  private String content; // 댓글 내용
  private String carId; // 작성자 유저 아이디
  private Integer likeCount; // 좋아요 수
  private Integer unlikeCount; // 싫어요 수
  private Date regDate; // 최초 댓글 등록일
  private Date modDate; // 최근 댓글 수정일
  
}
