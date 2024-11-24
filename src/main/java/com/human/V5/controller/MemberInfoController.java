package com.human.V5.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.human.V5.entity.UserEntity;

@Controller
public class MemberInfoController {
	
    @GetMapping("/updatelogic")
    public String updatelogic(HttpSession session, Model model) {
        // 세션에서 사용자의 비밀번호 확인 여부를 확인
        Boolean isPasswordVerified = (Boolean) session.getAttribute("isPasswordVerified");
        
        if (isPasswordVerified != null && isPasswordVerified) {
            // 비밀번호가 확인되었다면 개인 정보 수정 화면으로 이동
            return "/MyPage/updateMemberInfo";
        }
        
        // 비밀번호 확인이 안 되었으면 비밀번호 확인 화면으로 이동
        return "/MyPage/updatelogic";
    }
    
    
    @PostMapping("/check_password")
    @ResponseBody
    public Map<String, Object> checkPassword(@RequestBody Map<String, String> requestBody, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        // 요청 데이터와 세션 데이터를 로깅
        System.out.println("Request body: " + requestBody); // 클라이언트에서 받은 데이터 출력
        System.out.println("Session user: " + session.getAttribute("user")); // 세션에서 user 확인

        try {
            String password = requestBody.get("password");
            UserEntity user = (UserEntity) session.getAttribute("user");

            if (user == null) {
                System.out.println("Session user is null"); // 세션에 user가 없을 경우 로그
                response.put("status", "error");
                response.put("message", "로그인 정보가 없습니다. 다시 로그인해주세요.");
                return response;
            }

            System.out.println("User password in session: " + user.getCarPw()); // 세션에 저장된 비밀번호 로그

            if (user.getCarPw().equals(password)) {
                session.setAttribute("isPasswordVerified", true);
                response.put("status", "success");
                response.put("message", "비밀번호가 맞습니다!");
            } else {
                response.put("status", "error");
                response.put("message", "비밀번호가 틀렸습니다!");
            }
        } catch (Exception e) {
            System.err.println("Error in checkPassword: " + e.getMessage()); // 예외 메시지 출력
            response.put("status", "error");
            response.put("message", "서버에서 오류가 발생했습니다.");
        }

        return response;
    }



}
