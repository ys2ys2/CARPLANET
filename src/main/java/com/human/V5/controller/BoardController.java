package com.human.V5.controller;

import java.util.ArrayList;
import java.util.List;  // List와 ArrayList를 사용하기 위한 import

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

// Post 클래스를 내부에 정의
class Post {
    private String userId;
    private String date;
    private String content;
    private int likeCount;
    private int commentCount;
    private int shareCount;

    // 생성자
    public Post(String userId, String date, String content, int likeCount, int commentCount, int shareCount) {
        this.userId = userId;
        this.date = date;
        this.content = content;
        this.likeCount = likeCount;
        this.commentCount = commentCount;
        this.shareCount = shareCount;
    }

    // Getters and Setters
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }

    public int getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }

    public int getShareCount() {
        return shareCount;
    }

    public void setShareCount(int shareCount) {
        this.shareCount = shareCount;
    }
}

@Controller
public class BoardController {

    // 게시판 리스트를 보여주는 메서드
    @GetMapping("/board")
    public String showBoard(Model model) {
        // 예시 데이터: 실제로는 DB에서 가져오는 부분
        List<Post> posts = new ArrayList<>();  // ArrayList는 Post 객체를 담을 수 있도록 제네릭 타입을 사용합니다.
        posts.add(new Post("user1", "2024-10-01", "스포티지 2020년 10월에 세차 산건데요. 혹시 이 엔진오일 써도 괜찮을까요?", 5, 0, 10));
        posts.add(new Post("user2", "2024-10-02", "연료 품질이 우수하고 서비스가 뛰어난 곳, 추천드립니다.", 10, 1, 20));
        
        // 게시물 데이터를 모델에 추가
        model.addAttribute("posts", posts);
        
        // board.jsp로 포워드
        return "board";  // JSP 파일 이름을 리턴
    }
}
