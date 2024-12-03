package com.human.V5.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PostLikeDto {
  private Integer postIndex;
  private Integer likeCount;
  private Integer unlikeCount;
  
}
