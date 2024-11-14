/*
 * package com.human.V5.entity;
 * 
 * 
 * import javax.persistence.Column; import javax.persistence.Entity; import
 * javax.persistence.GeneratedValue; import javax.persistence.GenerationType;
 * import javax.persistence.Id; import javax.persistence.Table;
 * 
 * import lombok.AllArgsConstructor; import lombok.Getter; import
 * lombok.NoArgsConstructor; import lombok.Setter;
 * 
 * @Entity
 * 
 * @Table(name = "bord")
 * 
 * @Getter
 * 
 * @Setter
 * 
 * @NoArgsConstructor
 * 
 * @AllArgsConstructor public class BordEntity {
 * 
 * @Id
 * 
 * @GeneratedValue(strategy = GenerationType.IDENTITY)
 * 
 * @Column(name = "bord_seq") private Integer bordSeq; // 게시물 고유 번호
 * 
 * @Column(name = "title", nullable = false) private String title; // 게시물 제목
 * 
 * @Column(name = "content", columnDefinition = "TEXT") private String content;
 * // 게시물 내용
 * 
 * @Column(name = "file_path") private String filePath; // 파일 경로
 * 
 * @Column(name = "file_name") private String fileName; // 파일 이름
 * 
 * @Column(name = "like_value", columnDefinition = "INT DEFAULT 0") private
 * Integer likeValue; // 좋아요 수
 * 
 * @Column(name = "unlike_value", columnDefinition = "INT DEFAULT 0") private
 * Integer unlikeValue; // 싫어요 수
 * 
 * @Column(name = "author") private String author; // 작성자 유저 아이디
 * 
 * // Getters and Setters }
 */