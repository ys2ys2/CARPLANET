//현재 페이지와 데이터 세팅
let currentPage = 1;
//페이지당 아이템 수
const itemsPerPage = 5;
// 전체 데이터를 저장할 배열 선언
let allParkingData = [];
// map 객체를 전역으로 선언
let map;
let filteredParkingData = [];

//카카오 지도 불러오기
$(document).ready(function() {

    //1-1. 지도를 표시할 HTML 요소를 찾아 변수에 저장
    var container = document.getElementById('map');

    //1-2. 지도 초기화 옵션
    var options = {
        center: new kakao.maps.LatLng(33.450701, 126.570667),
        level: 3
    };

    //1-3. 카카오 지도 객체 생성, HTML요소에 지도 표시
    map = new kakao.maps.Map(container, options);
    
     // 주차장 데이터 불러오기 함수 호출
    fetchParkingLotData();
});


   
//탭 전환 함수
function showTab(tabName){
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.style.display = 'none';
    });
    document.getElementById(tabName).style.display = 'block';

    //버튼 스타일 설정
    document.querySelectorAll('.tab-button').forEach(button => {
        button.classList.remove('active');
    });
    document.querySelector(`[onclick="showTab('${tabName}')"]`).classList.add('active');

    //페이지 초기화
    currentPage=1;
    loadPageData(tabName);

}

    //페이지 데이터 로드
    function loadPageData(tabName){
        const parkingList = document.getElementById(tabName).querySelector('.parking-list');
        parkingList.innerHTML='';//기존 데이터를 지우고

      //현재 탭에 맞는 데이터를 가져와 표시
      fetchParkingLotData(tabName);
    }
    

// 공공데이터 API에서 주차장 리스트 가져오기
function fetchParkingLotData(tabName, province, city ) {
     // 전체 데이터를 불러오기 위해 한 번만 API를 호출하고, 이미 데이터가 있으면 바로 필터링과 렌더링으로 이동
     if (allParkingData.length > 0) {
        applyFilterAndRender(allParkingData, tabName, province, city);
        return;
    }
    $.ajax({
        url: 'http://api.data.go.kr/openapi/tn_pubr_prkplce_info_api',
        data: {
            serviceKey: 'oI8TfXEtYCINlcIZ8eXq9tri/7FV0Fr8dSuiooyeWFio2DRnWvwjql8OYqTAdWY1r7Et21qrdPkUw6Ad/iL3xQ==', // 
            pageNo: 1,
            numOfRows: 1000,
            type: 'json'
        },
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            console.log("API 응답:", response); // API 응답 데이터 구조 확인
            const data = response.response.body.items.map(item => ({
                name: item.prkplceNm || '이름 정보 없음', // 이름이 없는 경우 기본 텍스트
                prkplceSe: item.prkplceSe || '구분 정보 없음', // 구분 정보
                prkplceType: item.prkplceType || '유형 정보 없음', // 유형 정보
                parkingchrgeInfo: item.parkingchrgeInfo || '요금 정보 없음', // 요금 정보
                address: item.lnmadr || item.rdnmadr || '주소 정보 없음', // 지번주소가 도로명주소 사용, 둘 다 없으면 기본 메시지
                phone: item.phoneNumber || '전화번호 정보 없음', // 전화번호 정보
                latitude: item.latitude, // 위도
                longitude: item.longitude, // 경도
                prkcmprt: item.prkcmprt || '정보 없음',
                operDay: item.operDay || '정보 없음',
                weekdayOperOpenHhmm: item.weekdayOperOpenHhmm || '정보 없음',
                weekdayOperCloseHhmm: item.weekdayOperCloseHhmm || '정보 없음',
                satOperOperOpenHhmm: item.satOperOperOpenHhmm || '정보 없음',
                satOperCloseHhmm: item.satOperCloseHhmm || '정보 없음',
                holidayOperOpenHhmm: item.holidayOperOpenHhmm || '정보 없음',
                holidayCloseOpenHhmm: item.holidayCloseOpenHhmm || '정보 없음',
                parkingchrgeInfo: item.parkingchrgeInfo || '정보 없음',
                basicTime: item.basicTime || '정보 없음',
                basicCharge: item.basicCharge || '정보 없음',
                addUnitTime: item.addUnitTime || '정보 없음',
                addUnitCharge: item.addUnitCharge || '정보 없음',
                dayCmmtktAdjTime: item.dayCmmtktAdjTime || '정보 없음',
                dayCmmtkt: item.dayCmmtkt || '정보 없음',
                monthCmmtkt: item.monthCmmtkt || '정보 없음',
                metpay: item.metpay || '정보 없음',
                spcmnt: item.spcmnt || '정보 없음',
                institutionNm: item.institutionNm || '정보 없음',
                phone: item.phoneNumber || '전화번호 정보 없음',
                pwdbsPpkZoneYn: item.pwdbsPpkZoneYn || '정보 없음',
                referenceDate: item.referenceDate || '정보 없음'
            }));
          
            // 전체 데이터를 allParkingData에 저장
            allParkingData = data;
            
            // 필터링과 렌더링을 수행
            applyFilterAndRender(allParkingData, tabName, province, city);
        },
        error: function(error) {
            console.error("주차장 데이터를 불러오는데 실패했습니다:", error);
        }
    });
}

// 필터링과 렌더링을 수행하는 함수
function applyFilterAndRender(data, tabName, province, city) {
    const filteredData = filterParkingDataByRegion(data, province, city);
    console.log("필터링된 데이터:", filteredData);

    renderParkingList(filteredData, tabName); // 주차장 리스트 표시 함수 호출
    displayMarkers(filteredData); // 마커 표시 함수 호출
}

// 주소 필드를 기준으로 주차장 데이터를 필터링하는 함수
function filterParkingDataByRegion(data, province, city) {
    return data.filter(item => {
        const address = item.address; // 지번주소 또는 도로명주소 선택
        if (!address) return false; // 주소가 없으면 필터링 제외

        console.log("주소 필드:", address); // 주소 출력
        
        // 주소에서 도/시와 구/군 정보만 추출
        let addressProvinceCity;
        if (address.includes(' ')) {
            const indexOfSecondSpace = address.indexOf(' ', address.indexOf(' ') + 1);
            addressProvinceCity = address.slice(0, indexOfSecondSpace); // "서울특별시 강남구" 형식으로 추출
        } else {
            addressProvinceCity = address; // 공백이 없는 경우 전체 주소 사용
        }

        console.log("추출된 도/시와 구/군:", addressProvinceCity); // 추출 결과 확인
        console.log("사용자가 선택한 도/시와 구/군:", `${province} ${city}`);

        // 사용자가 선택한 도/시와 구/군으로 주소가 시작되는지 확인
        const isMatch = addressProvinceCity === `${province} ${city}`;
        console.log("필터링 일치 여부:", isMatch);

        return isMatch;
    });
}


// 주차장 리스트 데이터 표시 함수
function renderParkingList(data, tabName) {
    const parkingList = document.getElementById(tabName).querySelector('.parking-list'); // 주차장 목록을 표시할 HTML 요소 선택
    parkingList.innerHTML = ''; // 기존 데이터를 초기화

    data.forEach(item => {
        const parkingItem = document.createElement('div');
        parkingItem.classList.add('parking-item');
        parkingItem.innerHTML = `
            <h3>${item.name}</h3>
            <div class="label-container">
                <span class="label_gubun">${item.prkplceSe}</span> <!-- 구분 라벨 -->
                <span class="label_type">${item.prkplceType}</span> <!-- 유형 라벨 -->
                <span class="label_charge">${item.parkingchrgeInfo}</span> <!-- 요금 라벨 -->
            </div>
            <p>주소: ${item.address}</p>
            <p>전화번호: ${item.phone}</p>
        `;
           // 주차장 항목 클릭 시 상세 정보 표시 이벤트 추가
        parkingItem.addEventListener('click', function() {
            console.log("주차장 항목 클릭됨:", item); // 클릭 로그 추가
            showParkingDetails(item); // 클릭 시 상세 정보 함수 호출
            moveToLocationAndShowMarker(item); // 클릭 시 마커와 지도 이동 함수 호출
        });
        parkingList.appendChild(parkingItem);
    });
    document.getElementById('page-number').innerText = currentPage; // 현재 페이지 번호 표시
}

// 지도에 마커를 표시하는 함수
function displayMarkers(parkingData) {
    parkingData.forEach(item => {
        // 마커 위치 설정
        var markerPosition = new kakao.maps.LatLng(item.latitude, item.longitude);
 		console.log("마커 위치 설정 - 위도:", item.latitude, "경도:", item.longitude); // 마커 위치 확인 로그
       
        // 마커 생성
        var marker = new kakao.maps.Marker({
            position: markerPosition
        });
 			console.log("마커 위치:", markerPosition); // 마커 위치 확인용 로그
        // 지도에 마커 표시
        marker.setMap(map);

        // 마커 클릭 시 주차장명과 주소를 알림으로 표시
        kakao.maps.event.addListener(marker, 'click', function() {
            alert("주차장명: " + item.name + "\n주소: " + item.address);
        });
    });
}

// 주차장 리스트 클릭 시 해당 위치로 지도 이동 및 마커 표시
function moveToLocationAndShowMarker(item) {
    var latitude = item.latitude;
    var longitude = item.longitude;
 // 좌표값 확인
 console.log("주차장 위치 좌표 - 위도:", latitude, "경도:", longitude);

    // 카카오맵 LatLng 객체 생성 (위도, 경도 순서)
    var moveLatLon = new kakao.maps.LatLng(latitude, longitude);

    // 지도 중심을 이동하려는 위치로 설정
    map.setLevel(3); // 확대 레벨 설정
    map.panTo(moveLatLon); // 지도 중심 이동

    // 기존 마커 제거 후 새 마커 추가
    if (window.selectedMarker) {
        window.selectedMarker.setMap(null); // 기존 마커 제거
    }

    // 선택한 주차장 위치에 새 마커 생성
    var marker = new kakao.maps.Marker({
        position: moveLatLon
    });
    marker.setMap(map); // 지도에 마커 표시
    window.selectedMarker = marker; // 새 마커를 전역 변수에 저장
}


 // 페이지네이션 이전 페이지로 이동
 function prevPage() {
     if (currentPage > 1) {
         currentPage--;
         loadPageData(document.querySelector('.tab-button.active').innerText === "주변 주차장" ? 'nearby' : 'regional');
     }
 }

 // 페이지네이션 다음 페이지로 이동
 function nextPage() {
     fetchTotalCount(totalCount => { // 총 데이터 개수로 페이지 수 계산
         if (currentPage < Math.ceil(totalCount / itemsPerPage)) { // 현재 페이지가 마지막 페이지보다 작을 때만 실행
             currentPage++; // 페이지 번호 증가
            loadPageData(document.querySelector('.tab-button.active').innerText === "주변 주차장" ? 'nearby' : 'regional');
         }
     });
 }

// 총 데이터 개수를 가져오는 함수
function fetchTotalCount(callback) {
    $.ajax({
        url: 'http://api.data.go.kr/openapi/tn_pubr_prkplce_info_api',
        data: {
            serviceKey: 'oI8TfXEtYCINlcIZ8eXq9tri/7FV0Fr8dSuiooyeWFio2DRnWvwjql8OYqTAdWY1r7Et21qrdPkUw6Ad/iL3xQ==',
            pageNo: 1,
            numOfRows: 1,
            type: 'json'
        },
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            const totalCount = response.response.body.totalCount;
            if (typeof callback === 'function') {  // callback이 함수인지 확인
                callback(totalCount);  // 콜백 함수 호출
            } else {
                console.error("callback이 함수가 아닙니다.");
            }
        },
        error: function(error) {
            console.error("총 데이터 수를 불러오는데 실패했습니다:", error);
            callback(0);
        }
    });
}

// 클릭한 주차장의 모든 정보를 표시하고 팝업을 여는 함수
function showParkingDetails(item) {
    console.log("showParkingDetails 함수의 item 객체:", item); // parking 객체 확인
    const detailsContainer = document.getElementById('parking-details'); // 상세 정보 표시 영역

    detailsContainer.innerHTML = `
        <h2>${item.name}</h2>
        <p>주차장 관리번호: ${item.prkplceNo || '정보 없음'}</p>
        <p>주차장 구분: ${item.prkplceSe || '정보 없음'}</p>
        <p>주차장 유형: ${item.prkplceType || '정보 없음'}</p>
        <p>도로명 주소: ${item.rdnmadr || '정보 없음'}</p>
        <p>지번 주소: ${item.lnmadr || '정보 없음'}</p>
        <p>주차 구획 수: ${item.prkcmprt || '정보 없음'}</p>
        <p>운영 요일: ${item.operDay || '정보 없음'}</p>
        <p>평일 운영 시간: ${item.weekdayOperOpenHhmm || '정보 없음'} - ${item.weekdayOperCloseHhmm || '정보 없음'}</p>
        <p>토요일 운영 시간: ${item.satOperOperOpenHhmm || '정보 없음'} - ${item.satOperCloseHhmm || '정보 없음'}</p>
        <p>공휴일 운영 시간: ${item.holidayOperOpenHhmm || '정보 없음'} - ${item.holidayCloseOpenHhmm || '정보 없음'}</p>
        <p>요금 정보: ${item.parkingchrgeInfo || '정보 없음'}</p>
        <p>기본 시간: ${item.basicTime || '정보 없음'}</p>
        <p>기본 요금: ${item.basicCharge || '정보 없음'}</p>
        <p>추가 단위 시간: ${item.addUnitTime || '정보 없음'}</p>
        <p>추가 단위 요금: ${item.addUnitCharge || '정보 없음'}</p>
        <p>1일 주차권 요금 적용 시간: ${item.dayCmmtktAdjTime || '정보 없음'}</p>
        <p>1일 주차권 요금: ${item.dayCmmtkt || '정보 없음'}</p>
        <p>월 정기권 요금: ${item.monthCmmtkt || '정보 없음'}</p>
        <p>결제 방법: ${item.metpay || '정보 없음'}</p>
        <p>특기 사항: ${item.spcmnt || '정보 없음'}</p>
        <p>전화번호: ${item.phone || '정보 없음'}</p>
        <p>장애인 전용 주차 구역 보유 여부: ${item.pwdbsPpkZoneYn || '정보 없음'}</p>
        <p>데이터 기준 일자: ${item.referenceDate || '정보 없음'}</p>
    `;

    // 팝업을 보이도록 설정
    document.getElementById('parking-details-popup').style.display = 'block';
}

// 팝업을 닫는 함수
function closeParkingDetails() {
    document.getElementById('parking-details-popup').style.display = 'none';
}


// 초기 데이터 로드
showTab('search');