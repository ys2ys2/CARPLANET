<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/parkinglot.css"> 
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=fd90a39c953cfb75632633381ca03afc" ></script>	
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/parking_map.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/parking_searchbar.js"></script>

<title>주차장 찾기</title>

</head>
<body>


<div class="maincontainer-parking">


<div class="searchbar-parking">
<!-- 검색바 -->
    <div class="search-bar">
        <input type="text" placeholder="주차장을 검색하세요">
        <button type="submit">🔍</button>
    </div>

  <!-- 탭 메뉴 -->
    <div class="parking-tabs">
        <button class="tab-button active" onclick="showTab('search')">주차장 검색</button>
        <button class="tab-button" onclick="showTab('route')">주차장 길찾기</button>
    </div>

	<!-- 지역 선택 -->
        <div class="region-selection">
            <label for="region">지역 선택:</label>
            <select id="province-select">
		    <option value="">전체</option>
		    <option value="서울특별시">서울특별시</option>
		    <option value="부산광역시">부산광역시</option>
		    <!-- 다른 지역 옵션 추가 -->
			</select>
              <select id="city-select">
            <option value="">전체</option>
            <option value="강남구">강남구</option>
            <option value="해운대구">해운대구</option>
            <!-- 다른 세부 지역 옵션 추가 -->
        </select>
            <button onclick="applyRegionFilter()">검색하기</button>
        </div>
      <!-- 주차장 목록 및 페이지네이션 -->
        <div id="nearby" class="tab-content">
            <div class="parking-list"></div>
        </div>
        <div id="regional" class="tab-content" style="display:none;">
            <div class="parking-list"></div>
        </div>
    
    	<!-- 페이지네이션 -->
        <div class="pagination">
            <button onclick="prevPage()">이전</button>
           <span>현재 페이지: <span id="page-number">1</span></span>
            <button onclick="nextPage()">다음</button>
        </div>
    
</div><!--검색바의 가장 큰 div  -->
		<div class="parking-map" id="map"></div><!--지도 div  -->

<!-- HTML 내에 팝업 컨테이너 추가 -->
<div id="parking-details-popup" style="display: none;">
    <button onclick="closeParkingDetails()">닫기</button>
    <div id="parking-details"></div>
</div>
	


</div> <!-- 메인 컨테이너 닫는 div  -->

</body>
</html>