package com.human.V5.controller;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.human.V5.entity.UserEntity;
import com.human.V5.entity.VisitorEntity;
import com.human.V5.service.AdminService;
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




}
