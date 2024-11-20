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
            </div>
        </div>

        
<!-- 푸터 -->
<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />
</body>
</html>
