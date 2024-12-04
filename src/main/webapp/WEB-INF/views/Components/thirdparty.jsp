<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="ko">
<head>

	<link href="${pageContext.request.contextPath}/resources/css/header.css" rel="stylesheet" type="text/css">
  	<link href="${pageContext.request.contextPath}/resources/css/footer.css" rel="stylesheet" type="text/css">
  	<link href="${pageContext.request.contextPath}/resources/css/clause.css" rel="stylesheet" type="text/css">

<meta charset="UTF-8">
<title>개인정보 제3자 제공 동의</title>
</head>
<body>
	<!-- header -->
	<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />
  
  <div class="clause">
  
  	<div class="introimg"
		style="background-image:url('${pageContext.request.contextPath}/resources/images/clausemain.jpg');">
		<h2>CarPlanet 약관</h2>
		<h1>개인정보 제3자 제공 동의</h1>
	</div>
	
	<!-- 네비바 부분 -->
    <div class="c_section-container">
      <ul class="c_navbar">
        <li class="c_nav-item"><a href="${pageContext.request.contextPath}/clause" target="_blank">이용약관</a></li>
        <li class="c_nav-item"><a href="${pageContext.request.contextPath}/privacy" target="_blank" >개인정보 처리방침</a></li>
        <li class="c_nav-item"><a href="${pageContext.request.contextPath}/thirdparty" target="_blank">개인정보 제3자 제공 동의</a></li>
        <li class="c_nav-item"><a href="${pageContext.request.contextPath}/marketing" target="_blank">광고성 정보 수신동의</a></li>
        <li class="c_nav-item"><a href="${pageContext.request.contextPath}/copyright" target="_blank">저작권 보호 정책</a></li>
      </ul>
  	</div>
  
  <div class="third-party_text">
  1. 회사는 이용자의 개인정보를 본 처리방침 제2조에서 고지한 범위 내에서 사용하며, 이용자의 사전 동의 없이는 동 범위를 초과하여 이용하거나, 원칙적으로 이용자의 개인정보를 외부에 제공하지 않습니다. 단, 개인정보 보호법 제17조 및 제18조 등 법률의 특별한 규정에 해당하는 경우에만 개인정보를 제3자에게 제공합니다. 
  <br><br>
  2. 이용자는 개인정보의 제3자 제공에 대하여 동의하지 않을 수 있고, 언제든지 제3자 제공 동의를 철회할 수 있습니다. 동의를 거부하는 경우에도 일부 서비스는 이용할 수 있으나, 제3자 제공에 기반한 관련 서비스의 이용/제공이 제한될 수 있습니다.
  <br><br>
  
  </div>
 
  
  
  </div>
  








</body>
</html>