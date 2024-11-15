<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<title>로그인 및 회원가입</title>
<style>
/* 스타일 설정 유지 */
@font-face {
	font-family: 'KIMM_Bold';
	src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2212@1.0/KIMM_Bold.woff2') format('woff2');
	font-weight: 700;
	font-style: normal;
}

* { box-sizing: border-box; }

body {
	background: #f6f5f7;
	display: flex;
	justify-content: center;
	align-items: center;
	font-family: 'Montserrat', sans-serif;
	height: 100vh;
	margin: 0;
}

.container {
	display: flex;
	width: 60%;
	height: 80vh;
	position: relative;
	overflow: hidden;
}

.formbox {
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	background-color: white;
	width: 50%;
	padding: 20px;
	border-radius: 15px;
	text-align: center;
	height: 100%;
	position: absolute;
	top: 0;
	transition: all 0.6s ease-in-out;
}

.signinlogo { font-family: 'KIMM_Bold'; }

.sign-in-container {
	left: 0;
	z-index: 2;
}

.container.right-panel-active .sign-in-container {
	transform: translateX(100%);
}

.sign-up-container {
	left: 0;
	opacity: 0;
	z-index: 1;
}

.container.right-panel-active .sign-up-container {
	transform: translateX(100%);
	opacity: 1;
	z-index: 5;
	animation: show 0.6s;
}

@keyframes show { 0%, 49.99% { opacity: 0; z-index: 1; } 50%, 100% { opacity: 1; z-index: 5; } }

.formbox h2 { margin-bottom: 20px; }

.formbox p { font-weight: bold; font-size: 15px; cursor: pointer; }

.formlogo h2 {
	font-size: 2rem;
	margin: 0;
	padding: 0;
	color: #333;
}

.signininput, .signupinput {
	padding: 10px;
	width: 80%;
	margin: 10px 0;
	font-size: 14px;
	border: 1px solid #ddd;
	border-radius: 5px;
}

.checkbox-group {
	width: 80%;
	display: flex;
	flex-direction: column;
	align-items: start;
}

.signinbut {
	border: none;
	border-radius: 15px;
	background-color: #161938;
	width: 80%;
	padding: 10px 0;
	color: white;
	cursor: pointer;
	font-size: 16px;
	margin-top: 20px;
}

.signupinbtn:hover { transform: scale(1.1); }

.pbox { width: 80%; text-align: left; }

.s-login {
	margin-top: 20px;
	display: flex;
	justify-content: center;
	width: 100%;
	gap: 20px;
}

.s-login img {
	width: 40px;
	height: 40px;
	border: 1px solid black;
	border-radius: 50%;
	cursor: pointer;
}

.pagebox {
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	background-color: #161938;
	width: 50%;
	color: white;
	padding: 20px;
	text-align: center;
	height: 100%;
	position: absolute;
	right: 0;
	transform: translateX(0);
	transition: transform 0.6s ease-in-out;
}

.pagebox h2, .pagebox p { margin-bottom: 20px; }

.signupinbtn {
	border: none;
	cursor: pointer;
	font-size: 16px;
	width: 80%;
	height: 50px;
	border-radius: 25px;
	background-color: white;
	color: #161938;
	font-weight: bold;
	margin-bottom: 40px;
	padding: 10px;
	transition: transform 0.4s ease;
}

.overlay-container {
	position: absolute;
	top: 0;
	left: 50%;
	width: 50%;
	height: 100%;
	transition: transform 0.6s ease-in-out;
	z-index: 3;
}

.container.right-panel-active .overlay-container {
	transform: translateX(-200%);
}

.overlay {
	position: relative;
	height: 100%;
	width: 200%;
	display: flex;
	align-items: center;
	justify-content: center;
	transform: translateX(0);
	transition: transform 0.6s ease-in-out;
	border-radius: 15px;
}

.overlay-left, .overlay-right {
	position: absolute;
	width: 50%;
	height: 100%;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	background-color: #161938;
	align-items: center;
	text-align: center;
	padding: 20px;
	color: white;
	font-weight: bold;
	border-radius: 15px;
}

.overlay-left { transform: translateX(0); left: 0; }

.container.right-panel-active .overlay-left {
	transform: translateX(0);
	opacity: 0;
}

.overlay-right {
	right: 0;
	transform: translateX(0);
	opacity: 0;
}

.container.right-panel-active .overlay-right {
	transform: translateX(0);
	opacity: 1;
}
.wrapbox{
	display: flex;
	align-items: center;
	width: 80%;
}
.wrapbut{
	font-size: 13px; /* 텍스트 크기를 조금 줄여서 버튼 안에 맞춤 */
	border: 1px solid #ddd;
	border-radius: 5px;
	padding: 8px 10px; /* 수직 패딩을 줄여 버튼 높이를 낮춤 */
	margin-left: 5px;
	background-color: #f6f5f7;
	cursor: pointer;
	width: 80px; /* 버튼의 고정 너비 설정 */
	height: 40px; /* signupinput과 동일한 높이 */
	display: flex;
	align-items: center;
	justify-content: center;
	text-align: center;
}
</style>
</head>
<body>
	<div class="container" id="container">
		<form id="signupForm" action="joinProcess.do" method="POST">
			<div class="formbox sign-up-container">
				<div class="formlogo">
					<h2>회원가입</h2>
				</div>
				<input class="signupinput" name="carName" type="text" placeholder="이름" required>
				<input class="signupinput" name="phone" type="text" placeholder="전화번호" required>
				
				<div class="wrapbox">
				<input class="signupinput" id="carId" name="carId" type="text" placeholder="아이디" required>
				<button type="button" class="wrapbut" id="checkId">아이디 중복검사</button>
				</div>
				
				<div id="resultMsg" style="display:none; font-size:13px; color:red; margin-top:5px;"></div>
				<input class="signupinput" id="carPw" name="carPw" type="password" placeholder="비밀번호" required>
				<input class="signupinput" name="checkPw" type="password" placeholder="비밀번호 확인" required>
				<div class="wrapbox"><input class="signupinput" name="email" type="text" placeholder="이메일" required>
				<button id="emailnumber" type="button" class="wrapbut">인증번호 받기</button>
				</div>			
				<div class="wrapbox">
				<input class="signupinput" name="emailkey" type="text" placeholder="인증번호입력" required>
				<button type="button" class="wrapbut" id="verifyCodeButton">인증확인</button>
				</div>
				<input class="signupinput" name="birthday" type="text" placeholder="생년월일" required>
				<div class="checkbox-group">
					<label><input type="checkbox" required> 이용약관 필수 동의</label>
					<label><input type="checkbox" required> 위치정보 이용약관 필수 동의</label>
					<label><input type="checkbox" required> 개인정보 처리방침 필수 동의</label>
				</div>
				<button type="submit" id="signup-btn" class="signinbut">회원가입</button>
			</div>
		</form>

		<div class="overlay-container">
			<div class="overlay">
				<div class="overlay-left">
					<h2>다시 오셨네요!<br>맞춤 충전소 정보를 확인하세요!</h2>
					<p>아직 가입한 계정이 없으신가요?</p>
					<button class="signupinbtn" id="signUp">회원가입</button>
				</div>
				<div class="overlay-right">
					<h2>환영합니다<br>회원님만의 맞춤형 서비스를 만나보세요!</h2>
					<p>이미 가입한 회원이신가요?</p>
					<button class="signupinbtn" id="signIn">로그인</button>
				</div>
			</div>
		</div>

		<form method="post" action="loginProcess.do">
			<div class="formbox sign-in-container">
				<div class="formlogo">
					<h2 class="signinlogo">Car<br>Planet</h2>
				</div>
				<h2>로그인</h2>
				<input class="signininput" name="carId" type="text" placeholder="아이디">
				<input class="signininput" name="carPw" type="password" placeholder="비밀번호">
				<div class="pbox">
					<p>아이디를 잊어버리셨나요?</p>
					<p>비밀번호를 잊어버리셨나요?</p>
				</div>
				<button class="signinbut" id="signin-btn" type="submit">로그인</button>
				<div class="s-login">
					<img src="${pageContext.request.contextPath}/resources/images/googlebutton.png" alt="Google">
					<img src="${pageContext.request.contextPath}/resources/images/kakaobutton.png" alt="Kakao">
					<img src="${pageContext.request.contextPath}/resources/images/naverbutton.png" alt="Naver">
				</div>
			</div>
		</form>
	</div>



	<script>
	$(document).ready(function() {
	    const signUpButton = document.getElementById('signUp');
	    const signInButton = document.getElementById('signIn');
	    const container = document.getElementById('container');

	    signUpButton.addEventListener('click', () => {
	        container.classList.add("right-panel-active");
	    });

	    signInButton.addEventListener('click', () => {
	        container.classList.remove("right-panel-active");
	    });

	    
	    let isIdChecked = false;
	    let isEmailVerified = false;
	    
	    $("#checkId").on("click", function() {
	        const carId = $("#carId").val();
	        
	        if (carId.trim().length === 0) {
	            alert("아이디가 입력되지 않았습니다.");
	            $("#carId").focus();
	        } else {
	            $.ajax({
	                type: "post",
	                url: "checkId.do",
	                data: { carId : carId },
	                success: function(resData) {
	                    const msg = $("#resultMsg");
	                    msg.show();

	                    if (resData.trim() === "PASS") {
	                        msg.html("사용 가능한 아이디입니다.").css("color", "green");
	                        isIdChecked = true;
	                    } else {
	                        msg.html("이미 사용중인 아이디입니다.").css("color", "red");
	                        $("#carId").val("").focus();
	                        isIdChecked = false;
	                    }
	                },
	                error: function(error) {
	                    console.log("아이디 중복검사 중 에러 발생:", error);
	                }
	            });
	        }
	    });

	    // 입력 커서가 비밀번호 필드로 이동하면 중복 검사 메시지를 숨깁니다.
	    $("#carPw").on("focus", () => {
	        const msg = $("#resultMsg");
	        if (msg.text() === "사용 가능한 아이디입니다.") {
	            msg.hide();
	        }
	    });
	    
	 // 이메일 인증번호 발송 요청
	    $("#emailnumber").on("click", function() {
	        const email = $('input[name="email"]').val();
	        
	        
	        if (email.trim().length === 0) {
	            alert("이메일 주소를 입력해주세요.");
	            return;
	        }

	        $.ajax({
	            type: "post",
	            url: "sendVerificationCode",
	            data: { email: email },
	            success: function(response) {
	                if (response === "SUCCESS") {
	                    alert("인증번호가 이메일로 전송되었습니다.");
	                } else {
	                    alert("인증번호 전송에 실패했습니다.");
	                }
	            },
	            error: function() {
	                alert("인증번호 전송 중 오류가 발생했습니다.");
	            }
	        });
	    });

	    // 인증번호 확인 요청
	    $("#verifyCodeButton").on("click", function() {
	        const email = $('input[name="email"]').val();
	        const verificationCode = $('input[name="emailkey"]').val();

	        if (email.trim().length === 0 || verificationCode.trim().length === 0) {
	            alert("이메일 주소와 인증번호를 모두 입력해주세요.");
	            return;
	        }

	        $.ajax({
	            type: "post",
	            url: "verifyCode",
	            contentType: "application/json", // JSON 형식으로 전송
	            data: JSON.stringify({ email: email, code: verificationCode }), // JSON 문자열로 변환
	            success: function(response) {
	                if (response === "SUCCESS") {
	                    alert("이메일 인증이 완료되었습니다.");
	                    isEmailVerified = true;
	                } else {
	                    alert("인증번호가 일치하지 않습니다.");
	                    isEmailVerified = false;
	                }
	            },
	            error: function() {
	                alert("인증 확인 중 오류가 발생했습니다.");
	            }
	        });
	    });
		
	    
	    function validateForm() {
	    	console.log("validateForm 실행");
	    	console.log("isIdChecked: ", isIdChecked);
	        console.log("isEmailVerified: ", isEmailVerified);
	        const password = document.querySelector('input[name="carPw"]').value;
	        const confirmPassword = document.querySelector('input[name="checkPw"]').value;
	        const termsChecked = Array.from(document.querySelectorAll('.checkbox-group input[type="checkbox"]')).every(checkbox => checkbox.checked);
	       
	        if (!isIdChecked) {
	            alert("아이디 중복검사를 진행해주세요.");
	            return false;
	        }

	        if (!isEmailVerified) {
	            alert("이메일 인증을 완료해주세요.");
	            return false;
	        }
	        
	        if (password !== confirmPassword) {
	            alert("비밀번호가 일치하지 않습니다.");
	            return false;
	        }
	        
	        if (!termsChecked) {
	            alert("모든 약관에 동의하셔야 합니다.");
	            return false;
	        }

	        return true;
	    }
	   
	    // 폼 제출 이벤트 핸들러
	    $("#signupForm").on("submit", function (event) {
	        if (!validateForm()) {
	            event.preventDefault(); // 제출 중단
	        }
	    });
	});

	</script>
</body>
</html>
