<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>




<!DOCTYPE html>


<html lang="ko">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">


<!-- 카카오 맵 API -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=66fe3ec238628b8043889a81592616b2&libraries=services"></script>

<link href="${pageContext.request.contextPath}/resources/css/evmap.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/evdropdown.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/js/kakaoevmap.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/js/kakaoevroad.js" defer></script>


<title>Car Planet 전기차 충전소</title>

</head>

<body>

<div class="maincontainer">

<!-- 검색 창 -->
<div class="searchbar">
	<div class="searchlogo">
		<p>CAR PLANET</p>
	</div>
	<div class="tabbar">
        <span class="tabbarev active" onclick="showTab('search')">충전소 검색</span>
		<span class="tabbarroad" onclick="showTab('route')">충전소 길 찾기</span>
	</div>
	
	<!-- 충전소 검색 내용 -->
    <div id="searchContent" class="tab-content active">
	<div class="selectlocal">
		<h3>지역 선택</h3>
		<!-- 시/도 드롭다운 -->
		<select id="citySelect" class="dropdown">
			<option value="">시/도</option>
            <option value="11">서울특별시</option>
            <option value="26">부산광역시</option>
            <option value="27">대구광역시</option>
            <option value="28">인천광역시</option>
            <option value="29">광주광역시</option>
            <option value="30">대전광역시</option>
            <option value="31">울산광역시</option>
            <option value="36">세종특별자치시</option>
            <option value="41">경기도</option>
            <option value="43">충청북도</option>
            <option value="44">충청남도</option>
            <option value="52">전북특별자치도</option>
            <option value="46">전라남도</option>
            <option value="47">경상북도</option>
            <option value="48">경상남도</option>
            <option value="50">제주특별자치도</option>
            <option value="51">강원특별자치도</option>
        </select>
        
        <!-- 시/군 선택 드롭다운 -->
	    <select id="districtSelect" class="dropdown" disabled>
	        <option value="">시/군</option>
	    </select>
	</div>

    <!-- 입력 폼(검색용도) -->
<%--     <div class="searchinput-container">
        <input type="text" placeholder="충전소를 검색해 주세요." class="searchinput">
        <div id="suggestions"></div>
   		<button class="searchicon">
        	<img src="${pageContext.request.contextPath}/resources/images/searchicon.png" alt="searchicon">
        </button>
    </div> --%>
    
    <div class="searchbutton-container">
    	<button class="searchbutton" id="stationSearchButton">검색하기</button>
    	<button class="searchbutton" id="resetButton">초기화</button>
    </div>
    
	<div class="chargetypetext">[충전타입]</div>
	
	<div class="chargetype">
	    <label><input type="checkbox" value="chargetypeAllcheck" checked> 전체</label>
	    <label><input type="checkbox" value="04" checked> DC콤보</label>
	    <label><input type="checkbox" value="01" checked> DC차데모</label>
	    <label><input type="checkbox" value="07" checked> AC3상</label>
	    <label><input type="checkbox" value="02" checked> 완속</label>
	</div>

	
	<div class="searchlist">
		<h2>검색결과</h2>
    	<ul id="resultList">
	 		<!-- 검색결과 리스트 -->
	    </ul>
	</div>
	
	<!-- 페이지네이션 버튼 -->
	<div id="pagination" class="pagination-container"></div>

	
	</div> <!-- end of tab-content active-->
        <!-- 충전소 길 찾기 내용 -->
        <div id="routeContent" class="tab-content">
            <div class="route-search">
                <input type="text" id="originInput" placeholder="출발지를 입력하세요" class="route-input">
                	<div id="originSuggestions" class="suggestions-container"></div>
                <input type="text" id="destinationInput" placeholder="도착지를 입력하세요" class="route-input">
                	<div id="destinationSuggestions" class="suggestions-container"></div>
                <button id="searchButton" class="route-searchbutton">경로 검색</button>
                    <input type="hidden" id="originCoords">
   	 				<input type="hidden" id="destinationCoords">
            </div>

            <div class="route-result" id="routeResult">
            <div id="directionsList" class="directions-list"></div>
                <!-- 경로 결과 예시 -->
            </div>
        </div>
	
	
	</div> <!-- end of searchbar -->




<!-- 카카오 맵 -->
<div class="kakaomap" id="map"></div>


<!-- 충전소 정보 팝업 -->
<div id="stationInfoPopup" class="station-info-popup">
	<button id="closePopupButton">X</button> <!-- 닫기 버튼 -->
	<div class="real-popup">
		    <div><h3 id="popupStationName">충전소 이름</h3></div>
		<div class="popupchargebusi">
			<p>충전소 운영기관</p>
			<p>충전소 이용가능시간</p>
		</div>
		
		<div class="popupchargeType">
			<table>
		        <thead>
		            <tr>
		                <th>구분</th>
		                <th>충전기 타입</th>
		                <th>충전기 상태<br>(갱신일시)</th>
		            </tr>
		        </thead>
		        <tbody>
		            <tr>
		                <td>급속<br>(50kW 단독)</td>
		                <td>
		                    <img src="dc_chademo_icon.png" alt="DC차데모">
		                    <img src="ac3_icon.png" alt="AC3상">
		                    <img src="dc_combo_icon.png" alt="DC콤보">
		                </td>
		                <td>
		                    <span class="status-button">사용가능</span><br>
		                    2024.11.02 13:08
		                </td>
		            </tr>
		        </tbody>
		    </table>
		</div>
		
		<div class="popupchargeinfo">
			<p>상세정보:</p>
		
			<span>도로명주소: </span>
			<span>상세위치: </span>
			<span>운영기관: </span>
			<span>연락처: </span>
			<span>충전요금: </span>
			<span>참고사항: </span>
			<span>이용자제한: </span>
		
		</div>
		
		<div class="popupchargephoto">
			<p>위치사진</p>
		
		
		</div>
	

	    
    </div> <!-- end of real-popup -->
</div> <!-- end of station-info-popup -->






</div> <!-- end of maincontainer -->





</body>


</html>