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




// 출발지와 도착지 마커를 전역 변수로 생성
var originMarker = new kakao.maps.Marker({
    image: new kakao.maps.MarkerImage(
        'https://t1.daumcdn.net/localimg/localimages/07/2018/pc/flagImg/blue_b.png', // 파란색 마커 이미지
        new kakao.maps.Size(35, 40) // 마커 크기
    )
});

var destinationMarker = new kakao.maps.Marker({
    image: new kakao.maps.MarkerImage(
        'https://t1.daumcdn.net/localimg/localimages/07/2018/pc/flagImg/red_b.png', // 빨간색 마커 이미지
        new kakao.maps.Size(35, 40) // 마커 크기
    )
});

var polyline; // 경로를 표시할 폴리라인 객체




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

     // 'search' 탭이 활성화될 때만 지역 선택 창과 페이지네이션 보이게 함
     const regionSelection = document.querySelector('.region-selection');
     const paginationContainer = document.getElementById('pagination');
 
     if (tabName === 'search') {
         regionSelection.style.display = 'block'; // 검색 탭에서는 지역 선택창 표시
         const province = document.getElementById('province-select').value;
         const city = document.getElementById('city-select').value;
         fetchParkingLotData(province, city); // 데이터 로드
         paginationContainer.style.display = 'block'; // 페이지네이션 표시
     } else {
         regionSelection.style.display = 'none'; // 다른 탭에서는 지역 선택창 숨기기
         paginationContainer.style.display = 'none'; // 페이지네이션 숨기기
     }
 }
 
 // 초기 로드시 'search' 탭을 기본으로 설정
 document.addEventListener('DOMContentLoaded', function () {
     showTab('search');
 });

    // 페이지 데이터 로드
function loadPageData(data) {


    const tabContent = document.getElementById('search'); // 검색 탭의 요소를 지정
    const parkingList = tabContent.querySelector('.parking-list');
    parkingList.innerHTML = ''; // 기존 데이터를 지우기
    
    // 페이지 시작 및 끝 인덱스 계산
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const pageData = data.slice(startIndex, endIndex);
    renderParkingList(pageData);
    displayPagination(data.length);
}

    // 페이지네이션을 생성하는 함수
function displayPagination(totalItems) {
    const totalPages = Math.ceil(totalItems / itemsPerPage); // 전체 페이지 수 계산
    const paginationContainer = document.getElementById('pagination');
    paginationContainer.innerHTML = ''; // 기존 버튼 초기화

    // 현재 탭이 'search'가 아닐 경우 페이지네이션 숨김
    const activeTab = document.querySelector('.tab-content:not([style*="display: none"])').id;
    if (activeTab !== 'search') {
        paginationContainer.style.display = 'none'; // 페이지네이션 숨기기
        return;
    }
    paginationContainer.style.display = 'block'; // 페이지네이션 보이기

    // 한 화면에 보여질 페이지네이션 버튼 수
    const paginationGroupSize = 5;

    // 현재 그룹 계산
    const currentGroup = Math.ceil(currentPage / paginationGroupSize); // 현재 페이지에 따라 그룹 계산
    const startPage = (currentGroup - 1) * paginationGroupSize + 1; // 현재 그룹의 첫 페이지 번호
    const endPage = Math.min(startPage + paginationGroupSize - 1, totalPages); // 현재 그룹의 마지막 페이지 번호

    // 이전 그룹 버튼 추가 (이전 그룹이 있는 경우에만 표시)
    if (currentGroup > 1) {
        const prevGroupButton = document.createElement('button');
        prevGroupButton.innerText = '«';
        prevGroupButton.addEventListener('click', () => {
            currentPage = startPage - 1; // 이전 그룹의 마지막 페이지로 이동
            displayPagination(totalItems); // 페이지네이션 다시 렌더링
            loadPageData(filteredParkingData); // 데이터 다시 로드
        });
        paginationContainer.appendChild(prevGroupButton);
    }

    // 현재 그룹의 페이지 번호 버튼 생성
    for (let i = startPage; i <= endPage; i++) {
        const pageButton = document.createElement('button');
        pageButton.innerText = i;
        pageButton.addEventListener('click', () => {
            currentPage = i; // 클릭된 페이지로 현재 페이지 변경
            loadPageData(filteredParkingData); // 데이터 다시 로드
            displayPagination(totalItems); // 페이지네이션 다시 렌더링
        });

        // 현재 페이지인 경우 버튼 강조
        if (i === currentPage) {
            pageButton.classList.add('active');
        }

        paginationContainer.appendChild(pageButton);
    }

    // 다음 그룹 버튼 추가 (다음 그룹이 있는 경우에만 표시)
    if (endPage < totalPages) {
        const nextGroupButton = document.createElement('button');
        nextGroupButton.innerText = '»';
        nextGroupButton.addEventListener('click', () => {
            currentPage = endPage + 1; // 다음 그룹의 첫 페이지로 이동
            displayPagination(totalItems); // 페이지네이션 다시 렌더링
            loadPageData(filteredParkingData); // 데이터 다시 로드
        });
        paginationContainer.appendChild(nextGroupButton);
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
                 weekdayOperColseHhmm: item.weekdayOperColseHhmm || '정보 없음',
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

        
         const isMatch = address.includes(province) && address.includes(city);

         return isMatch;
     });
 }



// 필터링과 렌더링을 수행하는 함수
function applyFilterAndRender(data, province, city) {
    const filteredData = filterParkingDataByRegion(data, province, city);

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
        // showParkingDetails(item);
    });
  
 }


// 지도에 마커를 표시하는 함수
function displayMarkers(parkingData) {
    parkingData.forEach(item => {
        // 마커 위치 설정
        var markerPosition = new kakao.maps.LatLng(item.latitude, item.longitude);
       
        // 마커 생성
        var marker = new kakao.maps.Marker({
            position: markerPosition,
            map: map//지도에 마커를 바로 표시
        });
            kakao.maps.event.addListener(marker, 'click', ()=>{
                showParkingDetails(item); //클릭된 주차장의 정보를 상세 팝업에 전달.
            });
        
        });
    };


// 주차장 리스트 클릭 시 해당 위치로 지도 이동 및 마커 표시
function moveToLocationAndShowMarker(item) {
    console.log("moveToLocationAndShowMarker 호출됨:", item); // 함수 호출 확인
   
    var latitude = item.latitude;
    var longitude = item.longitude;
 // 좌표값 확인

    // 카카오맵 LatLng 객체 생성 (위도, 경도 순서)
    var moveLatLon = new kakao.maps.LatLng(latitude, longitude);
    console.log("LatLng 객체:", moveLatLon);

    // 지도 중심을 이동하려는 위치로 설정
    map.setLevel(3); // 확대 레벨 설정
    map.panTo(moveLatLon); // 지도 중심 이동
    // 기존 마커 제거 후 새 마커 추가
    if (window.selectedMarker) {
        window.selectedMarker.setMap(null); // 기존 마커 제거
    }

    // 선택한 주차장 위치에 새 마커 생성
    var marker = new kakao.maps.Marker({
        position: moveLatLon,
        map: map, // 지도에 마커 표시
    });
    // marker.setMap(map); // 지도에 마커 표시
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
    
});

// 클릭한 주차장의 모든 정보를 표시하고 팝업을 여는 함수
function showParkingDetails(item) {
    const detailsContainer = document.getElementById('parking-details'); // 상세 정보 표시 영역
    const roadviewContainer = document.getElementById('roadview-container');

    if (!detailsContainer) {
        console.error("'parking-details' 요소를 찾을 수 없습니다.");
        return;
    }

    if (!roadviewContainer) {
        console.error("'roadview-container' 요소를 찾을 수 없습니다.");
        return;
    }

    // 주소 표시 (지번 주소가 없으면 도로명 주소 사용)
    const address = item.address || '주소 정보 없음';
    detailsContainer.innerHTML = `
        <h2 class="parking-title">${item.name}</h2>
        <p class="info-address"><strong></strong> ${address}</p>
        <div class="info-type-label">
            <p class="info-type-se">${item.prkplceSe || '정보 없음'}</p>
            <p class="info-type-ty">${item.prkplceType || '정보 없음'}</p>
        </div>
        <button class="info-coordinates-btn" id="navigate-btn"> 
            <img src="/CarPlanet/resources/images/navicon.png" alt="길찾기">길찾기
        </button>
        <p class="info-open">운영 시간 </p>
        <table class="info-table-open">
            <tbody>
                <tr>
                    <td>평일</td>
                    <td>${item.weekdayOperOpenHhmm || '정보 없음'} - ${item.weekdayOperColseHhmm || '정보 없음'}</td>
                </tr>
                <tr>
                    <td>토요일</td>
                    <td>${item.satOperOperOpenHhmm || '정보 없음'} - ${item.satOperCloseHhmm || '정보 없음'}</td>
                </tr>
                <tr>
                    <td>공휴일</td>
                    <td>${item.holidayOperOpenHhmm || '정보 없음'} - ${item.holidayCloseOpenHhmm || '정보 없음'}</td>
                </tr>
            </tbody>
        </table>
        <p class="info-charge">요금 정보</p>
        <table class="info-table">
            <tbody>
                <tr>
                    <td>기본 시간</td>
                    <td>${item.basicTime || '정보 없음'}분</td>
                </tr>
                <tr>
                    <td>기본 요금</td>
                    <td>${item.basicCharge || '정보 없음'}원</td>
                </tr>
                <tr>
                    <td>추가 시간</td>
                    <td>${item.addUnitTime || '정보 없음'}분</td>
                </tr>
                <tr>
                    <td>추가 요금</td>
                    <td>${item.addUnitCharge || '정보 없음'}원</td>
                </tr>
            </tbody>
        </table>
        <p class="info-extra info-divider">추가 정보</p>
        <p class="info-capacity info-divider">주차 구획 수: ${item.prkcmprt || '정보 없음'}</p>
        <p class="info-contact info-divider">전화번호: ${item.phone || '정보 없음'}</p>
        <p class="info-accessibility info-divider">장애인 전용 주차 구역 보유 여부: ${
            item.pwdbsPpkZoneYn === 'Y' ? '보유' : item.pwdbsPpkZoneYn === 'N' ? '미보유' : '정보 없음'
        }</p>
    `;

    // 팝업을 보이도록 설정
    document.getElementById('parking-details-popup').style.display = 'block';

    // 로드뷰 설정
    const roadview = new kakao.maps.Roadview(roadviewContainer);
    const roadviewClient = new kakao.maps.RoadviewClient();

    if (item.latitude && item.longitude) {
        const position = new kakao.maps.LatLng(item.latitude, item.longitude);

        roadviewClient.getNearestPanoId(position, 50, function (panoId) {
            if (panoId) {
                roadview.setPanoId(panoId, position);
            } else {
                roadviewContainer.innerHTML = '<p>로드뷰를 사용할 수 없는 위치입니다.</p>';
            }
        });
    } else {
        roadviewContainer.innerHTML = '<p>위치 데이터가 올바르지 않습니다.</p>';
    }

    // 길찾기 버튼 클릭 이벤트 추가
    const navigateButton = document.getElementById('navigate-btn');
    if (navigateButton) {
        navigateButton.addEventListener('click', () => {
            const latitude = item.latitude || '정보 없음';
            const longitude = item.longitude || '정보 없음';

            if (latitude !== '정보 없음' && longitude !== '정보 없음') {
                const endLocationInput = document.getElementById('end-location');
                endLocationInput.value = item.name; // 도착지 이름 설정

                // 도착지 좌표 설정
                endCoords = `${longitude},${latitude}`;

                 // 기존 도착지 마커 제거
            if (destinationMarker) {
                destinationMarker.setMap(null);
            }

            // 새로운 도착지 마커 생성
            destinationMarker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(latitude, longitude),
                map: map,
                image: new kakao.maps.MarkerImage(
                    'https://t1.daumcdn.net/localimg/localimages/07/2018/pc/flagImg/red_b.png', // 빨간색 마커 이미지
                    new kakao.maps.Size(35, 40) // 마커 크기
                )
            });

            // 지도 중심을 도착지로 이동
            map.panTo(new kakao.maps.LatLng(latitude, longitude));

            // 길찾기 탭으로 전환
            showTab('route'); // 기존 탭 전환 함수 호출
        } else {
            alert('위도와 경도 정보가 없습니다.');
        }
    });
} else {
    console.error("'navigate-btn' 버튼을 찾을 수 없습니다.");
}


}



// 팝업을 닫는 함수
function closeParkingDetails() {
    document.getElementById('parking-details-popup').style.display = 'none';
}

function resetRoute() {
    // 도착지 마커 제거
    if (endMarker) {
        console.log("길찾기 초기화: 도착지 마커 제거"); // 디버깅용 로그
        endMarker.setMap(null); // 지도에서 도착지 마커 제거
        endMarker = null; // endMarker 변수를 null로 초기화
    }

    // 도착지 좌표 초기화
    endCoords = null;

    // 입력 필드 초기화
    document.getElementById('end-location').value = ''; // 도착지 입력 필드를 빈 값으로 설정
    document.getElementById('start-location').value = ''; // 출발지 입력 필드를 빈 값으로 설정

    // 추가적으로 필요한 초기화 작업이 있다면 여기에 추가 가능
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
        // 각 장소에 맞는 아이콘 URL 가져오기
        const iconUrl = getIconUrl(place.category_group_code);

        // 아이템 컨테이너 생성
        const item = document.createElement('div');
        item.classList.add('autocomplete-item');

        // 아이콘 추가
        const icon = document.createElement('img');
        icon.src = iconUrl || 'https://img.icons8.com/?size=100&id=default-icon&format=png&color=4D4D4D'; // 기본 아이콘 설정
        icon.alt = '아이콘';
        icon.classList.add('autocomplete-icon'); // 아이콘에 스타일 적용

        // 장소 이름 추가
        const text = document.createElement('span');
        text.textContent = place.place_name;

        // 아이콘과 텍스트를 아이템에 추가
        item.appendChild(icon);
        item.appendChild(text);

        // 마우스 클릭 시 해당 항목 선택 가능
        item.onclick = () => {
            selectPlace(place, type);
            resultsContainer.style.display = 'none';
        };

        resultsContainer.appendChild(item);
    });   
     // 외부 클릭 감지 및 검색창 닫기
     document.addEventListener('click', (event) => {
        if (!resultsContainer.contains(event.target)) {
            resultsContainer.style.display = 'none';
        }
    }, { once: true }); // 한 번 실행 후 리스너 제거
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

// 스왑 버튼: 출발지와 도착지의 값을 교환 및 마커 교환
function swapLocations() {
    // 출발지와 도착지 입력 필드 가져오기
    const startLocation = document.getElementById('start-location');
    const endLocation = document.getElementById('end-location');

    // 출발지와 도착지의 값을 교환
    const tempValue = startLocation.value; // 출발지 값을 임시 변수에 저장
    startLocation.value = endLocation.value; // 도착지 값을 출발지로 복사
    endLocation.value = tempValue; // 임시 변수에 저장된 출발지 값을 도착지로 복사

    // 출발지와 도착지 마커의 좌표 교환
    if (originMarker && destinationMarker) {
        // 출발지 마커와 도착지 마커의 위치 교환
        const tempPosition = originMarker.getPosition(); // 출발지 마커 위치 저장
        originMarker.setPosition(destinationMarker.getPosition()); // 도착지 마커 위치를 출발지 마커로 설정
        destinationMarker.setPosition(tempPosition); // 임시 변수에 저장된 출발지 마커 위치를 도착지 마커로 설정
    }

    // 출발지와 도착지 좌표 교환
    const tempCoords = startCoords; // 출발지 좌표를 임시 변수에 저장
    startCoords = endCoords; // 도착지 좌표를 출발지로 복사
    endCoords = tempCoords; // 임시 변수에 저장된 출발지 좌표를 도착지로 복사

}


//초기화 버튼 기능: 출발지와 도착지 입력값 모두 초기화
function clearAllInputs() {
    //출발지와 도착지 입력 필드 가져오기 
    const startLocation = document.getElementById('start-location');
    const endLocation = document.getElementById('end-location');
    //입력값 초기회
    startLocation.value = '';
    endLocation.value = ''; //도착지 값을 빈 문자열로 설정

    //마커 제거
    originMarker.setMap(null);
    destinationMarker.setMap(null);

    if(polyline){
        polyline.setMap(null); 
        polyline =null;
    }

    //좌표 초기화
    startCoords =null;
    endCoords = null;

}




//출발지 마커 설정 함수
 function setOriginMarker(place){
    const coords =new kakao.maps.LatLng(place.y, place.x);
    
    //기존 출발지 마커 제거
    if(originMarker){
        originMarker.setMap(null);
    }

    //새로운 출발지 마커 생성  
    originMarker = new kakao.maps.Marker({
        position: coords, 
        image: new kakao.maps.MarkerImage(
            'https://t1.daumcdn.net/localimg/localimages/07/2018/pc/flagImg/blue_b.png', // 파란색 마커
            new kakao.maps.Size(35,40)
        )
    });
    originMarker.setMap(map); //지도에 표시
    map.panTo(coords); //지도 중심 이동

}

//도착지 마커 설정 함수
function setDestinationMarker(place){
    const coords = new kakao.maps.LatLng(place.y, place.x);
  
    //기존 도착지 마커 제거
    if(destinationMarker){
        destinationMarker.setMap(null);
    }
    //새로운 도착지 마커 생성
    destinationMarker = new kakao.maps.Marker({
        position: coords,
        image: new kakao.maps.MarkerImage(
            'https://t1.daumcdn.net/localimg/localimages/07/2018/pc/flagImg/red_b.png', // 빨간색 마커
            new kakao.maps.Size(35, 40)
        )
    });
    destinationMarker.setMap(map);
    map.panTo(coords); 
}


//길찾기 기능
//2. 카카오 모빌리티로 연결

// 출발지와 도착지의 좌표를 저장할 변수
let startCoords = null;
let endCoords = null;

async function convertAddressToCoords(address, type) {
    const geocoder = new kakao.maps.services.Geocoder();
    return new Promise((resolve, reject) => {
        geocoder.addressSearch(address, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                const coords = `${result[0].x},${result[0].y}`; // 경도, 위도 형식
                if (type === 'start') {
                    startCoords = coords; // 출발지 좌표 저장
                } else if (type === 'end') {
                    endCoords = coords; // 도착지 좌표 저장 (이 경우는 거의 사용하지 않음)
                }
                resolve(coords);
            } else {
                reject(`"${address}"를 좌표로 변환할 수 없습니다.`);
            }
        });
    });
}


    function selectPlace(place, type){
        const inputField = document.getElementById(type === 'start' ? 'start-location' :
            'end-location');  
            inputField.value = place.place_name //선택한 장소 이름을 입력창에 설정
    
    if(type === 'start'){
        startCoords = `${place.x}, ${place.y}`; //출발지 좌표 저장
        setOriginMarker(place); //출발지 마커설정(기존 마커 제거 포함)
    }else{
        endCoords = `${place.x}, ${place.y}`; //도착지 좌표저장
        setDestinationMarker(place);//도착지 마커설정(기존 마커 제거 포함)
    }


    }

    window.findRoute = async function findRoute() {
        // 출발지와 도착지 입력값 가져오기
        const startLocationInput = document.getElementById('start-location').value.trim();
        const endLocationInput = document.getElementById('end-location').value.trim();
    
        // 입력값 유효성 검사
        if (!startLocationInput || !endLocationInput) {
            alert("출발지와 도착지를 모두 입력해주세요.");
            return;
        }
    
        try {
            // 출발지 좌표가 설정되지 않은 경우, 주소를 좌표로 변환
            if (!startCoords) {
                await convertAddressToCoords(startLocationInput, 'start');
            }
            if (!endCoords) {
                await convertAddressToCoords(endLocationInput, 'end');
            }
    
            const url = `https://apis-navi.kakaomobility.com/v1/directions?origin=${startCoords}&destination=${endCoords}&priority=RECOMMEND&car_fuel=GASOLINE&car_hipass=false&alternatives=false&road_details=false`;
    
            const response = await fetch(url, {
                method: 'GET',
                headers: {
                    'Authorization': `KakaoAK ${REST_API_KEY}`
                }
            });
    
            if (!response.ok) {
                throw new Error(`API 호출 실패: ${response.status}`);
            }
    
            const data = await response.json();
    
            if (!data.routes || data.routes.length === 0) {
                alert("경로를 찾을 수 없습니다.");
                return;
            }
    
            // 응답 데이터를 지도에 표시
            displayRouteOnMap(data.routes[0]);
            
            // 출발지, 도착지와 함께 텍스트 안내 표시
            displayRoute(data, startLocationInput, endLocationInput);
    
        } catch (error) {
            console.error("길찾기 실패:", error);
            alert(`길찾기 실패: ${error.message}`);
        }
    };
    

function getInputValuesAndDisplayRoute(data) {
    // 출발지와 도착지 입력 필드에서 값을 가져옴
    const startLocation = document.getElementById("start-location").value.trim();
    const endLocation = document.getElementById("end-location").value.trim();

    // displayRoute 함수 호출
    displayRoute(data, startLocation, endLocation);
}






function displayRoute(data, startLocation, endLocation) {
    const routeDirections = document.getElementById("route-directions");
    routeDirections.innerHTML = ''; // 기존 결과 초기화

    if (data.routes && data.routes.length > 0) {
        const route = data.routes[0];
        const summary = route.summary || null;
        const sections = route.sections || [];


        if (summary) {
            const distance = summary.distance; // 총 거리 (미터 단위)
            const duration = summary.duration; // 예상 소요 시간 (초 단위)

            routeDirections.innerHTML += `
                <div class="route-fixed-info">
                <h4>경로 요약</h4>
                <p>총 거리: ${(distance / 1000).toFixed(2)} km</p>
                <p>예상 소요 시간: ${(duration / 60).toFixed(0)} 분</p>
				 </div>
            `;
        } else {
            routeDirections.innerHTML += '<p>요약 정보를 가져올 수 없습니다.</p>';
        }


        // 길 안내 정보 표시
        if (sections.length > 0) {
            routeDirections.innerHTML += `<h3>길 안내</h3>`;
            sections.forEach((section, sectionIndex) => {
                if (section.guides) {
                    section.guides.forEach((guide, guideIndex) => {
                        let guidanceText = guide.guidance;
                        let iconUrl = typeIconMap[guide.type] || "https://img.icons8.com/?size=100&id=100000&format=png"; // 기본 아이콘

                        // 첫 번째 가이드는 출발지로 수정
                        if (sectionIndex === 0 && guideIndex === 0) {
                            guidanceText = ` <img src="https://t1.daumcdn.net/localimg/localimages/07/2018/pc/flagImg/blue_b.png" 
                                     alt="출발지 마커" class="marker-icon"> ${startLocation}`;
                                     iconUrl = null; // 기본 아이콘 제거
                        }

                        // 마지막 가이드는 도착지로 수정
                        const isLastGuide =
                            sectionIndex === sections.length - 1 &&
                            guideIndex === section.guides.length - 1;
                        if (isLastGuide) {
                            guidanceText = ` <img src="https://t1.daumcdn.net/localimg/localimages/07/2018/pc/flagImg/red_b.png" 
                                     alt="도착지 마커" class="marker-icon">${endLocation}`;
                                     iconUrl = null; // 기본 아이콘 제거
                                    }

                        // 길 안내 정보를 HTML에 추가
                        routeDirections.innerHTML += `
                            <div class="guide-info">
                            ${iconUrl !== null && iconUrl !== undefined ? `<img src="${iconUrl}" alt="길안내 아이콘" class="guide-icon">` : ''}
                                <span>${guidanceText}</span>
                            </div>
                        `;
                    });
                }
            });
        } else {
            routeDirections.innerHTML += '<p>길 안내 정보를 가져올 수 없습니다.</p>';
        }

        // 지도에 경로 표시
        displayRouteOnMap(route);
    } else {
        routeDirections.innerHTML = '<p>경로를 찾을 수 없습니다.</p>';
    }
}

function displayRouteOnMap(route) {
    // 기존 폴리라인 제거
    if (polyline) {
        polyline.setMap(null);
        polyline = null;
    }

    // 경로 좌표 생성
    const path = route.sections.flatMap(section => 
        section.guides.map(guide => new kakao.maps.LatLng(guide.y, guide.x))
    );

    // 폴리라인 생성
    polyline = new kakao.maps.Polyline({
        path: path,
        strokeWeight: 4,
        strokeColor: '#FF0000',
        strokeOpacity: 0.7,
        strokeStyle: 'solid'
    });

    // 지도에 폴리라인 추가
    polyline.setMap(map);

    // 경로에 맞게 지도 중심과 확대 수준 설정
    const bounds = new kakao.maps.LatLngBounds();
    path.forEach(coord => bounds.extend(coord));
    map.setBounds(bounds);
}



//큰 서치바 검색 기능

// 검색 함수
function searchParking() {
    const searchInputElement = document.getElementById("parking-search");
    const searchInput = searchInputElement.value.toLowerCase();
    const resultsContainer = document.getElementById("autocomplete-results");
    // const searchInputElement = document.getElementById("parking-search");
    // const searchInput = document.getElementById("parking-search").value.toLowerCase();
    // const resultsContainer = document.getElementById("autocomplete-results");

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
        // document.getElementById("parking-search").value = selectedParking.name;
        document.getElementById("parking-search").value = "";

        resultsContainer.style.display = 'none';
        renderParkingList([selectedParking]); // 선택한 항목을 리스트에 표시
        selectedIndex = -1; // 인덱스 초기화
    }
       // 마우스 클릭 이벤트 처리
       resultsContainer.addEventListener("click", function (event) {
        const clickedItem = event.target.closest(".autocomplete-item"); // 클릭된 항목 확인
        if (clickedItem) {
            // `resultsContainer`와 `filteredData`가 항상 동기화되도록 인덱스 확인
            const index = Array.from(resultsContainer.children).indexOf(clickedItem);

            // 인덱스가 유효하지 않은 경우 바로 리턴 (에러 제거)
            if (index < 0 || index >= filteredData.length) {
                return; // 잘못된 인덱스 접근 방지
            }

            // 선택된 데이터 가져오기
            const selectedParking = filteredData[index];

            // 선택한 데이터가 유효한지 확인
            if (selectedParking && selectedParking.name) {
                searchInputElement.value = ""; // 검색창 초기화
                resultsContainer.style.display = 'none'; // 자동완성 창 닫기
                renderParkingList([selectedParking]); // 선택한 항목을 리스트에 표시
            }
        }
    });
    


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
    // 각 주차장의 아이콘 URL 가져오기
    const iconUrl = getIconUrl(parking.category_group_code);

    // 아이템 컨테이너 생성
    const item = document.createElement('div');
    item.classList.add('autocomplete-item');

    // 아이콘 추가
    const icon = document.createElement('img');
    icon.src = iconUrl || 'https://img.icons8.com/?size=100&id=default-icon&format=png&color=4D4D4D'; // 기본 아이콘 설정
    icon.alt = '아이콘';
    icon.classList.add('autocomplete-icon'); // 아이콘에 스타일 적용

    // 주차장 이름 추가
    const text = document.createElement('span');
    text.textContent = parking.name;

    // 아이콘과 텍스트를 아이템에 추가
    item.appendChild(icon);
    item.appendChild(text);

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

// 현재 위치를 지도에 표시
function showCurrentLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            (position) => {
                const latitude = position.coords.latitude; // 위도
                const longitude = position.coords.longitude; // 경도

                const markerImage = new kakao.maps.MarkerImage(
                    "https://ssl.pstatic.net/static/maps/m/pin_rd.png", //이미지 URL
                    new kakao.maps.Size(20, 20), //마커 이미지 크기
                {
                    offset: new kakao.maps.Point(12,35), //이미지의 중심 좌표
                }
                );

                // 현재 위치 마커를 감싸는 HTML 요소 생성
                const markerContent = document.createElement('div');
                markerContent.className = 'custom-marker';

                // HTML 구조
                markerContent.innerHTML = `
                    <div class="radar-effect"></div>
                    <img 
                        src="https://ssl.pstatic.net/static/maps/m/pin_rd.png" 
                        class="location-icon" 
                        alt="현재 위치">
                `;

                // 카카오맵 CustomOverlay를 이용해 마커 표시
                const markerOverlay = new kakao.maps.CustomOverlay({
                    position: new kakao.maps.LatLng(latitude, longitude),
                    content: markerContent, // 위에서 생성한 HTML 구조 삽입
                    map: map,
                    zIndex: 1
                });

                // 지도 중심을 현재 위치로 이동
                map.setCenter(new kakao.maps.LatLng(latitude, longitude));
            },
            (error) => {
                // 위치 가져오기 실패 시 처리
                switch (error.code) {
                    case error.PERMISSION_DENIED:
                        alert("위치 정보 사용 권한이 거부되었습니다.");
                        break;
                    case error.POSITION_UNAVAILABLE:
                        alert("위치 정보를 사용할 수 없습니다.");
                        break;
                    case error.TIMEOUT:
                        alert("위치 정보를 가져오는 데 시간이 초과되었습니다.");
                        break;
                    default:
                        alert("알 수 없는 오류가 발생했습니다.");
                }
            }
        );
    } else {
        alert("이 브라우저에서는 위치 정보를 지원하지 않습니다.");
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