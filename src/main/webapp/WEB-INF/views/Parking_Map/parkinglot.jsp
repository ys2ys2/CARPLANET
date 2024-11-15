<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/parkinglot.css"> 
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=fd90a39c953cfb75632633381ca03afc&libraries=services" ></script>	
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/parking_map.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/parking_searchbar.js"></script>


    <!-- 서치바 highlight 클래스 스타일 추가 -->
    <style>
        .autocomplete-item.highlight {
            background-color: #e0e0e0; /* 강조 표시 배경색 */
            font-weight: bold;         /* 글씨 강조 */
        }
.autocomplete-item {
    padding: 8px;
    cursor: pointer;
}
		     
		/* 강조 표시된 항목 스타일 (이름 변경) */
		.autocomplete-item.route-highlight {
		    background-color: #e0e0e0; /* 강조 배경색 */
		    font-weight: bold;         /* 글씨 강조 */
		    color: #333;               /* 강조 텍스트 색상 */
		    border-radius: 4px;        /* 부드러운 모서리 */
		}
        
    </style>
    
<title>주차장 찾기</title>

</head>
<body>
<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />

<div class="parking-map" id="map"></div><!--지도 div  -->
<div class="maincontainer-parking">

<!--전체 콘텐츠 묶는 컨테이너  -->
<div class="content-container">

<!--메인 서치바 큰 컨테이너 -->
<div class="mainsearch-bar">
<!-- 검색바 -->
<div class="search-bar">
    <input type="text" id="parking-search" placeholder="주차장을 검색하세요" onkeydown="searchParking(event)">
    <button type="submit">🔍</button>
</div>


<!-- 자동완성 검색 결과 표시 영역 -->
<div id="autocomplete-results" class="autocomplete-results" style="display: none;">
    <!-- 검색 결과가 여기에 표시됩니다 -->
</div>
</div>


<div class="parking-contents">
  <!-- 탭 메뉴 -->
    <div class="parking-tabs">
        <button class="tab-button active" onclick="showTab('search')">주차장 검색</button>
        <button class="tab-button" onclick="showTab('route')">주차장 길찾기</button>
    </div>

	<!-- 지역 선택 -->
        <div class="region-selection">
            <label for="region">지역 선택</label>
            <select id="province-select">
		    <option value="">시/도 선택</option>
		    <!-- <option value="서울특별시">서울특별시</option>
		    <option value="부산광역시">부산광역시</option> -->
		    <!-- 다른 지역 옵션 추가 -->
			</select>
              <select id="city-select">
            <option value="">시/구/군 선택</option>
            <!-- <option value="강남구">강남구</option>
            <option value="해운대구">해운대구</option> -->
            <!-- 다른 세부 지역 옵션 추가 -->
        </select>
            <button onclick="applyRegionFilter()">검색하기</button>
        </div>


      <!-- 주차장 목록 및 페이지네이션 -->
        <div id="search" class="tab-content">
            <div class="parking-list"></div>
        </div>


        <div id="route" class="tab-content" style="display:none;">
        
        <!-- 출발지와 도착지 입력 -->
    	<div class="route-search">
        
        <input type="text" id="start-location" placeholder="출발지를 입력하세요" onkeydown="searchAutocomplete(event, 'start')">
        <div id="start-search-results" class="search-results" style="display: none;">
            <!-- 출발지 검색 결과 목록이 여기에 표시됩니다 -->
        </div>

       
        <input type="text" id="end-location" placeholder="도착지를 입력하세요" onkeydown="searchAutocomplete(event, 'end')">
        <div id="end-search-results" class="search-results" style="display: none;">
            <!-- 도착지 검색 결과 목록이 여기에 표시됩니다 -->
        </div>
        
        <button onclick="findRoute()">길찾기</button>
    </div>

        <!-- 자동완성 검색 결과 표시 영역 -->
        <div id="search-results" class="search-results" style="display: none;">
            <!-- 검색 결과 목록이 여기에 표시됩니다 -->
        </div>

    <!-- 길찾기 경로 표시 영역 -->
    <div class="route-result">
        <h3>길찾기 경로</h3>
        <div id="route-directions">
            <!-- 길찾기 결과가 표시될 영역 -->
        </div>
    </div>
     </div>

    	<!-- 페이지네이션 -->
        <div id="pagination" class="pagination">
        </div>
    
	
<!-- HTML 내에 팝업 컨테이너 추가 -->
<div id="parking-details-popup" class="parking-details-popup" style="display: none;">
    <button class="close-button" onclick="closeParkingDetails()">✖</button>
    <div id="parking-details"></div>
</div>
</div>	

</div> 
 </div>  

</body>
</html>