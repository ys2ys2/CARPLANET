<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>닉네임 설정.</title>
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
	height:40vh;
	background: #fff;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
	border-radius: 15px;
	overflow: hidden;
	display: flex;
	flex-direction: column;
	position: relative;
	margin: 0 auto; /* 중앙 정렬 */
}
.mainboxheader{
	width:100%;
	display:flex;
	justify-content:center;
	align-items:center;
	background-color: #007bff;
	font-size:20px;
	color:white;
	padding: 20px 0;
	font-weight: bold;
}
.mainsection {
    width: 100%;
    height: 80%;
    margin: 0 auto;
    display: flex;
    align-items: center;
    justify-content: center; 
}

.nicknameinputbox {
    width: 300px; 
    height: 40px;
    box-sizing: border-box;
    padding: 0 15px; 
    margin: 10px 0;
    border: 2px solid #ddd; 
    border-radius: 8px; 
    font-size: 16px; 
    font-family: 'Arial', sans-serif;
    transition: all 0.3s ease; 
}

.nicknameinputbox:focus {
    border-color: #161938; 
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.5); 
    outline: none; 
}

button {
    background-color: #007bff; 
    color: white; 
    border: none; 
    padding: 10px 20px; 
    font-size: 16px; 
    border-radius: 8px; 
    cursor: pointer; 
    transition: all 0.3s ease; 
}

button:hover {
    background-color: #0056b3; 
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); 
}

button:active {
    background-color: #003f7f; 
    transform: scale(0.95); 
}

.nickname-description {
    font-size: 18px; /* 적절한 글씨 크기 */
    color: #555; /* 부드러운 텍스트 색상 */
    margin-bottom: 20px; /* 입력 필드와의 간격 */
    line-height: 1.6; /* 줄 간격 */
    text-align: center; /* 중앙 정렬 */
    padding: 0 15px; /* 좌우 여백 */
    background-color: #f9f9f9; /* 배경색 추가 */
    border-radius: 10px; /* 모서리를 둥글게 */
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* 부드러운 그림자 */
    display: inline-block; /* 내용 크기에 맞게 조정 */
    max-width: 90%; /* 너무 길어지지 않도록 제한 */
}

</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />
<div class="section">
	<div class="mainbox">
		<div class="mainboxheader">초기 닉네임 설정</div>
		<div class="mainsection">
			<form action="setnickname.do" method="POST">
				<input type="hidden" name="carId" value="${not empty param ? param.carId : carId}">
				<p class="nickname-description">닉네임은 게시물작성 및 사용자 이름으로<br> 설정되니 신중히 설정해주세요 !</p>
				<input class="nicknameinputbox" name="carNickname" type="text" placeholder="사용하실 닉네임을 입력해주세요"/><br>
				<button type="submit">확인</button>
			</form>
		</div>
	</div>


</div>
<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />
</body>
</html>