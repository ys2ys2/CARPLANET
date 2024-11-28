<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CAR PLANET</title>
    <!-- Swiper CSS 추가 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/Introduction.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
    <jsp:include page="/WEB-INF/views/MainPage/header2.jsp" />
    
<!-- 전체 컨테이너 -->
<div class="main-container">

    <!-- CHAEVI ZONE 섹션 -->
    <section id="chaevi-zone" class="section" style="background-image: url('${pageContext.request.contextPath}/resources/images/50.png');">
        <div class="content-left">
            <h1 class="zone-title">CAR PLANET</h1>
            <p class="zone-description">
                신뢰할 수 있는 데이터로 전기차 충전, 주유소, 주차장의 정보를 제공합니다.
            </p>
            <button class="cta-button" onclick="scrollToNextSection()">
                정확한 목적지 정보 제공 
            </button>
        </div>

        <!-- 박스 레이아웃 -->
        <div class="box-container">
            <div class="box">
                <h3 class="box-title">운전자 편의성 향상</h3>
                <p class="box-description">주차장 위치, 실시간 주유소 및 전기차 충전소 정보 제공으로 목적지 선택 및 이동이 더욱 편리</p>
            </div>
            <div class="box">
                <h3 class="box-title">환경 운전 문화 조성</h3>
                <p class="box-description">전기차 충전소 정보 제공을 통해, 에코 드라이빙과 같은 친환경적인 운전 문화를 형성</p>
            </div>
            <div class="box">
                <h3 class="box-title">위치 기반 정보 제공</h3>
                <p class="box-description">현재 위치를 중점으로 가까운 주유소, 충전소, 주차장 정보를 제공합니다.</p>
            </div>
        </div>
    </section>

    <!-- PRICE 섹션 -->
    <section id="price-section" class="section bg-white">
        <div class="text-center">
            <h2 class="zone-title">요금제</h2>
            <div class="pricing-grid">
                <div class="pricing-card">
                    <h3 class="pricing-title">기본 요금제</h3>
                    <p class="pricing-price">월 10,000원</p>
                    <ul class="pricing-details">
                        <li>기본 충전</li>
                        <li>24/7 고객 지원</li>
                    </ul>
                    <button class="pricing-button">
                        선택하기
                    </button>
                </div>
            </div>
        </div>
    </section>
    
    
    <!-- APP 섹션 -->
 <section id="app-section" class="section" style="background: #f4f4f4;">

    <div class="app-container">
        <!-- 텍스트 영역 -->
        <div class="slider-container">
             <!-- 검정 네모 박스와 슬라이더 -->
        <div class="black-box"></div>
            <div class="slider">
                <div class="slide"><img src="${pageContext.request.contextPath}/resources/images/0101.png" alt="Slide 1"></div>
                <div class="slide"><img src="${pageContext.request.contextPath}/resources/images/0202.png" alt="Slide 2"></div>
                <div class="slide"><img src="${pageContext.request.contextPath}/resources/images/0303.png" alt="Slide 3"></div>
                <div class="slide"><img src="${pageContext.request.contextPath}/resources/images/0404.png" alt="Slide 4"></div>
            </div>
        </div>
    
        <div class="text-container">
         
            <h1>빠르고 편리한 주차장<br>충전소,주유소 찾기</h1>
            <p>
                빠르고 간편하게 주차장,전기차 충전소,<br>
                지역별로 확인 가능한 저렴한 주유소 찾기,<br>
                CAR PLANET 하나로 편리하게 이용하세요.
            </p>
               <h3>CAR PLANET</h3>
           
        </div>
    </div>

</section>
</div>

    <!-- 메인 스크립트 -->
    <script>
    //슬라이더 왼쪽영역에서 자동으로 슬라이드 설정
    document.addEventListener("DOMContentLoaded", function () {
        const slider = document.querySelector('.slider');
        const slides = document.querySelectorAll('.slide');
        const totalSlides = slides.length;
        let currentIndex = 0;

        // 슬라이드 전환 함수
        function moveToNextSlide() {
            currentIndex = (currentIndex + 1) % totalSlides;
            slider.style.transform = `translateX(-${currentIndex * 100}%)`;
        }

        // 일정 시간마다 슬라이드 이동
        setInterval(moveToNextSlide, 5000); // 5초마다 이동
    });
    
    
    
    //이동 js부분
    function scrollToNextSection() {
    const nextSection = document.querySelector('#app-section'); // 이동할 섹션 ID
    if (nextSection) {
        nextSection.scrollIntoView({ behavior: 'smooth' });
    }
}

    

    </script>

</body>

</html>

