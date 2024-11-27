package com.human.V5.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PostCommentLikeDto {
  private Integer postCommentIndex;
  private Integer likeCount;
  private Integer unlikeCount;
  
}
