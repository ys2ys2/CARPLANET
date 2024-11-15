<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css?ver=1.0">
<title>header</title>
</head>
<body>
  <header>
    <div class="header-container">
      <div class="logo">
        <a href="${pageContext.request.contextPath}/HomePage/mainpage">CAR PLANET</a>
      </div>
      <div class="menu">
        <a href="${pageContext.request.contextPath}/company/about">회사소개</a>
      <a href="${pageContext.request.contextPath}/Auth/Login.do">로그인</a>
      
      </div>
    </div>
  </header>
</body>
</html>