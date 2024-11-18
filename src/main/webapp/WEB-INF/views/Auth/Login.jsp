<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://accounts.google.com/gsi/client" async defer></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
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

.section {
	background: #f6f5f7;
	display: flex;
	justify-content: center;
	flex-direction:column;
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
<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />
<div class="section">
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
					<button class="signupinbtn" id="logout">로그아웃</button>
				</div>
				<div class="overlay-right">
					<h2>환영합니다<br>회원님만의 맞춤형 서비스를 만나보세요!</h2>
					<p>이미 가입한 회원이신가요?</p>
					<button class="signupinbtn" id="signIn">로그인</button>
				</div>
			</div>
		</div>

		<form id="loginForm" method="post" action="loginProcess.do">
			<div class="formbox sign-in-container">
				<div class="formlogo">
					<h2 class="signinlogo">Car<br>Planet</h2>
				</div>
				<h2>로그인</h2>
				<input class="signininput" id="loginCarId" name="carId" type="text" placeholder="아이디">
				<input class="signininput" id="loginCarPw" name="carPw" type="password" placeholder="비밀번호">
				<div id="loginErrorMsg" style="color: red; font-size: 14px; display: none; margin-top: 10px;"></div>
				<div class="pbox">
					<a href="${pageContext.request.contextPath}/Auth/IdPwsearch.do">계정을 잊어버리셨나요?</a>
				</div>
				<button class="signinbut" id="signin-btn" type="submit">로그인</button>
				<div class="s-login">
					<img id="googleLogin" src="${pageContext.request.contextPath}/resources/images/googlebutton.png" alt="Google">
					<img id="kakaologin" src="${pageContext.request.contextPath}/resources/images/kakaobutton.png" alt="Kakao">
					<img src="${pageContext.request.contextPath}/resources/images/naverbutton.png" alt="Naver">
				</div>
			</div>
		</form>
	</div>
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
	    
	    document.getElementById("loginForm").addEventListener("submit", function (event) {
	        const carId = document.getElementById("loginCarId").value.trim();
	        const carPw = document.getElementById("loginCarPw").value.trim();
	        const errorMsg = document.getElementById("loginErrorMsg");

	        // 기본 제출 동작 막기
	        event.preventDefault();

	        // 유효성 검사
	        if (carId === "" || carPw === "") {
	            errorMsg.textContent = "아이디와 비밀번호를 입력해주세요.";
	            errorMsg.style.display = "block";
	            return; // 폼 제출 중단
	        }

	        // 유효성 검사가 통과된 경우 폼 제출
	        errorMsg.style.display = "none"; // 에러 메시지 숨기기
	        this.submit();
	    });
	    
	 // 로그인 실패 시 메시지를 alert로 표시
        const serverMessage = "${msg}"; // EL로 모델 메시지 가져오기
                if (serverMessage && serverMessage.trim() !== "") {
                    alert(serverMessage); // 서버 메시지를 alert로 표시
                }
        
        Kakao.init('4e64d93f08866447cfc28a75eec83485'); // YOUR_JAVASCRIPT_KEY를 카카오 개발자 콘솔에서 복사한 JavaScript 키로 대체
        console.log(Kakao.isInitialized()); // Kakao SDK가 초기화되었는지 확인
        
        $('#kakaologin').on('click', function () {
            Kakao.Auth.login({
                scope: 'profile_nickname', // 필요한 동의 항목
                success: function (authObj) {
                    console.log('로그인 성공:', authObj);

                    // 사용자 정보 요청
                    Kakao.API.request({
                        url: '/v2/user/me',
                        success: function (res) {
                            console.log('사용자 정보:', res);

                            // 서버로 사용자 정보 전송
                            $.ajax({
                                type: 'POST',
                                url: 'kakaoLoginProcess.do', // 서버의 처리 엔드포인트
                                contentType: 'application/json',
                                data: JSON.stringify(res), // 사용자 정보를 JSON으로 전송
                                success: function (response) {
                                    alert('로그인 성공');
                                    window.location.href = '/V5/'; // 성공 후 리다이렉트
                                },
                                error: function (error) {
                                    console.error('서버 처리 에러:', error);
                                    alert('로그인 처리 중 문제가 발생했습니다.');
                                }
                            });
                        },
                        fail: function (error) {
                            console.error('사용자 정보 요청 실패:', error);
                        }
                    });
                },
                fail: function (error) {
                    console.error('로그인 실패:', error);
                    alert('카카오 로그인에 실패했습니다.');
                }
            });
        });
        
        // 구글 로그인 초기화
        window.onload = function () {
            google.accounts.id.initialize({
                client_id: '965683450029-68l8v3esl34io1oj9rn0cjavk5addr1c.apps.googleusercontent.com', // 구글 클라이언트 ID
                callback: handleGoogleLoginResponse
            });

            google.accounts.id.renderButton(
                document.getElementById('googleLogin'), // 구글 로그인 버튼 ID
                { theme: 'outline', size: 'large' }
            );
        };

        // 구글 로그인 응답 처리
        function handleGoogleLoginResponse(response) {
            console.log('구글 로그인 성공:', response);

            // 구글 ID 토큰 서버 전송
            $.ajax({
                type: 'POST',
                url: 'googleLoginProcess.do',
                contentType: 'application/json',
                data: JSON.stringify({ id_token: response.credential }),
                success: function (res) {
                    alert('구글 로그인 성공');
                    window.location.href = '/V5/';
                },
                error: function (err) {
                    console.error('구글 로그인 실패:', err);
                    alert('구글 로그인 처리 중 문제가 발생했습니다.');
                }
            });
        }
        
        
        $("#logout").on("click", function () {
            // 확인 알림창
            const confirmation = confirm("정말 로그아웃 하시겠습니까?");
            
            if (confirmation) {
                // 사용자가 '확인'을 누르면 로그아웃 요청 전송
                $.ajax({
                    url: "logout.do", // 서버 로그아웃 URL
                    type: "GET", // 로그아웃 요청 방식
                    success: function (response) {
                        // 로그아웃 성공 시 메인 페이지로 리다이렉트
                        alert("로그아웃되었습니다.");
                        window.location.href = "/V5/"; // 메인 페이지로 이동
                    },
                    error: function (xhr, status, error) {
                        console.error("로그아웃 요청 중 오류 발생:", error);
                        alert("로그아웃에 실패했습니다.");
                    },
                });
            } else {
                // 사용자가 '취소'를 누르면 아무 동작도 하지 않음
                console.log("사용자가 로그아웃을 취소했습니다.");
            }
        });
        
	});

	</script>
	<!-- 푸터 -->
<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />
</body>
</html>
