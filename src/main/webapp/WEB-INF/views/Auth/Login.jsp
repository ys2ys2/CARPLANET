<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://accounts.google.com/gsi/client" async defer></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="${pageContext.request.contextPath}/resources/css/Login.css" rel="stylesheet" type="text/css">


<meta charset="UTF-8">

<title>로그인 및 회원가입</title>

</head>
<body>
<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />
<div class="section">
	<div class="container" id="container">
		<form id="signupForm" action="joinProcess.do" method="POST">
			<div class="formbox sign-up-container" style="justify-content: flex-start;">
				<div class="formlogo">
					<h2>회원가입</h2>
				</div>
				<input class="signupinput" name="carName" type="text" placeholder="이름" required>
				<input class="signupinput" name="phone" type="text" placeholder="전화번호" required>
				
				<div class="wrapbox">
				<input class="signupinput" id="carId" name="carId" type="text" placeholder="아이디" required>
				<button type="button" class="wrapbut" id="checkId">중복검사</button>
				</div>
				
				<div id="resultMsg" style="display:none; font-size:13px; color:red; margin-top:5px;"></div>
				<input style="margin-top:0;" class="signupinput" id="carPw" name="carPw" type="password" placeholder="비밀번호" maxlength="16" required>
				<p id="pwwarning" class="pwterm">※비밀번호는 8~16자, 최소 1개의 소문자와 1개의 특수문자를 포함해야 합니다.</p>
				<input class="signupinput" name="checkPw" type="password" placeholder="비밀번호 확인" required>
				<div class="wrapbox">
				<input class="signupinput" name="email" type="text" id="emailInput" placeholder="이메일" required>
				<button id="emailnumber" type="button" class="wrapbut">인증번호 받기</button>
				</div>			
				<p id="emailWarning" class="pwterm">※이메일 주소를 입력해주세요. 올바른 형식 예: user@example.com</p>
				<div class="wrapbox">
				<input class="signupinput" name="emailkey" type="text" placeholder="인증번호입력" required>
				<button type="button" class="wrapbut" id="verifyCodeButton">인증확인</button>
				</div>
				<input class="signupinput" name="birthday" type="text" placeholder="생년월일 8자리" maxlength="8" required>
				<p id="birWarning" class="pwterm">※생년월일을 입력해주세요. 올바른 형식 예: 19980410</p>
				<div class="checkbox-group">
					<label><input type="checkbox" required data-type="termsOfService" class="terms-detail"> 이용약관 필수 동의</label>
   					<label><input type="checkbox" required data-type="locationPolicy" class="terms-detail"> 위치정보 이용약관 필수 동의</label>
    				<label><input type="checkbox" required data-type="privacyPolicy" class="terms-detail"> 개인정보 처리방침 필수 동의</label>

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

		<form id="loginForm" method="post" action="loginProcess.do">
			<div class="formbox sign-in-container">
				<div class="formlogo">
					<span class="signinlogo">CAR PLANET</span>
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
					<div id="googleLogin"></div>
					<div class="s-loginImg"><img id="kakaologin" src="${pageContext.request.contextPath}/resources/images/kakaobutton.png" alt="Kakao">
					<img src="${pageContext.request.contextPath}/resources/images/naverbutton.png" alt="Naver"></div>
				</div>
			</div>
		</form>
	</div>
	
	<div class="terms-modal" id="termsModal" style="display: none;">
    <div class="Lmodal-content">
        <span class="close-button" id="closeModal">&times;</span>
        <h2 id="modalTitle">약관 제목</h2>
        <div id="modalContent">약관 상세 내용</div>
        <!-- 모달 내 체크박스와 버튼 -->
        <div style="margin-top: 20px;">
            <label><input type="checkbox" id="modalCheckbox"> 약관을 읽고 동의합니다.</label>
        </div>
        <div style="margin:20px 0 20px 0;">
            <button id="confirmTerms" disabled>확인</button>
            <button id="cancelTerms">취소</button>
        </div>
    </div>
	</div>
	</div>


	<script>
	$(document).ready(function() {
	    const signUpButton = document.getElementById('signUp');
	    const signInButton = document.getElementById('signIn');
	    const container = document.getElementById('container');
	    const termsModal = $("#termsModal");
	    const modalTitle = $("#modalTitle");
	    const modalContent = $("#modalContent");
	    const closeModal = $("#closeModal");
	    const confirmTerms = $("#confirmTerms");
	    const modalCheckbox = $("#modalCheckbox");
	    const cancelTerms = $("#cancelTerms");
	    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	    const passwordRegex = /^(?=.*[a-z])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,16}$/;
	    const passwordInput = document.querySelector('input[name="carPw"]');
	    const passwordMessage = document.getElementById('pwwarning'); // 안내문자 요소 생성
	    const emailInput = document.getElementById('emailInput');
	    const emailMessage = document.getElementById('emailWarning');
	    const birthdayInput = document.querySelector('input[name="birthday"]');
	    const birRegex = /^\d{8}$/;
	    const termsDetails = {
	    	    termsOfService: `
	    	        1. 본 서비스는 사용자에게 정보를 제공하기 위해 운영됩니다.<br>
	    	        2. 사용자는 서비스를 개인적인 목적으로만 사용할 수 있으며, 상업적 목적으로 사용할 수 없습니다.<br>
	    	        3. 서비스를 악용하거나 불법적인 행위를 하지 않을 의무가 있습니다.<br>
	    	        4. 회사는 서비스 운영과 관련된 변경, 중단 또는 종료를 할 권리가 있습니다.
	    	    `,
	    	    locationPolicy: `
	    	        1. 본 서비스는 사용자의 위치정보를 기반으로 맞춤형 서비스를 제공합니다.<br>
	    	        2. 위치정보는 사용자 동의 하에 수집되며, 서비스 제공을 위한 목적으로만 사용됩니다.<br>
	    	        3. 사용자는 언제든지 위치정보 제공을 중단할 수 있습니다.<br>
	    	        4. 위치정보는 서비스 종료 후 즉시 삭제됩니다.
	    	    `,
	    	    privacyPolicy: `
	    	        1. 개인정보는 사용자의 동의 하에 수집되며, 법적 근거에 따라 안전하게 처리됩니다.<br>
	    	        2. 수집된 개인정보는 서비스 제공, 계정 관리 및 법적 의무 준수를 위해 사용됩니다.<br>
	    	        3. 사용자는 언제든지 개인정보 열람, 수정 및 삭제를 요청할 권리가 있습니다.<br>
	    	        4. 회사는 개인정보를 제3자와 공유하지 않으며, 보안을 위해 최선을 다합니다.
	    	    `
	    	};

	    
	    $(".terms-detail").on("click", function (event) {
	        event.preventDefault(); // 기본 체크 방지
	        const type = $(this).data("type");
	        const parentCheckbox = $(this); // 부모 체크박스 참조 저장

	        // 약관 상세내용 설정
	        if (termsDetails[type]) {
	            modalTitle.text(type === "termsOfService" ? "이용약관" : 
	                            type === "locationPolicy" ? "위치정보 이용약관" : 
	                            "개인정보 처리방침");
	            modalContent.html(termsDetails[type]);
	        } else {
	            modalTitle.text("약관 내용");
	            modalContent.text("약관 내용을 불러오지 못했습니다.");
	        }

	        // 초기화
	        modalCheckbox.prop("checked", false);
	        confirmTerms.prop("disabled", true);

	        // 모달 보이기
	        termsModal.fadeIn();

	        // 모달 내 체크박스 상태 변경
	        modalCheckbox.on("change", function () {
	            confirmTerms.prop("disabled", !$(this).is(":checked")); // 체크 상태에 따라 버튼 활성화
	        });

	        // 확인 버튼 클릭 시
	        confirmTerms.off("click").on("click", function () {
	            parentCheckbox.prop("checked", true); // 상위 체크박스 활성화
	            termsModal.fadeOut(); // 모달 닫기
	        });

	        // 취소 버튼 또는 닫기 버튼 클릭 시
	        cancelTerms.off("click").on("click", function () {
	            termsModal.fadeOut(); // 모달 닫기
	        });

	        closeModal.off("click").on("click", function () {
	            termsModal.fadeOut(); // 모달 닫기
	        });
	    });

	    // 모달 배경 클릭 시 닫기
	    $(window).on("click", function (e) {
	        if ($(e.target).is(termsModal)) {
	            termsModal.fadeOut();
	        }
	    });

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
		
	    
	    function validateEmail(email) {
	        return emailRegex.test(email);
	    }

	    function validatePassword(password) {
	        return passwordRegex.test(password);
	    }
	    
	    function validateBir(birthday){
	    	return birRegex.test(birthday);
	    }

	    // 이메일 입력 이벤트 핸들러
	    emailInput.addEventListener('input', function () {
	        const email = emailInput.value.trim();
	        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // 간단한 이메일 형식 검사

	        if (email === "") {
	            emailMessage.textContent = "이메일 주소를 입력해주세요.";
	            emailMessage.style.color = "red";
	            emailMessage.style.display = "block";
	        } else if (!emailRegex.test(email)) {
	            emailMessage.textContent = "※올바른 이메일 형식을 입력해주세요. 예: user@example.com";
	            emailMessage.style.color = "red";
	            emailMessage.style.display = "block";
	        } else {
	            emailMessage.textContent = "사용 가능한 이메일 형식입니다.";
	            emailMessage.style.color = "green";
	            emailMessage.style.display = "block";
	        }
	    });
	    
	    //생일입력 이벤트 핸들러
birthdayInput.addEventListener('input', function () {
    const birthday = birthdayInput.value.trim();
    const birRegex = /^\d{8}$/; // 8자리 숫자 형식 확인

    if (!birRegex.test(birthday)) {
        birWarning.textContent = "생년월일은 8자리 숫자로 입력해주세요. 예: 19980410";
        return;
    }

    const year = parseInt(birthday.substring(0, 4), 10);
    const month = parseInt(birthday.substring(4, 6), 10);
    const day = parseInt(birthday.substring(6, 8), 10);

    // 현재 연도 가져오기
    const currentYear = new Date().getFullYear();

    // 연도, 월, 일 유효성 검사
    if (year < 1900 || year > currentYear) {
        birWarning.textContent = "연도는 1900~" + currentYear + " 사이여야 합니다.";
    } else if (month < 1 || month > 12) {
        birWarning.textContent = "월은 1~12 사이여야 합니다.";
    } else {
        // 월에 따라 최대 일 수 계산
        const daysInMonth = new Date(year, month, 0).getDate(); // month에 0을 넣으면 이전 월의 마지막 날 반환
        if (day < 1 || day > daysInMonth) {
            birWarning.textContent = month + "월에는 1~" + daysInMonth + "일만 유효합니다.";
        } else {
            birWarning.textContent = "올바른 생년월일 입니다."; // 모든 유효성 검사가 통과되면 경고 메시지 제거
            birWarning.style.color = "green";
        }
    }
});




	    // 비밀번호 입력 이벤트 핸들러
	    passwordInput.addEventListener('input', function () {
	        const password = passwordInput.value.trim();
	        const passwordRegex = /^(?=.*[a-z])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,16}$/;

	        if (password === "") {
	            passwordMessage.textContent = "비밀번호를 입력해주세요.";
	            passwordMessage.style.color = "red";
	            passwordMessage.style.display = "block";
	        } else if (!passwordRegex.test(password)) {
	            passwordMessage.textContent =
	                "비밀번호는 8~16자, 최소 1개의 소문자와 1개의 특수문자를 포함해야 합니다.";
	            passwordMessage.style.color = "red";
	            passwordMessage.style.display = "block";
	        } else {
	            passwordMessage.textContent = "사용 가능한 비밀번호입니다.";
	            passwordMessage.style.color = "green";
	            passwordMessage.style.display = "block";
	        }
	    });
	    
	    function validateForm() {
	        console.log("validateForm 실행");
	        console.log("isIdChecked: ", isIdChecked);
	        console.log("isEmailVerified: ", isEmailVerified);

	        // 폼 필드 값 가져오기
	        const email = document.querySelector('input[name="email"]').value.trim();
	        const password = document.querySelector('input[name="carPw"]').value.trim();
	        const confirmPassword = document.querySelector('input[name="checkPw"]').value.trim();
	        const birthday = document.querySelector('input[name="birthday"]').value.trim();
	        const termsChecked = Array.from(
	            document.querySelectorAll('.checkbox-group input[type="checkbox"]')
	        ).every(checkbox => checkbox.checked);

	        // 이메일 유효성 검사
	        if (!validateEmail(email)) {
	            alert("유효하지 않은 이메일 형식입니다. 올바른 이메일 주소를 입력해주세요.");
	            return false;
	        }

	        // 비밀번호 유효성 검사
	        if (!validatePassword(password)) {
	            alert("비밀번호는 8~16자이며, 최소 1개의 소문자와 1개의 특수문자를 포함해야 합니다.");
	            return false;
	        }
	        
	        if (!validateBir(birthday)){
	        	alert("생년월일을 정확히 입력해 주세요")
	        	return false;
	        }

	        // 비밀번호 확인 검사
	        if (password !== confirmPassword) {
	            alert("비밀번호가 일치하지 않습니다.");
	            return false;
	        }

	        // 아이디 중복 검사 확인
	        if (!isIdChecked) {
	            alert("아이디 중복검사를 진행해주세요.");
	            return false;
	        }

	        // 이메일 인증 확인
	        if (!isEmailVerified) {
	            alert("이메일 인증을 완료해주세요.");
	            return false;
	        }

	        // 약관 동의 확인
	        if (!termsChecked) {
	            alert("모든 약관에 동의하셔야 합니다.");
	            return false;
	        }

	        // 모든 유효성 검사가 통과되면 true 반환
	        return true;
	    }

	    // 폼 제출 이벤트 핸들러
	    $("#signupForm").on("submit", function (event) {
	        if (!validateForm()) {
	            event.preventDefault(); // 제출 중단
	        }
	    });

	   
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
                scope: 'profile_nickname',
                success: function (authObj) {
                    console.log('로그인 성공:', authObj);

                    Kakao.API.request({
                        url: '/v2/user/me',
                        success: function (res) {
                            console.log('사용자 정보:', res);

                            // 서버로 사용자 정보 전송
                            $.ajax({
                                type: 'POST',
                                url: 'kakaoLoginProcess.do',
                                contentType: 'application/json',
                                data: JSON.stringify(res),
                                success: function (response) {
                                    console.log('서버 응답:', response);

                                    // 응답 데이터 전체 확인
                                    console.log('리다이렉트 URL:', response.redirectUrl);
                                    console.log('carId:', response.carId);

                                    if (response.redirectUrl) {
                                        if (response.redirectUrl.includes("Authsetname.do") && response.carId) {
                                        	const finalRedirectUrl = response.redirectUrl+"?carId="+response.carId;
                                        	console.log('Final Redirect URL:', finalRedirectUrl); // 최종 URL
                                        	window.location.href = finalRedirectUrl;
                                        } else {
                                            window.location.href = response.redirectUrl;
                                        }
                                    } else {
                                        console.error("리다이렉트 URL이 응답에 없습니다.");
                                        alert("리다이렉트 정보가 누락되었습니다.");
                                    }
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


        
        window.onload = function () {
            google.accounts.id.initialize({
                client_id: "965683450029-68l8v3esl34io1oj9rn0cjavk5addr1c.apps.googleusercontent.com", // Google 클라이언트 ID
                callback: handleGoogleLoginResponse, // 성공 시 콜백
            });

            // Google에서 제공하는 버튼 렌더링
            google.accounts.id.renderButton(
                document.getElementById('googleLogin'), // 버튼이 렌더링될 요소
                { theme: 'outline', size: 'large' } // 버튼 스타일
            );
        };

// Google 로그인 성공 후 응답 처리
        function handleGoogleLoginResponse(response) {
            console.log('Google 로그인 성공:', response);

            // ID 토큰(credential)을 서버로 전송하여 처리
            $.ajax({
                type: 'POST',
                url: 'googleLoginProcess.do', // 서버의 처리 URL
                contentType: 'application/json',
                data: JSON.stringify({ id_token: response.credential }), // ID 토큰을 JSON 형식으로 서버에 전송
                success: function (response) {
                    console.log('서버 응답:', response);

                    // 응답 데이터에서 리다이렉트 URL 확인
                    if (response.redirectUrl) {
                        // 신규 사용자라면 닉네임 설정 페이지로 이동
                        if (response.redirectUrl.includes("Authsetname.do") && response.carId) {
                            window.location.href = response.redirectUrl+"?carId="+response.carId;
                        } else {
                            // 기존 사용자는 메인 페이지로 이동
                            window.location.href = response.redirectUrl;
                        }
                    } else {
                        console.error("리다이렉트 URL이 응답에 없습니다.");
                        alert("리다이렉트 정보가 누락되었습니다.");
                    }
                },
                error: function (error) {
                    console.error('구글 로그인 처리 중 오류:', error);
                    alert('Google 로그인 처리 중 문제가 발생했습니다.');
                }
            });
        }


        
	});

	</script>
	<!-- 푸터 -->
<div class="footer-right"><jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" /></div>
<div class="footer"><jsp:include page="/WEB-INF/views/MainPage/footer.jsp" /></div>
</body>
</html>
