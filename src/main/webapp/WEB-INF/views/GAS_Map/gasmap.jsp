<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="${pageContext.request.contextPath}/resources/css/evmap.css?v=1.0" rel="stylesheet" type="text/css">
<title>Car Planet 주유소</title>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9dc9962fd8d9c313d5ca5a57212228ab&libraries=services,geometry"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/gas.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/gasroad.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/gasdropdowndata.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.6.2/proj4.js"></script>
<style>
@font-face {
	font-family: 'KIMM_Bold';
	src:
		url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2212@1.0/KIMM_Bold.woff2')
		format('woff2');
	font-weight: 700;
	font-style: normal;
}

@font-face {
    font-family: 'GongGothicMedium';
    src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff') format('woff');
    font-weight: normal;
    font-style: normal;
}

/*눈누 기초고딕  */
@font-face {
    font-family: 'NoonnuBasicGothicRegular';
    src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noon-2410@1.0/NoonnuBasicGothicRegular.woff2') format('woff2');
    font-weight: normal;
    font-style: normal;
}


/*프리텐다드  */
@font-face {
    font-family: 'Pretendard-Regular';
    src: url('https://fastly.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
    font-weight: 400;
    font-style: normal;
}

* {
	margin: 0;
	box-sizing: border-box;
	    font-family: 'GongGothicMedium';
}

body, html {
	width: 100%;
	height: 100%;
	overflow: hidden;
}

.main-container {
	display: flex;
	height: 100vh;
}

.gas-sidebar {
	position: absolute;
	left: 0;
	width: 350px; /* 사이드바 너비 */
	height: 90vh;
	background-color: rgba(255, 255, 255, 0.95); /* 반투명 효과 */
	box-shadow: 0px 5px 10px rgba(0, 0, 0, 0.5);
	overflow-y: auto;
	z-index: 10;
	border-radius: 20px;
	margin: 20px; /* 사이드바와 화면 경계 사이 여백 */
}

.map-container {
	flex: 1; /* 지도 영역 확장 */
	position: relative;
}

#map {
	width: 100%;
	height: 100vh; /* 전체 화면 차지 */
	position: relative;
}

.gassearchlogo {
	width: 100%;
	height: auto;
	background-color: #0d8aff;
	color: white;
}

.gassearchlogo p {
	font-family: 'KIMM_Bold';
	font-size: 25px;
	color: white;
	margin-left: 1vh;
	padding: 25px 0 25px 0;
}

#regsec, #rousec {
	width: 100%;
	display: flex;
	flex-direction: column;
	align-items: center;
}

/* 초기에는 경로별 섹션(rousec)을 숨김 */
#rousec {
	display: none;
}

.sidebarheader {
	width: 100%;
	display: flex;
}

.regionban {
	width: 50%;
	text-align: center;
	height: max-content;
	padding: 10px;
	border: 1px solid white;
	color: #0d8aff;
	cursor: pointer;
}

.routeban {
	width: 50%;
	text-align: center;
	height: max-content;
	padding: 10px;
	border: 1px solid white;
	cursor: pointer;
}

.regionban.active::after, .routeban.active::after {
	content: "";
	display: block;
	width: 50%;
	height: 2px; /* 밑줄 두께 */
	background-color: #0d8aff;
	margin: 2px auto 0;
}

.gasinfo {
	width: 90%;
	height: max-content;
	margin: 10px 0;
	padding: 10px 0;
	font-size: 18px;
	font-weight: bold;
	text-align: left;
}

.sidemiddle {
	width: 100%;
	display: flex;
	flex-direction: column;
	height: max-content;
	align-items: center;
	padding: 0 5px 0 5px;
}

.sidemiddle div {
	height: max-content;
	width: 90%;
	padding: 10px;
	display: flex;
	align-items: center; /* 세로 가운데 정렬 */
}

.sidetap {
	width: 15%;
	text-align: center;
	color: black;
	font-weight: bold;
}

.sidemiddle div>div {
	width: 85%;
}

.sidemiddle hr {
	width: 90%;
	margin: 5px 0 5px 0;
	height: 2px;
	background-color: #161938;
	border: none;
}

.siderbarbottom {
	width: 100%;
	height: max-content;
	display: flex;
	justify-content: center;
	align-items: center;
}

.gaslist {
    width: 90%;
    max-width: 600px; /* 최대 너비 */
    height: 300px;
    border: 2px solid #2a2a5d; /* 테두리 색상 변경 */
    border-radius: 10px; /* 둥근 모서리 */
    margin: 10px auto; /* 가운데 정렬 및 위아래 여백 */
    overflow-y: auto;
    display: flex;
    flex-direction: column;
    gap: 10px; /* 항목 간 간격 추가 */
    background-color: #f9fafb; /* 밝은 배경색 */
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 부드러운 그림자 */
    padding: 10px; /* 내부 여백 */
}

.gaslist::-webkit-scrollbar {
    width: 8px; /* 스크롤바 너비 */
}

.gaslist::-webkit-scrollbar-thumb {
    background: #007BFF; /* 스크롤바 색상 */
    border-radius: 10px; /* 스크롤바 둥근 모서리 */
}

.gaslist::-webkit-scrollbar-track {
    background: #e6e6e6; /* 스크롤 트랙 배경 */
}

.gas-item {
    background-color: #ffffff; /* 카드 배경색 */
    border: 1px solid #d1d1d1; /* 카드 테두리 */
    border-radius: 8px; /* 카드 둥근 모서리 */
    padding: 15px; /* 카드 내부 여백 */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 카드 그림자 */
    display: flex;
    flex-direction: column;
    text-align: left; /* 왼쪽 정렬 */
    cursor:pointer;
}

.gas-item p {
    margin: 5px 0; /* 텍스트 간격 */
    font-size: 14px; /* 기본 글씨 크기 */
    color: #333333; /* 텍스트 색상 */
}

.gas-item strong {
    font-size: 16px; /* 강조 텍스트 크기 */
    color: #007BFF; /* 강조 텍스트 색상 */
}

.additional-info,.brand-info{
	display: flex;
	flex-wrap: wrap; /* 요소들을 여러 줄에 걸쳐 표시 */
	gap: 10px; /* 요소 간 간격 */
}

.additional-info label,.brand-info label {
	display: flex;
	align-items: center ;
	background-color: #f5f5f5;
	padding: 5px 5px !important;
	border-radius: 5px;
	font-size: 10px;
}

.Gasroute-input {
	width: 90%;
	padding: 10px;
	margin-bottom: 10px;
	font-family: 'SUIT-Regular', sans-serif;
	font-size: 16px;
	border: 1px solid #ccc;
	border-radius: 5px;
	outline: none;
}

.Gasroute-btn {
	width: 90%;
	padding: 10px;
	margin-bottom: 10px;
	font-size: 16px;
	border-radius: 5px;
	outline: none;
	background-color: #0d8aff;
	border: none;
	color: white;
}

.resetbox {
	width: 90%;
	display: flex;
	justify-content: flex-end !important;
	padding: 0 !important;
	margin-bottom: 10px;
	flex-direction: row;
}

.resetbutton {
	border-radius: 5px;
	border:solid 2px black;
	padding:1px 2px;
	font-weight: 500 !important;
	cursor: pointer;
}

.resetbutton:hover{
background-color: #0d8aff;
color:white;
}



#city, #town {
	width: 40%;
	height: 30px;
	border: 1px solid #ccc;
	border-radius: 5px;
	margin-right: 5px;
}

#sido {
	width: 55%;
	height: 30px;
	border: 1px solid #ccc;
	border-radius: 5px;
	margin-right: 5px;
}

.destinationlist {
	display: flex;
	flex-direction: column;
}

.destinationlist p {
	text-align: start;
	width: 100%;
	padding: 8px;
}

.empty-message {
	color: #333;
	font-size: 14px;
	text-align: center;
	padding: 20px;
}

#stationInfoBox {
    display: none; /* 처음에는 숨김 */
    position: absolute; /* 부모인 #map-container 기준으로 배치 */
    flex-direction:column;
    top: 20px; /* 위쪽 여백 */
    right: 20px; /* 오른쪽 여백 */
    width: 300px; /* 박스 너비 */
    background: white; /* 배경색 */
    border: 1px solid #ccc; /* 테두리 */
    padding: 10px; /* 내부 여백 */
    box-shadow: 0 5px 10px rgba(0, 0, 0, 0.5); /* 그림자 효과 */
    z-index: 1000; /* 지도보다 위로 표시되도록 설정 */
    border-radius: 10px; /* 모서리 둥글게 */
}
#stationName{
	padding: 0px 0px 5px 0px;
		
}


#infocate{
	display:flex;
	justify-content: space-around;
}
#oilKND{
	background-color: #4CC417;
	border-radius: 15px;
	width: max-content;
	padding: 5px 15px;
	color:white;
}
#CONM{
	background-color: #4CC417;
	border-radius: 15px;
	width: max-content;
	padding: 5px 15px;
	color:white;
}

.detailline{
	border-bottom:1px solid black;
	padding:10px;
}

.gasnavigate{
	width:80%;
	height:auto;
	display:flex;
	flex-direction:column;
}
/* 테블릿PC (1024px 이하) */
@media (max-width: 1024px) {
	.sidemiddle div:nth-child(1) {
    display:flex;
    flex-direction:column;
	}
	
	.sidemiddle div:nth-child(1) div{
    display:flex;
    flex-direction:column;
	}
	
	#sido, #city, #town{
		width:100%;
	}
	
	.resetbox {
        flex-direction: row !important; /* 강제로 가로 정렬 */
        justify-content: flex-end !important; /* 오른쪽 정렬 유지 */
    }
    
	.Gasroute-input{
		font-size:13px;
		height:30px;
	}
	
	.Gasroute-btn{
		height:30px;
		display:flex;
		justify-content: center;
		align-items: center;
	}
	
    .gas-sidebar {
        width: 260px; /* 사이드바 너비 축소 */
        height: 85vh;
        font-size: 14px;
        margin: 10px;
    }

    .sidetap {
        font-size: 12px; /* 텍스트 크기 축소 */
    }

    #sido, #city, #town {
        height: 35px;
        font-size: 13px;
    }

    .additional-info label, .brand-info label {
        font-size: 11px; /* 체크박스 라벨 크기 축소 */
    }

    #stationInfoBox {
        width: 240px; /* 정보 박스 크기 축소 */
        top: 15px;
        right: 15px;
    }

    .gaslist {
        height: 220px; /* 리스트 높이 축소 */
    }
}

/* 중형 모바일 (768px 이하) */
@media (max-width: 768px) {

	.sidemiddle div:nth-child(1) {
    display:flex;
    flex-direction:column;
	}
	
	.sidemiddle div:nth-child(1) div{
    display:flex;
    flex-direction:column;
	}
	
	.Gasroute-input{
		font-size:13px;
		height:25px;
	}
	
	.Gasroute-btn{
		height:25px;
		display:flex;
		justify-content: center;
		align-items: center;
	}
	
	.resetbox {
        flex-direction: row !important; /* 강제로 가로 정렬 */
        justify-content: flex-end !important; /* 오른쪽 정렬 유지 */
    }
	
	.side2{
		display:flex;
    flex-direction:column;
	}
	
	.side2 p{
		width:max-content;
	}
	
	.side3{
		display:flex;
    flex-direction:column;
	}
	
	.side3 p{
		display:flex;
    flex-direction:column;
	}
	
	
    .gas-sidebar {
        width: 220px;
        height: 80vh;
        font-size: 12px; /* 전체 폰트 크기 축소 */
    }

    .sidemiddle div {
        padding: 0 5px;
    }

    #sido, #city, #town {
        width: 100%;
        height: 30px;
        font-size: 12px;
        margin-bottom: 5px;
    }

    .additional-info, .brand-info {
        gap: 8px; /* 요소 간격 축소 */
    }

    #stationInfoBox {
        width: 200px;
        font-size: 12px; /* 박스 안 텍스트 크기 축소 */
    }

    .gaslist {
        height: 180px;
        font-size: 11px; /* 리스트 폰트 크기 축소 */
    }
}

/* 소형 모바일 (425px 이하) */
@media (max-width: 425px) {
	.sidemiddle div:nth-child(1) {
    display:flex;
    flex-direction:column;
	}
	
	.sidemiddle div:nth-child(1) div{
    display:flex;
    flex-direction:column;
	}
	
	.Gasroute-input{
		font-size:13px;
		height:20px;
	}
	
	.Gasroute-btn{
		height:20px;
		display:flex;
		justify-content: center;
		align-items: center;
	}
	
	.resetbox {
        flex-direction: row !important; /* 강제로 가로 정렬 */
        justify-content: flex-end !important; /* 오른쪽 정렬 유지 */
    }
	
	.side2{
		display:flex;
    flex-direction:column;
	}
	
	.side2 p{
		width:max-content;
	}
	
	.side3{
		display:flex;
    flex-direction:column;
	}
	
	.side3 p{
		display:flex;
    flex-direction:column;
	}
	
    .gas-sidebar {
        width: 200px;
        height: 75vh;
        font-size: 10px;
    }

    .regionban, .routeban {
        font-size: 12px;
    }

    .sidetap {
        font-size: 10px;
    }

    #sido, #city, #town {
        height: 25px;
        font-size: 10px;
    }

    .additional-info label, .brand-info label {
        font-size: 10px;
        padding: 3px 5px;
    }

    #stationInfoBox {
        width: 180px;
        font-size: 10px;
    }

    .gaslist {
        height: 150px;
        font-size: 10px;
    }
}

/* 초소형 모바일 (320px 이하) */
@media (max-width: 320px) {
	.sidemiddle div:nth-child(1) {
    display:flex;
    flex-direction:column;
	}
	
	.sidemiddle div:nth-child(1) div{
    display:flex;
    flex-direction:column;
	}
	
	.Gasroute-input{
		font-size:13px;
		height:15px;
	}
	
	.Gasroute-btn{
		height:15px;
		display:flex;
		justify-content: center;
		align-items: center;
	}
	
	.resetbox {
        flex-direction: row !important; /* 강제로 가로 정렬 */
        justify-content: flex-end !important; /* 오른쪽 정렬 유지 */
    }
	
	.side2{
		display:flex;
    flex-direction:column;
	}
	
	.side2 p{
		width:max-content;
	}
	
	.side3{
		display:flex;
    flex-direction:column;
	}
	
	.side3 p{
		display:flex;
    flex-direction:column;
	}

    .gas-sidebar {
        width: 180px;
        height: 70vh;
        font-size: 9px;
    }

    .sidetap {
        font-size: 9px;
    }

    #sido, #city, #town {
        font-size: 9px;
        height: 20px;
    }

    .additional-info label, .brand-info label {
        font-size: 9px;
        padding: 2px 4px;
    }

    #stationInfoBox {
        width: 160px;
        font-size: 9px;
    }

    .gaslist {
        height: 120px;
        font-size: 9px;
    }
}

</style>
</head>

<body>
<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />
	<div class="main-container">
		<div class="gas-sidebar">
			<div id="regsec">
				<div class="sidebarheader">
					<p class="regionban active">지역별</p>
					<p class="routeban">경로별</p>
				</div>
				<div class="sidemiddle">
					<div>
						<p class="sidetap">지역</p>
						<div>
							<select id="sido" name="sido">
									<option selected disabled>시/도</option>
									<option value="11">서울특별시</option>
									<option value="26">부산광역시</option>
									<option value="27">대구광역시</option>
									<option value="28">인천광역시</option>
									<option value="29">광주광역시</option>
									<option value="30">대전광역시</option>
									<option value="31">울산광역시</option>
									<option value="41">경기도</option>
									<option value="42">강원도</option>
									<option value="43">충청북도</option>
									<option value="44">충청남도</option>
									<option value="45">전라북도</option>
									<option value="46">전라남도</option>
									<option value="47">경상북도</option>
									<option value="48">경상남도</option>
									<option value="50">제주특별자치도</option>
							</select>
							<select id="city" name="city">
								<option selected disabled>시군구 선택</option>
							</select>
							<select id="town" name="town">
								<option selected disabled>읍면동 선택</option>
							</select>
						</div>
					</div>
					<hr>
					<div class="side2">
						<p class="sidetap">부가정보</p>
						<div class="additional-info">
							<label><input type="checkbox">세차장</label>
							<label><input type="checkbox">경정비</label>
							<label><input type="checkbox">편의점</label>
							<label><input type="checkbox">품질인증</label>
						</div>
					</div>
					<hr>
					<div class="side3">
						<p class="sidetap">상표</p>
						<div class="brand-info">
							<label><input type="checkbox">SKE</label>
							<label><input type="checkbox">GSC</label>
							<label><input type="checkbox">HDO</label>
							<label><input type="checkbox">SOIL</label>
							<label><input type="checkbox">RTE</label>
							<label><input type="checkbox">RTX</label>
							<label><input type="checkbox">NHO</label>
						</div>
					</div>
				<hr>
				</div>
				<div class="gasinfo">
					<p>주유소 정보</p>
				</div>
				<div class="siderbarbottom">
					<div class="gaslist">
						<p class="empty-message">지역 또는 경로를 선택하여 주유소 정보를 확인하세요!</p>
					</div>
				</div>
			</div>
			<div id="rousec">
				<div class="sidebarheader">
					<p class="regionban">지역별</p>
					<p class="routeban">경로별</p>
				</div>
				<div class="gasinfo">
					<p>길찾기</p>
				</div>
				<div class="sidemiddle">
					<div class="resetbox">
						<p class="resetbutton">초기화</p>
					</div>
					<input id="startPoint" class="Gasroute-input" type="text"
						placeholder="출발지를 입력하세요" />
					<input id="endPoint" class="Gasroute-input" type="text"
						placeholder="도착지를 입력하세요" />
					<button class="Gasroute-btn">
						<p>경로검색</p>
					</button>
				</div>
			<div class="gasnavigate">
				<div class="startnavi"></div>
				<div class="routenavi"></div>
				<div class="endnavi"></div>			
			</div>
			</div>
		</div>
		<div class="map-container">
    <div id="map"></div>
    <div id="stationInfoBox">
        <h2 id="stationName">주유소 이름</h2>
        <div id="infocate"><div id="oilKND"></div><div id="CONM"></div></div>
        <table id="stationTable" style="width: 100%; border-collapse: collapse; margin-top: 10px;">
        <thead>
            <tr>
                <th style="border: 1px solid #ddd; padding: 8px;">연료 종류</th>
                <th style="border: 1px solid #ddd; padding: 8px;">가격</th>
            </tr>
        </thead>
        <tbody>
            <!-- 데이터가 여기에 추가될 예정 -->
        </tbody>
        
    </table>
        <h2 style="padding: 5px 0px 5px 5px;">상세정보</h2>
        <div class="detailline"><h5>지번주소</h5><p></p></div>
        <div class="detailline"><h5>도로명주소</h5><p></p></div>
        <div class="detailline"><h5>전화번호</h5><p></p></div>
        <div class="detailline"><h5>기준일자</h5><p></p></div>
        <div class="detailline"><h5>기준시간</h5><p></p></div>
        
        <h2 style="padding: 5px 0px 5px 5px;">기타정보</h2>
        
    </div>
</div>
	</div>
</body>
</html>
