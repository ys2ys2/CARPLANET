// 지도 설정
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };

var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

// 지도 타입과 줌 컨트롤을 추가합니다
var mapTypeControl = new kakao.maps.MapTypeControl();
map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

var zoomControl = new kakao.maps.ZoomControl();
map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

// 교통정보를 지도에 표시
map.addOverlayMapTypeId(kakao.maps.MapTypeId.TRAFFIC);

// 장소 검색 객체 생성
var ps = new kakao.maps.services.Places();

// 출발지와 도착지 마커를 전역 변수로 생성해둠
var originMarker = new kakao.maps.Marker();
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
                const item = document.createElement("div");
                item.className = "autocomplete-item";
                item.textContent = place.place_name;
                item.onclick = () => selectPlaceCallback(place);
                suggestionsContainer.appendChild(item);
            });
        }
    });
}

// 출발지 선택 시 처리 함수
function selectOriginPlace(place) {
    document.getElementById("originInput").value = place.place_name;
    document.getElementById("originCoords").value = `${place.x},${place.y}`;
    originSuggestions.innerHTML = "";
    setOriginMarker(place);
}

// 도착지 선택 시 처리 함수
function selectDestinationPlace(place) {
    document.getElementById("destinationInput").value = place.place_name;
    document.getElementById("destinationCoords").value = `${place.x},${place.y}`;
    destinationSuggestions.innerHTML = "";
    setDestinationMarker(place);
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
    const originCoords = document.getElementById("originCoords").value;
    const destinationCoords = document.getElementById("destinationCoords").value;

    if (originCoords && destinationCoords) {
        const routeData = await getRoute(originCoords, destinationCoords);
        if (routeData) displayRoute(routeData);
    } else {
        alert("출발지와 목적지를 모두 입력해 주세요.");
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

// 경로와 안내 지침 표시 함수
function displayRoute(routeData) {
    if (routeData && routeData.routes && routeData.routes[0]) {
        const linePath = [];
        const directionsList = document.getElementById('directionsList'); // 경로 안내 표시할 div
        directionsList.innerHTML = ''; // 기존 안내 초기화
        
        // 총 예상 이동 시간 계산
        const totalDurationInSeconds = routeData.routes[0].summary.duration;
        const totalMinutes = Math.floor(totalDurationInSeconds / 60);
        const totalSeconds = totalDurationInSeconds % 60;
        const totalDurationText = `총 예상 이동 시간: 약 ${totalMinutes}분 `; //초는 이렇게 사용! ${totalSeconds}초
        
        // 예상 이동 시간 표시
        const totalDurationElement = document.createElement('div');
        totalDurationElement.className = 'total-duration';
        totalDurationElement.innerHTML = `<strong>${totalDurationText}</strong>`;
        directionsList.appendChild(totalDurationElement);

        // 경로 데이터에서 x, y 좌표를 추출하여 선을 구성
        routeData.routes[0].sections[0].roads.forEach(road => {
            const vertexes = road.vertexes;
            for (let i = 0; i < vertexes.length; i += 2) {
                linePath.push(new kakao.maps.LatLng(vertexes[i + 1], vertexes[i]));
            }
        });

		// 출발지 이름 가져오기
		const originName = document.getElementById("originInput").value; // 사용자가 입력한 출발지 이름

		// 각 가이드(guide) 지침을 화면에 표시
		routeData.routes[0].sections[0].guides.forEach((guide, index) => {
		    const directionItem = document.createElement('div');
		    directionItem.className = 'direction-item';
		
		    // 첫 번째 안내 지침은 "출발지"로 표시, 마지막은 "목적지"로 표시
		    let guidanceText;
		    if (index === 0) {
        		guidanceText = `출발 : ${originName}`; // 출발지 이름 포함
		    } else if (index === routeData.routes[0].sections[0].guides.length - 1) {
		        guidanceText = "목적지";
		    } else {
		        // 도로 이름(road name)을 포함하여 지침 텍스트 생성
		        const roadName = guide.road && guide.road.name ? `${guide.road.name} 방면 ` : ""; // 도로 이름이 존재할 경우 추가
		        guidanceText = `${roadName}${guide.guidance || "이동"} 후 ${guide.distance}m 이동`; // 지침 텍스트
		    }
		
		    // 설정한 안내 지침을 HTML로 적용
		    directionItem.innerHTML = `<strong>${guidanceText}</strong>`;
		    directionsList.appendChild(directionItem);
		});


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

