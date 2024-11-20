<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        <!-- 차량 정보 섹션 -->
        <h4>나의 차량 정보</h4>
        <div class="car-info">
            <img src="${pageContext.request.contextPath}/resources/images/01.jpg" alt="차량 이미지" class="car-image">
            <div class="car-details">
                <div class="car-detail">
                    <div class="label-box">차량 종류</div>
                    <input type="text" class="value-box input-field" placeholder="차량 종류를 입력해 주세요." />
                </div>
                <div class="car-detail">
                    <div class="label-box">차량 번호</div>
                    <input type="text" class="value-box input-field" placeholder="차량 번호를 입력해 주세요." />
                </div>
                <div class="car-detail">
                    <div class="label-box">차량 유종</div>
                    <div class="value-box">
                        <!-- 차량 유종 드롭다운 -->
                        <select class="value-box input-field">
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
    const carInfo = {
        carType: document.querySelector('input[placeholder="차량 종류를 입력해 주세요."]').value,
        carNumber: document.querySelector('input[placeholder="차량 번호를 입력해 주세요."]').value,
        fuelType: document.querySelector('select').value,
    };

    fetch('/CarPlanet/car/save', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8', // UTF-8 설정
        },
        body: JSON.stringify(carInfo),
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('서버 오류: ' + response.status); // 서버 상태 코드가 200번대가 아니면 에러 처리
        }
        return response.text(); // 서버에서 받은 응답 메시지 추출
    })
    .then(message => {
        alert(message); // 성공 메시지를 alert로 표시
    })
    .catch(error => {
        console.error('Error:', error); // 에러 메시지 출력
        alert('저장 중 오류가 발생했습니다. 다시 시도해 주세요.'); // 사용자에게 에러 메시지 표시
    });
});




</script>




</body>
</html>
