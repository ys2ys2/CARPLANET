package com.human.V5.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.human.V5.entity.UserEntity;
import com.human.V5.service.myPageService;

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

    
    @GetMapping("/getRecentPrice")
    @ResponseBody
    public ResponseEntity<String> getRecentPrice() {

        // 요청할 외부 API URL (파라미터를 클라이언트에서 받지 않음)
        String apiUrl = "http://www.opinet.co.kr/api/avgRecentPrice.do?out=json&code=F241113446";

        // RestTemplate을 사용하여 외부 API에 GET 요청
        RestTemplate restTemplate = new RestTemplate();
        try {
            // 외부 API로부터 XML 응답을 String으로 받음
            String response = restTemplate.getForObject(apiUrl, String.class);

            // 응답을 그대로 클라이언트에 전달
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json; charset=UTF-8")  // 응답 타입을 XML로 설정
                    .body(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("API 호출 실패");
        }
    }
    
    

    // 커뮤니티 페이지
    @GetMapping("/community")
    public String community() {
        return "Community/community";
    }

    
}
