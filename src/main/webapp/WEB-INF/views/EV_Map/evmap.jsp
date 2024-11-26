<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>




<!DOCTYPE html>


<html lang="ko">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">


<!-- 카카오 맵 API -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=66fe3ec238628b8043889a81592616b2&libraries=services"></script>

<link href="${pageContext.request.contextPath}/resources/css/evmap.css?v=1.0" rel="stylesheet" type="text/css">

<script src="${pageContext.request.contextPath}/resources/js/evdropdown.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/js/kakaoevmap.js" defer></script>
<script src="${pageContext.request.contextPath}/resources/js/kakaoevroad.js" defer></script>

<title>Car Planet 전기차 충전소</title>

</head>

<body>

<jsp:include page="/WEB-INF/views/MainPage/header.jsp"/>

<div class="maincontainer">

<!-- 검색 창 -->
<div class="searchbar">
<!-- 	<div class="searchlogo">
		<p>CAR PLANET</p>
	</div> -->
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
	<div class="pagination-wrapper">
		<div id="pagination" class="pagination-container"></div>
	</div>

	
	</div> <!-- end of tab-content active-->
	
    <!-- 충전소 길 찾기 내용 -->
    <div id="routeContent" class="tab-content">
    		
        <div class="route-search">
        	<h3>길 찾기</h3>
        	
        	<!-- 출발지 입력과 스왑 버튼 -->
        	<div class="input-container">
            	<input type="text" id="originInput" placeholder="출발지를 입력하세요" class="route-input">
             	<img src="https://img.icons8.com/?size=100&id=o93UMkegCS8X&format=png&color=000000" class="route-swapbutton" alt="스왑" id="swapButton"/>
            </div>

            
            <div id="originSuggestions" class="suggestions-container"></div>
            
            
            <!-- 도착지 입력 -->
            <div class="input-container">
            	<input type="text" id="destinationInput" placeholder="도착지를 입력하세요" class="route-input">
           		<img src="https://img.icons8.com/?size=100&id=8112&format=png&color=000000" class="route-swapbutton" alt="취소" id="cancelButton"/>
           	</div>	
           	
           	<div id="destinationSuggestions" class="suggestions-container"></div>
            <button id="searchButton" class="route-searchbutton">경로 검색</button>
                
                <input type="hidden" id="originCoords">
 				<input type="hidden" id="destinationCoords">
        
        </div><!-- end of route-search -->

        <div class="route-result" id="routeResult">
       		<div class="route-header"></div>
	       	<div class="route-main">
	       		<span class="route-icon"></span>
	       		<span class="route-nav"></span>
	       		<div class="route-footer"></div> <!-- 목적지를 표시할 공간 추가 -->
	       	</div>
        	
        </div>
            <div id="directionsList" class="directions-list"></div>
            <!-- 경로 결과 예시 -->
            
    </div> <!--  end of tab-content -->
	</div> <!-- end of searchbar -->




<!-- 카카오 맵 -->
<div class="kakaomap" id="map"></div>


<!-- 충전소 정보 팝업 -->
<div id="stationInfoPopup" class="station-info-popup">
	
	<button id="closePopupButton">X</button>
	<div class="real-popup">
		<div class="popupStationName">
			<span id="popupStationName"></span>
		</div>
		<div class="popupchargebusi">
			<span class="popupOperator" data-value="popupOperator"></span>
			<span class="popupOperator" id="popupUseTime"></span>
		</div>
		
		<div class="popupchargeType">
			<table>
		        <thead>
		            <tr>
		                <th>구분</th>
		                <th>충전기 타입</th>
		                <th>충전기 상태<br>
		                	<small>(갱신 시간)</small>
		                </th>
		            </tr>
		        </thead>
		        <tbody>
		            <tr>
		                <td>
		                	<span id="popupOutput"></span>
		                </td>
		                <td>
		                    <span id="popupType"></span>
		                </td>
		                <td>
		                    <span class="status-button">
		                    	<span id="popupStatus"></span><br>
		                    	<small id="popupStatusUpdateDate"></small> <!-- 갱신 일시 표시용 -->
		                    </span>
		                </td>
		            </tr>
		        </tbody>
		    </table>
		</div>
		
		<div class="popupchargeinfo">
			<span class="info-header">상세정보</span>
		
		    <div class="info-item">
		        <div class="label">주소</div><div class="info-stats"id="popupAddress"></div>
		    </div>
		    <div class="info-item">
		        <div class="label">운영기관</div><div class="info-stats" data-value="popupOperator"></div>
		    </div>
		    <div class="info-item">
		        <div class="label">연락처</div><div class="info-stats" id="popupContact"></div>
		    </div>
		    <div class="info-item">
		        <div class="label">참고사항</div><div class="info-stats" id="popupNote"></div>
		    </div>
		    <div class="info-item">
		        <div class="label">이용자제한</div><div class="info-stats" id="popupLimitDetail"></div>
		    </div>
		
		</div>
		<div class="popupchargephoto">
			<div class="chargephoto-header">
				<div>위치사진</div>
				<button class="roadviewnav">
					<img src="${pageContext.request.contextPath}/resources/images/navicon.png" alt="길찾기아이콘" />
				<div>길 찾기</div>
				</button>
			</div>
				<div class="roadview" id="roadview"></div> <!-- 로드뷰 -->
		</div>
	    
    </div> <!-- end of real-popup -->
</div> <!-- end of station-info-popup -->



</div> <!-- end of maincontainer -->





</body>


</html>