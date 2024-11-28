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
    
    
<!-- 전체 컨테이너 추가 -->
<div class="container">
    <!-- CHAEVI ZONE 섹션 -->
<section id="chaevi-zone" class="section" style="background-image: url('${pageContext.request.contextPath}/resources/images/50.png');">
    <div class="content-left text-left">
        <h1 class="zone-title">CAR PLANET</h1>
        <p class="zone-description">
            신뢰할 수 있는 데이터로 전기차 충전,주유소,주차장의 정보를 제공 합니다.
        </p>
        <button class="cta-button" onclick="scrollToNextSection()">
             정확한 목적지 정보 제공 <span class="arrow"></span>
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
                <p class="box-description">현재 위치를 중점으로 가까운 주유소, 충전소, 주차장 정보 제공</p>
            </div>
        </div>
    </section>

    <!-- APP 섹션 -->
<div class="container">
    <!-- 왼쪽 슬라이더 -->
    <div class="slider-container">
        <div class="slider">
            <!-- Slide 1 -->
            <div class="slide">
                <img src="${pageContext.request.contextPath}/resources/images/0101.png" alt="Slide 1">
            </div>
            <div class="slide">
                <img src="${pageContext.request.contextPath}/resources/images/0202.png" alt="Slide 2">
            </div>
            <div class="slide">
                <img src="${pageContext.request.contextPath}/resources/images/0303.png" alt="Slide 3">
            </div>
            <div class="slide">
                <img src="${pageContext.request.contextPath}/resources/images/0404.png" alt="Slide 4">
            </div>
        </div>
    </div>

    <!-- 오른쪽 텍스트 -->
    <div class="text-container">
        <h3>CHAEVI APP</h3>
        <h1>앱 하나로 빠르고<br>편리한 전기차 충전!</h1>
        <p>
            충전소 찾기와 충전 내역 확인은 기본,<br>
            QR 회원 인증부터 충전소 선택(예약)까지<br>
            채비 앱 하나로 편리하게 이용하세요.
        </p>
        <a href="#" class="more-link">
            CHAEVI APP MORE <span>→</span>
        </a>
    </div>
</div>




    <!-- PRICE 섹션 -->
    <section id="price-section" class="section full-screen bg-white">
        <div class="text-center">
            <h2 class="text-4xl font-bold">요금제</h2>
            <div class="pricing-grid mt-8 grid grid-cols-3 gap-8">
                <div class="pricing-card border rounded-lg shadow-lg p-6">
                    <h3 class="text-2xl font-semibold">기본 요금제</h3>
                    <p class="mt-4 text-lg">월 10,000원</p>
                    <ul class="mt-4 list-disc list-inside">
                        <li>기본 충전</li>
                        <li>24/7 고객 지원</li>
                    </ul>
                    <button class="mt-8 bg-blue-500 hover:bg-blue-600 text-white py-3 px-6 rounded">
                        선택하기
                    </button>
                </div>
                <!-- 추가 요금제 카드는 필요 시 추가 -->
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
    
    

    </script>

</body>

</html>


