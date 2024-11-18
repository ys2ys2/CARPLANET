package com.human.V5.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.human.V5.entity.UserEntity;
import com.human.V5.service.myPageService;
import com.human.V5.vo.UserVO;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
public class MainController {
	
	private myPageService mps;

    // 메인 페이지
    @GetMapping("/") 
    public String home() {
        return "MainPage/mainpage";
    }

    // 마이페이지
    @GetMapping("/mypage")
    public String myPage(HttpServletRequest request) {
    	UserEntity userId = getCurrentUser(request);
        if (userId == null) {
            return "redirect:/Auth/Login.do"; // 로그인되지 않은 경우 로그인 페이지로 리다이렉트
        }
        return "MyPage/mypage"; // 로그인된 경우 마이페이지로 이동
    }

    private UserEntity getCurrentUser(HttpServletRequest request) {
        // 세션에서 UserEntity 가져오기
        UserEntity user = (UserEntity) request.getSession().getAttribute("user");
        return user; // 세션에 저장된 UserEntity 반환 (없으면 null 반환)
    }



    // 커뮤니티 페이지
    @GetMapping("/community")
    public String community() {
        return "Community/community";
    }

    
}
