<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/updatelogic.css">



</head>
<body>
<div class="main-container">
	<div class="main-header">
		<h3>CAR PLANET Account</h3>
	</div>
	<div class="main-body">
		<span class="name">${user.carName} 님</span>
		<span class="welcome">방문을 환영합니다.</span>
	</div>
	
	<!-- 개인 정보 관리 영역 -->
	<div id="mainInfo" class="main-info">
		<span>
			<img alt="이미지" src="https://prd.kr-ccapi.kia.com/web/v1/portal/assets/images/icon/ico_head_user.png">
		</span>
        <span class="main-info-update" id="manageAccount">
			개인 정보 관리 >
		</span>
		
		<div class="main-info-end">
			<span>${user.carName}</span>
			<span>${user.email}</span>
		</div>
	</div> <!-- end of mainInfo -->
		
        <!-- 비밀번호 확인 영역 -->
	    <div id="checkpw" class="checkpw">
	        <h3>비밀번호 재확인</h3>
	        <span class="checkpw-intro">본인 확인을 위해 비밀번호를 다시 입력해주세요.</span>
	        <span class="checkpw-intro">비밀번호는 타인에게 노출되지 않도록 주의해주세요.</span>
	        <form id="passwordForm">
	            <div class="checkpwform">
	                <h3><label for="password">비밀번호 입력</label></h3>
	                <input type="password" id="password" placeholder="비밀번호 입력">
	            </div>
	            <span id="passwordError" class="checkValid">비밀번호가 일치하지 않습니다.</span>
	            <button type="submit">확인</button>
	        </form>
		
		</div> <!-- end of checkpw -->
	
		<!-- 회원정보 수정 영역 -->
	    <div id="updateInfo" class="update-info">
	    	<div class="updateWrapper">
	    	
		    	<h3>필수 입력 정보</h3>
		    	<div class="e_b-wrapper">
			    	<form class="update-email">
			            <label for="email">이메일</label>
			            <input type="email" id="email" name="email" value="${user.email}" readonly>
			        </form>
		        
			    	<form class="update-birthday">
			            <label for="birthday">생년월일</label>
			            <input type="date" id="birthday" name="birthday" value="${user.birthday}" readonly>
			        </form>
		        </div>
		        <h3>사용자 정보</h3>
		        <div class="n_p-wrapper">
			    	<form class="update-carName">
			            <label for="carName">닉네임</label>
			            <input type="text" id="carName" name="carName" value="${user.carName}" readonly>
			        </form>
			    	<form class="update-phone">
			            <label for="phone">휴대폰번호</label>
			            <input type="tel" id="phone" name="phone" value="${user.phone}" readonly>
			        </form>
		        </div>
		        <div class="pw-wrapper">
			    	<div class="update-pw">
			    		<span>비밀번호</span><span class="pwbtn">변경</span>
			    	</div>
		    	</div>
		    	
	       </div> <!-- end of updateWrapper -->
	    </div> <!-- end of update-info -->
	





</div> <!-- end of main-container -->








<script>

const contextPath = "${pageContext.request.contextPath}"; // JSP에서 컨텍스트 경로 가져오기
const fields = ['email', 'birthday', 'carName', 'phone', 'password'];

document.addEventListener('DOMContentLoaded', () => {
    // "개인 정보 관리 >" 클릭 이벤트 처리
    document.getElementById('manageAccount').addEventListener('click', () => {
        const mainInfo = document.getElementById('mainInfo'); // 개인 정보 관리 영역
        const checkpw = document.getElementById('checkpw'); // 비밀번호 확인 영역

        if (mainInfo && checkpw) { // 요소가 존재하는지 확인
            mainInfo.style.display = 'none'; // 개인 정보 관리 영역 숨기기
            checkpw.style.display = 'flex'; // 비밀번호 확인 영역 보이기
        } else {
            console.error('mainInfo 또는 checkpw 요소를 찾을 수 없습니다.');
        }
    });

   // 비밀번호 확인 폼 제출 처리
   document.getElementById('passwordForm').addEventListener('submit', (event) => {
       event.preventDefault(); // 기본 폼 제출 방지

       const password = document.getElementById('password').value;
       console.log("Sending password to:", `${contextPath}/check_password`);
       console.log("Password payload:", JSON.stringify({ password }));

       
       // 비밀번호 확인 요청
	fetch(contextPath + "/check_password", {
	    method: 'POST',
	    headers: {
	        'Content-Type': 'application/json',
	    },
        body: JSON.stringify({ password }), // JSON으로 비밀번호 전송
	})
	    .then((response) => {
	        console.log("Response status:", response.status); // 상태 코드 확인
	        console.log("Response content type:", response.headers.get("Content-Type")); // 응답 형식 확인

	        if (!response.ok) {
	            throw new Error('서버 오류가 발생했습니다.');
	        }

            return response.json(); // 응답 데이터를 JSON으로 파싱
	    })
	    .then((data) => {
	        console.log("Response data:", data); // 서버에서 반환된 데이터 확인
	        if (data.status === 'success') {
	            alert(data.message); // 비밀번호 맞음 메시지
	            document.getElementById('checkpw').style.display = 'none'; // 비밀번호 확인 영역 숨기기
                   document.getElementById('updateInfo').style.display = 'block'; // 회원정보 수정 영역 보이기
	        } else {
	            alert(data.message); // 비밀번호 틀림 메시지
	        }
	    })
	    .catch((error) => {
	        console.error('Error:', error);
	        alert('서버와 통신 중 문제가 발생했습니다.');
	    });
	});
    
   fields.forEach((field) => {
       const input = document.getElementById(field); // 각 필드의 input 요소 가져오기
       input.addEventListener('click', () => {
           input.removeAttribute('readonly'); // readonly 속성 제거
           input.focus(); // 입력창에 포커스
       });

       // 포커스를 잃으면 다시 readonly 설정
       input.addEventListener('blur', () => {
           input.setAttribute('readonly', true); // 입력 완료 후 다시 readonly 설정
       });
   });
	    
	
    
});

</script>


</body>

</html>