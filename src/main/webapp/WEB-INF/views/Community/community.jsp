<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>게시판</title>
<style>

/* 폰트 임포트 */
@import
	url('https://fonts.googleapis.com/css2?family=GongGothic:ital,wght@0,400;0,500;1,400&display=swap')
	;

@import
	url('https://fonts.googleapis.com/css2?family=Pretendard:wght@400;500;600&display=swap')
	;

@charset "UTF-8";

* {
	margin: 5;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Pretendard-Regular', Arial, sans-serif; /* 기본 글꼴 */
	width: 100vw;
	height: 100%;
	/* display: flex; */
	flex-direction: column;
	justify-content: flex-start;
	align-items: center;
	margin: 0;
	padding: 0;
}

/* 소제목 폰트 적용 */
h1, h2, h3, h4, h5, h6 {
	font-family: 'GongGothicMedium', Arial, sans-serif;
}

img {
	width: 80px;
	height: 80px;
}

input::placeholder {
	color: #999999;
	font-size: 14px;
	font-style: italic;
	opacity: 1;
	padding: 7px;
}

.wrap form {
	display: flex;
	flex-direction: column;
	width: 60%;
	gap: 25px;
	/* border: 1px solid gainsboro; */
	padding: 20px;
	justify-content: center;
	align-items: center;
	border-radius: 10px;
}

#form-title, #form-content {
	width: 80%;
	border: 1px solid gainsboro;
	border-radius: 10px;
	padding: 10px;
}

#form-content {
	height: 150px;
}

.content-img {
	width: 80%;
	border: 1px solid gainsboro;
	border-radius: 12px;
	overflow: hidden;
	display: flex;
	align-items: center;
}

.form-file-area {
	width: 30%;
    height: 100%;
	background-color: #007bff;
	color: white;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	padding: 30px;
	border-top-left-radius: 12px;
	border-bottom-left-radius: 12px;
}

#form-file-area {
	display: none;
}

.form-file-bimage {
	width: 70%;
	display: flex;
	justify-content: center;
	align-items: center;
}

.content-btn-area {
	width: 80%;
	display: flex;
	justify-content: flex-end;
	gap: 20px;
}

#content-btn1, #content-btn2 {
	background-color: #007bff;
	border: none;
	color: white;
	font-weight: 700;
	width: 90px;
	height: 40px;
	border-radius: 8px;
	cursor: pointer;
}

}
.pop-right-content {
	display: flex;
	align-items: center;
	gap: 10px; /* 순위와 제목 간 간격 조정 */
	margin: 5px 0; /* 각 항목 사이 간격 */
	font-size: 14px; /* 기본 글씨 크기 */
}

.pop-right-content .rank {
	font-weight: bold; /* 순위를 굵게 표시 */
	font-size: 18px; /* 순위 글씨 크기 */
	color: #007bff; /* 순위 글씨 색상 */
	width: 25px; /* 숫자 고정 크기 */
	text-align: center; /* 중앙 정렬 */
}

.pop-right-content .title {
	flex: 1; /* 제목이 남은 공간 차지 */
	font-size: 16px; /* 제목 글씨 크기 */
	font-weight: normal; /* 제목은 일반 두께 */
	color: #333; /* 제목 글씨 색상 */
	word-wrap: break-word; /* 긴 단어를 줄바꿈 처리 */
	word-break: break-word; /* 단어 단위로 줄바꿈 */
	white-space: normal; /* 줄바꿈 허용 */
}

.pop-right-img {
	position: relative;
	width: 100%;
	height: 200px;
	margin-top: 20px;
	overflow: hidden;
	border-radius: 10px;
}

.pop-right-img img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.pop-right-img p {
	position: absolute;
	top: 20%;
	left: 20%;
	color: white;
	font-size: 14px;
	font-weight: bold;
}

.pop-right-img p:nth-child(2) {
	top: 40%;
}

.srh-area-1 {
	width: 100%; /* 검색 영역 전체 너비 */
	position: relative; /* 돋보기 아이콘 배치용 */
	margin-top: 20px; /* 상단 여백 */
}

.srh-area-1 input {
	width: 100%; /* 검색창 너비를 영역 전체로 확장 */
	height: 50px; /* 검색창 높이 */
	padding: 10px 50px 10px 15px; /* 오른쪽에 돋보기 공간 확보 */
	border: 1px solid #D9D9D9;
	background-color: #D9D9D9;
	border-radius: 10px;
	font-size: 16px; /* 글자 크기 */
	box-sizing: border-box; /* 패딩 포함 크기 계산 */
}

#srh-icn1 {
	position: absolute; /* 검색창 내부에 위치 고정 */
	right: 35px; /* 검색창 내부 오른쪽에 배치 */
	top: 50%; /* 수직 중앙 배치 */
	transform: translateY(-50%);
	width: 20px; /* 돋보기 아이콘 크기 */
	height: 20px;
	background-image: url(/CarPlanet/resources/images/searchicon.png);
	/* 돋보기 아이콘 경로 */
	background-position: center;
	background-repeat: no-repeat;
	background-size: contain;
	pointer-events: none; /* 클릭되지 않도록 설정 */
}

/* 오른쪽 사이드바 */
/* 검색창 스타일 수정 */
.search-box {
	position: relative;
	display: flex;
	align-items: center;
	background: #e8e8e8; /* 배경색을 흰색으로 수정 */
	border-radius: 8px; /* 둥근 모서리 */
	padding: 5px 12px; /* 내부 패딩 */
	height: 40px; /* 검색창 높이 */
	width: 90%; /* 검색창 너비를 100%로 확장 */
	max-width: 400px; /* 최대 너비 설정 */
	margin: 0 auto; /* 가운데 정렬 */
}

/* 검색 입력 필드 */
.search-input {
	flex: 1;
	border: none;
	background: transparent;
	outline: none;
	font-size: 14px; /* 글씨 크기 */
	height: 100%; /* 입력창 높이를 부모 높이에 맞춤 */
	color: #333; /* 글자 색상 */
	padding-left: 40px; /* 왼쪽 패딩 추가 */
}

/* 돋보기 아이콘 */
.search-icon {
	position: absolute;
	right: 10px; /* 검색창 내부 오른쪽에 위치 */
	background: none;
	border: none;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	height: 20px; /* 돋보기 높이 */
	width: 20px; /* 돋보기 너비 */
	overflow: hidden;
}

/* 돋보기 아이콘 이미지 */
.searchicon-icon {
	height: 100%; /* 돋보기 이미지를 부모 높이에 맞춤 */
	width: auto; /* 가로 비율 유지 */
	object-fit: contain; /* 이미지를 자연스럽게 조정 */
	filter: brightness(0.5); /* 돋보기 색상을 조정 */
}

/* 검색 입력 필드 */
.keyword-section {
	background: white;
	border-radius: 12px;
	padding: 20px;
	margin-bottom: 16px;
}

.keyword-tag {
	background: #f0f0f0;
	padding: 8px 16px;
	border-radius: 20px;
	font-size: 14px;
	cursor: pointer;
	text-decoration: none;
	margin-bottom: 10px; /* 아래쪽 간격 추가 */
	display: inline-block; /* 태그가 블록처럼 처리되도록 변경 */
	color: #000; /* 폰트 색상을 검정으로 설정 */
}

.recommended-section {
	background: #fbfbfb;
	border-radius: 12px;
	padding: 20px;
}

/* 추천글 */
.recommended-item {
	display: flex;
	align-items: center;
	gap: 8px;
	padding: 8px 0;
	text-decoration: none;
	color: #333;
	border-bottom: 1px solid #e0e0e0; /* 항목 사이에 밑줄 추가 */
	margin-bottom: 10px; /* 항목 간 간격 추가 */
}

.recommended-item:last-child {
	border-bottom: none; /* 마지막 항목에는 밑줄 제거 */
	margin-bottom: 0; /* 마지막 항목의 간격 제거 */
}

.recommended-number {
	font-size: 16px;
	font-weight: bold;
	color: #007bff;
}

.recommended-text {
	font-size: 14px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

/* wrap 스타일 수정: 콘텐츠와 사이드바를 나란히 배치 */
.wrap {
	margin: auto; /* 모든 방향에서 여백 자동으로 설정 */
	border: 1px solid #fffff;
	width: 90%;
	max-width: 1100px;
	display: flex;
	flex-direction: row;
	gap: 20px;
	justify-content: space-between;
}

/* 사이드바 위치 조정 */
.side-right-wrap {
	width: 30%; /* 사이드바 너비 */
	margin-left: auto; /* 오른쪽으로 배치 */
}

.side-right {
	width: 100%;
	border: 1px solid gainsboro;
	padding: 20px;
	border-radius: 10px;
	background-color: #fff; /* 배경색 추가 */
}

/* 모바일 반응형 */
@media ( max-width : 768px) {
	.wrap {
		flex-direction: column; /* 세로 방향 배치 */
		align-items: center; /* 중앙 정렬 */
	}
	.side-right-wrap {
		width: 100%; /* 화면 너비 전체 */
		margin-left: 0; /* 좌우 여백 제거 */
	}
}

/* 모바일 화면 (768px 이하) */
@media ( max-width : 768px) {
	body {
		font-size: 14px; /* 기본 글자 크기 축소 */
	}
	#form-title, #form-content {
		font-size: 12px; /* 입력 필드 글자 크기 축소 */
	}
	#content-btn1, #content-btn2 {
		width: 70px; /* 버튼 크기 축소 */
		height: 30px;
		font-size: 10px;
	}
	.pop-title {
		font-size: 14px; /* 인기 키워드 제목 크기 축소 */
	}
	.pop-wrap a {
		font-size: 10px; /* 인기 키워드 링크 크기 축소 */
	}
	.pop-right-content .title {
		font-size: 12px; /* 추천글 제목 크기 축소 */
	}
}

/* 초소형 화면 (480px 이하) */
@media ( max-width : 480px) {
	body {
		font-size: 12px; /* 기본 글자 크기 축소 */
	}
	#form-title, #form-content {
		font-size: 10px; /* 입력 필드 글자 크기 축소 */
	}
	#content-btn1, #content-btn2 {
		width: 60px; /* 버튼 크기 축소 */
		height: 25px;
		font-size: 8px;
	}
	.pop-title {
		font-size: 12px; /* 인기 키워드 제목 크기 축소 */
	}
	.pop-wrap a {
		font-size: 8px; /* 인기 키워드 링크 크기 축소 */
	}
	.pop-right-content .title {
		font-size: 10px; /* 추천글 제목 크기 축소 */
	}
}

/* 태블릿 화면 (1024px 이하) */
@media ( max-width : 1024px) {
	body {
		font-size: 16px; /* 기본 글자 크기 축소 */
	}
	#form-title, #form-content {
		font-size: 14px; /* 입력 필드 글자 크기 축소 */
	}
	#content-btn1, #content-btn2 {
		width: 80px; /* 버튼 크기 축소 */
		height: 35px;
		font-size: 12px;
	}
	.pop-title {
		font-size: 16px; /* 인기 키워드 제목 크기 축소 */
	}
	.pop-wrap a {
		font-size: 12px; /* 인기 키워드 링크 크기 축소 */
	}
	.pop-right-content .title {
		font-size: 14px; /* 추천글 제목 크기 축소 */
	}
}

/* 모바일 화면 (768px 이하) */
@media ( max-width : 768px) {
	.side-right-wrap {
		display: none; /* 오른쪽 섹션을 숨김 */
	}
	.wrap {
		width: 100%; /* 중앙 콘텐츠가 화면 전체를 차지하도록 변경 */
		justify-content: center; /* 중앙 정렬 */
		margin-top: 20px; /* 상단 여백 추가 */
	}
	body {
		font-size: 14px; /* 기본 글자 크기 축소 */
		padding-top: 20px; /* 상단 여백 추가 */
	}
	#form-title, #form-content {
		font-size: 12px; /* 입력 필드 글자 크기 축소 */
	}
	#content-btn1, #content-btn2 {
		width: 70px; /* 버튼 크기 축소 */
		height: 30px;
		font-size: 10px;
	}
	.pop-title {
		font-size: 14px; /* 인기 키워드 제목 크기 축소 */
	}
	.pop-wrap a {
		font-size: 10px; /* 인기 키워드 링크 크기 축소 */
	}
	.pop-right-content .title {
		font-size: 12px; /* 추천글 제목 크기 축소 */
	}
}

/* 초소형 화면 (480px 이하) */
@media ( max-width : 480px) {
	body {
		font-size: 12px; /* 기본 글자 크기 축소 */
	}
	#form-title, #form-content {
		font-size: 10px; /* 입력 필드 글자 크기 축소 */
	}
	#content-btn1, #content-btn2 {
		width: 60px; /* 버튼 크기 축소 */
		height: 25px;
		font-size: 8px;
	}
	.pop-title {
		font-size: 12px; /* 인기 키워드 제목 크기 축소 */
	}
	.pop-wrap a {
		font-size: 8px; /* 인기 키워드 링크 크기 축소 */
	}
	.pop-right-content .title {
		font-size: 10px; /* 추천글 제목 크기 축소 */
	}
}

/* 오른쪽 추천글 */
</style>
</head>
<body>
	<!-- 헤더 -->
	<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />
	<div class="wrap">
		<!-- 콘텐츠 영역 -->
		<form id="registerPost"
			action="<c:if test='${post != null}'>updatePost.do</c:if><c:if test='${post == null}'>registerPost.do</c:if>"
			method="post" enctype="multipart/form-data" accept-charset="UTF-8">
			<c:if test="${post != null}">
				<input type="hidden" name="postIndex" value="${post.postIndex}">
			</c:if>
			<input id="form-title" name="title" type="text"
				placeholder="제목을 입력해주세요" required
				value="${post != null ? post.title : ''}">
			<textarea id="form-content" name="content"
				placeholder="어떤 정보를 공유하고 싶으신가요?" required>${post != null ? post.content : ''}</textarea>

			<div class="content-img">
				<label class="form-file-area" for="form-file-area">파일 첨부</label> <input
					type="file" id="form-file-area" name="file" accept="image/*"
					onchange="setThumbnail(event);">

				<div class="form-file-bimage">
					<img id="preview" alt="미리보기 이미지"
						src="<c:if test='${post != null && post.filePath != null && post.fileName != null}'>/CarPlanet${post.filePath}${post.fileName}</c:if><c:if test='${post == null || post.filePath == null}'>${pageContext.request.contextPath}/resources/images/image90.png</c:if>">
				</div>
			</div>

			<div class="content-btn-area">
				<button id="content-btn1" type="button"
					onclick="window.location.href='getPostList.do';">돌아가기</button>
				<button id="content-btn2" type="submit">공유하기</button>
			</div>
		</form>

		<!-- 사이드바 영역 -->
		<div class="side-right-wrap">
			<div class="side-right">
				<!-- 검색 섹션 -->
				<div class="search-box">
					<form action="searchPostList.do" method="get">
						<input type="search" name="keyword" class="search-input"
							placeholder="검색" required />
						<button type="submit" class="search-icon">
							<img src="/CarPlanet/resources/images/searchicon.png"
								alt="writing" class="searchicon-icon" />
						</button>
					</form>
				</div>

				<!-- 인기 키워드 -->
				<div class="keyword-section">
					<div class="keyword-header">
						<span class="trophy-icon"></span>
						<h2 class="keyword-title">🏆 인기 키워드</h2>
					</div>
					<div class="keyword-grid">
						<c:forEach var="keyword" items="${popularKeywords}"
							varStatus="status">
							<c:if test="${status.index < 8}">
								<a href="searchPostList.do?keyword=${keyword}"
									class="keyword-tag">${keyword}</a>
							</c:if>
						</c:forEach>
					</div>
				</div>

				<!-- 추천글 -->
				<div class="recommended-section">
					<h2 class="recommended-title">추천글</h2>
					<div class="recommended-list">
						<c:forEach var="post" items="${recommendedPosts}"
							varStatus="status">
							<a href="searchPostList.do?keyword=${post.title}"
								class="recommended-item"> <span class="recommended-number">${status.index + 1}</span>
								<span class="recommended-text">${post.title}</span>
							</a>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
		function setThumbnail(event) {
			var reader = new FileReader();

			reader.onload = function(event) {
				var img = document.getElementById("preview");
				img.setAttribute("src", event.target.result);
			};
			reader.readAsDataURL(event.target.files[0]);
		}
	</script>
</body>
</html>