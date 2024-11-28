package com.human.V5.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Entity
@Getter
@AllArgsConstructor
@Table(name="Car_notice")
public class NoticeEntity {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name="notice_Idx", updatable=false)
	private int noticeIdx;
	
	@Column(name="notice_ntitle", updatable=false)
	private String carnTitle;
	
	@Column(name="notice_type", updatable=false)
	private String noticeType;
	
	@Column(name="notice_details", updatable=false)
	private String noticeDetails;
	
	@Builder
	public NoticeEntity(String carnTitle,String noticeType ,String NoticeDetails) {
		this.carnTitle = carnTitle;
		this.noticeType = noticeType;
		this.noticeDetails = NoticeDetails;
		
		
	}
	
}
