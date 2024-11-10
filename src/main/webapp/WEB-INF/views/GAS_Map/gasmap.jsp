<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Car Planet 주유소</title>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9dc9962fd8d9c313d5ca5a57212228ab&libraries=services"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/gas.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/gasdropdowndata.js"></script>
<style>
@font-face {
	font-family: 'KIMM_Bold';
	src:
		url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2212@1.0/KIMM_Bold.woff2')
		format('woff2');
	font-weight: 700;
	font-style: normal;
}

* {
	margin: 0;
	box-sizing: border-box;
}

.section {
	width: 1270px;
	height: 100vh;
}

.grid-container {
	display: grid;
	grid-template-columns: 350px 1fr 1fr 1fr;
	grid-template-rows: 1fr 1fr 1fr;
	height: 100%;
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

.map {
	grid-column: 2/5;
	grid-row: 1/4;
}

.gas-sidebar {
	grid-column: 1/2;
	grid-row: 1/4;
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
	background-color: #0d8aff;
	margin: 10px 0;
	padding: 10px 0;
	font-size: 20px;
	font-weight: bold;
	color: white;
	text-align: center;
	-webkit-box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px
		rgba(0, 0, 0, 0.23);
	-moz-box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px
		rgba(0, 0, 0, 0.23);
	-ms-box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px
		rgba(0, 0, 0, 0.23);
	-o-box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px
		rgba(0, 0, 0, 0.23);
	box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
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
	height: 300px;
	background-color: grey;
	text-align: center;
	margin-top: 5px;
}

.additional-info {
	display: flex;
	flex-wrap: wrap; /* 요소들을 여러 줄에 걸쳐 표시 */
	gap: 10px; /* 요소 간 간격 */
}

.additional-info label {
	display: flex;
	align-items: center;
	background-color: #f5f5f5;
	padding: 5px 5px;
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
}

.resetbox p {
	background-color: #0d8aff;
	color: white !important;
	border-radius: 5px;
	font-weight: 500 !important;
	cursor: pointer;
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
	test-align: start;
	width: 100%;
	padding: 8px;
}
</style>
</head>

<body>
	<div class="section">
		<div class="grid-container">
			<div class="gas-sidebar">
				<div id="regsec">
					<div class="gassearchlogo">
						<p>CAR PLANET</p>
					</div>
					<div class="sidebarheader">
						<p class="regionban active">지역별</p>
						<p class="routeban">경로별</p>
					</div>
					<div class="gasinfo">
						<p>주유소 정보</p>
					</div>
					<div class="sidemiddle">
						<div>
							<p class="sidetap">지역</p>
							<div>
								<select id="sido" name="sido">
									<option selected disabled>시도</option>
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
								</select> <select id="city" name="city">
									<option selected disabled>시군구 선택</option>
								</select> <select id="town" name="town">
									<option selected disabled>읍면동 선택</option>
								</select>
							</div>
						</div>
						<hr>
						<div>
							<p class="sidetap">부가정보</p>
							<div class="additional-info">
								<label><input type="checkbox">세차장</label> <label><input
									type="checkbox">경정비</label> <label><input
									type="checkbox">편의점</label> <label><input
									type="checkbox">24시간</label>
							</div>
						</div>
						<hr>
						<div>
							<p class="sidetap">상표</p>
							<div>상표명</div>
						</div>
						<hr>
					</div>
					<div class="siderbarbottom">
						<div class="gaslist">리스트 들어와유</div>
					</div>
				</div>

				<div id="rousec">
					<div class="gassearchlogo">
						<p>CAR PLANET</p>
					</div>
					<div class="sidebarheader">
						<p class="regionban">지역별</p>
						<p class="routeban">경로별</p>
					</div>
					<div class="gasinfo">
						<p>주유소 정보</p>
					</div>
					<div class="sidemiddle">
						<div class="resetbox">
							<p>초기화</p>
						</div>
						<input id="startPoint" class="Gasroute-input" type="text"
							placeholder="출발지를 입력하세요" /> <input id="endPoint"
							class="Gasroute-input" type="text" placeholder="도착지를 입력하세요" />
						<button class="Gasroute-btn">
							<p>경로검색</p>
						</button>
					</div>
				</div>

			</div>


			<div class="map" id="map"></div>
		</div>
	</div>


</body>
</html>