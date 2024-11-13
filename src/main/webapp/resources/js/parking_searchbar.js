//현재 페이지와 데이터 세팅
let currentPage = 1;
//페이지당 아이템 수
const itemsPerPage = 4;
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

// //탭 전환 함수
// function showTab(tabName){
//     document.querySelectorAll('.tab-content').forEach(tab => {
//     });
//     document.getElementById(tabName).style.display = 'block';

//     document.querySelectorAll('.tab-button').forEach(button => {
//         button.classList.remove('active');
//     });
//     document.querySelector(`[onclick="showTab('${tabName}')"]`).classList.add('active');

//     const province = document.getElementById('province-select').value;
//     const city = document.getElementById('city-select').value;

//     if (tabName === 'search') { // 검색 탭이 활성화될 때만 데이터를 로드
//         fetchParkingLotData(province, city);
//     }
// }


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
        "제주특별자치시": ["제주시", "서귀포시"],
        
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

     // 전체 데이터를 불러오기 위해 한 번만 API를 호출하고, 이미 데이터가 있으면 바로 필터링과 렌더링으로 이동
     if (allParkingData.length > 0) {
        applyFilterAndRender(allParkingData, tabName, province, city);
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
                pwdbsPpkZoneYn: item.pwdbsPpkZoneYn || '정보 없음',
                referenceDate: item.referenceDate || '정보 없음'
            }));
          
            // 전체 데이터를 allParkingData에 저장
            allParkingData = data;
            
            // 필터링과 렌더링을 수행
            applyFilterAndRender(allParkingData,province, city);
        },
        error: function(error) {
            console.error("주차장 데이터를 불러오는데 실패했습니다:", error);
        }
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
            console.log("주차장 항목 클릭됨:", item); // 클릭 로그 추가
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