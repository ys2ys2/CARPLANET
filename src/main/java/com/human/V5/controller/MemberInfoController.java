package com.human.V5.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.human.V5.entity.UserEntity;
import com.human.V5.service.UserService;

@Controller
public class MemberInfoController {
	
	@Autowired
	private UserService userService;
	
	
	@GetMapping("/updatelogic")
	public String updatelogic() {
	    return "MyPage/updatelogic"; // JSP 파일 이름 반환
	}

    
    
    @PostMapping(value = "/check_password", produces = "application/json")
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
            } else {
                response.put("status", "error");
                response.put("message", "비밀번호를 확인해주세요.");
            }
        } catch (Exception e) {
            System.err.println("Error in checkPassword: " + e.getMessage()); // 예외 메시지 출력
            response.put("status", "error");
            response.put("message", "서버에서 오류가 발생했습니다.");
        }

        return response;
    }
    
    
    //updateUser
    @PostMapping(value = "/updateUserInfo", produces = "application/json")
    public ResponseEntity<Map<String, String>> updateUserInfo(@RequestBody Map<String, String> userInfo, HttpSession session) {
        try {
            UserEntity user = (UserEntity) session.getAttribute("user");
            if (user == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("status", "FAIL", "message", "로그인이 필요합니다."));
            }

            String newCarName = userInfo.get("carName");
            String newBirthday = userInfo.get("birthday");
            String newPhone = userInfo.get("phone");
            String newEmail = userInfo.get("email");

            user.updateCarName(newCarName);
            user.setBirthday(newBirthday);
            user.setPhone(newPhone);
            user.setEmail(newEmail);

            userService.updateUser(user);
            session.setAttribute("user", user);

            return ResponseEntity.ok(Map.of("status", "SUCCESS"));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("status", "FAIL", "message", "서버 오류가 발생했습니다."));
        }
    }



}
