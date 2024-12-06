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
    
    
<div class="oil-prices-container">
    <!-- 제목 추가 -->
   <h2 class="oil-prices-title">
    <span class="black-text">우리동네 주유소</span> 
    <span class="blue-text">TOP10</span>
</h2>


    <div class="oil-prices">
        <div class="oil-left">
            <!-- 좌측 5개의 주유소 정보 -->
        </div>
        <div class="oil-right">
            <!-- 우측 5개의 주유소 정보 -->
        </div>
    </div>
</div>

<!-- 왼쪽 화살표 아이콘 -->
<div class="arrow-icon" id="arrow-icon">
    <i class="fas fa-arrow-left"></i> <!-- 'fa-arrow-right'에서 'fa-arrow-left'로 변경 -->
</div>

<!-- 전국 평균 유가 정보 및 그래프 -->
<div class="price-section">
  <h1 class="section-title">
    <span class="black-text">일주일</span> 
    <span class="blue-text">평균 유가</span>
</h1>
    
    <div class="price-container">
        <!-- 고급휘발유 -->
        <div class="price-box">
            <div class="fuel-type">고급휘발유</div>
            <div class="value" id="premium-gasoline">-</div>
            <canvas id="premiumGasolineChart" width="300" height="200"></canvas>
            <!-- 날짜 표시 영역 추가 -->
            <div id="premium-dates" class="chart-dates"></div>
        </div>

        <!-- 보통휘발유 -->
        <div class="price-box">
            <div class="fuel-type">보통휘발유</div>
            <div class="value" id="regular-gasoline">-</div>
            <canvas id="regularGasolineChart" width="300" height="200"></canvas>
            <!-- 날짜 표시 영역 추가 -->
            <div id="regular-dates" class="chart-dates"></div>
        </div>

        <!-- 자동차경유 -->
        <div class="price-box">
            <div class="fuel-type">자동차경유</div>
            <div class="value" id="diesel">-</div>
            <canvas id="dieselChart" width="300" height="200"></canvas>
            <!-- 날짜 표시 영역 추가 -->
            <div id="diesel-dates" class="chart-dates"></div>
        </div>
    </div>
</div>


    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>

    <script>
    
    async function loadOilStations(areaCode) {
    	
        try {
            // JSON 데이터를 가져오기
            const response = await fetch('./getOilStations/'+areaCode); // 서버에서 데이터를 제공하는 엔드포인트
            const data = await response.json();

            console.log("data:", data);
            
            // 주유소 데이터 가져오기
            const oilStations = data.RESULT.OIL;

            // 좌측과 우측 컨테이너 가져오기
            const oilLeft = document.querySelector('.oil-left');
            const oilRight = document.querySelector('.oil-right');
            	const x =1;

            // 주유소 데이터 렌더링
            	oilStations.forEach((station, index) => {
            	    console.log("Current index:", index); // index 값 확인

            	    const oilItem = document.createElement('div');
            	    oilItem.classList.add('oil-item');
            	    
            	    // 문자열 연결로 innerHTML 작성
            	    oilItem.innerHTML = 
            	        '<h3 class="station-name">'+ (index + 1)+'.'+station.OS_NM + '</h3>' +
            	        '<p class="station-price">가격: ' + station.PRICE + '</p>' +
            	        '<p class="station-address">주소: ' + station.VAN_ADR + '</p>';

            	    // 좌측 또는 우측 컨테이너에 추가
            	    if (index < 5) {
            	        oilLeft.appendChild(oilItem);
            	    } else {
            	        oilRight.appendChild(oilItem);
            	    }
            	});

        } catch (error) {
            console.error('주유소 데이터를 가져오는 중 오류 발생:', error);
        }
    }
    
    
    
    //유가 부분
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

            // 날짜 형식 (MM.DD) - 오늘을 기준으로 전날 6일 전까지 날짜 계산
            const dates = [];
            const now = new Date();

            // 한국 시간 적용 (UTC+9)
            const timeOffset = 9 * 60 * 60 * 1000; // 9시간을 밀리초로 변환
            now.setTime(now.getTime() + timeOffset); // 한국 시간으로 맞춤

            console.log('오늘 날짜', Date(now));
            // 데이터 확인 로그
            console.log('Dates:', dates);
            console.log('Premium Prices:', premiumGasolinePrices);
            console.log('Regular Prices:', regularGasolinePrices);
            console.log('Diesel Prices:', dieselPrices);

            // 7일간의 날짜 배열 생성
            for (let i = 0; i <= 6; i++) {
                const targetDate = new Date(now); // 새로 복사한 날짜 객체
                targetDate.setDate(now.getDate() - (7 - i)); // 오늘 날짜에서 6-i일을 빼서 계산

                const month = targetDate.getMonth() + 1; // 월 (0부터 시작하므로 +1)
                const day = targetDate.getDate();      // 일

                console.log('월/일: ' + month + "/" + day);

                // 숫자 형식으로 (MM.DD) 반환
                const formattedDate = month.toString().padStart(2, '0') + "." + day.toString().padStart(2, '0');
                dates.push(formattedDate);

                // 날짜 확인용 로그
                console.log(`날짜 ${i} (${6 - i}일 전):`, formattedDate);
            }

            // 날짜 배열을 과거에서 오늘까지 순서로 정렬
            //dates.reverse(); // 날짜를 11.21부터 11.27까지 순서대로 뒤집기
            //premiumGasolinePrices.reverse(); 
            //regularGasolinePrices.reverse();
            //dieselPrices.reverse();

            // 날짜 배열 출력 (디버깅용)
            console.log("최종 날짜 배열:", dates);

            // 유가 정보 업데이트
            document.getElementById('premium-gasoline').textContent = premiumGasolinePrices[0] ? premiumGasolinePrices[0] + " 원" : "-";
            document.getElementById('regular-gasoline').textContent = regularGasolinePrices[0] ? regularGasolinePrices[0] + " 원" : "-";
            document.getElementById('diesel').textContent = dieselPrices[0] ? dieselPrices[0] + " 원" : "-";

            // 그래프 생성
            createChart('premiumGasolineChart', '고급휘발유', premiumGasolinePrices, dates);
            createChart('regularGasolineChart', '보통휘발유', regularGasolinePrices, dates);
            createChart('dieselChart', '자동차경유', dieselPrices, dates);

            // 날짜 업데이트 (그래프 아래에 날짜 표시)
            if (dates.length > 0) {
                document.getElementById('premium-dates').innerHTML = dates.join(' / ');
                document.getElementById('regular-dates').innerHTML = dates.join(' / ');
                document.getElementById('diesel-dates').innerHTML = dates.join(' / ');
            } else {
                console.error('날짜 배열이 비어있습니다.');
            }

        } catch (error) {
            console.error('데이터 가져오기 실패:', error);
        }
    }

    // 페이지 로드 후 데이터 가져오기 호출
    window.onload = fetchData;



        
    
        $(document).ready(function() {//window.onload 이벤트 처리에 대한 jQuery구문
        	
        	//지역명과 지역코드 매핑
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
    	                    
    	                  	//지역별 최저가격 주유소 10개 가져오기
    	                    loadOilStations(areaCode);

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
            
   });//end of jQuery 구문
        
    </script>

    <!-- Swiper JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>

    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
    <jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />

</body>

</html>
