<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9dc9962fd8d9c313d5ca5a57212228ab&libraries=services"></script>
<style>
* {
	margin: 0;
}

.section {
	width: 1400px;
	height: 100vh;
	box-sizing: border-box;
}

.grid-container {
	display: grid;
	grid-template-columns: 1fr 1fr 1fr 1fr;
	grid-template-rows: 1fr 1fr 1fr;
	height: 100%;
}

.map {
	grid-column: 2/5;
	grid-row: 1/4;
	background-color: red;
}

.gas-sidebar {
	grid-column: 1/2;
	grid-row: 1/4;
	display: flex;
	flex-direction: column;
	align-items: center;
}

.sidebarheader {
	width: 100%;
	display: flex;
}

.headerban {
	width: 50%;
	text-align: center;
	background-color: #464B79;
	height: max-content;
	color: white;
	padding: 20px;
	border: 1px solid white;
}

.gasinfo {
	width: 80%;
	height: max-content;
	background-color: #161938;
	margin: 20px 0;
	padding: 10px 0;
	font-size: 20px;
	font-weight: bold;
	color: white;
	text-align: center;
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

.sidemiddle div>p {
	width: 23%;
	text-align: center;
	color: black;
	font-weight: bold;
}

.sidemiddle div>div {
	width: 77%;
	background-color: #eee; /* 예제용 배경색 */
	padding: 10px; /* 여백 추가 */
	border-radius: 5px;
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
	height: 500px;
	background-color: grey;
	text-align: center;
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
</style>
</head>

<body>
	<div class="section">
		<div class="grid-container">
			<div class="gas-sidebar">
				<div class="sidebarheader">
					<p class="headerban">지역별</p>
					<p class="headerban">경로별</p>
				</div>
				<div class="gasinfo">
					<p>주유소 정보</p>
				</div>
				<div class="sidemiddle">
					<div>
						<p>지역</p>
						<div>
							<select id="bcity" name="bcity">
								<option value="seoul">충청</option>
								<option value="busan">경기</option>
								<option value="incheon">강원</option>
								<option value="daegu">전라</option>
							</select>
							<select id="city" name="city">
								<option value="seoul">천안</option>
								<option value="busan">예산</option>
								<option value="incheon">아산</option>
								<option value="daegu">탕정</option>
							</select>
							<select id="city" name="city">
								<option value="seoul">읍면동</option>
								<option value="busan">목천</option>
								<option value="incheon">신부</option>
								<option value="daegu">두정</option>
							</select>
						</div>
					</div>
					<hr>
					<div>
						<p>부가정보</p>
						<div class="additional-info">
							<label><input type="checkbox">세차장</label>
							<label><input type="checkbox">경정비</label>
							<label><input type="checkbox">편의점</label>
							<label><input type="checkbox">24시간</label>
						</div>
					</div>
					<hr>
					<div>
						<p>상표</p>
						<div>상표명</div>
					</div>
					<hr>
				</div>
				<div class="siderbarbottom">
					<div class="gaslist">리스트 들어와유</div>
				</div>
			</div>


			<div class="map" id="map"></div>
		</div>
	</div>

	<script>
		// 지도를 표시할 div와 지도 옵션을 설정합니다
		var mapContainer = document.getElementById('map');
		var mapOption = {
			center : new kakao.maps.LatLng(37.5665, 126.9780), // 지도의 중심좌표 (예: 서울 중심)
			level : 3
		// 지도의 확대 레벨
		};

		// 지도를 생성합니다
		var map = new kakao.maps.Map(mapContainer, mapOption);
	</script>
</body>
</html>
