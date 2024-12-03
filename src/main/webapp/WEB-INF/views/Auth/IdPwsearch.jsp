<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>아이디/비밀번호 찾기</title>
<style>
html, body {
	height: 100%; /* html과 body가 전체 높이를 가짐 */
	margin: 0;
	padding: 0;
	display: flex;
	flex-direction: column;
}

.section {
	display: flex;
	background-color:#f6f5f7;
	justify-content: center;
	align-items: center;
	flex-direction: column;
	height: 100%;
	width: 100%; /* 추가: 전체 너비 사용 */
	text-align: center;
	box-sizing: border-box; /* padding 포함 */
}

.mainbox {
	width: 40%;
	min-width: 350px;
	background: #fff;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
	border-radius: 15px;
	overflow: hidden;
	display: flex;
	flex-direction: column;
	position: relative;
	margin: 0 auto; /* 중앙 정렬 */
}

.title {
	padding: 20px 0;
	background-color: #161938;
	color: white;
	font-size: 20px;
	font-weight: bold;
	border-radius: 15px 15px 0 0;
	text-align: center;
	border-bottom: solid 2px white;
}

.cateban {
	display: flex;
	background-color: #fafafa;
	border-bottom: 2px solid #eeeeee;
}

.cateban>p {
	flex: 1;
	text-align: center;
	padding: 15px 0;
	font-size: 16px;
	font-weight: 600;
	color: #666666;
	cursor: pointer;
	transition: background-color 0.3s ease, color 0.3s ease;
}

.cateban>p.active {
	background-color: #161938;
	color: #ffffff;
	border-bottom: 3px solid #1d4e89;
}

.cateban>p:hover {
	background-color: #e0e0e0;
}

.content {
	padding: 30px 20px;
	background-color: #f9f9f9;
	display: flex;
	justify-content: center;
	align-items: center;
}

.idform, .pwform {
	display: none;
	width: 100%;
	justify-content: center;
	align-items: center;
}

.idform.active, .pwform.active {
	display: flex;
}

form {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 15px;
	width: 100%;
	max-width: 300px;
}

form p {
	font-size: 14px;
	font-weight: bold;
	color: #555555;
	margin-bottom: 5px;
}

.signupinput {
	width: 100%;
	padding: 12px;
	font-size: 14px;
	border: 1px solid #cccccc;
	border-radius: 8px;
	background-color: #ffffff;
	transition: all 0.2s ease;
}

.signupinput:focus {
	border-color: #161938;
	box-shadow: 0 0 5px rgba(106, 17, 203, 0.2);
	outline: none;
}

button {
	padding: 12px 20px;
	font-size: 14px;
	font-weight: bold;
	color: #ffffff;
	background-color: #161938;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	transition: background-color 0.2s ease, transform 0.2s ease;
}

button:hover {
	background-color: #1d4e89;
}

button:active {
	transform: scale(0.98);
}

.icon {
	display: flex;
	align-items: center;
	justify-content: space-between;
	width: 100%;
}

.wrapbut {
	font-size: 12px; /* 텍스트 크기를 조금 줄여서 버튼 안에 맞춤 */
	border: 1px solid #ddd;
	border-radius: 5px;
	padding: 8px 10px; /* 수직 패딩을 줄여 버튼 높이를 낮춤 */
	margin-left: 5px;
	background-color: #161938;
	cursor: pointer;
	width: 90px; /* 버튼의 고정 너비 설정 */
	height: 40px; /* signupinput과 동일한 높이 */
	display: flex;
	align-items: center;
	justify-content: center;
	text-align: center;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />
	<div class="section">
		<div class="mainbox">
			<div class="title">아이디 / 비밀번호 찾기</div>
			<div class="cateban">
				<p id="idTab" class="active">아이디 찾기</p>
				<p id="pwTab">비밀번호 찾기</p>
			</div>
			<div class="content">
				<!-- 아이디 찾기 폼 -->
				<div class="idform active" id="idForm">
					<form id="findIdForm">
						<p>이름</p>
						<div class="icon">
							<input class="signupinput" id="name" name="name" type="text"
								placeholder="이름" required>
						</div>
						<p>이메일</p>
						<div class="icon">
							<input class="signupinput" id="emailId" name="email" type="email"
								placeholder="이메일" required>
							<button id="emailnumber-id" type="button" class="wrapbut">인증번호
								받기</button>
						</div>
						<div class="icon">
							<input class="signupinput" id="emailKeyId" name="emailkey"
								type="text" placeholder="인증번호입력" required>
							<button type="button" class="wrapbut" id="verifyCodeButtonId">인증확인</button>
						</div>
						<button type="submit">아이디 찾기</button>
					</form>
					<div id="idResult"
						style="margin-top: 20px; color: green; font-weight: bold;"></div>
				</div>
				<!-- 비밀번호 찾기 폼 -->
				<div class="pwform" id="pwForm">
					<form id="pwForm">
						<p>아이디</p>
						<div class="icon">
							<input class="signupinput" id="carId" name="carId" type="text"
								placeholder="아이디" required>
						</div>
						<p>이메일</p>
						<div class="icon">
							<input class="signupinput" id="emailPw" name="email" type="email"
								placeholder="이메일" required>
							<button id="emailnumber-pw" type="button" class="wrapbut">인증번호
								받기</button>
						</div>
						<div class="icon">
							<input class="signupinput" id="emailKeyPw" name="emailkey"
								type="text" placeholder="인증번호입력" required>
							<button type="button" class="wrapbut" id="verifyCodeButtonPw">인증확인</button>
						</div>
						<button type="submit">비밀번호 찾기</button>
					</form>
				</div>
			</div>
		</div>
	</div>


	<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
	<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />
</body>

<script>
	$(document).ready(
			function() {
				let isEmailVerified = false; // 이메일 인증 상태 플래그

				// 이메일 인증번호 발송 요청
				// 아이디 찾기 폼 - 인증번호 발송 요청
				$("#emailnumber-id").on("click", function() {
					const email = $("#idForm input[name='email']").val(); // 아이디 찾기 폼 이메일 입력값
					if (email.trim().length === 0) {
						alert("이메일 주소를 입력해주세요.");
						return;
					}

					$.ajax({
						type : "post",
						url : "sendVerificationCode",
						data : {
							email : email
						},
						success : function(response) {
							if (response === "SUCCESS") {
								alert("인증번호가 이메일로 전송되었습니다.");
							} else {
								alert("인증번호 전송에 실패했습니다.");
							}
						},
						error : function() {
							alert("인증번호 전송 중 오류가 발생했습니다.");
						},
					});
				});

				// 비밀번호 찾기 폼 - 인증번호 발송 요청
				$("#emailnumber-pw").on("click", function() {
					const email = $("#pwForm input[name='email']").val(); // 비밀번호 찾기 폼 이메일 입력값
					if (email.trim().length === 0) {
						alert("이메일 주소를 입력해주세요.");
						return;
					}

					$.ajax({
						type : "post",
						url : "sendVerificationCode",
						data : {
							email : email
						},
						success : function(response) {
							if (response === "SUCCESS") {
								alert("인증번호가 이메일로 전송되었습니다.");
							} else {
								alert("인증번호 전송에 실패했습니다.");
							}
						},
						error : function() {
							alert("인증번호 전송 중 오류가 발생했습니다.");
						},
					});
				});

				// 아이디 찾기 폼 - 인증번호 확인 요청
				$("#verifyCodeButtonId").on(
						"click",
						function() {
							const email = $("#idForm input[name='email']")
									.val(); // 아이디 찾기 폼 이메일 입력값
							const verificationCode = $("#emailKeyId").val(); // 인증번호 입력값

							if (email.trim().length === 0
									|| verificationCode.trim().length === 0) {
								alert("이메일 주소와 인증번호를 모두 입력해주세요.");
								return;
							}

							$.ajax({
								type : "post",
								url : "verifyCode",
								contentType : "application/json",
								data : JSON.stringify({
									email : email,
									code : verificationCode
								}),
								success : function(response) {
									if (response === "SUCCESS") {
										alert("아이디 찾기: 이메일 인증이 완료되었습니다.");
										isEmailVerified = true;
									} else {
										alert("아이디 찾기: 인증번호가 일치하지 않습니다.");
										isEmailVerified = false;
									}
								},
								error : function() {
									alert("아이디 찾기: 인증 확인 중 오류가 발생했습니다.");
								},
							});
						});

				// 비밀번호 찾기 폼 - 인증번호 확인 요청
				$("#verifyCodeButtonPw").on(
						"click",
						function() {
							const email = $("#pwForm input[name='email']")
									.val(); // 비밀번호 찾기 폼 이메일 입력값
							const verificationCode = $("#emailKeyPw").val(); // 인증번호 입력값

							if (email.trim().length === 0
									|| verificationCode.trim().length === 0) {
								alert("이메일 주소와 인증번호를 모두 입력해주세요.");
								return;
							}

							$.ajax({
								type : "post",
								url : "verifyCode",
								contentType : "application/json",
								data : JSON.stringify({
									email : email,
									code : verificationCode
								}),
								success : function(response) {
									if (response === "SUCCESS") {
										alert("비밀번호 찾기: 이메일 인증이 완료되었습니다.");
										isEmailVerified = true;
									} else {
										alert("비밀번호 찾기: 인증번호가 일치하지 않습니다.");
										isEmailVerified = false;
									}
								},
								error : function() {
									alert("비밀번호 찾기: 인증 확인 중 오류가 발생했습니다.");
								},
							});
						});

				// 아이디 찾기 폼 제출 시 서버에서 아이디 받아오기
				$("#findIdForm").on(
						"submit",
						function(event) {
							event.preventDefault(); // 기본 폼 제출 동작 중단

							if (!isEmailVerified) {
								alert("이메일 인증을 완료해주세요.");
								return;
							}

							const name = $("#name").val();
							const email = $("#emailId").val();

							$.ajax({
							    type: "post",
							    url: "findId",
							    data: {
							        name: name,
							        email: email
							    },
							    dataType: "json",
							    success: function(response) {
							        if (Array.isArray(response)) {
							            const ids = response.join(", "); // 여러 ID를 쉼표로 구분
							            $("#idResult").text("찾은 아이디들: " + ids).css("color", "green");
							        } else {
							            $("#idResult").text("찾은 아이디: " + response).css("color", "green");
							        }
							    },
							    error: function(xhr) {
							        if (xhr.status === 404) {
							            $("#idResult").text("해당 이름과 이메일로 아이디를 찾을 수 없습니다.").css("color", "red");
							        } else {
							            $("#idResult").text("아이디 찾기 요청 중 오류가 발생했습니다.").css("color", "red");
							        }
							    }
							});

						});

				// 비밀번호 찾기 폼 제출 시 처리
				$("#pwForm").on("submit", function(event) {
					event.preventDefault(); // 기본 폼 제출 중단

					if (!isEmailVerified) {
						alert("이메일 인증을 완료해주세요.");
						return;
					}

					const carId = $("#carId").val();
					const email = $("#emailPw").val();
					
					console.log(carId+email)

					$.ajax({
						type : "post",
						url : "sendTemporaryPassword", // 서버의 엔드포인트
						data : {
							id : carId,
							email : email
						},
						success : function(response) {
							alert("임시 비밀번호를 메일로 전송했습니다."); // 성공 메시지 표시
							window.location.href = "/CarPlanet/";
						},
						error : function(xhr) {
							if (xhr.status === 404) {
								alert("해당 아이디와 이메일로 사용자를 찾을 수 없습니다.");
							} else {
								alert("임시 비밀번호 요청 중 오류가 발생했습니다.");
							}
						},
					});
				});

				// 탭 전환 로직
				const idTab = document.getElementById("idTab");
				const pwTab = document.getElementById("pwTab");

				const idForm = document.getElementById("idForm");
				const pwForm = document.getElementById("pwForm");

				idTab.addEventListener("click", function() {
					idTab.classList.add("active");
					pwTab.classList.remove("active");
					idForm.classList.add("active");
					pwForm.classList.remove("active");
					isEmailVerified = false;
				});

				pwTab.addEventListener("click", function() {
					pwTab.classList.add("active");
					idTab.classList.remove("active");
					pwForm.classList.add("active");
					idForm.classList.remove("active");
					isEmailVerified = false;
				});
			});
</script>
</html>
