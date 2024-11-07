//현재 페이지와 데이터 세팅
let currentPage = 1;
//페이지당 아이템 수
const itemsPerPage = 5;

//탭 전환 함수
function showTab(tabName){
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.computedStyleMap.display = 'none';
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

        //현재 페이지에서 보여줄 데이터를 불러오기
        const data = getData(tabName);//데이터를 가져오는 함수 필요 
        const startIndex = (currentPage -1)* itemsPerPage;
    
        //해당 데이터 렌더링 
        data.slice(startIndex, endIndex).forEach(item=> {
            const parkingItem = document.createElement('div');
            parkingItem.classList.add('parking-item');
            parkingItem.innerHTML = `
            <h3>${item.name}</h3>
            <p>거리: ${item.distance}</p>
            <p>주소: ${item.address}</p>
            <p>전화번호: ${item.phone}</p>
            `;
            parkingList.appendChild(parkingItem);

        });
        document.getElementById('page-number').innerText = currentPage;
    }

    //더미 데이터 가져오는 함수 (api나 서버 데이터로 교체 가능)
    function getData(tabName){
        return [ 
            {name: "상암", distance:"866m", address: "서울시 강남구", phone: "02-576-2720"},
            {name: "상암", distance:"866m", address: "서울시 강남구", phone: "02-576-2720"},
            //추가 데이터...
        ];
    }
    //페이지네이션 이전 페이지로 이동

    function prevPage(){
        if(currentPage>1){
            currentPage--;
            loadPageData(document.querySelector('.tab-button.active').innerText === "주변 주차장" ? 'nearby' : 'regional');
        }
    }


    //페이지네이션 다음 페이지로 이동
    function nextPage(){
        const data = getData(document.querySelector('.tab-button.active').innerText ==="주변 주차장" ? 'nearby' : 'regional');
        if(currentPage < Math.ceil(data/length/itemsPerPage)){
            currentPage++;
            loadPageData(document.querySelector('.tab-button.active').innerText === "주변 주차장" ? 'nearby' : 'regional');
        }
    }

    //초기 데이터 로드
    showTab('nearby');