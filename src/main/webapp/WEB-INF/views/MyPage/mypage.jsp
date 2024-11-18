희진
janghyijin_66034_94246
온라인

희진 — 2024-11-13 오후 6:22
같이가자
나졸려
송선호 — 2024-11-13 오후 6:22
좋아용!
희진 — 2024-11-14 오전 11:03
화이트
집에 4개 있는데
필요함?
송선호 — 2024-11-14 오전 11:07
괜찮아용 감사합니다!!
희진 — 2024-11-15 오후 12:34
오늘 7시 20뷴에 도망갈꺼임
송선호 — 2024-11-15 오후 12:34
같이 가용
희진 — 2024-11-15 오후 12:35
오키
오늘도 내덩생 보겠다
ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ
동생 온다해서 7시 10분까지 빨리 하고 도망가야지 헤
송선호 — 2024-11-15 오후 12:35
좋아용~!
희진 — 2024-11-15 오후 4:28
선호
지금
로그인 되는거임???
송선호 — 2024-11-15 오후 4:28
아뇨 아직 안올라왔어요
희진 — 2024-11-15 오후 4:28
아하
아까 자기 다했다고
지탓하지말라해서
뭐지
송선호 — 2024-11-15 오후 4:28
이따 올라오면 말씀드릴게용
희진 — 2024-11-15 오후 4:28
했지
ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ
내꺼 받으면
로그인 누르면
들어가지고
커뮤니티도
다 들어가지게
송선호 — 2024-11-15 오후 4:29
충돌나서 깃 다시 받아서 파일 옮기고 다시 실행했는데 안되나봐요..
희진 — 2024-11-15 오후 4:29
해둠
룰루~!
송선호 — 2024-11-15 오후 4:29
고생많으셨어용!!
송선호 — 2024-11-15 오후 6:10
@charset "UTF-8";

/* 폰트 설정 */
@font-face { /* 어그로체 */
    font-family: 'SBAggroB';
    src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2108@1.1/SBAggroB.woff') format('woff');
확장
message.txt
3KB
희진 — 오늘 오전 9:43
선호 로그인 하면 되는걸로 변경됨??????
송선호 — 오늘 오전 9:43
아직 확인 못했어용
희진 — 오늘 오전 9:44
아니아니 커뮤니티 로근인 해야 들어갈 수 있는걸로 변경했엉>???
너너너 어케 했엉 글 올릴때 로그인해야
희진 — 오늘 오전 9:58
올릴때만 로그인 허용한거 어케함 나 이따 알려줘
희진 — 오늘 오전 10:16
선호오
송선호 — 오늘 오전 10:16
넵!
송선호 — 오늘 오전 10:55
@PostMapping("/updatePost.do")
  public String updatePost(HttpServletRequest request, PostVO vo) throws IOException {
    String userId = getCurrentUserId(request);
    if (userId == null) {
      return "redirect:/Auth/Login.do";
    }




<button onclick="location.href='/V5/community/post.do'">공유하기</button>
희진 — 오늘 오전 10:59
<button onclick="location.href='/V5/community/post.do'">공유하기</button>
        <span><a href="${pageContext.request.contextPath}/mypage">마이페이지</a></span>
송선호 — 오늘 오전 11:01
<button onclick="location.href='${pageContext.request.contextPath}/mypage'" style="display: flex; align-items: center; gap: 8px; padding: 10px; border: none; background-color: #007BFF; color: white; border-radius: 5px; cursor: pointer;">
    <img src="/V5/resources/images/mypage-icon.png" alt="마이페이지" style="width: 20px; height: 20px;">
    <span>마이페이지</span>
</button>
희진 — 오늘 오전 11:02
package com.human.V5.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
public class MainController {

    //희진- 메인페이지 경로: localhost:9090/CarPlanet/
    @GetMapping("/") 
    public String home() {
        return "MainPage/mainpage";
    }

    @GetMapping("/mypage")
    public String mypage() {
        return "MyPage/mypage";
    }

    @GetMapping("/community")
    public String community() {
        return "Community/community";
    }
    @GetMapping("/mypage.do")
    public String updatePost(HttpServletRequest request, PostVO vo) throws IOException {
      String userId = getCurrentUserId(request);
      if (userId == null) {
        return "redirect:/Auth/Login.do";
      }


}
선호야 나 화장실만 다녀올게
배아파서
송선호 — 오늘 오전 11:03
넹
package com.human.V5.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.human.V5.vo.UserVO;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
public class MainController {

    @GetMapping("/")
    public String home() {
        return "MainPage/mainpage";
    }

    @GetMapping("/mypage")
    public String myPage(HttpServletRequest request) {
        String userId = getCurrentUserId(request);
        if (userId == null) {
            return "redirect:/Auth/Login.do";
        }
        return "MyPage/mypage";
    }

    @GetMapping("/community")
    public String community() {
        return "Community/community";
    }

    private String getCurrentUserId(HttpServletRequest request) {
        UserVO user = (UserVO) request.getSession().getAttribute("user");
        return (user != null) ? user.getUserId() : null;
    }
}
희진 — 오늘 오전 11:11
<c:when test="${not empty user}">
    <!-- 로그인 성공 시, 마이페이지와 로그아웃 표시 -->
    <div class="header-container">
      <div class="member">
        <span class="userprofile">${user.carId}님 환영합니다!</span>
        <button onclick="location.href='${pageContext.request.contextPath}/mypage'" style="display: flex; align-items: center; gap: 8px; padding: 10px; border: none; background-color: #007BFF; color: white; border-radius: 5px; cursor: pointer;">
    <img src="/V5/resources/images/mypage-icon.png" alt="마이페이지" style="width: 20px; height: 20px;">
    <span>마이페이지</span>
</button>

  <div class="icon-item">
    <a href="${pageContext.request.contextPath}/mypage">
      <img src="${pageContext.request.contextPath}/resources/images/MyPage.png" alt="마이페이지" class="icon">
      <span>마이페이지</span>
아ㅏㅇ
선호야 로그인하면
에러가 뜨느거야
로그인해서 들어가면
마이페이지 오류나는거야
송선호 — 오늘 오전 11:14
언니 파일로 보내주실 수 있을까요?
컨트롤러랑 푸터 헤더만요!
서비스도요!
희진 — 오늘 오전 11:15
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
확장
header.jsp
4KB
package com.human.V5.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
확장
MainController.java
2KB
package com.human.V5.vo;


import lombok.Data;
import lombok.NoArgsConstructor;
확장
UserVO.java
1KB
package com.human.V5.service;


import com.human.V5.entity.UserEntity;

확장
UserService.java
1KB
package com.human.V5.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
확장
UserServiceImpl.java
3KB
송선호 — 오늘 오전 11:28
언니 저 왜 마이페이지 버튼이 없을까요..?
이미지
희진 — 오늘 오전 11:29
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
확장
header.jsp
4KB
@charset "UTF-8";

/* 폰트 설정 */
@font-face { /* 어그로체 */
    font-family: 'SBAggroB';
    src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2108@1.1/SBAggroB.woff') format('woff');
확장
header.css
4KB
css도 바꿨엉
송선호 — 오늘 오전 11:30
넵!
송선호 — 오늘 오전 11:38
<!-- 로그인 성공 시, 마이페이지와 로그아웃 표시 -->
    <div class="header-container">
      <div class="member">
        <span class="userprofile">${user.carId}님 환영합니다!</span>
        <button onclick="location.href='${pageContext.request.contextPath}/mypage'" 
        style="display: flex; align-items: center; gap: 8px; padding: 10px; border: none; background-color: #007BFF; color: white; border-radius: 5px; cursor: pointer;">
    <img src="${pageContext.request.contextPath}/resources/images/mypage-icon.png" alt="마이페이지" style="width: 20px; height: 20px;">
    <span>마이페이지</span>
</button>
-
package com.human.V5.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.human.V5.vo.UserVO;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
public class MainController {

    @GetMapping("/")
    public String home() {
        return "MainPage/mainpage";
    }

    @GetMapping("/mypage")
    public String myPage(HttpServletRequest request) {
        String userId = getCurrentUserId(request);
        if (userId == null) {
            return "redirect:/Auth/Login.do";
        }
        return "MyPage/mypage";
    }

    @GetMapping("/community")
    public String community() {
        return "Community/community";
    }

    private String getCurrentUserId(HttpServletRequest request) {
        UserVO user = (UserVO) request.getSession().getAttribute("user");
        return (user != null) ? user.getCarId() : null;
    }
}
희진 — 오늘 오전 11:44
11월 18, 2024 11:44:33 오전 org.apache.catalina.core.StandardWrapperValve invoke
심각: 경로 [/CarPlanet]의 컨텍스트 내의 서블릿 [appServlet]을(를) 위한 Servlet.service() 호출이, 근본 원인(root cause)과 함께, 예외 [Request processing failed; nested exception is java.lang.ClassCastException: class com.human.V5.entity.UserEntity cannot be cast to class com.human.V5.vo.UserVO (com.human.V5.entity.UserEntity and com.human.V5.vo.UserVO are in unnamed module of loader org.apache.catalina.loader.ParallelWebappClassLoader @517bd097)]을(를) 발생시켰습니다.
java.lang.ClassCastException: class com.human.V5.entity.UserEntity cannot be cast to class com.human.V5.vo.UserVO (com.human.V5.entity.UserEntity and com.human.V5.vo.UserVO are in unnamed module of loader org.apache.catalina.loader.ParallelWebappClassLoader @517bd097)
at com.human.V5.controller.MainController.getCurrentUserId(MainController.java:36)
at com.human.V5.controller.MainController.myPage(MainController.java:23)
at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
확장
message.txt
5KB
송선호 — 오늘 오전 11:50
<div class="member">
        <span class="userprofile">${user.carId}님 환영합니다!</span>
       <button onclick="location.href='${pageContext.request.contextPath}/mypage'" 
        style="display: flex; align-items: center; gap: 8px; padding: 10px; border: none; background-color: #007BFF; color: white; border-radius: 5px; cursor: pointer;">
    <img src="${pageContext.request.contextPath}/resources/images/mypage-icon.png" alt="마이페이지" style="width: 20px; height: 20px;">
    <span>마이페이지</span>
희진 — 오늘 오전 11:53
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
확장
mypage.jsp
4KB
선호
너꺼 수정 안했으면
마이페이지 누르면
들어가질꺼야
송선호 — 오늘 오전 11:54
제꺼 수정해서 오류떠서 여쭤봤어용 ㅠ
희진 — 오늘 오전 11:54
어어
아아
송선호 — 오늘 오전 11:55
확인이 안돼서 언니꺼 수정한 부분만 언니한테 보내서 확인하구 있는거에욤
ㅠ
희진 — 오늘 오전 11:55
ㅠㅠㅠ
아아 ㅠ
송선호 — 오늘 오전 11:55
한번 해볼게용
희진 — 오늘 오전 11:55
저거 딱히 건든건없엉
연결하느ㅜㄴ거 에서 ㅇ오류나나봥
ㅠ
송선호 — 오늘 오전 11:55
500에러 저거만 해결하면 될텐데 음
넵 그런거 같아용
언니 혹시 마이페이지만 띄어서 확인해보셨나욤?
저 방금 들어갔는데 없는 페이지로 떠서용..
희진 — 오늘 오후 12:02
맞아 지금
나도 안들어가져
송선호 — 오늘 오후 12:02
최근에 언제 들어가봤어용??
희진 — 오늘 오후 12:02
이거 연결하기 전에
!
수정 전에
오늘 아참
package com.human.V5.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
public class MainController {

    //희진- 메인페이지 경로: localhost:9090/CarPlanet/
    @GetMapping("/") 
    public String home() {
        return "MainPage/mainpage";
    }

    @GetMapping("/mypage")
    public String mypage() {
        return "MyPage/mypage";
    }

    @GetMapping("/community")
    public String community() {
        return "Community/community";
    }


}
희진 — 오늘 오후 12:35
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
확장
mypage.jsp
4KB
송선호 — 오늘 오후 1:29
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
확장
mypage.jsp
4KB
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
확장
header.jsp
4KB
package com.human.V5.service;

import org.springframework.stereotype.Service;

import com.human.V5.entity.UserEntity;
import com.human.V5.repository.UserRepository;
확장
myPageService.java
1KB
package com.human.V5.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
확장
MainController.java
2KB
﻿
송선호
2000so
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 메인</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypage.css">
</head>
<body>
<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />

<!-- 왼쪽 프로필 영역 -->
<div class="profile-section">
    <div class="profile-card">
        <!-- 차량 정보 섹션 -->
        <h4>나의 차량 정보</h4>
        <div class="car-info">
            <img src="${pageContext.request.contextPath}/resources/images/car_image.png" alt="차량 이미지" class="car-image">
            <div class="car-details">
                <div class="car-detail">
                    <span>차량 종류</span><span>아우디 A6</span>
                </div>
                <div class="car-detail">
                    <span>차량 번호</span><span>123가1234</span>
                </div>
                <div class="car-detail">
                    <span>차량 유종</span><span>디젤</span>
                </div>
            </div>
            <!-- 차량 정보 등록하기 버튼 -->
            <a href="${pageContext.request.contextPath}/registerCarInfo.jsp" class="register-car-info-btn">차량정보 등록하기</a>
        </div>

        <!-- 자주 가는 장소 섹션 -->
        <h4>자주가는 장소</h4>
        <div class="frequent-places">
            <div class="place-card">
                <span>주차장</span>
                <a href="${pageContext.request.contextPath}/parking.jsp" class="more-btn">장소 더보기</a>
            </div>
            <div class="place-card">
                <span>전기차 충전소</span>
                <a href="${pageContext.request.contextPath}/evCharging.jsp" class="more-btn">장소 더보기</a>
            </div>
            <div class="place-card">
                <span>주유소</span>
                <a href="${pageContext.request.contextPath}/gasStation.jsp" class="more-btn">장소 더보기</a>
            </div>
        </div>

        <!-- 나의 리뷰 관리 섹션 -->
        <h4>나의 리뷰관리</h4>
        <div class="review-management">
            <div class="review-card">
                <span>주차장</span>
                <a href="${pageContext.request.contextPath}/editParkingReview.jsp" class="edit-btn">리뷰 수정</a>
            </div>
            <div class="review-card">
                <span>전기차 충전소</span>
                <a href="${pageContext.request.contextPath}/editEvChargingReview.jsp" class="edit-btn">리뷰 수정</a>
            </div>
            <div class="review-card">
                <span>주유소</span>
                <a href="${pageContext.request.contextPath}/editGasStationReview.jsp" class="edit-btn">리뷰 수정</a>
            </div>
        </div>
    </div>
</div>

<!-- 푸터 -->
<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />
</body>
</html>