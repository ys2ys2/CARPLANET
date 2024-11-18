<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<title>CAR PLANET</title>
<!-- Swiper CSS 추가 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mainpage.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> <!-- Chart.js 불러오기 -->
  <!-- <script src="${pageContext.request.contextPath}/resources/js/Opinetoil.js"></script> -->
  
   <!--  <style>
        .price-container {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
        }
        .price-box {
            text-align: center;
        }
        .label {
            font-weight: bold;
        }
        .value {
            font-size: 1.2em;
            color: #333;
        }
    </style>--> 
<title>CAR PLANET</title>
<!-- Swiper CSS 추가 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mainpage.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> <!-- Chart.js 불러오기 -->
  <!-- <script src="${pageContext.request.contextPath}/resources/js/Opinetoil.js"></script> -->
  
   <!--  <style>
        .price-container {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
        }
        .price-box {
            text-align: center;
        }
        .label {
            font-weight: bold;
        }
        .value {
            font-size: 1.2em;
            color: #333;
        }
    </style>--> 
</head>
<body>

<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />

<!-- 메뉴 아이콘 및 유가 정보 박스 -->
<div class="menu-container">
    <a href="${pageContext.request.contextPath}/evmap" class="menu-item">
        <img src="${pageContext.request.contextPath}/resources/images/ele.png" alt="전기차 충전소">
        <span>전기차 충전소</span>
    </a>
    <a href="${pageContext.request.contextPath}/gasStation.jsp" class="menu-item">
        <img src="${pageContext.request.contextPath}/resources/images/gas.png" alt="주유소">
        <span>주유소</span>
    </a>
    <a href="${pageContext.request.contextPath}/parkinglot" class="menu-item">
        <img src="${pageContext.request.contextPath}/resources/images/par.png" alt="주차장">
        <span>주차장</span>
    </a>
    <a href="${pageContext.request.contextPath}/repair.jsp" class="menu-item">
        <img src="${pageContext.request.contextPath}/resources/images/rep.png" alt="정비소">
        <span>정비소</span>
    </a>
    <a href="${pageContext.request.contextPath}/community.jsp" class="menu-item">
        <img src="${pageContext.request.contextPath}/resources/images/Community.png" alt="커뮤니티">
        <span>커뮤니티</span>
    </a>
</div>

<!-- 전국 평균 유가 정보 및 그래프 -->
<div class="price-container">
    <div class="price-box">
        <div class="label">전국평균</div>
        <div class="value" id="premium-gasoline">고급휘발유</div>
    </div>
    <div class="price-box">
        <div class="label">전국평균</div>
        <div class="value" id="regular-gasoline">보통휘발유</div>
    </div>
    <div class="price-box">
        <div class="label">전국평균</div>
        <div class="value" id="diesel">자동차경유</div>
    </div>
</div>
<!--  <canvas id="priceChart" width="400" height="200"></canvas> <!-- 그래프를 그릴 캔버스 -->


<!-- 콘텐츠 전환 영역 (주차장 슬라이더) -->
<div class="container parking-slider">
    <div class="text-content">
        <p id="title" class="title-text">주변 주차할 공간이 없다고요?</p>
        <h2 id="subtitle" class="subtitle-text">주차장과 주차장의<br> 후기가 궁금하면</h2>
        <a id="button" href="#" class="btn">자세히 보기</a>
        <div class="arrows">
            <span onclick="prevContent()">&#9664;</span>
            <span onclick="nextContent()">&#9654;</span>
        </div>
    </div>
    <div class="image-content">
        <div id="searchText" class="search-text">주차장 찾기</div>
        <img id="image" alt="주차장 이미지">
    </div>
</div>

<script>
    let currentIndex = 0;
    const contentData = [
        {
            title: "주변 주차할 공간이 없다고요?",
            subtitle: "주차장과 주차장의<br> 후기가 궁금하면",
            buttonText: "자세히 보기",
            buttonLink: "${pageContext.request.contextPath}/parking",
            searchText: "주차장 찾기",
            imgSrc: "${pageContext.request.contextPath}/resources/images/00.png"
        },
        {
            title: "주변 주유소를 찾고 있다고요?",
            subtitle: "주유소와 가격<br> 후기가 궁금하면",
            buttonText: "자세히 보기",
            buttonLink: "${pageContext.request.contextPath}/gasStation",
            searchText: "주유소 찾기",
            imgSrc: "${pageContext.request.contextPath}/resources/images/00.png"
        },
        {
            title: "주변 충전소를 찾고 있다고요?",
            subtitle: "전기차 충전소의 가격<br> 후기가 궁금하면",
            buttonText: "자세히 보기",
            buttonLink: "${pageContext.request.contextPath}/electricCharging",
            searchText: "전기차 충전소 찾기",
            imgSrc: "${pageContext.request.contextPath}/resources/images/00.png"
        }
    ];

    function updateContent() {
        const data = contentData[currentIndex];
        document.getElementById("title").innerText = data.title;
        document.getElementById("subtitle").innerHTML = data.subtitle;
        document.getElementById("button").innerText = data.buttonText;
        document.getElementById("button").href = data.buttonLink;
        document.getElementById("searchText").innerText = data.searchText; // 검색 텍스트 업데이트
        document.getElementById("image").src = data.imgSrc;
    }

    function nextContent() {
        currentIndex = (currentIndex + 1) % contentData.length;
        updateContent();
    }

    function prevContent() {
        currentIndex = (currentIndex - 1 + contentData.length) % contentData.length;
        updateContent();
    }

    window.onload = updateContent;
</script>


<!-- 슬라이더 컨테이너 -->
<div class="slider-container" style="display: flex; align-items: center; max-width: 900px;">
    <!-- 고정된 텍스트 영역 -->
    <div class="text-content1" style="flex: 1; padding: 20px;">
        <h1>계속 변동이 되는</h1>
        <p>휘발유 경유 LPG의 가격을</p>
        <p>실시간으로 확인을 해보세요.</p>
    </div>

    <!-- 카드 슬라이드 영역 -->
    <div class="swiper-container mySwiper card-slider" style="flex: 2; overflow: hidden; padding-left: 20px;">
        <div class="swiper-wrapper" style="display: flex;">
            <!-- 첫 번째 슬라이드 -->
            <div class="swiper-slide card-container" style="flex-shrink: 0; display: flex; gap: 20px;">
                <div class="card usage-history-card">
                    <h3>용도 이력</h3>
                    <p>사용기간: 2019년 10월 1일 ~ 2022년 12월 3일</p>
                    <p>이력구분: 대여용(렌터카) 이력</p>
                </div>
            </div>

            <!-- 두 번째 슬라이드 -->
            <div class="swiper-slide card-container" style="flex-shrink: 0; display: flex; gap: 20px;">
                <div class="card low-emission-card">
                    <h3>저공해차 인증</h3>
                    <p>제작사: BMW코리아㈜</p>
                    <p>차명: BMW 430i Convertible</p>
                </div>
                <div class="card insurance-status-card">
                    <h3>자동차 보험 미가입</h3>
                    <p>보험 미가입 기간: 2019년 10월 ~ 2022년 12월</p>
                </div>
            </div>

            <!-- 세 번째 슬라이드 -->
            <div class="swiper-slide card-container" style="flex-shrink: 0; display: flex; gap: 20px;">
                <div class="card inspection-card">
                    <h3>자동차 검사</h3>
                    <p>검사일자: 2022년 8월 16일</p>
                    <p>주행거리: 24,500km</p>
                </div>
                <div class="card mileage-change-card">
                    <h3>주행거리 변경</h3>
                    <p>변경일자: 2020년 8월 2일</p>
                    <p>주행거리: 46,120km</p>
                </div>
            </div>
        </div> <!-- swiper-wrapper 끝 -->
    </div> <!-- swiper-container 끝 -->
</div> <!-- slider-container 끝 -->


<!-- Swiper JavaScript 추가 -->
<script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>

<!-- Swiper 초기화 스크립트 -->
<script>
const swiper = new Swiper('.mySwiper', {
	  slidesPerView: 3, // 한 화면에 3개의 카드 보여줌
	  spaceBetween: 200, // 카드 간 간격
	  loop: true, // 무한 루프
	  autoplay: {
	    delay: 3000, // 3초마다 반복
	    disableOnInteraction: false,
	  },
	  centeredSlides: false, // 카드가 왼쪽에서 오른쪽으로 슬라이드 되도록 설정
	});

</script>



<!-- 메인 스크립트 -->

<!-- 푸터 -->
<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />

</body>
</html>

