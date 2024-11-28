package com.human.V5.vo;


import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@Data
@Getter
@Setter
@NoArgsConstructor
public class PostCommentVO {
	private Integer postCommentIndex;
	private Integer postIndex;
	private String content;
	
}
