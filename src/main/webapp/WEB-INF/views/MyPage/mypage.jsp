<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 메인</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypage.css">
</head>
<body>
<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />


<div class="profile-section">
    <div class="profile-card">
    <input type="hidden" id="carIdx" value="${sessionScope.user.carIdx}" />
        <!-- 차량 정보 섹션 -->
        <h4>나의 차량 정보</h4>
        <div class="car-info">
        	<div class="car-image">
    			<input type="file" id="carImage" name="carImage" accept="image/*"> <!-- 기본 파일 선택 버튼 숨김 -->
      			<img src="" alt="차량 이미지"> <!-- 기본 src는 비워둠 -->
      			<button type="button" id="uploadButton" class="upload-btn">사진 등록</button> <!-- 커스텀 버튼 -->
        	</div>
            <div class="car-details">
                <div class="car-detail">
                    <div class="label-box">차량 종류</div>
                    <input type="text" id="carType" class="value-box input-field" placeholder="차량 종류를 입력해 주세요." />
                </div>
                <div class="car-detail">
                    <div class="label-box">차량 번호</div>
                    <input type="text" id="carNumber" class="value-box input-field" placeholder="차량 번호를 입력해 주세요." />
                </div>
                <div class="car-detail">
                    <div class="label-box">차량 유종</div>
                    <div class="value-box">
                        <!-- 차량 유종 드롭다운 -->
                        <select id="fuelType" class="value-box input-field">
                            <option value="" disabled selected>차량 유종을 선택해 주세요</option>
                            <option value="디젤">디젤</option>
                            <option value="휘발유">휘발유</option>
                            <option value="전기">전기</option>
                            <option value="lpg">LPG</option>
                        </select>
                    </div>
                </div>
            </div>
            <!-- 차량 정보 등록하기 버튼 -->
            <div class="register-car-info-btn">등록하기</div>
        </div>
    </div>
    
    <!-- 나의 커뮤니티 관리 섹션 -->
    <div class="community-section">
        <h4>나의 커뮤니티 관리</h4>
        <div class="community-links">
            <ul>
                <!-- 예시 커뮤니티 글 링크 -->
                <li><a href="https://example.com/community-post-1" target="_blank"></a></li>
                <li><a href="https://example.com/community-post-2" target="_blank"></a></li>
                <li><a href="https://example.com/community-post-3" target="_blank"></a></li>
            </ul>
        </div>
        <!-- 커뮤니티 글 수정 버튼 -->
        <a href="${pageContext.request.contextPath}/communityEditPage.jsp" class="edit-community-posts-btn">커뮤니티 글 수정하기</a>
    </div>
</div>

        
<!-- 푸터 -->
<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />


<script>

document.querySelector('.register-car-info-btn').addEventListener('click', () => {
    const formData = new FormData();

    // 텍스트 입력 필드 값 추가
    formData.append('carType', document.querySelector('input[placeholder="차량 종류를 입력해 주세요."]').value);
    formData.append('carNumber', document.querySelector('input[placeholder="차량 번호를 입력해 주세요."]').value);
    formData.append('fuelType', document.querySelector('select').value);

    // 파일 추가 (이미지 파일)
    const carImageFile = document.querySelector('#carImage').files[0];
    if (carImageFile) {
        formData.append('carImage', carImageFile);
    }

    // 서버에 요청
    fetch('${pageContext.request.contextPath}/car/save', {
        method: 'POST',
        body: formData, // FormData를 body에 전달
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('서버 오류: ' + response.status);
        }
        return response.text();
    })
    .then(message => {
        alert(message); // 성공 메시지 표시
        location.reload(); // 페이지 새로고침
    })
    .catch(error => {
        console.error('Error:', error);
        alert('저장 중 오류가 발생했습니다. 다시 시도해 주세요.');
    });
});


// session.car_idx = car_info table.car_idx
$(document).ready(function() {
    const carIdx = $('#carIdx').val();
    console.log("carIdx:", carIdx);
    console.log("carIdx (from hidden input):", carIdx, "Type:", typeof carIdx);

    if (carIdx) {
    	const url = "/CarPlanet/car/" + carIdx;
        console.log("const로 만든 url 체크:  ", url);
        
        $.ajax({
        	url: url,
            type: 'GET',
            dataType: 'json',
            success: function(carInfo) {
            	console.log("Response Data:", carInfo);
                
                if (carInfo) {
                	$('#carType').val(carInfo.carType);
                    $('#carNumber').val(carInfo.carNumber);
                    $('#fuelType').val(carInfo.fuelType);
                    
                    if (!$('#fuelType').val()) {
                        $('#fuelType').val('');
                    }
                    
                    // 이미지 처리
                    if (carInfo.base64Image) {
                        const imgElement = document.querySelector('.car-image img');
                        imgElement.src = 'data:image/jpeg;base64,' + carInfo.base64Image; // Base64 이미지 설정
                    }
                }
            },
            error: function(err) {
                console.error("차량 정보를 불러오는데 실패했습니다.", err);
            }
        });
    }
});


</script>




</body>
</html>