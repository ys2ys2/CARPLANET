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
    var map = new kakao.maps.Map(container, options);
    
     // 주차장 데이터 불러오기 함수 호출
    fetchParkingLotData();
});





    //카카오 지도와 주차장 위치 연결
    function setMarkerOnMap(lat, lng){
        const mapContainer = document.getElementById('map'); //지도 표시할 div 선택
        const mapOptions = {
            center: new kakao.maps.LatLng(lat, lng), //지정한 좌표를 중심으로 지도 표시
            level: 3 //확대 레벨 설정
        };
        const map = new kakao.maps.Map(mapContainer, mapOptions); //지도 객체 생성

        //마커 위치와 설정
        const markerPosition = new kakao.maps.LatLng(lat, lng);
        const marker = new kakao.maps.Marker({
            position: markerPosition //마커의 위치 설정
        });
        marker.setMap(map); //지도에 마커 표시
    }

    //클릭한 주차장의 모든 정보를 표시하는 함수
    function showParkingDetails(parking) {
        const detailsContainer = document.getElementById('parking-details'); // 상세 정보 표시 영역
    
        detailsContainer.innerHTML = `
            <h2>${parking.prkplceNm}</h2>
            <p>주차장 관리번호: ${parking.prkplceNo}</p>
            <p>주차장 구분: ${parking.prkplceSe}</p>
            <p>주차장 유형: ${parking.prkplceType}</p>
            <p>도로명 주소: ${parking.rdnmadr}</p>
            <p>지번 주소: ${parking.lnmadr}</p>
            <p>주차 구획 수: ${parking.prkcmprt}</p>
            <p>운영 요일: ${parking.operDay}</p>
            <p>평일 운영 시간: ${parking.weekdayOperOpenHhmm} - ${parking.weekdayOperColseHhmm}</p>
            <p>토요일 운영 시간: ${parking.satOperOperOpenHhmm} - ${parking.satOperCloseHhmm}</p>
            <p>공휴일 운영 시간: ${parking.holidayOperOpenHhmm} - ${parking.holidayCloseOpenHhmm}</p>
            <p>요금 정보: ${parking.parkingchrgeInfo}</p>
            <p>기본 시간: ${parking.basicTime}</p>
            <p>기본 요금: ${parking.basicCharge}</p>
            <p>추가 단위 시간: ${parking.addUnitTime}</p>
            <p>추가 단위 요금: ${parking.addUnitCharge}</p>
            <p>1일 주차권 요금 적용 시간: ${parking.dayCmmtktAdjTime}</p>
            <p>1일 주차권 요금: ${parking.dayCmmtkt}</p>
            <p>월 정기권 요금: ${parking.monthCmmtkt}</p>
            <p>결제 방법: ${parking.metpay}</p>
            <p>특기 사항: ${parking.spcmnt}</p>
            <p>관리 기관명: ${parking.institutionNm}</p>
            <p>전화번호: ${parking.phoneNumber}</p>
            <p>위도: ${parking.latitude}, 경도: ${parking.longitude}</p>
            <p>장애인 전용 주차 구역 보유 여부: ${parking.pwdbsPpkZoneYn}</p>
            <p>데이터 기준 일자: ${parking.referenceDate}</p>
        `;
    // 지도의 해당 위치로 마커 표시
    setMarkerOnMap(parking.latitude, parking.longitude);
    
        // 모달 열기 (모달을 사용한다면)
        detailsContainer.style.display = 'block';
    }
    