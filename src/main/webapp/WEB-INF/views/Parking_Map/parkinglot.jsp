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
        <button class="tab-button active" onclick="showTab('nearby')">주변 주차장</button>
        <button class="tab-button" onclick="showTab('regional')">지역 주차장</button>
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


	


</div> <!-- 메인 컨테이너 닫는 div  -->

</body>
</html>