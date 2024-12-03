<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!--<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css?ver=1.0">  -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<title>header</title>
</head>
<body>
<header>

<div class="header">
  <!-- 로고 영역 -->
  <div class="logo">
    <a href="${pageContext.request.contextPath}/">CAR PLANET</a>
  </div>
  
  <!-- 사용자 메뉴 영역 -->
<c:choose>
  <c:when test="${not empty user}">
    <!-- 로그인 성공 시, 마이페이지와 로그아웃 표시 -->
 <div class="header-container">
      <div class="member">
         <span class="userprofile">${not empty user.carNickname ? user.carNickname : "유저"}님 환영합니다!</span>
        <c:choose>
        	<c:when test="${user.carStatus == 3}">
       	        <button class="admin-btn" onclick="location.href='./Admin/admin.do'">
		        	<span>관리자 페이지</span>
		        </button>
		    </c:when>
		<c:otherwise>
	        <button class="mypage-btn" onclick="location.href='./mypage'">
	          <!-- 마이페이지 아이콘 추가 (주석 처리된 부분을 원하면 해제) -->
	          <!--<img src="${pageContext.request.contextPath}/resources/images/mypage-icon.png" alt="마이페이지" class="mypage-icon">-->
	          <span>마이페이지</span>
	        </button>
	    </c:otherwise>
	    </c:choose>
        <!-- 로그아웃을 링크로 변경 -->
        <span><a href="#" id="logout">로그아웃</a></span>
      </div>
    </div>
  </c:when>
  <c:otherwise>
    <!-- 로그인 실패 -->
    <div class="user-menu">
      <span><a href="${pageContext.request.contextPath}/Introduction">회사소개</a></span>
      <span><a href="${pageContext.request.contextPath}/Auth/Login.do">로그인</a></span>
    </div>
  </c:otherwise>
</c:choose>

</div>

</header>
   
<script>


  // 로그아웃 버튼 클릭 이벤트
  $("#logout").on("click", function (e) {
    e.preventDefault(); // 기본 동작(링크 이동) 방지
    const confirmation = confirm("정말 로그아웃 하시겠습니까?");
    if (confirmation) {
      // 사용자가 '확인'을 누르면 로그아웃 요청 전송
      $.ajax({
        url: "/CarPlanet/Auth/logout.do", // 서버 로그아웃 URL
        url: "/CarPlanet/Auth/logout.do", // 서버 로그아웃 URL
        type: "GET", // 로그아웃 요청 방식
        success: function (response) {
          alert("로그아웃되었습니다.");
          window.location.href = "/CarPlanet/"; // 메인 페이지로 이동
        },
        error: function (xhr, status, error) {
          console.error("로그아웃 요청 중 오류 발생:", error);
          alert("로그아웃에 실패했습니다.");
        },
      });
    } else {
      // 사용자가 '취소'를 누르면 아무 동작도 하지 않음
      console.log("사용자가 로그아웃을 취소했습니다.");
    }
  });
</script>


</body>
</html>