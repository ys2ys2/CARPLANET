<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer_right.css">
</head>
<body>

<!-- 오른쪽 고정 메뉴 -->
<div class="right-fixed-menu">
  <div class="menu-item">
    <a href="${pageContext.request.contextPath}/evmap">
      <img src="${pageContext.request.contextPath}/resources/images/ele.png" alt="전기차 충전소"><br>전기차
    </a>
  </div>
  <div class="menu-item">
    <a href="${pageContext.request.contextPath}/Gas/Gasmap.do">
      <img src="${pageContext.request.contextPath}/resources/images/gas.png" alt="주유소"><br>주유소
    </a>
  </div>
  <div class="menu-item">
    <a href="${pageContext.request.contextPath}/parkinglot">
      <img src="${pageContext.request.contextPath}/resources/images/par.png" alt="주차장"><br>주차장
    </a>
  </div>
  <div class="menu-item">
    <a href="${pageContext.request.contextPath}/community/getPostList.do">
      <img src="${pageContext.request.contextPath}/resources/images/Community.png" alt="커뮤니티"><br>커뮤니티
    </a>
  </div>
</div>


</body>
</html>
