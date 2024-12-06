<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/admin.js"></script>
<title>관리자</title>


<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: Arial, sans-serif;
}

.main-container {
	position: relative;
	top: 100px;
	left: 200px;
	display: flex;
	width: 80%;
	height: 80vh;
	border: 1px solid black;
	border-radius: 25px;
}

.sidebar {
	width: 20%;
	background-color: #333;
	color: #fff;
	display: flex;
	flex-direction: column;
	border-radius: 25px 0 0 25px;
}

.sidebar ul {
	list-style: none;
	padding: 0;
}

.sidebar ul li {
	padding: 15px;
	text-align: center;
}

.sidebar ul li a {
	color: #fff;
	text-decoration: none;
	display: block;
}

.sidebar ul li a:hover {
	background-color: #575757;
}

.content {
	flex: 1;
	padding: 20px;
	overflow-y: auto;
}

.section {
	margin-bottom: 30px;
}

#summary {
	display: flex;
	height: 100%;
	flex-wrap: wrap; /* 줄바꿈을 허용하여 2x2 배치를 만듭니다 */
	justify-content: space-between;
	gap: 20px;
	padding: 10px;
	overflow: hidden;
}

.summary-box {
	width: calc(50% - 10px);
	height: 265px;
	background-color: #f0f0f0; /* 박스 배경색 */
	display: flex;
	align-items: center; /* 수직 가운데 정렬 */
	justify-content: center; /* 수평 가운데 정렬 */
	border: 1px solid #ccc;
	border-radius: 10px;
	font-size: 16px;
	color: #333;
}

.summary-content {
	text-align: center;
}

.summary-content h3 {
	margin-bottom: 10px;
	font-size: 20px;
	color: #555;
}

.summary-content .count {
	font-size: 48px; /* 큰 숫자 */
	font-weight: bold;
	color: #333;
}

/* 모달 배경 */
.noticemodal {
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
	display: none;
}

/* 모달 콘텐츠 */
.notice-content {
	display: flex;
	flex-direction: column;
	background: #fff;
	padding: 30px;
	border-radius: 10px;
	width: 80%;
	max-width: 600px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

/* 제목과 공지 종류 */
.noticemodal-Title {
	display: flex;
	width: 100%;
	margin: 10px 0 10px 0;
}

#carnTitle, #noticeType {
	height: 40px;
	padding: 5px 10px;
	border-radius: 10px;
	font-size: 16px;
	border: 1px solid #ccc;
}

#carnTitle {
	flex: 2; /* 제목을 더 넓게 */
	margin-right: 15px;
}

#noticeType {
	flex: 1; /* 공지 종류를 좁게 */
}

/* 공지사항 입력 텍스트 에어리어 */
#noticeDetails {
	width: 100%;
	height: 150px;
	margin: 5px 0;
	padding: 10px;
	font-size: 16px;
	border-radius: 10px;
	border: 1px solid #ccc;
	resize: none; /* 크기 조절 금지 */
}

/* 버튼 그룹 */
.noticemodal-actions {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}

.noticemodal-actions button {
	padding: 10px 20px;
	border: none;
	border-radius: 10px;
	font-size: 16px;
	cursor: pointer;
}

#submitNotice {
	background: #007bff;
	color: #fff;
	font-weight: bold;
}

#submitNotice:hover {
	background: #0056b3;
}

#cancelNotice {
	background: #f8f9fa;
	color: #000;
}

#cancelNotice:hover {
	background: #e0e0e0;
}

a.dynamic-link:visited {
	color: black !important;
}

#user-table table {
	width: 100%;
	border-collapse: collapse;
}

#user-table th, #user-table td {
	border: 1px solid #ccc;
	padding: 10px;
	text-align: center;
	height: 28px;
}

#user-table td {
	font-size: 13px;
}

#user-table th {
	background-color: #f4f4f4;
	font-weight: bold;
}

#user-table td button {
	padding: 5px 10px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

#user-table td button.delete {
	background-color: #e74c3c;
	color: white;
}

#user-table td button.promote {
	background-color: #2ecc71;
	color: white;
}

.userinfoline {
	border-bottom: 1px solid black;
}

/* 게시물 박스 컨테이너 */
#post-box-container {
	display: flex;
	flex-wrap: wrap;
	gap: 20px;
	padding: 10px;
}

/* 게시물 박스 */
.post-box {
	width: calc(33.33% - 20px);
	height: 300px; /* 고정 높이 */
	border: 1px solid #ccc;
	border-radius: 10px;
	overflow: hidden;
	background-color: #f9f9f9;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	display: flex;
	flex-direction: column;
	justify-content: space-between;
}

/* 게시물 이미지 */
.imbox {
	width: 100%; /* 상자 너비에 맞춤 */
	height: 150px; /* 고정 높이 */
	display: block;
	border-bottom: 1px solid #ccc;
}

.imbox img {
	width: 100%;
	height: 100%;
}

/* 게시물 제목 */
.post-box h3 {
	margin: 10px 0;
	font-size: 18px;
	color: #333;
	padding: 0 10px;
}

/* 게시물 내용 */
.post-box p {
	font-size: 14px;
	color: #666;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	padding: 0 10px;
}

/* 게시물 하단 */
.post-box-footer {
	padding: 10px;
	border-top: 1px solid #ccc;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

/* 작성자 정보 */
.post-box-footer span {
	font-size: 14px;
	color: #666;
}

/* 삭제 버튼 */
.delete-post {
	width: 100%;
	height: 100%;
}

.delete-post:hover {
	background-color: #c0392b;
}

.deletebox {
	width: 30px;
	height: 30px;
	border: 1px solid #c0392b;
	border-radius: 5px;
	cursor: pointer;
}

.postheader {
    display: flex;
    justify-content: space-between; /* 양쪽으로 정렬 */
    align-items: center; /* 수직 가운데 정렬 */
    margin-bottom: 10px; /* 여백 추가 */
}

.post-search-box {
    display: flex;
    gap: 10px; /* 검색창과 버튼 사이 간격 */
}

.post-search-box input {
    padding: 5px;
    border: 1px solid #ccc;
    border-radius: 5px;
    font-size: 14px;
}

.post-search-box button {
    padding: 5px 10px;
    border: none;
    border-radius: 5px;
    background-color: #007bff;
    color: white;
    font-size: 14px;
    cursor: pointer;
}

.post-search-box button:hover {
    background-color: #0056b3;
}

@media (max-width: 1024px) {
.main-container{
	left:150px;
}
}


@media (max-width: 768px) {
	.main-container{
		width:70%
	}
	#user-table td button{
		width:60px;
		height:40px;
		font-size:10px;
	}
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />

	<div class="main-container">
		<div class="sidebar">
			<ul>
				<li><a href="#dashboard" class="menu-link"
					data-target="dashboard">대시보드</a></li>
				<li><a href="#user-management" class="menu-link"
					data-target="user-management">회원 관리</a></li>
				<li><a href="#post-management" class="menu-link"
					data-target="post-management">게시글 관리</a></li>
			</ul>
		</div>
		<div class="content">
			<div id="dashboard" class="section active">
				<h1>대시보드</h1>
				<hr style="margin: 10px 0 10px 0">
				<div id="summary">
					<div class="summary-box">
						<canvas id="visitorChart" width="400" height="400"></canvas>
					</div>
					<div class="summary-box">
						<div class="summary-content">
							<h3>공지사항 입력</h3>
							<p>
								현재 총 <span id="noticeCount">0</span>개의 공지사항이 등록되어 있습니다.
							</p>
							<button id="addNoticeBtn"
								style="padding: 10px 20px; font-size: 16px; margin-top: 10px; cursor: pointer;">공지사항
								추가</button>
						</div>
					</div>
					<div class="summary-box">
						<div class="summary-content">
							<h3>총 게시물 수</h3>
							<p id="postCountDisplay" class="count">0</p>
						</div>
					</div>
					<div class="summary-box">
						<div class="summary-content">
							<h3>총 회원 수</h3>
							<p id="userCountDisplay" class="count">0</p>
						</div>
					</div>
				</div>
			</div>


			<div id="user-management" class="section">
				<div
					style="display: flex; align-items: center; justify-content: space-between;">
					<h1 style="margin-bottom: 10px">회원 관리</h1>
					<div>
						<input type="text" id="search-input" placeholder="아이디 or 닉네임"
							style="padding: 5px; border: 1px solid #ccc; border-radius: 5px;">
						<select id="search-carstatus"
							style="padding: 5px; border: 1px solid #ccc; border-radius: 5px;">
							<option value="">-- 상태 선택 --</option>
							<option value="1">일반 회원</option>
							<option value="3">관리자</option>
							<option value="-1">탈퇴 요청 회원</option>
						</select>
						<button id="search-button"
							style="padding: 5px 10px; border: none; background-color: #007bff; color: white; border-radius: 5px; cursor: pointer;">
							검색</button>
						<button id="reset-button"
							style="padding: 5px 10px; border: none; background-color: #007bff; color: white; border-radius: 5px; cursor: pointer;">초기화</button>

					</div>
				</div>
				<p class="userinfoline">
					회원 등급 안내: <b>1</b> (일반 회원) | <b>-1</b> (탈퇴 요청 회원) | <b>3</b> (관리자)
				</p>


				<div id="user-table" style="margin-top: 15px">
					<div id="user-table">
						<table>
							<thead>
								<tr>
									<th>회원번호</th>
									<th>회원Id</th>
									<th>닉네임</th>
									<th>회원등급</th>
									<th>요청</th>
								</tr>
							</thead>
							<tbody>

							</tbody>
						</table>
					</div>
				</div>
			</div>


			<div id="post-management" class="section">
				<div class="postheader">
					<h1>게시글 관리</h1>
					<div class="post-search-box">
						<input type="text" id="post-input" placeholder="제목 or 내용 입력">
						<button id="psearch-button">검색</button>
						<button id="preset-button">초기화</button>
					</div>
				</div>
				<hr>
				<div id="post-box-container">
					<!-- 게시물 카드가 추가될 영역 -->
				</div>
			</div>
		</div>
	</div>

	<div class="noticemodal">
		<div class="notice-content">
			<h2>공지사항 입력</h2>
			<form action="noticeinput.do" method="post">
				<div class="noticemodal-Title">
					<input id="carnTitle" name="carnTitle" type="text"
						placeholder="제목입력" required> <select id="noticeType"
						name="noticeType">
						<option disabled selected>공지 종류</option>
						<option value="nomalnotice">공지 사항</option>
						<option value="updatenotice">업데이트 사항</option>
					</select>
				</div>
				<textarea id="noticeDetails" name="noticeDetails"
					placeholder="공지사항 입력" required></textarea>
				<div class="noticemodal-actions">
					<button type="submit" id="submitNotice">저장</button>
					<button type="button" id="cancelNotice">취소</button>
				</div>
			</form>
		</div>
	</div>


	<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
	<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />


	<script>
		$(document).ready(function() {
			const message = "${message}";
			if (message) {
				alert(message);
			}
		});
	</script>
</body>
</html>