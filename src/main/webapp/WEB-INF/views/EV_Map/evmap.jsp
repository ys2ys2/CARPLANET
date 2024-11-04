<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>




<!DOCTYPE html>


<html lang="ko">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">


<!-- 카카오 맵 API -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=66fe3ec238628b8043889a81592616b2"></script>
<link href="${pageContext.request.contextPath}/resources/css/evmap.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/evdropdown.js" defer></script>



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
		<span class="tabbarev">충전소 검색</span>
		<span class="tabbarroad">충전소 길 찾기</span>
	</div>
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
	








</div> <!-- end of searchbar -->

<!-- 카카오 맵 -->
<div class="kakaomap" id="map"></div>







</div> <!-- end of maincontainer -->











</body>

<script>

var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
var options = { //지도를 생성할 때 필요한 기본 옵션
	center: new kakao.maps.LatLng(33.450701, 126.570667), //지도의 중심좌표.
	level: 3 //지도의 레벨(확대, 축소 정도)
};

var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴

</script>

</html>