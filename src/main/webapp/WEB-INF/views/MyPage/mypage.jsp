<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>




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
	    <input type="hidden" id="existingCarImage" value="">
	    	<div class="profile-header">
	    		<h4>나의 차량 정보</h4>
	    		<div class="profile-editbtn">
		    		<span><img src="https://www.kia.com/content/dam/kwp/functional/btn_edit.svg">차량 정보 수정</span>
		    		<a href="${pageContext.request.contextPath}/updatelogic" onclick="openPopup(event, this.href);">
		    			<span id="editMemberInfoBtn">
		    			<img src="https://www.kia.com/content/dam/kwp/functional/btn_edit.svg">회원 정보 수정</span>
		    		</a>
	    		</div>
	    	</div>
	    	
	        <!-- 차량 정보 섹션 -->
	        <div class="car-info">
	        	<div class="car-image">
	    			<input type="file" id="carImage" name="carImage" style="display: none;" accept="image/*"> <!-- 기본 파일 선택 버튼 숨김 -->
	      			<img src=""> <!-- 기본 src는 비워둠 -->
      				<button type="button" id="uploadButton" class="upload-btn" disabled>사진 등록</button> <!-- 커스텀 버튼 -->
	        	</div>
	            <div class="car-details">
	                <div class="car-detail">
	                    <div class="label-box">차량 종류</div>
	                    <input type="text" id="carType" class="value-box input-field" placeholder="차량 종류를 입력해 주세요." readonly/>
	                </div>
	                <div class="car-detail">
	                    <div class="label-box">차량 번호</div>
	                    <input type="text" id="carNumber" class="value-box input-field" placeholder="차량 번호를 입력해 주세요." readonly/>
	                </div>
	                <div class="car-detail">
	                    <div class="label-box">차량 유종</div>
	                    <div class="value-box">
	                        <!-- 차량 유종 드롭다운 -->
	                        <select id="fuelType" class="value-box input-field" disabled>
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
                <!-- myPosts 리스트를 반복하며 게시글 출력 -->
                <c:forEach var="post" items="${myPosts}">
                    <li>
                    <a href="${pageContext.request.contextPath}/community/getPostList.do">
		                <span class="titleidx">#${post.postIndex}번 글 </span><span class="community-title">${post.title}</span>
		            </a>
		                <span class="community-date">
		                	<fmt:formatDate value="${post.regDate}" pattern="yy-MM-dd HH:mm" />
		                </span>
		                <%-- <span>내용: ${post.content}</span> --%>
                    
                    </li>
                </c:forEach>
            </ul>
            <c:if test="${empty myPosts}">
		        <p>작성한 게시글이 없습니다.</p>
		    </c:if>
        </div>
        <!-- 커뮤니티 글 수정 버튼 -->
        <a href="${pageContext.request.contextPath}/community/post.do" class="edit-community-posts-btn">커뮤니티 글 작성하기</a>
    </div>
</div>

        
<!-- 푸터 -->
<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />


<script>

function openPopup(event, url) {
    event.preventDefault(); 
    window.open(url, '_blank', 'width=500, height=700');
}

const contextPath = "${pageContext.request.contextPath}";

//차량 정보 수정 버튼 클릭 이벤트
document.querySelector('.profile-editbtn span:first-child').addEventListener('click', () => {
    // 입력 필드에서 readonly 속성 제거
    document.querySelector('#carType').removeAttribute('readonly');
    document.querySelector('#carNumber').removeAttribute('readonly');

    // select 필드에서 disabled 속성 제거
    document.querySelector('#fuelType').removeAttribute('disabled');

    // 사진 등록 버튼 활성화
    document.querySelector('#uploadButton').removeAttribute('disabled');

    // 사진 등록 버튼 활성화 상태 스타일 (선택 사항)
    const uploadButton = document.querySelector('#uploadButton');
    uploadButton.style.cursor = 'pointer';
    uploadButton.style.opacity = '1'; // 기본 상태 (활성화)
});




document.querySelector('.register-car-info-btn').addEventListener('click', () => {
    const formData = new FormData();

    // 텍스트 입력 필드 값 추가
    formData.append('carType', document.querySelector('input[placeholder="차량 종류를 입력해 주세요."]').value);
    formData.append('carNumber', document.querySelector('input[placeholder="차량 번호를 입력해 주세요."]').value);
    formData.append('fuelType', document.querySelector('select').value);

    // 파일 추가 (이미지 파일)
    const carImageFile = document.querySelector('#carImage').files[0];
    const existingCarImage = document.querySelector('#existingCarImage').value;

    if (carImageFile) {
        formData.append('carImage', carImageFile);
    } else if (existingCarImage) {
    	formData.append('existingCarImage', existingCarImage);
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
                        $('#existingCarImage').val(carInfo.base64Image); // Hidden 필드에 기존 이미지 저장
                        const imgElement = document.querySelector('.car-image img');
                        imgElement.src = 'data:image/jpeg;base64,' + carInfo.base64Image; // 미리보기 표시
                    }
                }
            },
            error: function(err) {
                console.error("차량 정보를 불러오는데 실패했습니다.", err);
            }
        });
    }
});

document.querySelector('#uploadButton').addEventListener('click', () => {
    document.querySelector('#carImage').click(); // 숨겨진 파일 선택 버튼 클릭
});

// 파일 선택 후 미리보기 이미지 표시
document.querySelector('#carImage').addEventListener('change', (event) => {
    const file = event.target.files[0]; // 선택한 파일
    if (file) {
        const reader = new FileReader(); // FileReader 객체 생성

        reader.onload = (e) => {
            // 파일 읽기가 완료되면 실행
            const imgElement = document.querySelector('.car-image img');
            imgElement.src = e.target.result; // img 태그의 src 속성에 Base64 URL 설정
        };

        reader.readAsDataURL(file); // 파일을 Base64 데이터 URL로 변환
    }
});



</script>




</body>
</html>