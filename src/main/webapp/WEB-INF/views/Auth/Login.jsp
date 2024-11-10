<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 및 회원가입</title>
<style>
@font-face {
	font-family: 'KIMM_Bold';
	src:
		url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2212@1.0/KIMM_Bold.woff2')
		format('woff2');
	font-weight: 700;
	font-style: normal;
}

* {
	box-sizing: border-box;
}

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
	overflow:hidden;
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



.signinlogo{
	font-family: 'KIMM_Bold';
}

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

@
keyframes show { 0%, 49.99% {
	opacity: 0;
	z-index: 1;
}

50
%
,
100
%
{
opacity
:
1;
z-index
:
5;
}
}
.formbox h2 {
	margin-bottom: 20px;
}

.formbox p {
	font-weight: bold;
	font-size: 15px;
	cursor: pointer;
}

.formlogo h2 {
	font-size: 2rem;
	margin: 0;
	padding: 0;
	color: #333;
}

.signininput, .signupinput{
	padding: 10px;
	width: 80%;
	margin: 10px 0;
	font-size: 16px;
	border: 1px solid #ddd;
	border-radius: 5px;
}
.checkbox-group{
	width:80%;
	display:flex;
	flex-direction:column;
	align-items:start;
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

.signupinbtn:hover{
	transform: scale(1.1);
}

.pbox {
	width: 80%;
	text-align: left;
}

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

.pagebox h2, .pagebox p {
	margin-bottom: 20px;
}

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
	border-radius:15px;
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
	color:white;
	font-weight:bold;
	border-radius:15px;
}


.overlay-left {
	transform: translateX(0);
	left: 0;
}

.container.right-panel-active .overlay-left {
	transform: translateX(0);
	opacity:0;
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

</style>
</head>
<body>
	<div class="container" id="container">
	<form>
		<div class="formbox sign-up-container">
			<div class="formlogo">
				<h2>회원가입</h2>
			</div>
			<input class="signupinput" type="text" placeholder="이름">
			<input class="signupinput" type="text" placeholder="전화번호">
			<input class="signupinput" type="text" placeholder="아이디">
			<input class="signupinput" type="password" placeholder="비밀번호">
			<input class="signupinput" type="password" placeholder="비밀번호 확인">
			<input class="signupinput" type="text" placeholder="이메일">
			<input class="signupinput" type="text" placeholder="이메일 인증번호 입력">
			<input class="signupinput" type="date" placeholder="생년월일">
			<div class="checkbox-group">
				<label><input type="checkbox"> 이용약관 필수 동의</label>
				<label><input type="checkbox"> 위치정보 이용약관 필수 동의</label>
				<label><input type="checkbox"> 개인정보 처리방침 필수 동의</label>
			</div>
			<button type="submit" class="signinbut">회원가입</button>
		</div>
		</form>

		<div class="overlay-container">
			<div class="overlay">
				<div class="overlay-left">
					<h2>다시 오셨네요!<br>맞춤 충전소 정보를<br> 확인하세요!</h2>
					<p>아직 가입한 계정이 없으신가요?</p>
					<p>아래 버튼을 누르면 회원가입 화면이 나타납니다!</p>
					<button class="signupinbtn" id="signUp">회원가입</button>
				</div>
				<div class="overlay-right">
					<h2>환영합니다<br>회원님만의<br>맞춤형 서비스를<br>만나보세요!</h2>
					<p>이미 가입한 회원이신가요?</p>
					<p>아래 버튼을 누르면 로그인 화면이 나타납니다!</p>
					<button class="signupinbtn" id="signIn">로그인</button>
				</div>
			</div>
		</div>
		<form>
		<div class="formbox sign-in-container">
			<div class="formlogo">
				<h2 class="signinlogo">
					Car<br>Planet
				</h2>
			</div>
			<h2>로그인</h2>
			<input class="signininput" type="text" placeholder="아이디"> <input
				class="signininput" type="password" placeholder="비밀번호">
			<div class="pbox">
				<p>아이디를 잊어버리셨나요?</p>
				<p>비밀번호를 잊어버리셨나요?</p>
			</div>
			<button class="signinbut" type="submit">로그인</button>
			<div class="s-login">
				<img
					src="${pageContext.request.contextPath}/resources/images/googlebutton.png"
					alt="Google"> <img
					src="${pageContext.request.contextPath}/resources/images/kakaobutton.png"
					alt="Kakao"> <img
					src="${pageContext.request.contextPath}/resources/images/naverbutton.png"
					alt="Naver">
			</div>
		</div>
		</form>
	</div>

	<script>
		const signUpButton = document.getElementById('signUp');
		const signInButton = document.getElementById('signIn');
		const container = document.getElementById('container');

		signUpButton.addEventListener('click', () => {
			container.classList.add("right-panel-active");
		});

		signInButton.addEventListener('click', () => {
			container.classList.remove("right-panel-active");
		});
	</script>
</body>
</html>
