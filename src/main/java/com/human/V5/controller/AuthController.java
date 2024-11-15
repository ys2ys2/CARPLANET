package com.human.V5.controller;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.human.V5.entity.UserEntity;
import com.human.V5.service.UserService;
import com.human.V5.vo.UserVO;

import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/Auth") // 공통 URL 정의
@AllArgsConstructor
public class AuthController {
	
	private UserService userService;
	
	@GetMapping("Login.do")
	public String Login() {
		return "Auth/Login";
	}
	
	@PostMapping("/joinProcess.do")
	public ModelAndView joinProcess(UserVO vo) {
	    ModelAndView mav = new ModelAndView();

	    UserEntity entity = UserEntity.builder()
	            .carName(vo.getCarName())
	            .phone(vo.getPhone())
	            .carId(vo.getCarId())
	            .carPw(vo.getCarPw())
	            .email(vo.getEmail())
	            .birthday(vo.getBirthday())
	            .build();

	    UserEntity savedVo = userService.save(entity);

	    // 회원가입 성공 여부에 따라 리다이렉션 처리
	    if (savedVo != null) {
	        mav.setViewName("redirect:/Auth/Login.do");  // 로그인으로 리다이렉트
	    } else {
	        mav.addObject("msg", "회원가입이 정상적으로 이루어지지 않았습니다.");
	        mav.setViewName("Auth/Login");  // 실패 시 로그인 페이지로 돌아가기
	    }
	    return mav;
	}
	
	//아이디 중복검사
		@PostMapping("/checkId.do")
		public ResponseEntity<String> checkId(String carId) {
			//중복 아이디가 없는 경우 결과값
			ResponseEntity<String> result = ResponseEntity.ok("PASS");
			
			System.out.println(carId);
			
			//if(memberServiceImpl.checkId(member_id) == 1) {//중복 아이디가 있는 경우
			if(userService.countByCarId(carId) == 1) {//쿼리 메소드를 이용해서 중복아이디 체크
				result = ResponseEntity.ok("FAIL");
			}
			return result;
		}
		
		 // 이메일 인증 요청
	    @PostMapping("/sendVerificationCode")
	    public ResponseEntity<String> sendVerificationCode(@RequestParam String email) {
	        try {
	            userService.authEmail(email); // 이메일 인증 코드 전송
	            return ResponseEntity.ok("SUCCESS");
	        } catch (Exception e) {
	            e.printStackTrace();
	            return ResponseEntity.status(500).body("FAIL");
	        }
	    }

	    // 이메일 인증 코드 확인
	    @PostMapping("/verifyCode")
	    public ResponseEntity<String> verifyCode(@RequestBody Map<String, String> request) {
	        String email = request.get("email");
	        String code = request.get("code");

	        if (userService.verifyCode(email, code)) {
	            return ResponseEntity.ok("SUCCESS");
	        } else {
	            return ResponseEntity.ok("FAIL");
	        }
	    }
		

}
