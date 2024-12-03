package com.human.V5.controller;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
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
	
	@GetMapping("/IdPwsearch.do")
	public String IdPwsearch() {
		return "Auth/IdPwsearch";
	}
	
	@GetMapping("/Authsetname.do")
	public String Authsetname() {
		return "Auth/Authsetname";
	}
	
	@PostMapping("/joinProcess.do")
	public ModelAndView joinProcess(UserVO vo, RedirectAttributes redirectModel) {
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
	    	redirectModel.addFlashAttribute("carId", vo.getCarId());
	        mav.setViewName("redirect:/Auth/Authsetname.do");  // 로그인으로 리다이렉트
	    } else {
	        mav.addObject("msg", "회원가입이 정상적으로 이루어지지 않았습니다.");
	        mav.setViewName("Auth/Login");  // 실패 시 로그인 페이지로 돌아가기
	    }
	    return mav;
	}
	
	@PostMapping("setnickname.do")
	public ModelAndView setNickname(@RequestParam String carId, @RequestParam String carNickname, HttpServletRequest request, ModelAndView mav) {
	    try {
	        // 1. 닉네임 중복 확인
	        if (userService.existsByCarNickname(carNickname)) {
	            mav.addObject("msg", "이미 사용 중인 닉네임입니다. 다른 닉네임을 입력해주세요.");
	            mav.setViewName("Auth/Authsetname");
	            return mav;
	        }

	        // 2. 기존 사용자 정보 가져오기
	        UserEntity userEntity = userService.findByCarId(carId);
	        if (userEntity == null) {
	            mav.addObject("msg", "사용자 정보를 찾을 수 없습니다. 다시 시도해주세요.");
	            mav.setViewName("Auth/Authsetname");
	            return mav;
	        }

	        // 3. 닉네임 업데이트
	        userEntity.updateNickname(carNickname); // 엔티티 내 수정 메서드 활용

	        // 4. 엔티티 업데이트
	        userService.updateUser(userEntity); // 닉네임만 반영됨

	        // 5. 세션 갱신
	        HttpSession session = request.getSession();
	        session.setAttribute("user", userEntity);

	        // 6. 성공적으로 처리 후 메인 페이지로 리다이렉트
	        mav.setViewName("redirect:/");
	    } catch (Exception e) {
	        e.printStackTrace();
	        mav.addObject("msg", "닉네임 설정 중 오류가 발생했습니다. 다시 시도해주세요.");
	        mav.setViewName("Auth/Authsetname");
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
		
	    //로그인 처리 요청
	    @PostMapping("/loginProcess.do")
	    public ModelAndView loginProcess(String carId, String carPw,
	                                     HttpServletRequest request, ModelAndView mav) {
	        
	        String viewName = "Auth/Login"; // 로그인 실패시 뷰이름

	        // UserEntity 조회 (status 조건 포함)
	        UserEntity vo = userService.findByCarIdAndCarPw(carId, carPw); // 상태 조건 없이 먼저 조회
	        
	        if (vo != null) { // 아이디와 비밀번호는 맞는 경우
	            if (Arrays.asList(1, 3).contains(vo.getCarStatus())) { // status가 1 또는 3인지 확인
	                // 로그인 성공 처리
	                HttpSession session = request.getSession();
	                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	                String formattedRegDate = formatter.format(vo.getRegDate());
	                session.setAttribute("formattedRegDate", formattedRegDate);
	                session.setAttribute("user", vo);
	                viewName = "redirect:/"; // 메인 페이지 재요청
	            } else { // 상태가 1, 3이 아닌 경우
	                mav.addObject("msg", "삭제 처리된 아이디입니다");
	            }
	        } else { // 아이디와 비밀번호가 틀린 경우
	            mav.addObject("msg", "아이디나 비밀번호가 일치하지 않습니다");
	        }
	        
	        mav.setViewName(viewName);
	        return mav;
	    }

		
		@GetMapping("/logout.do")
		public String logout(HttpServletRequest request) {
			//세션객체를 초기화 시킴(request객체의 getSession()메소드 이용해서 세션객체 얻음)
			HttpSession session = request.getSession();
			session.invalidate();
			
			return "redirect:/";				
		}
		
		@PostMapping("/kakaoLoginProcess.do")
		public ResponseEntity<Map<String, String>> kakaoLoginProcess(@RequestBody Map<String, Object> userInfo, HttpServletRequest request) {
		    try {
		        String kakaoId = userInfo.get("id").toString();
		        String nickname = (String) ((Map<String, Object>) userInfo.get("properties")).get("nickname");

		        UserEntity user = userService.findByKakaoId(kakaoId);
		        if (user == null) {
		            user = UserEntity.builder()
		                    .carId(kakaoId)
		                    .carName(nickname)
		                    .build();
		            userService.save(user);

		            HttpSession session = request.getSession();
		            session.setAttribute("user", user);

		            Map<String, String> response = new HashMap<>();
		            response.put("redirectUrl", "/CarPlanet/Auth/Authsetname.do");
		            response.put("carId", user.getCarId());

		            // JSON 응답 강제 설정
		            return ResponseEntity.ok()
		                    .header("Content-Type", "application/json")
		                    .body(response);
		        }

		        HttpSession session = request.getSession();
		        session.setAttribute("user", user);

		        Map<String, String> response = new HashMap<>();
		        response.put("redirectUrl", "/CarPlanet");

		        return ResponseEntity.ok()
		                .header("Content-Type", "application/json")
		                .body(response);
		    } catch (Exception e) {
		        e.printStackTrace();
		        return ResponseEntity.status(500).body(Collections.singletonMap("error", "FAIL"));
		    }
		}






		@PostMapping("/googleLoginProcess.do")
		public ResponseEntity<Map<String, String>> googleLoginProcess(@RequestBody Map<String, String> payload, HttpServletRequest request) {
		    try {
		        // Google 클라이언트 ID
		        String clientId = "965683450029-68l8v3esl34io1oj9rn0cjavk5addr1c.apps.googleusercontent.com";
		        String idTokenString = payload.get("id_token");

		        // Google ID Token 검증
		        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
		                new NetHttpTransport(),
		                new JacksonFactory()
		        ).setAudience(Collections.singletonList(clientId)).build();

		        GoogleIdToken idToken = verifier.verify(idTokenString);
		        if (idToken != null) {
		            GoogleIdToken.Payload payloadData = idToken.getPayload();

		            // 사용자 정보 추출
		            String googleId = payloadData.getSubject();
		            String email = payloadData.getEmail();
		            String name = (String) payloadData.get("name");

		            // 데이터베이스에서 사용자 검색 또는 저장 로직
		            UserEntity user = userService.findByGoogleId(googleId);
		            if (user == null) {
		                user = UserEntity.builder()
		                        .carId(googleId)
		                        .carName(name)
		                        .email(email)
		                        .build();
		                userService.save(user);

		                // 세션 저장
		                HttpSession session = request.getSession();
		                session.setAttribute("user", user);

		                // 응답 데이터 생성
		                Map<String, String> response = new HashMap<>();
		                response.put("redirectUrl", "/CarPlanet/Auth/Authsetname.do");
		                response.put("carId", user.getCarId());

		                return ResponseEntity.ok()
		                        .header("Content-Type", "application/json")
		                        .body(response);
		            }

		            // 기존 사용자라면 메인 페이지로 리다이렉트
		            HttpSession session = request.getSession();
		            session.setAttribute("user", user);

		            Map<String, String> response = new HashMap<>();
		            response.put("redirectUrl", "/CarPlanet");

		            return ResponseEntity.ok()
		                    .header("Content-Type", "application/json")
		                    .body(response);
		        } else {
		            return ResponseEntity.badRequest().body(Collections.singletonMap("error", "Invalid ID Token"));
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		        return ResponseEntity.status(500).body(Collections.singletonMap("error", "Google Login Failed"));
		    }
		}

		
		//아이디 찾기

		@PostMapping("/findId")
		public ResponseEntity<?> findId(@RequestParam String name, @RequestParam String email) {
		    try {
		        // 이름과 이메일로 사용자 검색
		        List<UserEntity> users = userService.findByNameAndEmail(name, email);

		        if (users.isEmpty()) {
		            return ResponseEntity.status(404).body("사용자를 찾을 수 없습니다.");
		        }

		        // 여러 사용자 ID 반환
		        List<String> userIds = users.stream()
		                                    .map(UserEntity::getCarId) // ID 추출
		                                    .collect(Collectors.toList());

		        return ResponseEntity.ok(userIds); // 리스트 반환
		    } catch (Exception e) {
		        e.printStackTrace();
		        return ResponseEntity.status(500).body("아이디 찾기 중 오류가 발생했습니다.");
		    }
		}

		
		//비밀번호 찾기
		@PostMapping("/sendTemporaryPassword")
		public ResponseEntity<String> sendTemporaryPassword(@RequestParam String id, @RequestParam String email) {
		    try {
		        // 아이디와 이메일로 사용자 검색
		        UserEntity user = userService.findByIdAndEmail(id, email);

		        if (user != null) {
		            // 임시 비밀번호 생성
		            String tempPassword = userService.generateTemporaryPassword();

		            // 임시 비밀번호를 데이터베이스에 업데이트
		            userService.updatePassword(user.getCarId(), tempPassword);

		            // 이메일 전송
		            userService.sendTemporaryPasswordEmail(user.getEmail(), tempPassword);

		            return ResponseEntity.ok("임시 비밀번호가 이메일로 전송되었습니다.");
		        } else {
		            return ResponseEntity.status(404).body("사용자를 찾을 수 없습니다.");
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		        return ResponseEntity.status(500).body("임시 비밀번호 생성 중 오류가 발생했습니다.");
		    }
		}
}
