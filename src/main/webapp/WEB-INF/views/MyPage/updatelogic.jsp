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
		<span class="name">${user.carNickname} 님</span>
		<span class="welcome">방문을 환영합니다!</span>
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
			<span>${user.carNickname}</span>
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
		    		<form class="update-birthday">
			            <label for="carid">아이디</label>
			            <input type="text" id="carid" name="carid" value="${user.carId}" readonly>
			        </form>
			    	<form class="update-email">
			            <label for="email">이메일</label>
			            <input type="email" id="email" name="email" value="${user.email}" readonly>
			            <span class="check" onclick="startEmailVerification()">인증하기</span>
			        </form>
  			        <!-- 인증번호 입력란 (숨김 처리) -->
				    <form class="checkAuthcode" id="email-verification">
				        <label for="verification-code">인증번호 입력</label>
				        <input type="text" id="verification-code" placeholder="인증번호 입력">
				        <span class="check" onclick="verifyEmailCode()">확인</span>
				    </form>
				     
		        </div>
		        
		        <h3>사용자 정보</h3>
		        <div class="n_p-wrapper">
			    	<form class="update-carName">
			            <label for="carNickname">닉네임</label>
			            <input type="text" id="carNickname" name="carNickname" value="${user.carNickname}" readonly>
			        </form>
      			    <form class="update-birthday">
			            <label for="birthday">생년월일</label>
			            <input type="date" id="birthday" name="birthday" value="${user.birthday}" readonly>
			        </form>
			    	<form class="update-phone">
			            <label for="phone">휴대폰번호</label>
			            <input type="tel" id="phone" name="phone" value="${user.phone}" readonly>
			            <!-- <span class="check">인증하기</span> -->
			        </form>
			        <form class="reg-date">
			        	<label for="date">가입일자</label>
			        	<input type="text" id="reg-date" name="reg-date" value="${formattedRegDate}" readonly>
			        </form>
		        </div>
		        <div class="pw-wrapper">
			    	<div class="update-pw">
			    		<span>비밀번호</span><span class="pwbtn">변경</span>
			    	</div>
		    	</div>
		    	
	       </div> <!-- end of updateWrapper -->
	       
	       <div class="update-footer">
	       	<button type="button" class="update-delete" onclick="confirmDelete()">탈퇴하기</button>
	       	<button type="button" class="update-save" onclick="saveUserInfo()">수정하기</button>
	       </div>
	    </div> <!-- end of update-info -->
	    
 	    <!-- 비밀번호 수정 영역 -->
    	<div class="pwpw-wrapper" id="changepwpw">
    		<div class="pwpw-header">
    			<span>비밀번호 변경</span>
    		</div>
    		<div class="pwpw-main">
    			<div class="resettext">회원님의 비밀번호를 재설정해 주세요.</div>
    			<span>*비밀번호는 8~16자 영문 소문자 및 특수문자 1개 이상 포함.</span>
    			<span>*공백 금지</span>
    			
    			<form id="changePasswordForm">
	    			<div class="now-pw">
	    				<label for="current-password">현재 비밀번호 입력</label>
               			<input type="password" id="current-password" name="current-password" required>
	    			</div>
  			            <div class="new-pw">
		                <label for="new-password">신규 비밀번호 입력</label>
		                <input type="password" id="new-password" name="new-password" required>
		            </div>
		            <div class="check-new-pw">
		                <label for="confirm-password">신규 비밀번호 확인</label>
		                <input type="password" id="confirm-password" name="confirm-password" required>
		            </div>
		            
		            <button type="submit">변경</button>		    			
    			</form>
    		</div>
    	
    	</div> <!-- end of pwpw-wrapper -->	   
	    
	    

</div> <!-- end of main-container -->








<script>

const contextPath = "${pageContext.request.contextPath}"; // JSP에서 컨텍스트 경로 가져오기
const fields = ['email', 'birthday', 'carNickname', 'phone', 'password'];

//이메일 인증 로직
function startEmailVerification() {
    const emailInput = document.getElementById("email");
    const emailVerificationDiv = document.getElementById("email-verification");

    // 이메일 입력창 활성화
    emailInput.removeAttribute("readonly");
    emailInput.focus();

    // 인증번호 입력창 표시
    emailVerificationDiv.style.display = "block";

    // 이메일 변경 시 "인증하기" 상태 초기화
    emailInput.addEventListener("input", () => {
        emailVerificationDiv.style.display = "none";
    });

    // 이메일 인증 요청
    const email = emailInput.value;

    if (validateEmail(email)) {
        fetch("/CarPlanet/Auth/sendVerificationCode", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: new URLSearchParams({ email }),
        })
            .then((response) => response.text())
            .then((result) => {
                if (result === "SUCCESS") {
                    alert("인증번호가 발송되었습니다.");
                } else {
                    alert("이메일 인증 요청에 실패했습니다.");
                }
            })
            .catch((error) => {
                console.error("Error:", error);
                alert("서버와 통신 중 문제가 발생했습니다.");
            });
    } else {
        alert("유효한 이메일을 입력해주세요.");
        emailVerificationDiv.style.display = "none";
    }
}

function verifyEmailCode() {
    const emailInput = document.getElementById("email");
    const verificationCodeInput = document.getElementById("verification-code");
    const email = emailInput.value;
    const code = verificationCodeInput.value;

    fetch("/CarPlanet/Auth/verifyCode", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, code }),
    })
        .then((response) => response.text())
        .then((result) => {
            if (result === "SUCCESS") {
                alert("이메일 인증이 완료되었습니다.");
                emailInput.setAttribute("readonly", true); // 다시 읽기 전용
            } else {
                alert("인증번호가 올바르지 않습니다. 다시 시도해주세요.");
                emailInput.value = "${user.email}"; // 원래 이메일로 복원
                emailInput.setAttribute("readonly", true); // 읽기 전용으로 복원
                document.getElementById("email-verification").style.display = "none"; // 인증창 숨김
            }
        })
        .catch((error) => {
            console.error("Error:", error);
            alert("서버와 통신 중 문제가 발생했습니다.");
        });
}

function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}


function saveUserInfo() {
    const carNickname = document.getElementById("carNickname").value;
    const birthday = document.getElementById("birthday").value;
    const phone = document.getElementById("phone").value;
    const email = document.getElementById("email").value;

    fetch(contextPath + "/updateUserInfo", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({
            carNickname: carNickname,
            birthday: birthday,
            phone: phone,
            email: email,
        }),
    })
        .then((response) => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json(); // JSON 형식으로 응답 처리
        })
        .then((result) => {
            if (result.status === "SUCCESS") {
                alert("사용자 정보가 성공적으로 업데이트되었습니다.");
                location.reload(); // 페이지 새로고침
            } else {
                alert(`업데이트 실패: ${result.message}`);
            }
        })
        .catch((error) => {
            console.error("Error:", error);
            alert("서버와 통신 중 문제가 발생했습니다.");
        });
}




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
   
   
		// 비밀번호 변경 버튼 클릭 이벤트
	   	document.querySelector('.pwbtn').addEventListener('click', function() {
	       // 섹션 가져오기
	       const mainInfo = document.getElementById('mainInfo'); // 개인 정보 관리 영역
	       const updateInfo = document.getElementById('updateInfo'); // 회원정보 수정 영역
	       const checkpw = document.getElementById('checkpw'); // 비밀번호 확인 영역
	       const changepwpw = document.getElementById('changepwpw'); // 비밀번호 수정 영역
	
	       // 다른 섹션 숨기기
	       mainInfo.style.display = 'none';
	       updateInfo.style.display = 'none';
	       checkpw.style.display = 'none';
	
	       // 비밀번호 수정 영역 표시
	       changepwpw.style.display = 'block';
	   	});
	   	
	// 비밀번호 변경 폼 제출 처리
   	document.querySelector('#changepwpw form').addEventListener('submit', function (event) {
       event.preventDefault(); // 기본 폼 제출 동작 막기

       // 입력값 가져오기
       const currentPassword = document.getElementById('current-password').value;
       const newPassword = document.getElementById('new-password').value;
       const confirmPassword = document.getElementById('confirm-password').value;

       // 비밀번호 유효성 검사 정규식
       const passwordRegex = /^(?=.*[a-z])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,16}$/;

       // 현재 비밀번호 확인 (서버와 비교)
       fetch(contextPath + '/check_password', {
           method: 'POST',
           headers: { 'Content-Type': 'application/json' },
           body: JSON.stringify({ password: currentPassword }),
       })
           .then((response) => response.json())
           .then((data) => {
               if (data.status !== 'success') {
                   alert('현재 비밀번호를 확인해 주세요.');
                   return;
               }

               // 신규 비밀번호 유효성 검사
               if (!passwordRegex.test(newPassword)) {
                   alert('비밀번호는 8~16자 영문 대소문자 및 특수문자가 1개 이상 포함되어야 합니다.');
                   return;
               }

               // 신규 비밀번호와 확인 비밀번호가 일치하는지 확인
               if (newPassword !== confirmPassword) {
                   alert('비밀번호를 확인해 주세요.');
                   return;
               }

               // 모든 검사를 통과한 경우, 비밀번호 변경 요청
               changePassword(newPassword);
           })
           .catch((error) => {
               console.error('Error:', error);
               alert('서버와 통신 중 문제가 발생했습니다.');
           });
   	});
	
   	function changePassword(newPassword) {
   	    fetch(contextPath + "/update_password", {
   	        method: "POST",
   	        headers: {
   	            "Content-Type": "application/json",
   	        },
   	        body: JSON.stringify({
   	            newPassword: newPassword, // 전달할 비밀번호
   	        }),
   	    })
   	        .then((response) => {
   	            if (!response.ok) {
   	                throw new Error(`HTTP error! status: ${response.status}`);
   	            }
   	            return response.json(); // JSON 형식으로 응답 처리
   	        })
   	        .then((result) => {
   	            if (result.status === "SUCCESS") {
   	                alert("비밀번호가 성공적으로 변경되었습니다.");
   	                location.reload(); // 페이지 새로고침
   	            } else {
   	                alert(`업데이트 실패: ${result.message}`);
   	            }
   	        })
   	        .catch((error) => {
   	            console.error("Error:", error);
   	            alert("서버와 통신 중 문제가 발생했습니다.");
   	        });
   	}

   
});

	// 회원탈퇴 로직
	function confirmDelete() {
	    // 1. 사용자 확인 팝업
	    if (confirm('정말 탈퇴하시겠습니까?')) {
	        // 2. 탈퇴 요청 (fetch)
			fetch(contextPath + '/deleteUser', {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/json',
	            },
	            body: JSON.stringify({}), // 필요하면 추가 데이터를 body에 포함 가능
	        })
	            .then((response) => {
	                console.log('Response status:', response.status); // 응답 상태 확인
	                if (!response.ok) {
	                    throw new Error('서버 오류가 발생했습니다.');
	                }
	                return response.json(); // 응답 데이터를 JSON으로 파싱
	            })
	            .then((data) => {
	                console.log('Response data:', data); // 서버 응답 데이터 확인
	                if (data.status === 'success') {
	                    // 3. 성공 시: 세션 초기화 및 리다이렉트
	                    alert('탈퇴 처리가 완료되었습니다.');
	                    sessionStorage.clear(); // 세션 데이터 삭제
	                    window.location.href = '/main'; // 메인 페이지로 이동
	                } else {
	                    // 4. 실패 시: 오류 메시지 표시
	                    alert(data.message || '탈퇴 처리에 실패했습니다.');
	                }
	            })
	            .catch((error) => {
	                console.error('Error:', error);
	                alert('서버와 통신 중 문제가 발생했습니다.');
	            });
	    }
	}

</script>


</body>

</html>