package com.human.V5.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.human.V5.entity.PostEntity;
import com.human.V5.entity.UserEntity;
import com.human.V5.service.CommunityService;
import com.human.V5.service.myPageService;

@Controller
public class MainController {
	
	private myPageService mps;
	@Autowired
	private CommunityService communityService;
	
    // 메인 페이지
    @GetMapping("/") 
    public String home() {
        return "MainPage/mainpage";
    }
    
    
    // 회사소개 페이지
    @GetMapping("/Introduction") 
    public String Introduction() {
        return "MainPage/Introduction";
    }
    
    
    // 유가 페이지
    @GetMapping("/oil_price") 
    public String oil_price() {
        return "MainPage/oil_price";
    }
    

    // 마이페이지
	/*
	 * @GetMapping("/mypage") public String myPage(HttpServletRequest request) {
	 * UserEntity userId = getCurrentUser(request); if (userId == null) { return
	 * "redirect:/Auth/Login.do"; // 로그인되지 않은 경우 로그인 페이지로 리다이렉트 } return
	 * "MyPage/mypage"; // 로그인된 경우 마이페이지로 이동 }
	 */
    
    // 마이페이지
    @GetMapping("/mypage")
    public ModelAndView myPage(HttpServletRequest request) {
        ModelAndView mav = new ModelAndView();

        // 세션에서 사용자 정보 가져오기
        UserEntity user = getCurrentUser(request);
        if (user == null) {
            mav.setViewName("redirect:/Auth/Login.do"); // 로그인되지 않은 경우 로그인 페이지로 리다이렉트
            return mav;
        }

        String carId = user.getCarId();

        Pageable pageable = PageRequest.of(0, 10); // 한 페이지당 10개
        List<PostEntity> myPosts;

        try {
            // communityService 인스턴스를 통해 호출
            myPosts = communityService.getMyPostEntities(carId, pageable);
        } catch (Exception e) {
            // 예외 처리
            e.printStackTrace();
            mav.addObject("error", "게시글을 불러오는 중 문제가 발생했습니다.");
            mav.setViewName("error/errorPage"); // 에러 페이지로 이동
            return mav;
        }

        // 마이페이지와 커뮤니티 게시글 데이터를 모델에 추가
        mav.addObject("myPosts", myPosts);
        mav.addObject("user", user);

        mav.setViewName("MyPage/mypage"); // 마이페이지로 이동
        return mav;
    }



    private UserEntity getCurrentUser(HttpServletRequest request) {
        // 세션에서 UserEntity 가져오기
        UserEntity user = (UserEntity) request.getSession().getAttribute("user");
        return user; // 세션에 저장된 UserEntity 반환 (없으면 null 반환)
    }
    
    
    @GetMapping("/getOilStations/{areaCode}")
    @ResponseBody
    public ResponseEntity<String> getOilStations(@PathVariable("areaCode") String areaCode) {

        // 요청할 외부 API URL (파라미터를 클라이언트에서 받지 않음)
        String apiUrl = "http://www.opinet.co.kr/api/lowTop10.do?out=json&code=F241113446&prodcd=B027&area="+areaCode;

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
	/*
	 * @GetMapping("/community") public String community() { return
	 * "Community/community"; }
	 */

    
}
