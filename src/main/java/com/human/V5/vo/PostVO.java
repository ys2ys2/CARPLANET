package com.human.V5.vo;


import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@Data
@NoArgsConstructor
public class PostVO {
	private Integer postIndex;
	private String title;
	private String content;
	private MultipartFile file;
	private String originalFilePath;
	private String originalFileName;
}
