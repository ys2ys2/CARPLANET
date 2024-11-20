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
	flex-direction:column;
	width: 70%;
	gap: 20px;
}
.s-loginImg{
	display: flex;
	justify-content: space-evenly;
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

.terms-modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
}

.modal-content {
    background: #fff;
    padding: 20px;
    border-radius: 10px;
    width: 80%;
    max-width: 500px;
    text-align: center; /* 기본적으로 가운데 정렬 */
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

#modalContent {
	margin:0 auto;
	width: 80%;
    text-align: Left; /* 텍스트만 왼쪽 정렬 */
    line-height: 1.6; /* 읽기 편하도록 줄 간격 설정 */
    background-color: #f9f9f9; /* 연한 배경색으로 박스 구분 */
    border: 1px solid #ddd; /* 연한 테두리 */
    border-radius: 10px; /* 모서리를 둥글게 */
    padding: 20px; /* 내부 여백 */
    margin-top: 10px; /* 상위 요소와 간격 추가 */
}

.close-button {
    position: absolute;
    top: 10px;
    right: 20px;
    font-size: 24px;
    cursor: pointer;
    color: #333;
}

#confirmTerms, #cancelTerms {
    padding: 10px 20px; /* 버튼 크기 */
    font-size: 14px; /* 텍스트 크기 */
    font-weight: bold; /* 텍스트 두께 */
    border-radius: 5px; /* 모서리를 둥글게 */
    border: 1px solid #ccc; /* 테두리 색상 */
    background: linear-gradient(to right, #f6f6f6, #e9e9e9); /* 부드러운 배경 그라데이션 */
    color: #333; /* 텍스트 색상 */
    cursor: pointer; /* 마우스 커서를 포인터로 변경 */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 가벼운 그림자 효과 */
    transition: all 0.3s ease; /* 부드러운 애니메이션 */
}

/* 호버 효과 */
#confirmTerms:hover, #cancelTerms:hover {
    background: linear-gradient(to right, #e0e0e0, #d4d4d4); /* 호버 시 배경 그라데이션 변경 */
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2); /* 호버 시 그림자 확대 */
    border-color: #aaa; /* 테두리 색상 변경 */
}

/* 활성화된 확인 버튼 */
#confirmTerms:disabled {
    background: #f0f0f0; /* 비활성화 시 배경색 */
    color: #aaa; /* 비활성화 시 텍스트 색상 */
    border-color: #ddd; /* 비활성화 시 테두리 색상 */
    cursor: not-allowed; /* 커서를 '금지'로 변경 */
    box-shadow: none; /* 그림자 제거 */
}

.pwterm{
	width:80%;
	font-weight: normal !important;
	font-size: 9px !important;
	text-align: left;
	cursor: text !important;
}

/* 테블릿 PC */
@media (max-width: 1024px) {
    .container {
        width: 70%; /* 너비를 줄여서 레이아웃 조정 */
        height: 70vh; /* 높이도 조금 줄임 */
    }
	
	.formbox{
		width: 50%
	}
	
    .formbox, .pagebox {
        padding: 10px; /* 내부 여백 조정 */
    }

    .signininput, .signupinput {
        font-size: 12px; /* 입력 필드 글씨 크기 줄임 */
        padding: 8px; /* 패딩 조정 */
    }

    .signinbut, .signupinbtn {
        font-size: 14px; /* 버튼 텍스트 크기 조정 */
        padding: 8px; /* 패딩 줄임 */
    }

    .s-login img {
        width: 30px; /* 소셜 로그인 버튼 크기 줄임 */
        height: 30px;
    }
}

/* 모바일 */
@media (max-width: 768px) {
    .container {
        width: 100%; /* 너비를 100%로 확장 */
        height: auto; /* 높이를 자동으로 */
        flex-direction: column; /* 세로 방향으로 나열 */
    }

    .formbox, .pagebox {
        height: 50vh; /* 높이를 자동으로 */
        padding: 15px; /* 여백 약간 추가 */
    }

    .signininput, .signupinput {
        font-size: 10px; /* 글씨 크기 더 줄임 */
        padding: 6px; /* 패딩 줄임 */
    }

    .signinbut, .signupinbtn {
        font-size: 12px; /* 버튼 텍스트 더 줄임 */
        padding: 6px;
    }

    .s-login {
        width: 100%; /* 소셜 로그인 섹션 전체 너비 사용 */
    }

    .s-login img {
        width: 25px; /* 버튼 크기 더 줄임 */
        height: 25px;
    }

    .wrapbut {
        font-size: 12px; /* 버튼 텍스트 크기 조정 */
        padding: 5px; /* 패딩 줄임 */
        height: auto; /* 높이 자동으로 */
    }
}

/* 중형 모바일 */
@media (max-width: 425px) {
    .container {
        flex-direction: column; /* 세로 방향으로 정렬 */
        width: 100%; /* 전체 너비 사용 */
        height: auto; /* 높이 자동으로 */
    }

    .formbox, .pagebox {
        width: 50%; /* 박스가 전체 너비를 차지 */
        padding: 10px; /* 내부 여백 줄임 */
    }

    .signininput, .signupinput {
        font-size: 9px; /* 글씨 크기 더 줄임 */
        padding: 5px; /* 패딩 줄임 */
    }

    .signinbut, .signupinbtn {
        font-size: 10px; /* 버튼 텍스트 줄임 */
        padding: 5px;
    }

    .s-login img {
        width: 20px; /* 소셜 로그인 버튼 크기 더 줄임 */
        height: 20px;
    }

    .wrapbut {
        font-size: 10px; /* 버튼 텍스트 더 줄임 */
        padding: 4px; /* 패딩 줄임 */
        height: auto; /* 높이 자동으로 */
    }
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
				<p class="pwterm">※비밀번호는 8~16자 영문 소문자 및 특수문자 1개이상 포함 공백금지 </p>
				<input style="margin-top:0;" class="signupinput" id="carPw" name="carPw" type="password" placeholder="비밀번호" required>
				<input class="signupinput" name="checkPw" type="password" placeholder="비밀번호 확인" required>
				<p class="pwterm">※이메일 주소를 입력해주세요. 올바른 형식 예: user@example.com</p>
				<div class="wrapbox">
				<input style="margin-top:0;" class="signupinput" name="email" type="text" placeholder="이메일" required>
				<button id="emailnumber" type="button" class="wrapbut">인증번호 받기</button>
				</div>			
				<div class="wrapbox">
				<input class="signupinput" name="emailkey" type="text" placeholder="인증번호입력" required>
				<button type="button" class="wrapbut" id="verifyCodeButton">인증확인</button>
				</div>
				<input class="signupinput" name="birthday" type="text" placeholder="생년월일 8자리" required>
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
					<div id="googleLogin"></div>
					<div class="s-loginImg"><img id="kakaologin" src="${pageContext.request.contextPath}/resources/images/kakaobutton.png" alt="Kakao">
					<img src="${pageContext.request.contextPath}/resources/images/naverbutton.png" alt="Naver"></div>
				</div>
			</div>
		</form>
	</div>
	
	<div class="terms-modal" id="termsModal" style="display: none;">
    <div class="modal-content">
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
<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />
</body>
</html>
