// 카카오모빌리티 사용을 위한 REST API 키
const REST_API_KEY = '8d162536747ffddff1f5576cb3b7f971'; 

//현재 페이지와 데이터 세팅
let currentPage = 1;
//페이지당 아이템 수
const itemsPerPage = 4;
// 전체 데이터를 저장할 배열 선언
let allParkingData = [];
// map 객체를 전역으로 선언
let map;

//길찾기 마커
let startMarker, endMarker;

//길찾기 장소 검색
const ps = new kakao.maps.services.Places(); // 장소 검색 객체 생성

//필터된 주차장 데이터
let filteredParkingData = [];

// 한 페이지당 가져올 데이터 수
const numOfRows = 100;

// 현재 선택된 항목의 인덱스를 저장하는 변수
let selectedIndex = -1; 

//카카오 지도 불러오기
$(document).ready(function() {

    //1-1. 지도를 표시할 HTML 요소를 찾아 변수에 저장
    var container = document.getElementById('map');

    //1-2. 지도 초기화 옵션
    var options = {
        center: new kakao.maps.LatLng(37.5665, 126.9780),
        level: 3
    };

    //1-3. 카카오 지도 객체 생성, HTML요소에 지도 표시
    map = new kakao.maps.Map(container, options);
    
     // 주차장 데이터 불러오기 함수 호출
    fetchParkingLotData();
});

// 탭 전환 함수
function showTab(tabName) {
    // 모든 탭 콘텐츠 숨기기
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.style.display = 'none';
    });

    // 선택한 탭만 보이도록 설정
    document.getElementById(tabName).style.display = 'block';

    // 모든 탭 버튼에서 'active' 클래스 제거
    document.querySelectorAll('.tab-button').forEach(button => {
        button.classList.remove('active');
    });

    // 선택된 탭 버튼에 'active' 클래스 추가
    document.querySelector(`[onclick="showTab('${tabName}')"]`).classList.add('active');

    // 'search' 탭이 활성화될 때만 지역 선택 창을 보이게 함
    const regionSelection = document.querySelector('.region-selection');
    if (tabName === 'search') {
     	regionSelection.style.display = 'block';  // 검색 탭에서는 보이도록
        const province = document.getElementById('province-select').value;
        const city = document.getElementById('city-select').value;
        fetchParkingLotData(province, city);
    } else {
        regionSelection.style.display = 'none';  // 다른 탭에서는 숨기도록
}
}
// 초기 로드시 'search' 탭을 기본으로 설정
document.addEventListener('DOMContentLoaded', function() {
    showTab('search');
});


    // 페이지 데이터 로드
function loadPageData(data) {
    console.log("loadPageData 호출됨"); // 함수 호출 로그


    const tabContent = document.getElementById('search'); // 검색 탭의 요소를 지정
    const parkingList = tabContent.querySelector('.parking-list');
    parkingList.innerHTML = ''; // 기존 데이터를 지우기
    
    // 페이지 시작 및 끝 인덱스 계산
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const pageData = data.slice(startIndex, endIndex);
    console.log("페이지 데이터:", pageData); // 전달되는 데이터 확인
    renderParkingList(pageData);
    displayPagination(data.length);
}

    
   // 페이지네이션을 생성하는 함수
function displayPagination(totalItems) {
    const totalPages = Math.ceil(totalItems / itemsPerPage); // 전체 페이지 수 계산
    const paginationContainer = document.getElementById('pagination');
    paginationContainer.innerHTML = ''; // 기존 버튼 초기화

    // 페이지 번호 버튼 생성
    for (let i = 1; i <= totalPages; i++) {
        const pageButton = document.createElement('button');
        pageButton.innerText = i;
        pageButton.addEventListener('click', () => {
            currentPage = i; // 버튼이 클릭된 페이지 번호로 현재 페이지 변경
            loadPageData(filteredParkingData); // 현재 필터링된 데이터를 기반으로 페이지 로드
        });

        // 현재 페이지인 경우 버튼 강조
        if (i === currentPage) {
            pageButton.classList.add('active');
        }

        paginationContainer.appendChild(pageButton);
    }
}


// App이라는 네임스페이스로 모든 기능을 묶기
const App = {
    regions: {
        "서울특별시": ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"],
        
        "부산광역시": ["중구", "서구", "동구", "영도구", "부산진구", "동래구", "남구", "북구", "해운대구", "사하구", "금정구", "강서구", "연제구", "수영구", "사상구", "기장군"],
        
        "대구광역시": ["중구", "동구", "서구", "남구", "북구", "수성구", "달서구", "달성군"],

        "대전광역시": ["동구", "중구", "서구", "유성구", "대덕구"],

        "인천광역시": ["중구", "동구", "남구", "연수구", "남동구", "부평구", "계양구", "서구", "강화군", "옹진군"],
        
        "광주광역시": ["동구", "서구", "남구", "북구", "광산구"],
        "울산광역시": ["중구", "남구", "동구", "북구", "울주군"],
        "제주특별자치도": ["제주시", "서귀포시"],
        
        "경기도": ["수원시", "성남시", "고양시", "용인시", "부천시", "안산시", "안양시", "남양주시", "화성시", "평택시", "의정부시", "시흥시", "파주시", "김포시", "광명시", "군포시", "이천시", "양주시", "구리시", "오산시", "안성시", "포천시", "의왕시", "하남시", "여주시", "연천군", "가평군", "양평군", "광주시"],
        
        "강원도": ["춘천시", "원주시", "강릉시", "동해시", "태백시", "속초시", "삼척시", "홍천시", "횡성시", "영월시", "평창시", "정선시", "철원시", "화천시", "양구시", "인제시", "고성시", "양양시"],
        
        "충청남도" :["천안시", "공주시", "보령시", "아산시", "서산시", "논산시", "계룡시", "당진시"],
        "충청북도" : ["청주시", "제천시", "충주시", "음성군", "진천군", "증평군", "괴산군", "단양군", "보은군", "옥천군", "영동군"],
        
        "경상남도": ["창원시", "김해시", "진주시", "양산시", "거제시", "통영시", "사천시", "밀양시", "함안군", "거창군", "창녕군", "고성군", "하동군", "합천군", "남해군", "함양군", "산청군", "의령군"],
       "경상북도": ["포항시", "경주시", "김천시", "안동시", "구미시", "영주시", "영천시", "상주시", "문경시", "경산시", "의성군", "청송군", "영양군", "영덕군", "청도군", "고령군", "성주군", "칠곡군", "예천군", "봉화군", "울진군", "울릉군"],


        "전라남도": ["목포시", "여수시", "순천시", "광양시", "담양군", "진도군", "나주시", "영암군", "강진군", "해남군", "무안군", "함평군", "영광군", "장성군", "완도군", "보성군", "화순군", "곡성군", "구례군"],


        "전라북도": ["전주시", "익산시", "군산시", "정읍시", "김제시", "남원시", "완주군", "진안군", "무주군", "장수군", "임실군", "순창군", "고창군", "부안군"]

    },

    initializeRegionSelection: function() {
        const provinceSelect = document.getElementById('province-select');
        const citySelect = document.getElementById('city-select');

        // 시/도 옵션 추가
        Object.keys(App.regions).forEach(province => {
            const option = document.createElement('option');
            option.value = province;
            option.text = province;
            provinceSelect.appendChild(option);
        });

        // 시/도 선택 시 구/군 옵션 업데이트
        provinceSelect.addEventListener('change', () => {
            const selectedProvince = provinceSelect.value;
            const cities = App.regions[selectedProvince] || [];
            
            // 기존 옵션 초기화 후 새 옵션 추가
            citySelect.innerHTML = '<option value="">전체</option>';
            cities.forEach(city => {
                const option = document.createElement('option');
                option.value = city;
                option.text = city;
                citySelect.appendChild(option);
            });
        });
    }
};

// 페이지 로드 시 지역 선택 초기화
document.addEventListener('DOMContentLoaded', App.initializeRegionSelection);


// 공공데이터 API에서 주차장 리스트 가져오기
function fetchParkingLotData(province, city ) {

    allParkingData = [];  // 전체 데이터를 저장할 배열 초기화
    let pageNo = 1;       // 첫 페이지부터 시작
    const numOfRows = 100; // 한 페이지당 최대 데이터 개수



   // 이미 계산된 전체 페이지 수를 사용하여 모든 페이지 데이터를 가져옴
  fetchTotalCount((totalCount) => {
    const totalPages = Math.ceil(totalCount / numOfRows); // 전체 페이지 수 계산

    // 2. 모든 페이지의 데이터를 순차적으로 가져오기
    function fetchNextPage() {
        if (pageNo > totalPages) {
            console.log("모든 데이터를 가져왔습니다.");
            console.log("전체 데이터:", allParkingData); // 전체 데이터를 출력
            applyFilterAndRender(allParkingData, province, city); // 모든 데이터를 가져온 후 필터링 및 렌더링
            return;
        }
    $.ajax({
        url: 'http://api.data.go.kr/openapi/tn_pubr_prkplce_info_api',
        data: {
            serviceKey: 'oI8TfXEtYCINlcIZ8eXq9tri/7FV0Fr8dSuiooyeWFio2DRnWvwjql8OYqTAdWY1r7Et21qrdPkUw6Ad/iL3xQ==', // 
            pageNo: pageNo,
            numOfRows: numOfRows,
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
                pwdbsPpkZoneYn: item.pwdbsPpkZoneYn === 'Y' ? '보유' : (item.pwdbsPpkZoneYn === 'N' ? '미보유' : '정보 없음'),
                referenceDate: item.referenceDate || '정보 없음'
            }));
          
            allParkingData = allParkingData.concat(data); // 데이터 추가
            pageNo++; // 다음 페이지로 넘어감
            fetchNextPage(); // 재귀 호출로 다음 페이지 가져오기;
            console.log("현재 페이지 번호:", pageNo); // 페이지 번호가 증가했는지 확인
        },
        error: function(error) {
            console.error("주차장 데이터를 불러오는데 실패했습니다:", error);
        }
    });
}
fetchNextPage(); // 첫 페이지 요청 시작
});
}


// 주소 필드를 기준으로 주차장 데이터를 필터링하는 함수
function filterParkingDataByRegion(data, province, city) {
    return data.filter(item => {
        const address = item.address; // 지번주소 또는 도로명주소 선택
        if (!address) return false; // 주소가 없으면 필터링 제외

        console.log("주소 필드:", address); // 주소 출력
        
        const isMatch = address.includes(province) && address.includes(city);
        // 디버그용 로그 출력
        console.log("주소 필드:", address);
        console.log("사용자가 선택한 도/시:", province);
        console.log("사용자가 선택한 구/군:", city);
        console.log("필터링 일치 여부:", isMatch);

        return isMatch;
    });
}



// 필터링과 렌더링을 수행하는 함수
function applyFilterAndRender(data, province, city) {
    const filteredData = filterParkingDataByRegion(data, province, city);
    console.log("필터링된 데이터:", filteredData);

    renderParkingList(filteredData); // 주차장 리스트 표시 함수 호출
    displayMarkers(filteredData); // 마커 표시 함수 호출
}

// 사용자가 선택한 지역을 기반으로 주차장 데이터를 불러오고 필터링하는 함수
function applyRegionFilter() {
    // 사용자 입력을 읽어옴
    const province = document.getElementById('province-select').value; // 도/시 선택값
    const city = document.getElementById('city-select').value; // 구/군 선택값
    
    filteredParkingData = filterParkingDataByRegion(allParkingData, province, city);
    currentPage = 1;
    loadPageData(filteredParkingData);
    
}



// 주차장 리스트 데이터 표시 함수
function renderParkingList(data) {
    
    const parkingList = document.getElementById('search').querySelector('.parking-list'); // 검색 탭 요소만 지정
    console.log("parkingList 요소 확인:", parkingList); // parkingList 요소가 null이 아닌지 확인
    parkingList.innerHTML = '';

     
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
            showParkingDetails(item); // 클릭 시 상세 정보 함수 호출
            moveToLocationAndShowMarker(item); // 클릭 시 마커와 지도 이동 함수 호출
        });
        parkingList.appendChild(parkingItem);
    });
     // 페이지 번호가 있는 경우 설정
     const pageNumber = document.getElementById('page-number');
     if (pageNumber) {
         pageNumber.innerText = currentPage;
     }
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



// 이전 페이지로 이동하는 함수
function prevPage() {
    if (currentPage > 1) {
        currentPage--;
        applyRegionFilter(); // 필터링된 데이터를 다시 로드
    }
}
// 다음 페이지로 이동하는 함수
function nextPage() {
    const totalPages = Math.ceil(allParkingData.length / itemsPerPage);
    if (currentPage < totalPages) {
        currentPage++;
        applyRegionFilter(); // 필터링된 데이터를 다시 로드
    }
}
// 총 데이터 개수를 가져오는 함수
function fetchTotalCount(callback) {
    console.log("fetchTotalCount 함수 호출됨");  // 함수 호출 확인 로그
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
// fetchTotalCount 함수 호출 및 totalCount 확인
fetchTotalCount(function(totalCount) {
    console.log("총 데이터 개수:", totalCount); // 전체 데이터 개수 출력
    
});


// 클릭한 주차장의 모든 정보를 표시하고 팝업을 여는 함수
function showParkingDetails(item) {
    console.log("showParkingDetails 함수의 item 객체:", item); // parking 객체 확인
    const detailsContainer = document.getElementById('parking-details'); // 상세 정보 표시 영역

    detailsContainer.innerHTML = `
        <h2>${item.name}</h2>
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
        <p>장애인 전용 주차 구역 보유 여부:  ${item.pwdbsPpkZoneYn === 'Y' ? '보유' : item.pwdbsPpkZoneYn === 'N' ? '미보유' : '정보 없음'}</p>
        <p>위도: ${item.latitude}</p> 
         <p>경도: ${item.longitude}</p> 
        <p>데이터 기준 일자: ${item.referenceDate || '정보 없음'}</p>
    `;

    // 팝업을 보이도록 설정
    document.getElementById('parking-details-popup').style.display = 'block';
}

// 팝업을 닫는 함수
function closeParkingDetails() {
    document.getElementById('parking-details-popup').style.display = 'none';
}


// 길찾기 기능 구현 자바스크립트 함수들

//1. 검색하면 출발지, 도착지가 맵에 찍히게 구현

// 자동완성 검색 함수
function searchAutocomplete(event, type) {
    const keyword = document.getElementById(type === 'start' ? 'start-location' : 'end-location').value;
    const resultsContainer = document.getElementById(type === 'start' ? 'start-search-results' : 'end-search-results'); // 각 검색 필드에 맞는 결과 컨테이너 선택

    if (!keyword) {
        resultsContainer.style.display = 'none';
        selectedIndex = -1; // 인덱스 초기화
        return;
    }

    // 키보드 이벤트 처리
    if (event.key === "ArrowDown") {
        selectedIndex = (selectedIndex + 1) % resultsContainer.querySelectorAll('.autocomplete-item').length;
        highlightRouteItem(selectedIndex, resultsContainer); // highlightRouteItem으로 변경
        event.preventDefault();
        return;
    } else if (event.key === "ArrowUp") {
        selectedIndex = (selectedIndex - 1 + resultsContainer.querySelectorAll('.autocomplete-item').length) % resultsContainer.querySelectorAll('.autocomplete-item').length;
        highlightRouteItem(selectedIndex, resultsContainer); // highlightRouteItem으로 변경
        event.preventDefault();
        return;
    } else if (event.key === "Enter" && selectedIndex >= 0) {
        const selectedItem = resultsContainer.querySelectorAll('.autocomplete-item')[selectedIndex];
        selectedItem.click(); // 선택된 항목 클릭 시 검색 실행
        selectedIndex = -1;
        return;
    }

    // 장소 검색 API 호출 (Arrow 키 및 Enter 키가 아닌 경우에만 호출)
    if (!['ArrowDown', 'ArrowUp', 'Enter'].includes(event.key)) {
        ps.keywordSearch(keyword, function(data, status) {
            if (status === kakao.maps.services.Status.OK) {
                displayRouteAutocompleteResults(data, type, resultsContainer);
            } else {
                resultsContainer.style.display = 'none';
            }
        });
    }
}

// 자동완성 결과 표시 함수
function displayRouteAutocompleteResults(data, type, resultsContainer) {
    resultsContainer.innerHTML = ''; // 기존 검색 결과 초기화
    resultsContainer.style.display = 'block';
    selectedIndex = -1; // 새로운 검색어가 입력될 때마다 선택 초기화

    data.forEach((place, index) => {
        const item = document.createElement('div');
        item.textContent = place.place_name;
        item.classList.add('autocomplete-item');
        
        // 마우스 클릭 시 해당 항목 선택 가능
        item.onclick = () => {
            selectPlace(place, type);
            resultsContainer.style.display = 'none';
        };

        resultsContainer.appendChild(item);
    });
}

// 특정 항목을 강조 표시하는 함수 (이름 변경)
function highlightRouteItem(index, container) {
    const items = container.querySelectorAll('.autocomplete-item');
    
    // 모든 항목의 강조 표시 제거
    items.forEach(item => item.classList.remove('route-highlight'));

    // 인덱스가 유효할 때만 강조 표시 추가
    if (index >= 0 && index < items.length) {
        items[index].classList.add('route-highlight');
    }
}


// 장소 선택 함수
function selectPlace(place, type) {
    const inputField = document.getElementById(type === 'start' ? 'start-location' : 'end-location');
    inputField.value = place.place_name; // 선택한 장소 이름을 입력 창에 설정



    // 마커 설정
    const location = new kakao.maps.LatLng(place.y, place.x);
    if (type === 'start') {
        if (startMarker) startMarker.setMap(null); // 기존 마커 제거
        startMarker = new kakao.maps.Marker({
            position: location
        });
        startMarker.setMap(map);
    } else {
        if (endMarker) endMarker.setMap(null); // 기존 마커 제거
        endMarker = new kakao.maps.Marker({
            position: location
        });
        endMarker.setMap(map);
    }

    // 지도 중심 이동
    map.panTo(location);

     // 검색 결과 창 닫기
    const resultsContainer = document.getElementById(type === 'start' ? 'start-search-results' : 'end-search-results');
    resultsContainer.style.display = 'none';
}

// 검색 결과 표시용 HTML 요소 (선택 사항)
function setupSearchResultsContainer() {
    const container = document.createElement('div');
    container.id = 'search-results';
    container.className = 'search-results';
    container.style.display = 'none';
    document.body.appendChild(container);
}

// 페이지 로드 시 검색 결과 표시용 컨테이너 생성
document.addEventListener('DOMContentLoaded', setupSearchResultsContainer);



//길찾기 기능
//2. 카카오 모빌리티로 연결


// 출발지와 도착지의 좌표를 저장할 변수
let startCoords = null;
let endCoords = null;

function selectPlace(place, type) {
    const inputField = document.getElementById(type === 'start' ? 'start-location' : 'end-location');
    inputField.value = place.place_name; // 선택한 장소 이름을 입력 창에 설정

    // 선택된 장소의 좌표 저장
    const location = `${place.x},${place.y}`; // 경도, 위도 형식

    if (type === 'start') {
        startCoords = location;
        console.log("출발지 좌표 저장:", startCoords); // 출발지 좌표 확인용 로그
        if (startMarker) startMarker.setMap(null); // 기존 마커 제거
        startMarker = new kakao.maps.Marker({
            position: new kakao.maps.LatLng(place.y, place.x)
        });
        startMarker.setMap(map);
    } else {
        endCoords = location;
        console.log("도착지 좌표 저장:", endCoords); // 도착지 좌표 확인용 로그
        if (endMarker) endMarker.setMap(null); // 기존 마커 제거
        endMarker = new kakao.maps.Marker({
            position: new kakao.maps.LatLng(place.y, place.x)
        });
        endMarker.setMap(map);
    }

    // 지도 중심 이동
    map.panTo(new kakao.maps.LatLng(place.y, place.x));

    // 검색 결과 창 닫기
    document.getElementById('search-results').style.display = 'none';
}


//길찾기 API 호출 및 결과 표시
function findRoute() {
    // 출발지와 도착지 좌표가 모두 설정되었는지 확인
    if (!startCoords || !endCoords) {
        alert("출발지와 도착지를 모두 선택해 주세요.");
        return;
    }

    // 길찾기 API 요청 URL 생성
    const url = `https://apis-navi.kakaomobility.com/v1/directions?origin=${startCoords}&destination=${endCoords}&priority=RECOMMEND&car_fuel=GASOLINE&car_hipass=false&alternatives=false&road_details=false`;

    // 길찾기 API 호출
    fetch(url, {
        method: 'GET',
        headers: {
            'Authorization': `KakaoAK ${REST_API_KEY}` // REST API 키 설정
        }
    })
    .then(response => response.json())
    .then(data => {
        displayRoute(data); // 경로 데이터를 화면에 표시하는 함수 호출
    })
    .catch(error => {
        alert("길찾기 API 요청에 실패했습니다.");
    });
}



//경로 데이터 표시
function displayRoute(data) {
    const routeDirections = document.getElementById("route-directions");
    routeDirections.innerHTML = ''; // 기존 결과 초기화

    // 경로 데이터에서 주요 정보 추출 및 표시
    if (data.routes && data.routes[0]) {
        const route = data.routes[0];
        const summary = route.summary;
        const sections = route.sections;

        // 요약 정보 표시
        const distance = summary.distance; // 총 거리 (미터 단위)
        const duration = summary.duration; // 예상 소요 시간 (초 단위)
        
        routeDirections.innerHTML += `
            <h3>경로 요약</h3>
            <p>총 거리: ${(distance / 1000).toFixed(2)} km</p>
            <p>예상 소요 시간: ${(duration / 60).toFixed(0)} 분</p>
        `;


        // 길 안내 정보 표시
        routeDirections.innerHTML += `<h3>길 안내</h3>`;
        sections.forEach(section => {
            section.guides.forEach(guide => {
                routeDirections.innerHTML += `
                    <p>${guide.guidance} (${guide.distance} m)</p>
                `;
            });
        });
    } else {
        routeDirections.innerHTML = '<p>경로를 찾을 수 없습니다.</p>';
    }
}


//큰 서치바 검색 기능

// 검색 함수
function searchParking() {
    const searchInput = document.getElementById("parking-search").value.toLowerCase();
    const resultsContainer = document.getElementById("autocomplete-results");

    if (!searchInput) {
        resultsContainer.style.display = 'none'; // 검색어가 없으면 자동완성 창 숨기기
        selectedIndex = -1; // 인덱스 초기화
        return;
    }

    // 검색어와 일치하는 주차장 목록 필터링
    const filteredData = allParkingData.filter(parking =>
        parking.name && parking.name.toLowerCase().includes(searchInput)
    );

    // 자동완성 결과 표시
    displayAutocompleteResults(filteredData);

      // 키보드 이벤트 처리
      if (event.key === "ArrowDown") {
        // 아래 방향키를 누르면 인덱스 증가
        selectedIndex = (selectedIndex + 1) % filteredData.length;
        highlightItem(selectedIndex);
    } else if (event.key === "ArrowUp") {
        // 위 방향키를 누르면 인덱스 감소
        selectedIndex = (selectedIndex - 1 + filteredData.length) % filteredData.length;
        highlightItem(selectedIndex);
    } else if (event.key === "Enter" && selectedIndex >= 0) {
        // 엔터 키로 선택 항목 검색
        const selectedParking = filteredData[selectedIndex];
        document.getElementById("parking-search").value = selectedParking.name;
        resultsContainer.style.display = 'none';
        renderParkingList([selectedParking]); // 선택한 항목을 리스트에 표시
        selectedIndex = -1; // 인덱스 초기화
    }
}
// 자동완성 항목을 강조 표시하는 함수
function highlightItem(index) {
    const resultsContainer = document.getElementById("autocomplete-results");
    const items = resultsContainer.querySelectorAll('.autocomplete-item');
    
    // 모든 항목의 강조 표시 제거
    items.forEach(item => item.classList.remove('highlight'));

    // 인덱스가 유효할 때만 강조 표시 추가
    if (index >= 0 && index < items.length) {
        items[index].classList.add('highlight');
    }
}

// 자동완성 결과 표시 함수
function displayAutocompleteResults(data) {
    const resultsContainer = document.getElementById("autocomplete-results");
    resultsContainer.innerHTML = ''; // 기존 검색 결과 초기화

    if (data.length === 0) {
        resultsContainer.style.display = 'none'; // 검색 결과가 없으면 자동완성 창 숨기기
        return;
    }

    // 필터링된 주차장 데이터를 자동완성 목록에 표시
    data.forEach(parking => {
        const item = document.createElement('div');
        item.textContent = parking.name;
        item.classList.add('autocomplete-item');
        
        // 주차장 이름을 클릭했을 때 검색창에 선택된 이름을 설정하고 자동완성 목록 숨김
        item.onclick = () => {
            document.getElementById("parking-search").value = parking.name;
            resultsContainer.style.display = 'none';
             // 선택한 주차장 정보를 parking-list에 표시
              renderParkingList([parking]); // 배열 형식으로 전달하여 단일 항목 표시
        };

        resultsContainer.appendChild(item);
    });

    resultsContainer.style.display = 'block'; // 자동완성 결과 표시
}

