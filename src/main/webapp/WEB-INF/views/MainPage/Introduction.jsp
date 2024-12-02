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
    <div class="container">
        <!-- Left Section -->
        <div class="left-section">
            <h5>우리지역 주유소 TOP10 </h5>
            <h1>신뢰할 수 있는<br>데이터를 위한 공공데이터 사용!</h1>
            <p>합리적인 비용 부담 없는 선택</p>
            <div class="link-button">
                <span>CAR PLANET</span>
                <div class="circle"></div>
                <div class="arrow"></div>
            </div>
        </div>
        
        <!-- Right Section -->
        <div class="right-section">
            <div class="card member">
                <h4>정확한 위치 기반의 정보를 제공</h4>
                <div class="price-group">
                    <div><span>공공데이터를 이용하여, 현제 위치를 중점으로 가까운주차장,충전소,주유소 정보를 제공</span></div>
                </div>
            </div>
            <div class="card non-member">
                <h4>커뮤니티 활성화로 사용자간 정보 교환</h4>
                <div class="price-group">
                    <span>커뮤니티를 통해 사용자들의 추천과 신뢰도 높은 정보 교환 가능</span>
                </div>
            </div>
        </div>
    </div>
</section>

    
    <!-- APP 섹션 -->
<section id="app-section" class="section">
    <div class="app-container">
        <!-- 텍스트 영역 -->
        <div class="text-container">
            <h1>빠르고 편리한 주차장<br>충전소, 주유소 찾기</h1>
            <p>
                빠르고 간편하게 주차장, 전기차 충전소,<br>
                지역별로 확인 가능한 저렴한 주유소 찾기,<br>
                CAR PLANET 하나로 편리하게 이용하세요.
            </p>
            <h3>CAR PLANET</h3>
        </div>

        <!-- 슬라이더와 검정 박스 -->
        <div class="slider-container">
            <div class="black-box">
            	<div class="phoneimg">
               		<img src="${pageContext.request.contextPath}/resources/images/mobile_app_cover.png" alt="app">
               	</div>
                <div class="slider">
                    <div class="slide"><img src="${pageContext.request.contextPath}/resources/images/0101.png" alt="Slide 1"></div>
                    <div class="slide"><img src="${pageContext.request.contextPath}/resources/images/0202.png" alt="Slide 2"></div>
                    <div class="slide"><img src="${pageContext.request.contextPath}/resources/images/0303.png" alt="Slide 3"></div>
                    <div class="slide"><img src="${pageContext.request.contextPath}/resources/images/0404.png" alt="Slide 4"></div>
                    <div class="slide"><img src="${pageContext.request.contextPath}/resources/images/0505.png" alt="Slide 5"></div>
                    <div class="slide"><img src="${pageContext.request.contextPath}/resources/images/0606.png" alt="Slide 6"></div>
                </div>
            </div>
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
        setInterval(moveToNextSlide, 2000); // 5초마다 이동
    });
    
    
    
    //이동 js부분
    function scrollToNextSection() {
    const nextSection = document.querySelector('#app-section'); // 이동할 섹션 ID
    if (nextSection) {
        nextSection.scrollIntoView({ behavior: 'smooth' });
    }
}

  //섹션 스크롤 슬라이드
    document.addEventListener("DOMContentLoaded", function () {
        const sections = document.querySelectorAll(".section"); // 모든 섹션 선택
        let currentIndex = 0; // 현재 활성화된 섹션 인덱스
        let isAnimating = false; // 현재 애니메이션 중인지 확인하는 플래그

        // 기본 스크롤 방지
        function preventDefaultScroll(e) {
            e.preventDefault(); // 기본 스크롤 동작 방지
        }

        // 섹션으로 이동하는 함수
        function scrollToSection(index) {
            if (isAnimating) return; // 애니메이션 중이면 무시
            isAnimating = true; // 애니메이션 중으로 설정

            // 해당 섹션으로 부드럽게 스크롤
            sections[index].scrollIntoView({
                behavior: "smooth",
                block: "start",
            });

            // 애니메이션 완료 후 플래그 초기화
            setTimeout(() => {
                isAnimating = false; // 애니메이션 플래그 해제
            }, 700); // 애니메이션 지속 시간(0.7초)
        }

        // 휠 이벤트 리스너 등록
        window.addEventListener("wheel", function (e) {
            e.preventDefault(); // 기본 스크롤 동작 방지
            if (isAnimating) return; // 애니메이션 중이면 이벤트 무시

            // 휠 방향에 따라 인덱스 변경
            if (e.deltaY > 0) {
                // 아래로 스크롤
                const nextIndex = Math.min(currentIndex + 1, sections.length - 1);
                if (nextIndex !== currentIndex) {
                    currentIndex = nextIndex;
                    scrollToSection(currentIndex);
                }
            } else {
                // 위로 스크롤
                const prevIndex = Math.max(currentIndex - 1, 0);
                if (prevIndex !== currentIndex) {
                    currentIndex = prevIndex;
                    scrollToSection(currentIndex);
                }
            }
        });

    });

    

    </script>

</body>

</html>


