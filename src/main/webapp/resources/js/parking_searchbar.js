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

let polyline = null; // 전역 변수로 폴리라인 선언

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

    // 주소 표시 (지번 주소가 없으면 도로명 주소 사용)
    const address = item.address || '주소 정보 없음';
    detailsContainer.innerHTML = `
        <h2 class="parking-title">${item.name}</h2>
        <p class="info-address"><strong></strong> ${address}</p>
        <div class="info-type-label"><p class="info-type-se">${item.prkplceSe || '정보 없음'}</p>
        <p class="info-type-ty">${item.prkplceType || '정보 없음'}</p></div>
        <button class="info-coordinates-btn" id="navigate-btn">길찾기</button>
        <p class="info-charge">운영 시간 </p>
         <table class="info-table">
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
        <p class="info-charge info-divider">추가 정보</p>
        <p class="info-capacity info-divider">주차 구획 수: ${item.prkcmprt || '정보 없음'}</p>
        <p class="info-contact info-divider">전화번호: ${item.phone || '정보 없음'}</p>
        <p class="info-accessibility info-divider">장애인 전용 주차 구역 보유 여부: ${item.pwdbsPpkZoneYn === 'Y' ? '보유' : item.pwdbsPpkZoneYn === 'N' ? '미보유' : '정보 없음'}</p>
        
    `;
    // <p class="info-date">데이터 기준 일자: ${item.referenceDate || '정보 없음'}</p> 위에 코드 삽입할지 말지 고민 중
    // 팝업을 보이도록 설정
    document.getElementById('parking-details-popup').style.display = 'block';
    
    const roadview = new kakao.maps.Roadview(roadviewContainer);
    const roadviewClient = new kakao.maps.RoadviewClient();
    
    if (item.latitude && item.longitude) {
        const position = new kakao.maps.LatLng(item.latitude, item.longitude);
    
        roadviewClient.getNearestPanoId(position, 50, function(panoId) {
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
        document.getElementById('navigate-btn').addEventListener('click', () => {
        const latitude = item.latitude || '정보 없음';
        const longitude = item.longitude || '정보 없음';

        if (latitude !== '정보 없음' && longitude !== '정보 없음') {
            const endLocationInput = document.getElementById('end-location');
            endLocationInput.value = item.name; // 도착지 입력 필드에 장소명 설정
            
            // 도착지 좌표 설정
            endCoords = `${longitude},${latitude}`;

            // 길찾기 탭으로 전환
             showTab('route'); // 기존 탭 전환 함수 호출
        } else {
            alert('위도와 경도 정보가 없습니다.');
        }
    });

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


function selectPlace(place, type) {
    const inputField = document.getElementById(type === 'start' ? 'start-location' : 'end-location');
    inputField.value = place.place_name; // 선택한 장소 이름을 입력 창에 설정

    // 선택된 장소의 좌표 저장
    const location = `${place.x},${place.y}`; // 경도, 위도 형식

    if (type === 'start') {
        startCoords = location;
        if (startMarker) startMarker.setMap(null); // 기존 마커 제거
        startMarker = new kakao.maps.Marker({
            position: new kakao.maps.LatLng(place.y, place.x)
        });
        startMarker.setMap(map);
    } else {
        endCoords = location;
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

async function findRoute() {
    const startLocationInput = document.getElementById('start-location').value;

    try {
        // 출발지 좌표가 설정되지 않은 경우, 입력값으로 변환
        if (!startCoords) {
            await convertAddressToCoords(startLocationInput, 'start');
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
        displayRoute(data); // 텍스트 안내
    } catch (error) {
        console.error("길찾기 실패:", error);
        alert(`길찾기 실패: ${error}`);
    }
}



//경로 데이터 표시(텍스트)
function displayRoute(data) {
    const routeDirections = document.getElementById("route-directions");
    routeDirections.innerHTML = ''; // 기존 결과 초기화

    if (data.routes && data.routes.length > 0) {
        const route = data.routes[0];
        const summary = route.summary || null;
        const sections = route.sections || [];

        // 요약 정보 표시
        if (summary) {
            const distance = summary.distance; // 총 거리 (미터 단위)
            const duration = summary.duration; // 예상 소요 시간 (초 단위)

            routeDirections.innerHTML += `
                <h4>경로 요약</h4>
                <p>총 거리: ${(distance / 1000).toFixed(2)} km</p>
                <p>예상 소요 시간: ${(duration / 60).toFixed(0)} 분</p>
            `;
        } else {
            routeDirections.innerHTML += '<p>요약 정보를 가져올 수 없습니다.</p>';
        }

		       // 길 안내 정보 표시
		if (sections.length > 0) {
		    routeDirections.innerHTML += `<h3>길 안내</h3>`;
		    sections.forEach(section => {
		        if (section.guides) {
		            section.guides.forEach(guide => {
		                // type에 따라 아이콘 URL 가져오기
		                const iconUrl = typeIconMap[guide.type] || "https://img.icons8.com/?size=100&id=100000&format=png"; // 기본 아이콘(직진)
		                
		                // 길 안내 정보를 HTML에 추가
		                routeDirections.innerHTML += `
		                    <div class="guide-info">
		                        <img src="${iconUrl}" alt="길안내 아이콘" class="guide-icon">
		                        <span>${guide.guidance} (${guide.distance} m)</span>
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


// 경로 데이터를 지도에 표시
function displayRouteOnMap(route) {
   // 이전 폴리라인 제거
   if (polyline) {
    polyline.setMap(null); // 기존 폴리라인을 지도에서 제거
    polyline = null; // 변수 초기화
}

    // 경로 데이터를 처리하여 폴리라인에 사용할 좌표 배열 생성
    const path = route.sections.flatMap(section => 
        section.guides.map(guide => new kakao.maps.LatLng(guide.y, guide.x))
    );

    // 폴리라인 생성
    polyline = new kakao.maps.Polyline({
        path: path, // 경로 좌표 데이터
        strokeWeight: 4, // 선 두께
        strokeColor: '#FF0000', // 선 색상
        strokeOpacity: 0.7, // 선 불투명도
        strokeStyle: 'solid' // 선 스타일
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
//     // 필터링된 주차장 데이터를 자동완성 목록에 표시
//     data.forEach(parking => {
//         const item = document.createElement('div');
//         item.textContent = parking.name;
//         item.classList.add('autocomplete-item');
        
//         // 주차장 이름을 클릭했을 때 검색창에 선택된 이름을 설정하고 자동완성 목록 숨김
//         item.onclick = () => {
//             document.getElementById("parking-search").value = parking.name;
//             resultsContainer.style.display = 'none';
//              // 선택한 주차장 정보를 parking-list에 표시
//               renderParkingList([parking]); // 배열 형식으로 전달하여 단일 항목 표시
//         };

//         resultsContainer.appendChild(item);
//     });

//     resultsContainer.style.display = 'block'; // 자동완성 결과 표시

//     // 외부 클릭 감지 및 자동완성 창 닫기
//     document.addEventListener('click', (event) => {
//         const searchInput = document.getElementById("parking-search"); // 검색 입력 필드
//         if (
//             !resultsContainer.contains(event.target) && // 클릭 대상이 자동완성 창 내부가 아니고
//             event.target !== searchInput // 클릭 대상이 검색창이 아닐 때
//         ) {
//             resultsContainer.style.display = 'none'; // 자동완성 창 닫기
//         }
//     }, { once: true }); // 한 번 실행 후 리스너 제거
// }

//현재 위치를 지도에 표시
function showCurrentLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            (position) => {
                const latitude = position.coords.latitude; // 위도
                const longitude = position.coords.longitude; // 경도

                // 현재 위치 마커 생성
                const marker = new kakao.maps.Marker({
                    position: new kakao.maps.LatLng(latitude, longitude), // 마커 위치 설정
                    map: map // 마커를 표시할 지도
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


    
// 지도타입 컨트롤의 지도 또는 스카이뷰 버튼을 클릭하면 호출되어 지도타입을 바꾸는 함수
function setMapType(maptype) { 
    var roadmapControl = document.getElementById('btnRoadmap');
    var skyviewControl = document.getElementById('btnSkyview'); 
    if (maptype === 'roadmap') {
        map.setMapTypeId(kakao.maps.MapTypeId.ROADMAP);    
        roadmapControl.className = 'selected_btn';
        skyviewControl.className = 'btn';
    } else {
        map.setMapTypeId(kakao.maps.MapTypeId.HYBRID);    
        skyviewControl.className = 'selected_btn';
        roadmapControl.className = 'btn';
    }
}

// 지도 확대, 축소 컨트롤에서 확대 버튼을 누르면 호출되어 지도를 확대하는 함수
function zoomIn() {
    map.setLevel(map.getLevel() - 1);
}

// 지도 확대, 축소 컨트롤에서 축소 버튼을 누르면 호출되어 지도를 확대하는 함수
function zoomOut() {
    map.setLevel(map.getLevel() + 1);
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