//현재 페이지와 데이터 세팅
let currentPage = 1;
//페이지당 아이템 수
const itemsPerPage = 5;

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
function fetchParkingLotData(tabName) {
    $.ajax({
        url: 'http://api.data.go.kr/openapi/tn_pubr_prkplce_info_api',
        data: {
            serviceKey: 'oI8TfXEtYCINlcIZ8eXq9tri/7FV0Fr8dSuiooyeWFio2DRnWvwjql8OYqTAdWY1r7Et21qrdPkUw6Ad/iL3xQ==', // 공공데이터 포털에서 발급받은 서비스 키를 입력하세요.
            pageNo: currentPage,
            numOfRows: itemsPerPage,
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
                address: item.lnmadr || item.rdnmadr || '주소 정보 없음', // 지번주소가 없으면 도로명주소 사용, 둘 다 없으면 기본 메시지
                phone: item.phoneNumber || '전화번호 정보 없음' // 전화번호 정보
            }));
            renderParkingList(data, tabName); // 주차장 리스트 표시 함수 호출
        },
        error: function(error) {
            console.error("주차장 데이터를 불러오는데 실패했습니다:", error);
        }
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
        parkingList.appendChild(parkingItem);
    });
    document.getElementById('page-number').innerText = currentPage; // 현재 페이지 번호 표시
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

// 초기 데이터 로드
showTab('nearby');