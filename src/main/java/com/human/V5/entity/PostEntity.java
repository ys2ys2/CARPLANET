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

@Entity
@Getter
@Setter
@NoArgsConstructor
@Table(name="Car_Post")
public class PostEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "post_index")
	private Integer postIndex; // 게시물 고유 번호

	@Column(name = "title", nullable = false, columnDefinition = "VARCHAR(255) CHARACTER SET UTF8")
	private String title; // 게시물 제목

	@Column(name = "content", columnDefinition = "TEXT CHARACTER SET UTF8")
	private String content; // 게시물 내용

	@Column(name = "file_path")
	private String filePath; // 파일 경로

	@Column(name = "file_name")
	private String fileName; // 파일 이름

	@Column(name = "car_id")
	private String carId; // 작성자 유저 아이디

	@Column(name="reg_date", columnDefinition="DATETIME DEFAULT NOW()")
	private Date regDate; // 최초 게시글 등록일

	@Column(name="mod_date", columnDefinition="DATETIME DEFAULT NOW()")
	private Date modDate; // 최근 게시글 수정일

	@Builder
	public PostEntity(String title, String content, String filePath, String fileName, String carId, Integer post_Index) {
		this.title = title;
		this.content = content;
		this.filePath = filePath;
		this.fileName = fileName;
		this.carId = carId;
		this.regDate = new Date();
		this.modDate = new Date();
		this.postIndex = post_Index;
	}
}
