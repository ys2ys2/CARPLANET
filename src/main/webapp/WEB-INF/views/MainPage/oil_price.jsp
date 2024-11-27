<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CAR PLANET</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=66fe3ec238628b8043889a81592616b2&libraries=services"></script>

    <!-- Swiper CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/oil_price.css">
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>

<body>

    <!-- 헤더 -->
    <jsp:include page="/WEB-INF/views/MainPage/header.jsp" />

<!-- 왼쪽 화살표 아이콘 -->
<div class="arrow-icon" id="arrow-icon">
    <i class="fas fa-arrow-left"></i> <!-- 'fa-arrow-right'에서 'fa-arrow-left'로 변경 -->
</div>

    <!-- 전국 평균 유가 정보 및 그래프 -->
    <div class="price-section">
        <h1 class="section-title">일주일 전국 평균 유가</h1>
        <div class="price-container">
            <!-- 고급휘발유 -->
            <div class="price-box">
                <div class="label">전국평균</div>
                <div class="fuel-type">고급휘발유</div>
                <div class="value" id="premium-gasoline">-</div>
                <canvas id="premiumGasolineChart" width="300" height="150"></canvas>
            </div>

            <!-- 보통휘발유 -->
            <div class="price-box">
                <div class="label">전국평균</div>
                <div class="fuel-type">보통휘발유</div>
                <div class="value" id="regular-gasoline">-</div>
                <canvas id="regularGasolineChart" width="300" height="150"></canvas>
            </div>

            <!-- 자동차경유 -->
            <div class="price-box">
                <div class="label">전국평균</div>
                <div class="fuel-type">자동차경유</div>
                <div class="value" id="diesel">-</div>
                <canvas id="dieselChart" width="300" height="150"></canvas>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>

    <script>
        // 데이터를 가져오는 함수
        async function fetchData() {
            try {
                const response = await fetch('./getRecentPrice');
                const data = await response.json();

                // API 응답에서 지난 7일의 데이터를 추출
                const premiumGasolinePrices = data.RESULT.OIL.filter(oil => oil.PRODCD === "B034")
                    .map(oil => oil.PRICE); // 고급휘발유의 7일 가격
                const regularGasolinePrices = data.RESULT.OIL.filter(oil => oil.PRODCD === "B027")
                    .map(oil => oil.PRICE); // 보통휘발유의 7일 가격
                const dieselPrices = data.RESULT.OIL.filter(oil => oil.PRODCD === "D047")
                    .map(oil => oil.PRICE); // 자동차경유의 7일 가격

                // 가격 정보 업데이트
                document.getElementById('premium-gasoline').textContent = premiumGasolinePrices[0] + " 원";
                document.getElementById('regular-gasoline').textContent = regularGasolinePrices[0] + " 원";
                document.getElementById('diesel').textContent = dieselPrices[0] + " 원";

                // 그래프 생성
                createChart('premiumGasolineChart', '고급휘발유', premiumGasolinePrices);
                createChart('regularGasolineChart', '보통휘발유', regularGasolinePrices);
                createChart('dieselChart', '자동차경유', dieselPrices);

            } catch (error) {
                console.error('데이터 가져오기 실패:', error);
            }
        }
        
        $(document).ready(function() {
    		const areaMapping = {
    	            "서울": "01",
    	            "경기": "02",
    	            "강원": "03",
    	            "충북": "04",
    	            "충남": "05",
    	            "전북": "06",
    	            "전남": "07",
    	            "경북": "08",
    	            "경남": "09",
    	            "부산": "10",
    	            "제주": "11",
    	            "대구": "14",
    	            "인천": "15",
    	            "광주": "16",
    	            "대전": "17",
    	            "울산": "18",
    	            "세종": "19"
    	        };
    		
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
    	
    	
    	if (navigator.geolocation) {
    	    console.log("위치 정보를 요청 중...");
    	    navigator.geolocation.getCurrentPosition(
    	        function (position) {
    	            const latitude = position.coords.latitude; // 위도
    	            const longitude = position.coords.longitude; // 경도
    	            console.log("현재 위치:", latitude, longitude);

    	            // 카카오 맵 Geocoder 객체 생성
    	            const geocoder = new kakao.maps.services.Geocoder();

    	            // 좌표 -> 주소 변환 요청
    	            const coord = new kakao.maps.LatLng(latitude, longitude);
    	            const callback = function (result, status) {
    	                if (status === kakao.maps.services.Status.OK) {
    	                    const regionName = result[0].address.region_1depth_name; // 지역 이름
    	                    const areaCode = areaMapping[regionName]; // 지역 이름을 코드로 변환
    	                    console.log("지역 코드:", areaCode);

    	                    if (areaCode) {
    	                        // Ajax 요청
    	                        $.ajax({
    	                            url: './getlowPrices',
    	                            type: 'GET',
    	                            data: { areaCode: areaCode }, // areaCode를 파라미터로 전달
    	                            datatype:'json',
    	                            success: function (response) {
    	                                console.log("서버 응답:", response); // 서버 응답 처리
    	                            },
    	                            error: function (xhr, status, error) {
    	                                console.error("요청 실패:", error); // 에러 처리
    	                            }
    	                        });
    	                    } else {
    	                        console.error("지역 코드가 없습니다.");
    	                    }
    	                } else {
    	                    console.error("주소 변환 실패:", status);
    	                }
    	            };

    	            geocoder.coord2Address(coord.getLng(), coord.getLat(), callback);
    	        },
    	        function (error) {
    	            console.error("위치 정보를 가져오지 못했습니다:", error.message);
    	        }
    	    );
    	} else {
    	    console.error("이 브라우저는 Geolocation API를 지원하지 않습니다.");
    	}
        });

        // 그래프 생성 함수
        function createChart(canvasId, label, prices) {
            const ctx = document.getElementById(canvasId).getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: Array(prices.length).fill(''),
                    datasets: [{
                        label: '전국 평균 유가 (원)',
                        data: prices,
                        borderColor: 'rgba(75, 192, 192, 1)',
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            display: true
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: false
                        },
                        x: {
                            ticks: {
                                display: false
                            }
                        }
                    }
                }
            });
        }

     // 데이터 가져오기 및 그래프 초기화
        fetchData();

        // 왼쪽 화살표 클릭 시 애니메이션 효과와 페이지 이동
        document.querySelector('.arrow-icon').addEventListener('click', function() {
            // 애니메이션 시작: 화면을 왼쪽으로 밀어내는 효과
            document.body.style.transition = "transform 0.5s ease-in-out";
            document.body.style.transform = "translateX(-100%)"; // 왼쪽으로 화면을 밀어내는 효과

            // 페이지 이동을 지연시키기 위해 잠시 기다린 후 이동
            setTimeout(function() {
                window.location.href = '${pageContext.request.contextPath}/'; // 이동할 URL
            }, 500); // 0.5초 지연
        });
    </script>

    <!-- Swiper JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>

    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
    <jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />

</body>

</html>
