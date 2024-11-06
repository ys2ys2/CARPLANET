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
    <div class="searchinput-container">
        <input type="text" placeholder="충전소를 검색해 주세요." class="searchinput">
        <div id="suggestions"></div>
   		<button class="searchicon">
        	<img src="${pageContext.request.contextPath}/resources/images/searchicon.png" alt="searchicon">
        </button>
    </div>
    
    <div class="searchbutton-container">
    	<button class="searchbutton">검색하기</button>
    	<button class="searchbutton">초기화</button>
    
    </div>
    
	<div class="chargetypetext">[충전타입]</div>
	
	<div class="chargetype">
	    <label><input type="checkbox" checked> 전체</label>
	    <label><input type="checkbox" checked> DC콤보</label>
	    <label><input type="checkbox" checked> DC차데모</label>
	    <label><input type="checkbox" checked> AC3상</label>
	    <label><input type="checkbox" checked> 완속</label>
	</div>
	
	<div class="searchlist">
		<h2>검색결과</h2>
	    <!-- 검색 결과 리스트 -->
    	<ul>
	    <li class="search-item">
<!-- 	        <img src="아이콘이미지경로" alt="아이콘" class="icon">
 -->	        <div class="info">
	            <h3>도솔공원</h3>
	            <div class="status">
	                <span class="available">사용가능</span>
	                <span class="fast">⚡ 급속</span>
	                <span class="type">DC콤보</span>
	            </div>
	        </div>
	    </li>
        <!-- 두 번째 충전소 아이템 -->
	    <li class="search-item">
<!-- 	        <img src="아이콘이미지경로" alt="아이콘" class="icon">
 -->	        <div class="info">
	            <h3>독립기념관</h3>
	            <div class="status">
	                <span class="available">사용가능</span>
	                <span class="fast">⚡ 급속</span>
	                <span class="type">DC차데모</span>
	                <span class="type">DC콤보</span>
	            </div>
	        </div>
	    </li>
	    </ul>
	</div>
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






</div> <!-- end of maincontainer -->





</body>


</html>