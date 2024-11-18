<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!--<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css?ver=1.0">  -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
<title>header</title>
</head>
<body>
<header>
  <div class="logo">
    <a href="${pageContext.request.contextPath}/HomePage/mainpage">CAR PLANET</a>
  </div>
  
  <c:choose>
  <c:when test="${not empty user}">
    <!-- 로그인 성공 시, 마이페이지와 로그아웃 표시 -->
    <div class="header-container">
      <div class="member">
        <span class="userprofile">${user.carId}님 환영합니다!</span>
           <span><a href="${pageContext.request.contextPath}/mypage">마이페이지</a></span>
        <!-- 로그아웃을 링크로 변경 -->
        <span><a href="${pageContext.request.contextPath}/Member/logout">로그아웃</a></span>
      </div>
    </div>
  </c:when>
  <c:otherwise>
    <!-- 로그인 실패 시, 로그인과 회원가입 표시 -->
    <div class="header-container">
      <div class="menu">
        <span><a href="${pageContext.request.contextPath}/company/about">회사소개</a></span>
        <span><a href="${pageContext.request.contextPath}/Auth/Login.do">로그인</a></span>
      </div>
    </div>
  </c:otherwise>
</c:choose>


</header>

</body>
</html>
