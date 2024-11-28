package com.human.V5.controller;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.apache.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.human.V5.entity.NoticeEntity;
import com.human.V5.entity.PostEntity;
import com.human.V5.entity.UserEntity;
import com.human.V5.entity.VisitorEntity;
import com.human.V5.service.AdminService;
import com.human.V5.vo.NoticeVO;
import com.human.V5.vo.VisitorVO;

import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/Admin")
@AllArgsConstructor
public class AdminController {
	
	private AdminService adminserviceimpl;
	
	@GetMapping("admin.do")
	public String Gas() {
		return "Administrator/Administrator";
	}
	
	@GetMapping("alluser.do")
	@ResponseBody
    public List<UserEntity> alluser() {
		
        return adminserviceimpl.getAllUsers(); // JSON 형식으로 반환
    }
	
	@PostMapping("/track-visitor")
	@ResponseBody
	public ResponseEntity<String> trackVisitor(@RequestBody VisitorVO vo) {
	    // 현재 날짜를 한국 시간대로 설정
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	    sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
	    String formattedDate = sdf.format(new Date());

	    // VisitorVO -> VisitorEntity 변환
	    VisitorEntity entity = VisitorEntity.builder()
	            .url(vo.getUrl())
	            .userAgent(vo.getUserAgent())
	            .timestamp(java.sql.Date.valueOf(formattedDate)) // 한국 시간 기준 날짜
	            .build();

	    // 서비스 계층 호출
	    VisitorEntity savedEntity = adminserviceimpl.save(entity);

	    // 결과에 따른 응답
	    if (savedEntity != null) {
	        return ResponseEntity.ok("방문자 데이터 저장 완료");
	    } else {
	        return ResponseEntity.status(500).body("방문자 데이터 저장 실패");
	    }
	}
	
	@GetMapping("/visitor-stats")
	@ResponseBody
	public ResponseEntity<List<Map<String, Object>>> getVisitorStats() {
	    List<Map<String, Object>> stats = adminserviceimpl.getRecentVisitorStats(5);
	    
	    // 새로운 리스트에 수정된 Map 저장
	    List<Map<String, Object>> modifiedStats = stats.stream().map(item -> {
	        // 새 Map 생성
	        Map<String, Object> modifiableMap = new HashMap<>(item);

	        // 날짜 변환
	        java.sql.Date sqlDate = (java.sql.Date) item.get("date"); // java.sql.Date
	        java.util.Date utilDate = new java.util.Date(sqlDate.getTime()); // java.util.Date로 변환
	        LocalDate localDate = utilDate.toInstant()
	                                      .atZone(TimeZone.getTimeZone("Asia/Seoul").toZoneId())
	                                      .toLocalDate();
	        String formattedDate = localDate.format(DateTimeFormatter.ofPattern("MM-dd"));

	        // 새 Map에 변환된 날짜 추가
	        modifiableMap.put("date", formattedDate);
	        return modifiableMap;
	    }).collect(Collectors.toList()); // Collectors.toList()로 스트림 결과를 리스트로 변환

	    return ResponseEntity.ok(modifiedStats);
	}
	
	
	@GetMapping("/userCount")
	@ResponseBody
	public ResponseEntity<Long> getUserCount(){
		
		long userCount = adminserviceimpl.getUserCount();
		return ResponseEntity.ok(userCount);
	}
	
	@GetMapping("/countPost")
	@ResponseBody
	public ResponseEntity<Long> getCountPost(){
		long postCount = adminserviceimpl.getPostCount();
		
		return ResponseEntity.ok(postCount);
	}
	
	@GetMapping("/countNotice")
	@ResponseBody
	public ResponseEntity<Long> getcountNotice(){
		long noticeCount = adminserviceimpl.getNoticeCount();
		
		return ResponseEntity.ok(noticeCount);
	}
	
	@PostMapping("/noticeinput.do")
	public ModelAndView saveNotice(NoticeVO vo,RedirectAttributes redirect) {
		ModelAndView mav = new ModelAndView();
		
		NoticeEntity ent = NoticeEntity.builder()
				.carnTitle(vo.getCarnTitle())
				.noticeType(vo.getNoticeType())
				.NoticeDetails(vo.getNoticeDetails())
				.build();
		
		NoticeEntity saveVO= adminserviceimpl.save(ent);
		
		if (saveVO != null) {
			redirect.addFlashAttribute("message","공지사항 입력이 완료 되었습니다.");
	        mav.setViewName("redirect:/Admin/admin.do");  // 로그인으로 리다이렉트
	    } else {
	        mav.addObject("msg", "공지사항 등록이 정상적으로 이루어지지 않았습니다.");
	    }
		
		return mav;
	}
	
	@PostMapping("/userdelete.do")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteUser(HttpSession session, int userIdx) {
	    UserEntity loggedInUser = (UserEntity) session.getAttribute("user");

	    Map<String, Object> response = new HashMap<>();

	    // 로그인 여부와 관리자 권한 검증
	    if (loggedInUser == null) {
	        response.put("success", false);
	        response.put("message", "로그인이 필요합니다.");
	        return ResponseEntity.status(HttpStatus.SC_UNAUTHORIZED).body(response);
	    }

	    if (loggedInUser.getCarStatus() != 3) { // 3: 관리자 권한
	        response.put("success", false);
	        response.put("message", "관리자 권한이 필요합니다.");
	        return ResponseEntity.status(HttpStatus.SC_FORBIDDEN).body(response);
	    }

	    // 삭제 처리
	    boolean success = adminserviceimpl.deleteUserByIdx(userIdx);
	    response.put("success", success);
	    response.put("message", success ? "회원이 성공적으로 삭제되었습니다." : "회원 삭제 실패");

	    return ResponseEntity.ok(response);
	}

	
	@PostMapping("/userPromote.do")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> promoteUser(HttpSession session, int userIdx) {
	    // 세션에서 로그인 사용자 정보 가져오기
	    UserEntity loggedInUser = (UserEntity) session.getAttribute("user");

	    Map<String, Object> response = new HashMap<>();

	    // 로그인 여부와 관리자 권한 검증
	    if (loggedInUser == null) {
	        response.put("success", false);
	        response.put("message", "로그인이 필요합니다.");
	        return ResponseEntity.status(HttpStatus.SC_UNAUTHORIZED).body(response);
	    }

	    if (loggedInUser.getCarStatus() != 3) { // 3: 관리자 권한
	        response.put("success", false);
	        response.put("message", "관리자 권한이 필요합니다.");
	        return ResponseEntity.status(HttpStatus.SC_FORBIDDEN).body(response);
	    }

	    // 관리자 권한 부여 로직
	    boolean success = adminserviceimpl.updateUserStatus(userIdx, 3);
	    response.put("success", success);
	    response.put("message", success ? "관리자 권한을 부여하였습니다." : "권한부여 실패");

	    return ResponseEntity.ok()
	            .header("Content-Type", "application/json; charset=UTF-8")
	            .body(response);
	}

	
	@PostMapping("/userdemote.do")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> demoteUser(HttpSession session, int userIdx) {
	    // 세션에서 로그인 사용자 가져오기
	    UserEntity logUser = (UserEntity) session.getAttribute("user");

	    Map<String, Object> response = new HashMap<>();

	    // 로그인 여부 확인
	    if (logUser == null) {
	        response.put("success", false);
	        response.put("message", "로그인이 필요합니다.");
	        return ResponseEntity.status(HttpStatus.SC_UNAUTHORIZED).body(response);
	    }

	    // 관리자 권한 여부 확인
	    if (logUser.getCarStatus() != 3) { // 3: 관리자
	        response.put("success", false);
	        response.put("message", "관리자 권한이 필요합니다.");
	        return ResponseEntity.status(HttpStatus.SC_FORBIDDEN).body(response);
	    }

	    // 일반 등급으로 강등 처리
	    boolean success = adminserviceimpl.updateUserStatus(userIdx, 1);
	    response.put("success", success);
	    response.put("message", success ? "일반회원 처리 되었습니다." : "처리 실패");

	    return ResponseEntity.ok()
	            .header("Content-Type", "application/json; charset=UTF-8")
	            .body(response);
	}


	@GetMapping("/searchUser.do")
	@ResponseBody
	public List<UserEntity> searchUser(@RequestParam(required = false) String keyword,
	                                   @RequestParam(required = false) Integer carStatus) {
		
		System.out.println(keyword+ ","+ carStatus);
	    // 세 가지 경우를 처리
	    if (keyword != "" && carStatus != null) {
	        // keyword와 carStatus 둘 다 설정된 경우
	        return adminserviceimpl.searchByKeywordAndCarStatus(keyword, carStatus);
	    } else if (keyword != "") {
	        // keyword만 설정된 경우
	        return adminserviceimpl.searchByKeyword(keyword);
	    } else if (carStatus != null) {
	        // carStatus만 설정된 경우
	        return adminserviceimpl.searchByCarStatus(carStatus);
	    } else {
	        // 검색 조건이 없는 경우 (전체 데이터 반환 or 빈 리스트 반환)
	        return new ArrayList<>();
	    }
	}
	
	@GetMapping("/searchPost.do")
	@ResponseBody
	public List<PostEntity> searchUser(@RequestParam(required = false) String keyword){
		
		return adminserviceimpl.psearchByKeyword(keyword);
	}
	
	@GetMapping("/allpost.do")
	@ResponseBody
	public List<PostEntity> allpost(){
		
		return adminserviceimpl.getAllpost();
	}


	@PostMapping("/deletepost")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deletePost(HttpSession session, @RequestParam int postIndex) {
	    // 현재 로그인한 사용자 정보 가져오기
	    UserEntity loggedInUser = (UserEntity) session.getAttribute("user");

	    Map<String, Object> response = new HashMap<>();

	    // 로그인 여부 확인
	    if (loggedInUser == null) {
	        response.put("success", false);
	        response.put("message", "로그인이 필요합니다.");
	        return ResponseEntity.status(HttpStatus.SC_UNAUTHORIZED).body(response); // 401 Unauthorized
	    }

	    // 관리자 권한 확인
	    if (loggedInUser.getCarStatus() != 3) { // 3: 관리자 권한
	        response.put("success", false);
	        response.put("message", "관리자 권한이 필요합니다.");
	        return ResponseEntity.status(HttpStatus.SC_FORBIDDEN).body(response); // 403 Forbidden
	    }

	    // 게시글 삭제 처리
	    boolean success = adminserviceimpl.deletePostByIndex(postIndex); // 게시글 삭제 서비스 호출

	    // 응답 데이터 구성
	    response.put("success", success);
	    response.put("message", success ? "게시글이 성공적으로 삭제되었습니다." : "게시글 삭제 실패");

	    return ResponseEntity.ok(response); // 200 OK
	}


}
