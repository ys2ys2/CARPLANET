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


<div class="profile-section">
    <div class="profile-card">
        <!-- 차량 정보 섹션 -->
        <h4>나의 차량 정보</h4>
        <div class="car-info">
            <img src="${pageContext.request.contextPath}/resources/images/01.jpg" alt="차량 이미지" class="car-image">
            <div class="car-details">
                <div class="car-detail">
                    <div class="label-box">차량 종류</div>
                    <div class="value-box">아우디 A6</div>
                </div>
                <div class="car-detail">
                    <div class="label-box">차량 번호</div>
                    <div class="value-box">123가 1234</div>
                </div>
                <div class="car-detail">
                    <div class="label-box">차량 유종</div>
                    <div class="value-box">디젤</div>
                </div>
            </div>
            <!-- 차량 정보 등록하기 버튼 -->
            <a href="${pageContext.request.contextPath}/registerCarInfo.jsp" class="register-car-info-btn">차량정보 등록하기</a>
        </div>
    </div>
    
    <!-- 나의 커뮤니티 관리 섹션 -->
    <div class="community-section">
        <h4>나의 커뮤니티 관리</h4>
        <div class="community-links">
            <ul>
                <!-- 예시 커뮤니티 글 링크 -->
                <li><a href="https://example.com/community-post-1" target="_blank"></a></li>
                <li><a href="https://example.com/community-post-2" target="_blank"></a></li>
                <li><a href="https://example.com/community-post-3" target="_blank"></a></li>
            </ul>
        </div>
        <!-- 커뮤니티 글 수정 버튼 -->
        <a href="${pageContext.request.contextPath}/communityEditPage.jsp" class="edit-community-posts-btn">커뮤니티 글 수정하기</a>
    </div>
</div>

        
<!-- 푸터 -->
<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />
</body>
</html>
