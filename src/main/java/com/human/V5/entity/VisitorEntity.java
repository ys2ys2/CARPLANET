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

@Entity
@Table(name = "visitor")
@Getter
public class VisitorEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String url;
    private String userAgent;
    
    @Column(name = "timestamp", columnDefinition = "DATE")
    private Date timestamp; // 날짜만 저장


    @Builder
    public VisitorEntity(String url, String userAgent, Date timestamp) {
        this.url = url;
        this.userAgent = userAgent;
        this.timestamp = timestamp;
    }
}
