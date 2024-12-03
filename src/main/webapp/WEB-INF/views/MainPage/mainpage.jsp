<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CAR PLANET</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mainpage.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            transition: transform 1s ease-in-out; /* 페이지 이동 애니메이션 */
        }
    </style>
</head>

<body>
    <jsp:include page="/WEB-INF/views/MainPage/header.jsp" />

<!-- 첫 번째 줄 -->
<div class="top-row">
    <!-- 전기차 충전소 -->
    <div class="ev-charging-container">
<a href="${pageContext.request.contextPath}/evmap">
    <img src="${pageContext.request.contextPath}/resources/images/0001.jpg" alt="전기차 충전소" class="ev-charging-img">
    <div class="ev-charging-text">
        <h3>EV Charging</h3>
        <p>전기차 충전소</p>
    </div>
</a>

    </div>

    <!-- 주유소 -->
    <div class="gas-station-container">
        <a href="${pageContext.request.contextPath}/Gas/Gasmap.do">
            <img src="${pageContext.request.contextPath}/resources/images/0002.jpg" alt="주유소" class="gas-station-img">
            <div class="gas-station-text">
                <h3>Gas Station</h3>
                <p>주유소</p>
            </div>
        </a>
    </div>
</div>

<div class="container_icon">
    <!-- 첫 번째 텍스트 -->
    <h1 class="central-text central-text-1">전국의 충전소 <br> 주유소 주차장</h1>
    <!-- 두 번째 텍스트 -->
    <h1 class="central-text central-text-2">가격을<br> 알아보세요</h1>
      <!-- 세 번째 텍스트 -->
    <h1 class="central-text central-text-3">
        <span class="falling-text">C</span>
        <span class="falling-text">A</span>
        <span class="falling-text">R</span>
    </h1>
    <!-- 네 번째 텍스트 -->
    <h1 class="central-text central-text-4">
        <span class="falling-text">P</span>
        <span class="falling-text">L</span>
        <span class="falling-text">A</span>
        <span class="falling-text">N</span>
        <span class="falling-text">E</span>
        <span class="falling-text">T</span>
    </h1>
    <!-- 다섯 번째 텍스트 -->
    <h1 class="central-text central-text-5">CAR<br> PLANET</h1>
</div>


<!-- 두 번째 줄 -->
<div class="bottom-row">
    <!-- 주차장 -->
    <div class="parking-lot-container">
        <a href="${pageContext.request.contextPath}/parkinglot">
            <img src="${pageContext.request.contextPath}/resources/images/주차장3.jpg" alt="주차장" class="parking-lot-img">
            <div class="parking-lot-text">
                <h3>Parking Lot</h3>
                <p>주차장</p>
            </div>
        </a>
    </div>

    <!-- 커뮤니티 -->
    <div class="community-container">
        <a href="${pageContext.request.contextPath}/community/getPostList.do">
            <img src="${pageContext.request.contextPath}/resources/images/0004.jpg" alt="커뮤니티" class="community-img">
            <div class="community-text">
                <h3>Community</h3>
                <p>커뮤니티</p>
            </div>
        </a>
    </div>
</div>

<!-- 화살표 아이콘과 텍스트 -->
<div class="arrow-container" id="arrow-container">
    <span class="arrow-text">오늘의 주유소 가격이 궁금해?</span>
    <div class="arrow-icon" id="arrow-icon">
        <i class="fas fa-arrow-right"></i>
    </div>
</div>


<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />

<script>
    // 오른쪽 화살표 클릭 시 애니메이션 효과와 페이지 이동
    document.querySelector('.arrow-icon').addEventListener('click', function() {
        // 애니메이션 시작: 화면의 오른쪽으로 스크롤
        document.body.style.transition = "transform 0.5s ease-in-out";
        document.body.style.transform = "translateX(-100%)"; // 왼쪽으로 화면을 밀어내는 효과

        // 페이지 이동을 지연시키기 위해 잠시 기다린 후 이동
        setTimeout(function() {
            window.location.href = '${pageContext.request.contextPath}/oil_price'; // 이동할 URL
        }, 500); // 0.6초 지연
    });
    
    $.ajax({
        url: '/CarPlanet/Admin/track-visitor', // 방문자 추적 API 엔드포인트
        type: 'POST', // HTTP 메서드
        contentType: 'application/json', // 데이터 형식
        data: JSON.stringify({
          url: window.location.href, // 현재 페이지 URL
          userAgent: navigator.userAgent // 브라우저 정보
        }),
        success: function (response) {
          console.log('방문자 데이터 전송 성공:');
        },
        error: function (error) {
          console.error('방문자 데이터 전송 실패:', error);
        }
      });
</script>
    
</body>

</html>