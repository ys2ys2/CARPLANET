<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>CAR PLANET</title>
<!-- Swiper CSS 추가 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mainpage.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
    <a href="${pageContext.request.contextPath}/Gas/Gasmap.do" class="menu-item">
        <img src="${pageContext.request.contextPath}/resources/images/gas.png" alt="주유소">
        <span>주유소</span>
    </a>
    <a href="${pageContext.request.contextPath}/parkinglot" class="menu-item">
        <img src="${pageContext.request.contextPath}/resources/images/par.png" alt="주차장">
        <span>주차장</span>
    </a>
    <a href="${pageContext.request.contextPath}/community/getPostList.do" class="menu-item">
        <img src="${pageContext.request.contextPath}/resources/images/Community.png" alt="커뮤니티">
        <span>커뮤니티</span>
    </a>
</div>

<!-- 전국 평균 유가 정보 및 그래프 -->
<div class="price-section">
    <h1 class="section-title">일주일 전국 평균 유가</h1>
    <div class="price-container">
        <!-- 고급휘발유 -->
        <div class="price-box">
            <div class="label">전국평균</div> <!-- 상단 레이블 -->
            <div class="fuel-type">고급휘발유</div> <!-- 유종 이름 -->
            <div class="value" id="premium-gasoline">-</div> <!-- 가격 표시 -->
            <canvas id="premiumGasolineChart" width="300" height="150"></canvas> <!-- 그래프 -->
        </div>

        <!-- 보통휘발유 -->
        <div class="price-box">
            <div class="label">전국평균</div> <!-- 상단 레이블 -->
            <div class="fuel-type">보통휘발유</div> <!-- 유종 이름 -->
            <div class="value" id="regular-gasoline">-</div> <!-- 가격 표시 -->
            <canvas id="regularGasolineChart" width="300" height="150"></canvas> <!-- 그래프 -->
        </div>

        <!-- 자동차경유 -->
        <div class="price-box">
            <div class="label">전국평균</div> <!-- 상단 레이블 -->
            <div class="fuel-type">자동차경유</div> <!-- 유종 이름 -->
            <div class="value" id="diesel">-</div> <!-- 가격 표시 -->
            <canvas id="dieselChart" width="300" height="150"></canvas> <!-- 그래프 -->
        </div>
    </div>
</div>




<!-- 그래프를 표시할 캔버스 
<canvas id="myChart" width="300" height="100"></canvas>-->

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>

  

<!-- 콘텐츠 전환 영역 (주차장 슬라이더) -->
<div class="container parking-slider" style="position: relative;">
    <div class="text-content">
        <p id="title" class="title-text">주변 주차할 공간이 없다고요?</p>
        <h2 id="subtitle" class="subtitle-text">주차장과 주차장의<br> 후기가 궁금하면</h2>
        <a id="button" href="#" class="btn">자세히 보기</a>
    </div>
    <div class="image-content">
        <div id="searchText" class="search-text">
        </div>
        <img id="image" alt="주차장 이미지">
    </div>
    <!-- 화살표 컨트롤 -->
    <div class="arrows">
        <span onclick="prevContent()">&#9664;</span>
        <span onclick="nextContent()">&#9654;</span>
    </div>
</div>

<script>
//데이터를 가져오는 함수
async function fetchData() {
    try {
        const response = await fetch('./getRecentPrice');
        const data = await response.json();

        // API 응답에서 필요한 데이터 추출
        const premiumGasoline = data.RESULT.OIL.find(oil => oil.PRODCD === "B034").PRICE; // 고급휘발유
        const regularGasoline = data.RESULT.OIL.find(oil => oil.PRODCD === "B027").PRICE; // 보통휘발유
        const diesel = data.RESULT.OIL.find(oil => oil.PRODCD === "D047").PRICE;         // 자동차경유

        // 가격 정보 업데이트
        document.getElementById('premium-gasoline').textContent = premiumGasoline + " 원";
        document.getElementById('regular-gasoline').textContent = regularGasoline + " 원";
        document.getElementById('diesel').textContent = diesel + " 원";

        // 그래프 생성
        createChart('premiumGasolineChart', '고급휘발유', premiumGasoline);
        createChart('regularGasolineChart', '보통휘발유', regularGasoline);
        createChart('dieselChart', '자동차경유', diesel);

    } catch (error) {
        console.error('데이터 가져오기 실패:', error);
    }
}

// 그래프 생성 함수
function createChart(canvasId, label, price) {
    const ctx = document.getElementById(canvasId).getContext('2d');
    new Chart(ctx, {
        type: 'line', // 선 그래프
        data: {
            labels: [label], // X축 라벨
            datasets: [{
                label: '전국 평균 유가 (원)', // 데이터 설명
                data: [price], // Y축 데이터
                borderColor: 'rgba(75, 192, 192, 1)', // 선 색상
                backgroundColor: 'rgba(75, 192, 192, 0.2)', // 선 아래 채우기 색상
                borderWidth: 2 // 선 굵기
            }]
        },
        options: {
            responsive: true, // 반응형 설정
            plugins: {
                legend: {
                    display: true, // 범례 표시
                }
            },
            scales: {
                y: {
                    beginAtZero: false // Y축 0부터 시작하지 않음
                }
            }
        }
    });
}

// 데이터 가져오기 및 그래프 초기화
fetchData();


    
//유가 API
	$(document).ready(function() {
    $.ajax({
        url: './getRecentPrice',  // 서버에서 제공하는 엔드포인트
        type: 'GET',             // GET 요청
        dataType: 'json',         // 응답을 XML 형식으로 받음
        success: function(response) {
            // 응답을 성공적으로 받았을 때 처리
            // 예를 들어, XML 데이터를 출력하거나 처리하는 로직
            console.log(response);  // 결과를 화면에 출력 (XML 내용)
        },
        error: function(xhr, status, error) {
            // 요청에 실패한 경우 처리
            console.error('Ajax 요청 실패:', status, error);
            $('#result').html('API 호출에 실패했습니다.');
        }
    });
	});




//주차장 부분 슬라이드
    let currentIndex = 0;
    const contentData = [
        {
            title: "주변 주차할 공간이 없다고요?",
            subtitle: "주차장과 주차장의<br> 후기가 궁금하면",
            buttonText: "자세히 보기",
            buttonLink: "${pageContext.request.contextPath}/parkinglot",
            imgSrc: "${pageContext.request.contextPath}/resources/images/003.png"
        },
        {
            title: "주변 주유소를 찾고 있다고요?",
            subtitle: "주유소와 가격<br> 후기가 궁금하면",
            buttonText: "자세히 보기",
            buttonLink:  "${pageContext.request.contextPath}/Gas/Gasmap.do",
            imgSrc: "${pageContext.request.contextPath}/resources/images/002.png"
        },
        {
            title: "주변 충전소를 찾고 있다고요?",
            subtitle: "전기차 충전소의 가격<br> 후기가 궁금하면",
            buttonText: "자세히 보기",
            buttonLink:  "${pageContext.request.contextPath}/evmap",
            imgSrc: "${pageContext.request.contextPath}/resources/images/001.png"
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
        <p>휘발유 경유<br> LPG의 가격을</p>
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

