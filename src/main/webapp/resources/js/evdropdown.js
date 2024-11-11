document.addEventListener("DOMContentLoaded", function () {
    // 전체 체크박스와 개별 체크박스를 가져오기
    const allCheckbox = document.querySelector('.chargetype input[value="chargetypeAllcheck"]');
    const typeCheckboxes = document.querySelectorAll('.chargetype input:not([value="chargetypeAllcheck"])');

    // '전체' 체크박스를 클릭했을 때 모든 타입 체크박스를 선택/해제
    allCheckbox.addEventListener("change", function () {
        const isChecked = allCheckbox.checked;
        typeCheckboxes.forEach(checkbox => {
            checkbox.checked = isChecked;
        });
    });

    // 개별 체크박스가 변경될 때 '전체' 체크박스 상태를 업데이트
    typeCheckboxes.forEach(checkbox => {
        checkbox.addEventListener("change", function () {
            // 모든 개별 체크박스가 체크된 상태면 '전체' 체크박스를 체크
            if (Array.from(typeCheckboxes).every(checkbox => checkbox.checked)) {
                allCheckbox.checked = true;
            } else {
                allCheckbox.checked = false;
            }
        });
    });
});


function showTab(tab) {
    // 모든 탭과 콘텐츠를 비활성화
    document.querySelectorAll('.tabbar span').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

    // 선택된 탭과 콘텐츠를 활성화
    if (tab === 'search') {
        document.querySelector('.tabbarev').classList.add('active');
        document.getElementById('searchContent').classList.add('active');
    } else if (tab === 'route') {
        document.querySelector('.tabbarroad').classList.add('active');
        document.getElementById('routeContent').classList.add('active');
    }
}


document.addEventListener("DOMContentLoaded", function() {
    // 시/군 데이터를 저장한 객체
    const districtData = {
        "11": [
            { value: "11680", text: "강남구" },
            { value: "11740", text: "강동구" },
            { value: "11305", text: "강북구" },
            { value: "11500", text: "강서구" },
            { value: "11620", text: "관악구" },
            { value: "11215", text: "광진구" },
            { value: "11530", text: "구로구" },
            { value: "11545", text: "금천구" },
            { value: "11350", text: "노원구" },
            { value: "11320", text: "도봉구" },
            { value: "11230", text: "동대문구" },
            { value: "11590", text: "동작구" },
            { value: "11440", text: "마포구" },
            { value: "11410", text: "서대문구" },
            { value: "11650", text: "서초구" },
            { value: "11200", text: "성동구" },
            { value: "11290", text: "성북구" },
            { value: "11710", text: "송파구" },
            { value: "11470", text: "양천구" },
            { value: "11560", text: "영등포구" },
            { value: "11170", text: "용산구" },
            { value: "11380", text: "은평구" },
            { value: "11110", text: "종로구" },
            { value: "11140", text: "중구" },
            { value: "11260", text: "중랑구" }
        ],
        "26": [
            { value: "26440", text: "강서구" },
            { value: "26410", text: "금정구" },
            { value: "26710", text: "기장군" },
            { value: "26290", text: "남구" },
            { value: "26170", text: "동구" },
            { value: "26260", text: "동래구" },
            { value: "26230", text: "부산진구" },
            { value: "26320", text: "북구" },
            { value: "26530", text: "사상구" },
            { value: "26380", text: "사하구" },
            { value: "26140", text: "서구" },
            { value: "26500", text: "수영구" },
            { value: "26470", text: "연제구" },
            { value: "26200", text: "영도구" },
            { value: "26110", text: "중구" },
            { value: "26350", text: "해운대구" }
        ],
	    "27": [
	        { value: "27200", text: "남구" },
	        { value: "27290", text: "달서구" },
	        { value: "27710", text: "달성군" },
	        { value: "27140", text: "동구" },
	        { value: "27230", text: "북구" },
	        { value: "27170", text: "서구" },
	        { value: "27260", text: "수성구" },
	        { value: "27110", text: "중구" }
	    ],
	    "28": [
	        { value: "28710", text: "강화군" },
	        { value: "28245", text: "계양구" },
	        { value: "28170", text: "남구" },
	        { value: "28200", text: "남동구" },
	        { value: "28140", text: "동구" },
	        { value: "28237", text: "부평구" },
	        { value: "28260", text: "서구" },
	        { value: "28185", text: "연수구" },
	        { value: "28720", text: "옹진군" },
	        { value: "28110", text: "중구" }
	    ],
	    "29": [
        { value: "29200", text: "광산구" },
        { value: "29155", text: "남구" },
        { value: "29110", text: "동구" },
        { value: "29170", text: "북구" },
        { value: "29140", text: "서구" }
    	],
	    "30": [
        { value: "30230", text: "대덕구" },
        { value: "30110", text: "동구" },
        { value: "30170", text: "서구" },
        { value: "30200", text: "유성구" },
        { value: "30140", text: "중구" }
    	],
	    "31": [
	        { value: "31140", text: "남구" },
	        { value: "31170", text: "동구" },
	        { value: "31200", text: "북구" },
	        { value: "31710", text: "울주군" },
	        { value: "31110", text: "중구" }
	    ],
	    "36": [
	        { value: "36110", text: "세종시" }
	    ],
	    "41": [
	        { value: "41820", text: "가평군" },
	        { value: "41280", text: "고양시" },
	        { value: "41290", text: "과천시" },
	        { value: "41210", text: "광명시" },
	        { value: "41610", text: "광주시" },
	        { value: "41310", text: "구리시" },
	        { value: "41410", text: "군포시" },
	        { value: "41570", text: "김포시" },
	        { value: "41360", text: "남양주시" },
	        { value: "41250", text: "동두천시" },
	        { value: "41190", text: "부천시" },
	        { value: "41130", text: "성남시" },
	        { value: "41110", text: "수원시" },
	        { value: "41390", text: "시흥시" },
	        { value: "41270", text: "안산시" },
	        { value: "41550", text: "안성시" },
	        { value: "41170", text: "안양시" },
	        { value: "41630", text: "양주시" },
	        { value: "41830", text: "양평군" },
	        { value: "41670", text: "여주시" },
	        { value: "41800", text: "연천군" },
	        { value: "41370", text: "오산시" },
	        { value: "41460", text: "용인시" },
	        { value: "41430", text: "의왕시" },
	        { value: "41150", text: "의정부시" },
	        { value: "41500", text: "이천시" },
	        { value: "41480", text: "파주시" },
	        { value: "41220", text: "평택시" },
	        { value: "41650", text: "포천시" },
	        { value: "41450", text: "하남시" },
	        { value: "41590", text: "화성시" }
	    ],
	    "43": [
	        { value: "43760", text: "괴산군" },
	        { value: "43800", text: "단양군" },
	        { value: "43720", text: "보은군" },
	        { value: "43740", text: "영동군" },
	        { value: "43730", text: "옥천군" },
	        { value: "43770", text: "음성군" },
	        { value: "43150", text: "제천시" },
	        { value: "43745", text: "증평군" },
	        { value: "43750", text: "진천군" },
	        { value: "43110", text: "청주시" },
	        { value: "43130", text: "충주시" }
	    ],
	    "44": [
	        { value: "44250", text: "계룡시" },
	        { value: "44150", text: "공주시" },
	        { value: "44710", text: "금산군" },
	        { value: "44230", text: "논산시" },
	        { value: "44270", text: "당진시" },
	        { value: "44180", text: "보령시" },
	        { value: "44760", text: "부여군" },
	        { value: "44210", text: "서산시" },
	        { value: "44770", text: "서천군" },
	        { value: "44200", text: "아산시" },
	        { value: "44810", text: "예산군" },
	        { value: "44130", text: "천안시" },
	        { value: "44790", text: "청양군" },
	        { value: "44825", text: "태안군" },
	        { value: "44800", text: "홍성군" }
	    ],
	    "46": [
	        { value: "46810", text: "강진군" },
	        { value: "46770", text: "고흥군" },
	        { value: "46720", text: "곡성군" },
	        { value: "46230", text: "광양시" },
	        { value: "46730", text: "구례군" },
	        { value: "46170", text: "나주시" },
	        { value: "46710", text: "담양군" },
	        { value: "46110", text: "목포시" },
	        { value: "46840", text: "무안군" },
	        { value: "46780", text: "보성군" },
	        { value: "46150", text: "순천시" },
	        { value: "46910", text: "신안군" },
	        { value: "46130", text: "여수시" },
	        { value: "46870", text: "영광군" },
	        { value: "46830", text: "영암군" },
	        { value: "46890", text: "완도군" },
	        { value: "46880", text: "장성군" },
	        { value: "46800", text: "장흥군" },
	        { value: "46900", text: "진도군" },
	        { value: "46860", text: "함평군" },
	        { value: "46820", text: "해남군" },
	        { value: "46790", text: "화순군" }
	    ],
	    "47": [
	        { value: "47290", text: "경산시" },
	        { value: "47130", text: "경주시" },
	        { value: "47830", text: "고령군" },
	        { value: "47190", text: "구미시" },
	        { value: "47720", text: "군위군" },
	        { value: "47150", text: "김천시" },
	        { value: "47280", text: "문경시" },
	        { value: "47920", text: "봉화군" },
	        { value: "47250", text: "상주시" },
	        { value: "47840", text: "성주군" },
	        { value: "47170", text: "안동시" },
	        { value: "47770", text: "영덕군" },
	        { value: "47760", text: "영양군" },
	        { value: "47210", text: "영주시" },
	        { value: "47230", text: "영천시" },
	        { value: "47900", text: "예천군" },
	        { value: "47930", text: "울진군" },
	        { value: "47730", text: "의성군" },
	        { value: "47820", text: "청도군" },
	        { value: "47750", text: "청송군" },
	        { value: "47850", text: "칠곡군" },
	        { value: "47110", text: "포항시" },
	        { value: "47940", text: "울릉도" }
	    ],
	    "48": [
	        { value: "48310", text: "거제시" },
	        { value: "48880", text: "거창군" },
	        { value: "48820", text: "고성군" },
	        { value: "48250", text: "김해시" },
	        { value: "48840", text: "남해군" },
	        { value: "48270", text: "밀양시" },
	        { value: "48240", text: "사천시" },
	        { value: "48860", text: "산청군" },
	        { value: "48330", text: "양산시" },
	        { value: "48720", text: "의령군" },
	        { value: "48170", text: "진주시" },
	        { value: "48740", text: "창녕군" },
	        { value: "48120", text: "창원시" },
	        { value: "48220", text: "통영시" },
	        { value: "48850", text: "하동군" },
	        { value: "48730", text: "함안군" },
	        { value: "48870", text: "함양군" },
	        { value: "48890", text: "합천군" }
	    ],
	    "50": [
	        { value: "50130", text: "서귀포시" },
	        { value: "50110", text: "제주시" }
	    ],
	    "51": [
	        { value: "51150", text: "강릉시" },
	        { value: "51820", text: "고성군" },
	        { value: "51170", text: "동해시" },
	        { value: "51230", text: "삼척시" },
	        { value: "51210", text: "속초시" },
	        { value: "51800", text: "양구군" },
	        { value: "51830", text: "양양군" },
	        { value: "51750", text: "영월군" },
	        { value: "51130", text: "원주시" },
	        { value: "51810", text: "인제군" },
	        { value: "51770", text: "정선군" },
	        { value: "51780", text: "철원군" },
	        { value: "51110", text: "춘천시" },
	        { value: "51190", text: "태백시" },
	        { value: "51760", text: "평창군" },
	        { value: "51720", text: "홍천군" },
	        { value: "51790", text: "화천군" },
	        { value: "51730", text: "횡성군" }
	    ],
	    "52": [
	        { value: "52790", text: "고창군" },
	        { value: "52130", text: "군산시" },
	        { value: "52210", text: "김제시" },
	        { value: "52190", text: "남원시" },
	        { value: "52730", text: "무주군" },
	        { value: "52800", text: "부안군" },
	        { value: "52770", text: "순창군" },
	        { value: "52710", text: "완주군" },
	        { value: "52140", text: "익산시" },
	        { value: "52750", text: "임실군" },
	        { value: "52740", text: "장수군" },
	        { value: "52110", text: "전주시" },
	        { value: "52180", text: "정읍시" },
	        { value: "52720", text: "진안군" }
	    ]
	    
	};   	    
	    

    // 시/도 선택 시 시/군 목록 업데이트
    document.getElementById("citySelect").addEventListener("change", function () {
        const selectedCity = this.value;
        const districtSelect = document.getElementById("districtSelect");

        // 시/군 옵션 초기화
        districtSelect.innerHTML = '<option value="">시/군</option>';

        // 시/군 데이터가 있는 경우에만 옵션 추가
        if (districtData[selectedCity]) {
            districtData[selectedCity].forEach(district => {
                const option = document.createElement("option");
                option.value = district.value;
                option.textContent = district.text;
                districtSelect.appendChild(option);
            });
            districtSelect.disabled = false; // 활성화
        } else {
            districtSelect.disabled = true; // 비활성화
        }
    });
    
    
	// 기본 변수 설정
	const apiKey = "rBOARBGR6WewzR+zYF+kQmTdL/uXaOHo8Xi8oSkMFzA/7fiYa80eViuXxb9mLDalaBCEyQPIIt3abBnIMVwU0Q==";
	const numOfRows = 30; // 한 페이지에 표시할 결과 개수
	let currentPage = 1; // 현재 페이지 번호
	let totalPage = 1; // 총 페이지 수
	const buttonsPerPage = 10; // 페이지네이션 그룹당 표시할 페이지 버튼 수
	let currentButtonGroup = 1; // 현재 페이지네이션 버튼 그룹
	let fetchedItems = []; // 전체 데이터를 저장할 배열
	
	
	// 검색하기 버튼 클릭 시 호출
    document.getElementById("stationSearchButton").addEventListener("click", async function () {
	    currentPage = 1; // 검색할 때마다 페이지를 1로 초기화
	    currentButtonGroup = 1; // 버튼 그룹도 초기화
        await fetchChargers(); // 전체 데이터 로드
        filterAndDisplayResults(); // 필터링 후 첫 페이지의 데이터 표시
        
	});

	// 특정 페이지에 해당하는 데이터를 가져오는 함수
    async function fetchChargers() {
	    const cityCode = document.getElementById("citySelect").value;
	    const districtCode = document.getElementById("districtSelect").value;
	
	    if (!cityCode || !districtCode) {
	        alert("시/도와 시/군을 선택해 주세요.");
	        return;
	    }
	    
	
        const apiUrl = `http://apis.data.go.kr/B552584/EvCharger/getChargerInfo?serviceKey=${encodeURIComponent(apiKey)}&numOfRows=1000&pageNo=1&dataType=XML&zcode=${cityCode}&zscode=${districtCode}`;
	
	    try {
	        const response = await fetch(apiUrl);
	        if (!response.ok) throw new Error("API 호출 오류");
	
	        const data = await response.text();
	        const parser = new DOMParser();
	        const xmlDoc = parser.parseFromString(data, "application/xml");
            fetchedItems = Array.from(xmlDoc.getElementsByTagName("item")); // 전체 데이터 저장
	
	        // 총 페이지 수 계산
	        // const totalCount = parseInt(xmlDoc.getElementsByTagName("totalCount")[0].textContent);
	        // totalPage = Math.ceil(totalCount / numOfRows);
			
	        // displayResults(items); // 결과 화면에 표시
	        // setupPagination(); // 페이지네이션 버튼 설정
	    } catch (error) {
	        console.error("API 호출 오류:", error);
	    }
	}
	
		// 필터링 후 결과를 표시하는 함수
		function filterAndDisplayResults() {
		    // 선택된 타입 체크박스 값을 배열로 수집
		    const selectedTypes = Array.from(document.querySelectorAll('.chargetype input:checked'))
		        .map(checkbox => checkbox.value)
        		.filter(value => value !== 'chargetypeAllcheck'); // 전체 체크박스는 제외
        		
		    // 전체가 선택된 경우 모든 데이터를 필터링 없이 표시
		    if (selectedTypes.length === 0 || selectedTypes.includes('chargetypeAllcheck')) {
		        displayResults(fetchedItems.slice((currentPage - 1) * numOfRows, currentPage * numOfRows));
		        totalPage = Math.ceil(fetchedItems.length / numOfRows);
		        setupPagination();
		        return;
		    }
		    
		    // 타입 코드와 각 타입에 대응되는 가능한 조합의 매핑 객체
		    const chargerTypeMap = {
		        "01": ["01", "03", "05", "06"], // DC차데모
		        "02": ["02", "08"],             // AC완속
		        "03": ["03", "06"],             // DC차데모+AC3상
		        "04": ["04", "05", "06", "08"], // DC콤보
		        "05": ["05", "06"],             // DC차데모+DC콤보
		        "06": ["06"],                   // DC차데모+AC3상+DC콤보
		        "07": ["07", "03", "06"],       // AC3상
		        "08": ["02", "08"],             // DC콤보(완속)
		        "89": ["89"]                    // H2
		    };
		    
	   	 	// 선택된 타입이 각 아이템의 타입에 포함되는지 확인하여 필터링
	    	const filteredItems = fetchedItems.filter(item => {
	        const chgerType = item.getElementsByTagName("chgerType")[0].textContent;
		        
	        // 선택된 타입 중 하나라도 충전기 타입 코드에 포함되는지 확인
	        return selectedTypes.some(selectedType => {
	            // 선택된 타입이 포함된 조합 목록에 현재 충전기의 타입이 있는지 확인
	            return chargerTypeMap[selectedType] && chargerTypeMap[selectedType].includes(chgerType);
	        	});
	    	});
		    
		    totalPage = Math.ceil(filteredItems.length / numOfRows); // 필터링된 데이터 기준으로 페이지 수 계산
		
		    // 현재 페이지의 항목만 표시
		    const currentPageItems = filteredItems.slice((currentPage - 1) * numOfRows, currentPage * numOfRows);
		    displayResults(currentPageItems); // 필터링된 데이터 화면에 표시
		    setupPagination(); // 페이지네이션 버튼 재설정
		}
	
	

	// 검색 결과를 화면에 표시하는 함수
	function displayResults(items) {
	    const resultList = document.querySelector(".searchlist ul");
	    resultList.innerHTML = ""; // 기존 리스트 초기화
	    
	    const stationNameCount = {}; // 충전소명 중복 여부 확인할 객체
	
	    for (let i = 0; i < items.length; i++) {
	        const statNm = items[i].getElementsByTagName("statNm")[0].textContent;	//충전소명
	        const addr = items[i].getElementsByTagName("addr")[0].textContent;		//주소
	        const useTime = items[i].getElementsByTagName("useTime")[0].textContent;//이용 가능 시간
	        const output = items[i].getElementsByTagName("output")[0].textContent;	//충전 용량
	        const type = items[i].getElementsByTagName("chgerType")[0].textContent;	//충전기 타입
            const stat = items[i].getElementsByTagName("stat")[0].textContent;		//충전기 상태
        	const limitYn = items[i].getElementsByTagName("limitYn")[0]?.textContent || "N"; // limitYn 값 또는 기본값 'N'
        	const limitDetail = items[i].getElementsByTagName("limitDetail")[0]?.textContent || ""; // limitDetail 값 또는 기본값 ''
        	const lat = parseFloat(items[i].getElementsByTagName("lat")[0].textContent); 	// 위도
			const lng = parseFloat(items[i].getElementsByTagName("lng")[0].textContent);	//경도
	
			//충전기 타입
	        const chargerTypeMap = {
	            "01": "DC차데모",
	            "02": "AC완속",
	            "03": "DC차데모+AC3상",
	            "04": "DC콤보",
	            "05": "DC차데모+DC콤보",
	            "06": "DC차데모+AC3상+DC콤보",
	            "07": "AC3상",
	            "08": "DC콤보(완속)",
	            "89": "H2"
	        };
	        const typeText = chargerTypeMap[type] || "알 수 없는 타입";
	        
            // 충전기 상태
	        const chargerStatusMap = {
            	"1": { text: "사용 불가", class: "status-unavailable" },
	            "2": { text: "사용 가능", class: "status-available" },
	            "3": { text: "사용 중", class: "status-in-use" },
	            "4": { text: "운영 중지", class: "status-out-of-service" },
	            "5": { text: "점검 중", class: "status-under-maintenance" },
	            "9": { text: "상태 미확인", class: "status-unknown" }
	        };
	        
        	const statusInfo = chargerStatusMap[stat] || { text: "알 수 없는 상태", class: "status-unknown" };
	        
	        // 이용 제한 정보 설정
        	const limitText = limitDetail ? limitDetail : "제한 없음";
        	
	        // 중복된 충전소명에 번호 붙이기
	        if (stationNameCount[statNm]) {
	            stationNameCount[statNm] += 1; // 중복 카운트 증가
	        } else {
	            stationNameCount[statNm] = 1; // 처음 등장하는 충전소명
	        }
	        
	        // 중복된 경우에만 번호 추가
        	const displayName = stationNameCount[statNm] > 1 ? `${statNm} (${stationNameCount[statNm]})` : statNm;
	
	
	        const listItem = document.createElement("li");
	        listItem.className = "search-item";
	        listItem.dataset.lat = lat;	//위도 data 추가
	        listItem.dataset.lng = lng;	//경도 data 추가
	        
	        listItem.innerHTML = `
	            <div class="info">
	            	<h3>${displayName}</h3> <!-- 중복 시 번호가 추가된 충전소명 -->
	                <p>${addr}</p>
	                <div class="status">
                    	<span class="stat ${statusInfo.class}">${statusInfo.text}</span> <!-- 충전기 상태 표시 -->
	                    <span class="fast">⚡ ${output}kW</span>
	                    <span class="type">타입: ${typeText}</span>
	                </div>
                	<p>이용시간: ${useTime}</p>
                	<p>이용자 제한사항: ${limitText}</p>
	            </div>
	        `;
	        
	        
	        // 리스트 항목 클릭 시 해당 위치로 이동 및 마커 표시
	        listItem.addEventListener("click", function () {
	        	const selectedLat = parseFloat(this.dataset.lat);
	        	const selectedLng = parseFloat(this.dataset.lng);
	        	
	        	//선택된 위치로 지도 중심 이동 및 마커 표시
            	const selectedLocation = new kakao.maps.LatLng(selectedLat, selectedLng);
            	map.setCenter(selectedLocation);
            	
	        	//새로운 마커 생성, 지도 표시하기
	        	const marker = new kakao.maps.Marker({
	        		position: selectedLocation,
	        		map: map
	        	});
	        });
	        
	        resultList.appendChild(listItem);
	    }
	}

	// 페이지네이션 버튼 설정 함수
	function setupPagination() {
	    const paginationContainer = document.getElementById("pagination");
	    paginationContainer.innerHTML = ""; // 기존 페이지네이션 버튼 초기화
	
	    // 현재 페이지 그룹의 첫 번째와 마지막 페이지 번호 계산
	    const startPage = (currentButtonGroup - 1) * buttonsPerPage + 1;
	    const endPage = Math.min(currentButtonGroup * buttonsPerPage, totalPage);
	
	    // 이전 버튼 생성
	    if (currentButtonGroup > 1) {
	        const prevButton = document.createElement("button");
	        prevButton.textContent = "◀";
	        prevButton.className = "page-button";
	        prevButton.addEventListener("click", function () {
	            currentButtonGroup--; // 이전 그룹으로 이동
	            setupPagination(); // 페이지네이션 버튼 재설정
	        });
	        paginationContainer.appendChild(prevButton);
	    }
	
	    // 페이지 번호 버튼 생성
	    for (let i = startPage; i <= endPage; i++) {
	        const pageButton = document.createElement("button");
	        pageButton.textContent = i;
	        pageButton.className = "page-button";
	        if (i === currentPage) pageButton.classList.add("active");
	
	        pageButton.addEventListener("click", function () {
	            currentPage = i; // 선택한 페이지로 업데이트
                filterAndDisplayResults(); // 페이지 변경 시 필터링된 결과 표시
	        });
	
	        paginationContainer.appendChild(pageButton);
	    }
	
	    // 다음 버튼 생성
	    if (endPage < totalPage) {
	        const nextButton = document.createElement("button");
	        nextButton.textContent = "▶";
	        nextButton.className = "page-button";
	        nextButton.addEventListener("click", function () {
	            currentButtonGroup++; // 다음 그룹으로 이동
	            setupPagination(); // 페이지네이션 버튼 재설정
	        });
	        paginationContainer.appendChild(nextButton);
	    }
	    
	    // 검색 결과 리스트 스크롤을 상단으로 이동
	    const searchListDiv = document.querySelector(".searchlist");
	    searchListDiv.scrollTop = 0;  // 스크롤 위치를 최상단으로 설정
	}
	

    // 초기화 버튼 기능
    document.getElementById("resetButton").addEventListener("click", function () {
        document.getElementById("citySelect").value = "";
        document.getElementById("districtSelect").value = "";
        document.querySelector(".searchlist ul").innerHTML = ""; // 결과 초기화
    });
    
    
    
});

	





