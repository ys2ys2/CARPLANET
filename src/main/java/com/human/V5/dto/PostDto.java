package com.human.V5.dto;

import com.human.V5.entity.PostCommentEntity;
import java.util.Date;
import java.util.List;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PostDto {
  private Integer postIndex; // 게시물 고유 번호
  private String title; // 게시물 제목
  private String content; // 게시물 내용
  private String filePath; // 파일 경로
  private String fileName; // 파일 이름
  private String carId; // 작성자 유저 아이디
  private Integer likeCount;
  private Integer unlikeCount;
  private List<PostCommentDto> comments;
  private Date regDate; // 최초 게시글 등록일
  private Date modDate; // 최근 게시글 수정일
  
}
