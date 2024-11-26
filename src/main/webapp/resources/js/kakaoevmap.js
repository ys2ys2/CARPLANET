// 지도 설정
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };

var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

// 지도 타입 컨트롤과 줌 컨트롤 변수 선언
var mapTypeControl = null;
var zoomControl = null;

// 초기 화면 크기를 확인하고 컨트롤 추가 여부 결정
if (window.innerWidth > 425) {
    addControls(); // 화면이 425px 초과일 경우 컨트롤 추가
}

// 화면 크기가 변경될 때 이벤트 처리
window.addEventListener("resize", function () {
    if (window.innerWidth <= 425) {
        // 화면이 425px 이하일 경우 컨트롤 제거
        removeControls();
    } else {
        // 화면이 425px 초과일 경우 컨트롤 추가
        addControls();
    }
});

// 컨트롤 추가 함수
function addControls() {
    if (!mapTypeControl && !zoomControl) { // 컨트롤이 없을 때만 추가
        mapTypeControl = new kakao.maps.MapTypeControl();
        map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

        zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
    }
}

// 컨트롤 제거 함수
function removeControls() {
    if (mapTypeControl && zoomControl) { // 컨트롤이 있을 때만 제거
        map.removeControl(mapTypeControl);
        map.removeControl(zoomControl);

        // 변수 초기화
        mapTypeControl = null;
        zoomControl = null;
    }
}


// 교통정보를 지도에 표시
map.addOverlayMapTypeId(kakao.maps.MapTypeId.TRAFFIC);

// 장소 검색 객체 생성
var ps = new kakao.maps.services.Places();

// 출발지와 도착지 마커를 전역 변수로 생성해둠
var originMarker = new kakao.maps.Marker({
	image: new kakao.maps.MarkerImage(
		'https://t1.daumcdn.net/localimg/localimages/07/2018/pc/flagImg/blue_b.png', //출발지 마커 이미지
		new kakao.maps.Size(35, 40) //마커 이미지 크기
	)
});
	
var destinationMarker = new kakao.maps.Marker({
    image: new kakao.maps.MarkerImage(
        'https://t1.daumcdn.net/localimg/localimages/07/2018/pc/flagImg/red_b.png', // 빨간색 마커 이미지 URL
        new kakao.maps.Size(35, 40) // 마커 이미지의 크기
    )
});

var polyline; // 경로를 표시할 폴리라인 객체

// 출발지 마커 설정 함수
function setOriginMarker(place) {
    var coords = new kakao.maps.LatLng(place.y, place.x);
    originMarker.setPosition(coords);
    originMarker.setMap(map);
    map.setCenter(coords);
}

// 도착지 마커 설정 함수
function setDestinationMarker(place) {
    var coords = new kakao.maps.LatLng(place.y, place.x);
    destinationMarker.setPosition(coords);
    destinationMarker.setMap(map);
    map.setCenter(coords);
}

// 자동완성 기능 및 장소 선택 함수
function autoComplete(query, suggestionsContainer, selectPlaceCallback) {
    if (!query.trim()) {
        suggestionsContainer.innerHTML = ""; // 입력이 없을 경우 목록을 지움
        return;
    }

    ps.keywordSearch(query, function(data, status) {
        if (status === kakao.maps.services.Status.OK) {
            suggestionsContainer.innerHTML = ""; // 기존 목록을 초기화
            data.forEach(function(place) {
			    const item = document.createElement("div"); // 첫 번째 item 선언
			    item.className = "autocomplete-item";
			    
			    // 아이콘 추가 부분
			    const icon = document.createElement("div"); // 아이콘을 위한 div 요소 생성
			    icon.className = "autocomplete-icon";
			
			    // category_group_code에 따른 아이콘 URL 설정
			    const iconUrl = getIconUrl(place.category_group_code);
			    icon.style.backgroundImage = `url('${iconUrl}')`;

			
			    // 장소 이름과 카테고리 정보를 함께 표시
			    item.innerHTML = `<strong>${place.place_name}</strong>`;
			    
			    // 아이콘을 item에 추가
			    item.prepend(icon);
			    item.onclick = () => selectPlaceCallback(place);
			    suggestionsContainer.appendChild(item);
			});
        }
    });
}

// category_group_code에 따른 아이콘 URL을 반환하는 함수
function getIconUrl(categoryCode) {
    switch (categoryCode) {
        case 'MT1':
            return 'https://img.icons8.com/?size=100&id=hx6mDkmtPgjw&format=png&color=4D4D4D'; //대형마트
        case 'CS2':
            return 'https://img.icons8.com/?size=100&id=3723&format=png&color=4D4D4D'; //편의점
        case 'PS3':
        	return 'https://img.icons8.com/?size=100&id=11064&format=png&color=4D4D4D'; //어린이집,유치원
        case 'SC4':
        	return 'https://img.icons8.com/?size=100&id=1954&format=png&color=4D4D4D'; //학교
        case 'AC5':
        	return 'https://img.icons8.com/?size=100&id=68665&format=png&color=4D4D4D'; //학원   	 
        case 'PK6':
        	return 'https://img.icons8.com/?size=100&id=10726&format=png&color=4D4D4D'; //주차장
        case 'OL7':
        	return 'https://img.icons8.com/?size=100&id=3679&format=png&color=4D4D4D'; //주유소,충전소
        case 'SW8':
            return 'https://img.icons8.com/?size=100&id=16556&format=png&color=4D4D4D'; //지하철역
        case 'BK9':
            return 'https://img.icons8.com/?size=100&id=59049&format=png&color=4D4D4D'; //은행
        case 'CT1':
        	return 'https://img.icons8.com/?size=100&id=3723&format=png&color=4D4D4D'; //문화시설
        case 'AG2':
        	return 'https://img.icons8.com/?size=100&id=25993&format=png&color=4D4D4D'; //부동산중개
        case 'PO3':
        	return 'https://img.icons8.com/?size=100&id=3723&format=png&color=4D4D4D'; //공공기관        	
        case 'AT4':
        	return 'https://img.icons8.com/?size=100&id=3723&format=png&color=4D4D4D'; //관광명소        	
        case 'AD5':
        	return 'https://img.icons8.com/?size=100&id=36196&format=png&color=4D4D4D'; //숙박       	
        case 'FD6':
        	return 'https://img.icons8.com/?size=100&id=12586&format=png&color=4D4D4D'; //음식점        	
        case 'CE7':
        	return 'https://img.icons8.com/?size=100&id=avzgbKiLzCFk&format=png&color=4D4D4D'; //카페        	
        case 'HP8':
        	return 'https://img.icons8.com/?size=100&id=kD7s-jinywzH&format=png&color=4D4D4D'; //병원        
        case 'PM9':
        	return 'https://img.icons8.com/?size=100&id=jqpP9i5gnLQN&format=png&color=4D4D4D'; //약국                	        	        	        	
        default:
            return 'https://img.icons8.com/?size=100&id=3723&format=png&color=4D4D4D'; // 기본
    }
}

// 출발지와 도착지 데이터를 관리할 객체
const routeDataManager = {
    origin: null, // 출발지 정보 저장
    destination: null, // 도착지 정보 저장

    // 출발지 설정
    setOrigin(place) {
        this.origin = place;
        document.getElementById("originInput").value = place.place_name;
        document.getElementById("originCoords").value = `${place.x},${place.y}`;
        originSuggestions.innerHTML = "";
        setOriginMarker(place);
    },

    // 도착지 설정
    setDestination(place) {
        this.destination = place;
        document.getElementById("destinationInput").value = place.place_name;
        document.getElementById("destinationCoords").value = `${place.x},${place.y}`;
        destinationSuggestions.innerHTML = "";
        setDestinationMarker(place);
    },

    // 값 초기화
    clear() {
        this.origin = null;
        this.destination = null;
    }
};



// 출발지 선택 시 처리 함수
function selectOriginPlace(place) {
    document.getElementById("originInput").value = place.place_name;
    document.getElementById("originCoords").value = `${place.x},${place.y}`;
    originSuggestions.innerHTML = "";
    setOriginMarker(place);
    routeDataManager.setOrigin(place);
}



// 도착지 선택 시 처리 함수
function selectDestinationPlace(place) {
    document.getElementById("destinationInput").value = place.place_name;
    document.getElementById("destinationCoords").value = `${place.x},${place.y}`;
    destinationSuggestions.innerHTML = "";
    setDestinationMarker(place);
    routeDataManager.setDestination(place);
}

// 출발지와 목적지 자동완성 설정
document.getElementById('originInput').addEventListener('input', function() {
    autoComplete(this.value, originSuggestions, selectOriginPlace);
});
document.getElementById('destinationInput').addEventListener('input', function() {
    autoComplete(this.value, destinationSuggestions, selectDestinationPlace);
});

// 길찾기 버튼 클릭 시 경로 찾기
document.getElementById('searchButton').addEventListener('click', async function() {
    if (!routeDataManager.origin || !routeDataManager.destination) {
        alert("출발지와 도착지를 입력해주세요.");
        return;
    }

    const originCoords = `${routeDataManager.origin.x},${routeDataManager.origin.y}`;
    const destinationCoords = `${routeDataManager.destination.x},${routeDataManager.destination.y}`;

    try {
        const routeData = await getRoute(originCoords, destinationCoords);
        if (routeData) {
            displayRoute(routeData);
        } else {
            alert("경로를 찾을 수 없습니다.");
        }
    } catch (error) {
        console.error("경로 검색 중 오류:", error);
        alert("경로 검색에 실패했습니다. 다시 시도해주세요.");
    }
});

// 길찾기 API 호출 함수
async function getRoute(origin, destination) {
    const apiKey = 'b7b268f48e77802bf13519781db46af4';
    const url = `https://apis-navi.kakaomobility.com/v1/directions?origin=${origin}&destination=${destination}&priority=RECOMMEND&car_fuel=GASOLINE`;

    try {
        const response = await fetch(url, {
            method: 'GET',
            headers: { 
                'Authorization': `KakaoAK ${apiKey}`, 
                'Content-Type': 'application/json' 
            }
        });
        
    	// 응답 데이터를 JSON으로 변환
        const routeData = await response.json();
        
        // 전체 routeData 출력
        console.log("Full Route Data:", routeData);

        return routeData;
        
    } catch (error) {
        console.error("경로 요청 중 오류 발생:", error);
        return null;
    }
}




const typeIconMap = {
    0: "https://img.icons8.com/?size=100&id=100000&format=png&color=000000", //직진
    1: "https://img.icons8.com/?size=100&id=3187&format=png&color=000000", //좌회전
    2: "https://img.icons8.com/?size=100&id=3241&format=png&color=000000", //우회전
    3: "https://img.icons8.com/?size=100&id=bmQbiY8FGmK2&format=png&color=000000", //U턴
    5: "https://img.icons8.com/?size=100&id=39785&format=png&color=000000", //왼쪽 방향
    6: "https://img.icons8.com/?size=100&id=39782&format=png&color=000000", //오른쪽 방향
    7: "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //고속 도로 출구
    8: "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //왼쪽에 고속 도로 출구
    9: "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //오른쪽에 고속 도로 출구
    10: "https://img.icons8.com/?size=100&id=62912&format=png&color=000000g", //고속 도로 입구
    11: "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //왼쪽에 고속 도로 입구
    12: "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //오른쪽에 고속 도로 입구
    14: "https://img.icons8.com/?size=100&id=AFbGHolwIW9w&format=png&color=000000", //고가도로 진입
    15: "https://img.icons8.com/?size=100&id=pSpQa6iHwEJ9&format=png&color=000000", //지하 차도 진입
    16: "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //고가 도로 옆길
    17: "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //지하 차도 옆길
    18 : "https://img.icons8.com/?size=100&id=43689&format=png&color=000000", //오른쪽 1시 방향
    19 : "https://img.icons8.com/?size=100&id=43689&format=png&color=000000", //오른쪽 2시 방향
    20 : "https://img.icons8.com/?size=100&id=39782&format=png&color=000000", //오른쪽 3시 방향
    21 : "https://img.icons8.com/?size=100&id=43690&format=png&color=000000", //오른쪽 4시 방향
    22 : "https://img.icons8.com/?size=100&id=43690&format=png&color=000000", //오른쪽 5시 방향
    23 : "https://img.icons8.com/?size=100&id=7800&format=png&color=000000", //6시 방향
    24 : "https://img.icons8.com/?size=100&id=43691&format=png&color=000000", //왼쪽 7시 방향
    25 : "https://img.icons8.com/?size=100&id=43691&format=png&color=000000", //왼쪽 8시 방향
    26 : "https://img.icons8.com/?size=100&id=39785&format=png&color=000000", //왼쪽 9시 방향
    27 : "https://img.icons8.com/?size=100&id=43688&format=png&color=000000", //왼쪽 10시 방향
    28 : "https://img.icons8.com/?size=100&id=43688&format=png&color=000000", //왼쪽 11시 방향
    29 : "https://img.icons8.com/?size=100&id=39778&format=png&color=000000", //12시 방향
    30 : "https://img.icons8.com/?size=100&id=A3wGuAmOGwpo&format=png&color=000000", //로터리에서 오른쪽 1시 방향
    31 : "https://img.icons8.com/?size=100&id=A3wGuAmOGwpo&format=png&color=000000", //로터리에서 오른쪽 2시방향
    32 : "https://img.icons8.com/?size=100&id=A3wGuAmOGwpo&format=png&color=000000", //로터리에서 오른쪽 2시방향
    33 : "https://img.icons8.com/?size=100&id=A3wGuAmOGwpo&format=png&color=000000", //로터리에서 오른쪽 4시방향
    34 : "https://img.icons8.com/?size=100&id=A3wGuAmOGwpo&format=png&color=000000", //로터리에서 오른쪽 5시방향
    35 : "https://img.icons8.com/?size=100&id=A3wGuAmOGwpo&format=png&color=000000", //로터리에서 6시방향
    36 : "https://img.icons8.com/?size=100&id=A3wGuAmOGwpo&format=png&color=000000", //로터리에서 왼쪽 7시방향
    37 : "https://img.icons8.com/?size=100&id=A3wGuAmOGwpo&format=png&color=000000", //로터리에서 왼쪽 8시방향
    38 : "https://img.icons8.com/?size=100&id=A3wGuAmOGwpo&format=png&color=000000", //로터리에서 왼쪽 9시방향
    39 : "https://img.icons8.com/?size=100&id=A3wGuAmOGwpo&format=png&color=000000", //로터리에서 왼쪽 10시방향
    40 : "https://img.icons8.com/?size=100&id=A3wGuAmOGwpo&format=png&color=000000", //로터리에서 왼쪽 11시방향
    41 : "https://img.icons8.com/?size=100&id=A3wGuAmOGwpo&format=png&color=000000", //로터리에서 왼쪽 12시방향
    42 : "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //도시 고속 도로 출구
    43 : "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //왼쪽에 도시 고속 도로 출구 
    44 : "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //오른쪽에 도시 고속 도로 출구
    45 : "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //도시 고속 도로 입구
    46 : "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //왼쪽에 도시 고속 도로 입구
    47 : "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //오른쪽에 도시 고속 도로 입구
    48 : "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //왼쪽 고속 도로 진입
    49 : "https://img.icons8.com/?size=100&id=62912&format=png&color=000000", //오른쪽 고속 도로 진입
    61 : "https://img.icons8.com/?size=100&id=9328&format=png&color=000000", //페리 항로 진입
    62 : "https://img.icons8.com/?size=100&id=9328&format=png&color=000000", //페리 항로 진출
    70 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //회전 교차로에서 오른쪽 1시 방향
    71 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //회전 교차로에서 오른쪽 2시 방향
    72 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //회전 교차로에서 오른쪽 3시 방향
    73 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //회전 교차로에서 오른쪽 4시 방향
    74 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //회전 교차로에서 오른쪽 5시 방향
    75 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //회전 교차로에서 6시 방향
    76 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //회전 교차로에서 왼쪽 7시 방향
    77 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //회전 교차로에서 왼쪽 8시 방향
    78 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //회전 교차로에서 왼쪽 9시 방향
    79 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //회전 교차로에서 왼쪽 10시 방향
    80 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //회전 교차로에서 왼쪽 11시 방향
    81 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //회전 교차로에서 12시 방향
    82 : "https://img.icons8.com/?size=100&id=100000&format=png&color=000000", //왼쪽 직진
    83 : "https://img.icons8.com/?size=100&id=100000&format=png&color=000000", //오른쪽 직진
    84 : "https://img.icons8.com/?size=100&id=61510&format=png&color=000000", //톨게이트 진입
    85 : "https://img.icons8.com/?size=100&id=36519&format=png&color=000000", //원톨링 진입
    86 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //분기 후 합류 구간 진입
    100 : "https://img.icons8.com/?size=100&id=15989&format=png&color=000000", //출발지
    101 : "https://img.icons8.com/?size=100&id=15989&format=png&color=000000", //목적지
    300 : "https://img.icons8.com/?size=100&id=7758&format=png&color=000000", //톨게이트
    301 : "https://img.icons8.com/?size=100&id=avzgbKiLzCFk&format=png&color=000000" // 휴게소
    
};



function ensureRouteDOMElements() {
    let routeHeader = document.querySelector('.route-header');
    let routeMain = document.querySelector('.route-main');
    let routeFooter = document.querySelector('.route-footer');

    // 각 요소가 없으면 동적으로 생성
    if (!routeHeader) {
        routeHeader = document.createElement('div');
        routeHeader.className = 'route-header';
        document.body.appendChild(routeHeader); // 적절한 부모 요소에 추가
    }
    if (!routeMain) {
        routeMain = document.createElement('div');
        routeMain.className = 'route-main';
        document.body.appendChild(routeMain); // 적절한 부모 요소에 추가
    }
    if (!routeFooter) {
        routeFooter = document.createElement('div');
        routeFooter.className = 'route-footer';
        document.body.appendChild(routeFooter); // 적절한 부모 요소에 추가
    }

    return { routeHeader, routeMain, routeFooter };
}


// 경로와 안내 지침 표시 함수
function displayRoute(routeData) {
    if (routeData && routeData.routes && routeData.routes[0]) {
        const { routeHeader, routeMain, routeFooter } = ensureRouteDOMElements(); // DOM 요소 보장
    
    
    	// 기존 데이터 초기화
        routeHeader.innerHTML = '';
        routeMain.innerHTML = '';
        routeFooter.innerHTML = '';
    
    
        const linePath = [];
        // 총 예상 이동 시간 계산
        const totalDurationInSeconds = routeData.routes[0].summary.duration;
        const totalHours = Math.floor(totalDurationInSeconds / 3600); // 시간 계산
		const totalMinutes = Math.floor((totalDurationInSeconds % 3600) / 60); // 분 계산
        
        // 예상 이동 시간을 시간과 분 형식으로 표시
        const totalDurationText = totalHours > 0
            ? `예상 이동 시간: 약 ${totalHours}시간 ${totalMinutes}분`
            : `예상 이동 시간: 약 ${totalMinutes}분`;

        // 예상 이동 시간(route-header)에 표시
        routeHeader.innerHTML = `<strong>${totalDurationText}</strong>`;

        // 경로 데이터에서 x, y 좌표를 추출하여 선을 구성
        routeData.routes[0].sections[0].roads.forEach(road => {
            const vertexes = road.vertexes;
            for (let i = 0; i < vertexes.length; i += 2) {
                linePath.push(new kakao.maps.LatLng(vertexes[i + 1], vertexes[i]));
            }
        });
        
        // 출발지 이름 가져오기
        const originName = document.getElementById("originInput").value; // 사용자가 입력한 출발지 이름
		const destinationName = document.getElementById("destinationInput").value; // 도착지 이름
      	
      	
         // 각 가이드(guide) 지침을 화면에 표시
        const guides = routeData.routes[0].sections[0].guides;
        guides.forEach((guide, index) => {
            const directionItem = document.createElement('div');
            directionItem.className = 'direction-item';

            // `guidance` 값 가져오기
            const guidanceText = guide.guidance || "이동";

            // 아이콘 URL 결정
            const iconUrl = typeIconMap[guide.type] || "https://example.com/icons/default.png";

            // 첫 번째 안내 지침은 "출발지"로 표시
            if (index === 0) {
                directionItem.innerHTML = `
                    <span class="route-icon"><img src="https://t1.daumcdn.net/localimg/localimages/07/2018/pc/flagImg/blue_b.png" alt="출발 아이콘"></span>
                    <span class="route-nav"><strong>${originName}</strong></span>
                `;
                routeMain.appendChild(directionItem);
            } 
            // 중간 안내 지침
            else {
                const roadName = guide.road && guide.road.name ? `${guide.road.name} 방면 ` : ""; // 도로 이름이 존재할 경우 추가
                const distanceText = guide.distance >= 1000
                    ? `${(guide.distance / 1000).toFixed(1)}km`
                    : `${guide.distance}m`;

                 // 목적지에 대한 특별 처리
			    const guidanceDescription = guide.guidance === "목적지"
			        ? `목적지까지 ${distanceText} 이동` // 목적지일 경우
			        : `${roadName}${guide.guidance || "이동"} 후 ${distanceText} 이동`; // 일반 경우

                directionItem.innerHTML = `
                    <span class="route-icon"><img src="${iconUrl}" alt="${guide.type}"></span>
                    <span class="route-nav">${guidanceDescription}</span>
                `;
                routeMain.appendChild(directionItem);
            }
        });

        // 도착지 표시 (리스트의 마지막에 추가)
        const destinationItem = document.createElement('div');
        destinationItem.className = 'direction-item';
        destinationItem.innerHTML = `
            <span class="route-icon"><img src="https://t1.daumcdn.net/localimg/localimages/07/2018/pc/flagImg/red_b.png" alt="목적지 아이콘"></span>
            <span class="route-nav"><strong>${destinationName}</strong></span>
        `;
        routeMain.appendChild(destinationItem);

        // 기존 경로가 있다면 제거
        if (polyline) {
            polyline.setMap(null);
        }

        // 새로운 경로를 그리고 지도에 표시
        polyline = new kakao.maps.Polyline({
            path: linePath,
            strokeWeight: 5,
            strokeColor: '#FF0000',
            strokeOpacity: 0.7,
            strokeStyle: 'solid'
        });
        polyline.setMap(map);

        // 경로에 맞게 지도 범위 설정
        const bounds = new kakao.maps.LatLngBounds();
        linePath.forEach(point => bounds.extend(point));
        map.setBounds(bounds);
    } else {
        alert("경로를 찾을 수 없습니다.");
    }
}

//초기화 함수
function clearPreviousRoute() {
    // 기존 폴리라인 제거
    if (polyline) {
        polyline.setMap(null);
        polyline = null;
    }

    // 기존 경로 결과 초기화
    const routeHeader = document.querySelector(".route-header");
    const routeMain = document.querySelector(".route-main");
    const routeFooter = document.querySelector(".route-footer");

    if (routeHeader) routeHeader.innerHTML = "";
    if (routeMain) routeMain.innerHTML = "";
    if (routeFooter) routeFooter.innerHTML = "";
}




// 지도에 마커를 표시하는 함수
function displayMarker(place) {
    var marker = new kakao.maps.Marker({
        map: map,
        position: new kakao.maps.LatLng(place.y, place.x) 
    });

    kakao.maps.event.addListener(marker, 'click', function() {
        infowindow.setContent('<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>');
        infowindow.open(map, marker);
    });
}

// 주소를 좌표로 변환하는 함수
async function getCoordinatesFromAddress(address) {
    const apiKey = 'b7b268f48e77802bf13519781db46af4';
    const url = `https://dapi.kakao.com/v2/local/search/address.json?query=${address}`;

    try {
        const response = await fetch(url, {
            method: 'GET',
            headers: { 'Authorization': `KakaoAK ${apiKey}` }
        });
        const data = await response.json();
        if (data.documents && data.documents.length > 0) {
            return `${data.documents[0].x},${data.documents[0].y}`;
        } else {
            console.warn("좌표를 찾을 수 없습니다.");
            return null;
        }
    } catch (error) {
        console.error("주소 변환 중 오류 발생:", error);
        return null;
    }
}

// 현재 위치를 받아 지도의 중심을 이동하는 함수
function setMapToCurrentLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            function(position) {
                const latitude = position.coords.latitude; // 위도
                const longitude = position.coords.longitude; // 경도
                
                const userLocation = new kakao.maps.LatLng(latitude, longitude); // 사용자의 현재 위치 좌표
                map.setCenter(userLocation); // 지도의 중심을 현재 위치로 이동
                
                // 현재 위치에 마커 추가 (옵션)
                const userMarker = new kakao.maps.Marker({
                    position: userLocation,
                    map: map
                });
                
            },
            function(error) {
                alert("현재 위치를 가져올 수 없습니다. 위치 정보를 허용해 주세요.");
            },
            {
                enableHighAccuracy: true, // 높은 정확도의 위치를 요청
                timeout: 10000,           // 위치 요청 제한 시간 설정 (10초)
                maximumAge: 0             // 항상 최신 위치 정보 요청
            }
        );
    } else {
        alert("이 브라우저에서는 현재 위치를 가져올 수 없습니다.");
    }
}

// 페이지 로드 시 현재 위치로 지도 이동
document.addEventListener("DOMContentLoaded", setMapToCurrentLocation);

// evdropdown.js에서 호출하는 함수: 도착지 좌표 설정
function setDestinationFromPopup(destination) {
    const { lat, lng, address } = destination;

    // 도착지 좌표 설정 및 마커 표시
    const place = { x: lng, y: lat, place_name: address };
    selectDestinationPlace(place); // 도착지 마커 표시

    // 경로 탭 활성화 후 경로 검색 실행
    setTimeout(() => {
        document.getElementById("searchButton").click(); // 경로 검색 버튼 자동 클릭
    }, 500);
}


// 스왑 버튼 기능 추가
document.getElementById('swapButton').addEventListener('click', function () {
	    if (routeDataManager.origin && routeDataManager.destination) {
        // 출발지와 도착지를 스왑
        const temp = routeDataManager.origin;
        routeDataManager.setOrigin(routeDataManager.destination);
        routeDataManager.setDestination(temp);
    }
});

// 취소 버튼 기능 추가 (출발지와 도착지 입력 필드 모두 초기화)
document.getElementById('cancelButton').addEventListener('click', function () {

    routeDataManager.clear();
    clearPreviousRoute();
    
    if (polyline) {
        polyline.setMap(null);
    }

    // 출발지 입력 필드와 좌표 초기화
    document.getElementById("originInput").value = '';
    document.getElementById("originCoords").value = '';
    originMarker.setMap(null); // 출발지 마커 제거

    // 도착지 입력 필드와 좌표 초기화
    document.getElementById("destinationInput").value = '';
    document.getElementById("destinationCoords").value = '';
    destinationMarker.setMap(null); // 도착지 마커 제거
});

