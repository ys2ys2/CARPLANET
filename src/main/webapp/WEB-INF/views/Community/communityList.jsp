<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>게시판</title>
<style>
@charset "UTF-8";

* {
	margin: 0;
	padding: 0;
}

body {
	width: 100%;
	height: 160vh;
}

img {
	width: 80px;
	height: 80px;
}

input::placeholder {
	color: #999999;
	font-size: 14px;
	font-style: italic4+;
	opacity: 1;
	padding: 7px;
}

.wrap {
	border: 1px solid gainsboro;
	width: 90%;
	height: 120%;
	margin: auto;
	margin-top: 30px;
	display: flex;
	gap: 20px;
	justify-content: center;
	align-items: center;
}

.wrap .left-area {
	display: flex;
	flex-direction: column;
	width: 50%;
	height: 98%;
	gap: 25px;
	border: 1px solid gainsboro;
	gap: 12px;
	border-top-left-radius: 12px;
	border-top-right-radius: 12px;
	align-items: center;
	overflow-y: scroll;
}

.top-image-area {
	position: relative;
	text-align: center;
	width: 100%;
	height: 15%;
	border-top-left-radius: 12px;
	border-top-right-radius: 12px;
}

.image-container {
	width: 100%;
	height: 150px;
	background-image: url('/CarPlanet/resources/images/image01.png');
	background-position: center;
	background-repeat: no-repeat;
	background-size: cover; /* 이미지가 div에 꽉 차게 설정 */
	border-radius: 12px;
	position: relative;
}

.text-container {
	position: absolute;
	top: 20px;
	left: 50%;
	transform: translateX(-50%);
	color: white;
}

.top-image-area {
	position: relative;
	text-align: center;
	width: 100%;
	height: auto; /* 이미지 높이에 맞게 자동 조정 */
	border-top-left-radius: 12px;
	border-top-right-radius: 12px;
}

.image-container {
	width: 100%;
	height: 150px;
	background-image: url('/CarPlanet/resources/images/image01.png');
	background-position: center;
	background-repeat: no-repeat;
	background-size: cover;
	border-radius: 12px;
}

.top-image-area button {
	position: absolute;
	left: 50%;
	top: 90px; /* 이미지 높이에 맞춰 아래로 배치 */
	transform: translate(-50%, 0); /* 중앙 정렬 */
	padding: 10px 20px;
	background-color: #007BFF;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	z-index: 10; /* 다른 요소 위로 표시 */
}



.bord-content-area {
	width: 80%;
	height: 35%;
	min-height: 35%;
}

.content-top {
	width: 80%;
	height: 15%;
	display: flex;
	gap: 10px;
}

.content-top .icon {
	width: 30px;
	height: 30px;
	background-image: url('/CarPlanet/resources/images/image10.png');
	background-position: center;
	background-repeat: no-repeat;
	background-size: cover;
	border-radius: 24px;
}

.content-main div {
	margin-top: 10px;
	width: 50%;
	height: 65%;
	min-height: 30%;
	background-position: left;
	background-repeat: no-repeat;
	background-size: contain;
}

.content-main {
	width: 80%;
	height: 60%;
}

.content-footer {
    width: 100%;
    height: 5%;
    display: flex;
    gap: 20px;
    margin-bottom: 15px; /* 추가된 간격 */
}

.border-bottom-area {
    border-bottom: 1px solid #999999;
    width: 120%;
    position: relative;
    right: 10%;
    margin-top: 15px; /* 추가된 간격 */
}

.content-review {
    display: none;
    width: calc(100% - 40px); /* 부모 컨테이너 너비를 기준으로 양쪽 간격 조정 */
    margin: 0 auto; /* 중앙 정렬 */
    background-color: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    position: absolute;
    z-index: 10; /* 다른 요소 위로 표시 */
    left: 0; /* 왼쪽으로 정렬 */
    right: 0; /* 오른쪽으로 정렬 */
}


.bord-content-area {
    position: relative; /* 댓글 창 위치 기준이 되는 부모 */
}




.content-review h3 {
    font-size: 18px;
    font-weight: bold;
    color: #333; /* 텍스트 색상 */
    margin-bottom: 10px;
}

.content-review textarea {
    width: 100%; /* 전체 너비 사용 */
    min-height: 80px;
    border: 1px solid #ccc;
    border-radius: 5px;
    padding: 10px;
    font-size: 14px;
    resize: none; /* 크기 조정 비활성화 */
    box-sizing: border-box;
    margin-bottom: 10px; /* 아래 버튼과 간격 */
}

.content-review div {
    display: flex;
    gap: 10px; /* 버튼 간격 */
    justify-content: flex-end; /* 버튼을 오른쪽 정렬 */
}

.content-review button {
    background-color: #0056b3; /* 남색 배경 */
    color: white; /* 텍스트 색상 */
    border: none;
    border-radius: 5px;
    padding: 10px 15px;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
}

.content-review button:hover {
    background-color: #003f7f; /* 호버 시 더 진한 남색 */
}


.border-bottom-area {
	border-bottom: 1px solid #999999;
	width: 120%;
	position: relative;
	right: 10%;
}

.content-footer .footer-1 {
	display: flex;
	gap: 5px;
	align-items: center;
}

.content-footer .footer-1 div {
	width: 30px;
	height: 30px;
	margin-top: 10px;
	background-image: url('/CarPlanet/resources/images/image\ 49.png');
	background-position: center;
	background-repeat: no-repeat;
	background-size: cover;
	border-radius: 24px;
}

.content-footer .footer-2 {
	display: flex;
	gap: 10px;
	align-items: center;
}

.content-footer .footer-2 div {
	width: 30px;
	height: 30px;
	margin-top: 10px;
	background-image: url('/CarPlanet/resources/images/image\ 50.png');
	background-position: center;
	background-repeat: no-repeat;
	background-size: cover;
	border-radius: 24px;
}

.content-footer .footer-3 {
	display: flex;
	gap: 15px;
	align-items: center;
}

.content-footer .footer-3 div.like-icn {
	width: 30px;
	height: 30px;
	margin-top: 10px;
	background-image: url('/CarPlanet/resources/images/image\ 51.png');
	background-position: center;
	background-repeat: no-repeat;
	background-size: cover;
	border-radius: 24px;
}

.content-footer .footer-3 div.share-icn {
	width: 30px;
	height: 30px;
	margin-top: 10px;
	background-image: url('/CarPlanet/resources/images/share.png');
	background-position: center;
	background-repeat: no-repeat;
	background-size: cover;
}

.content-footer .footer-4 {
	display: flex;
	gap: 5px;
	align-items: center;
	margin-left: 50px;
}

.content-footer .footer-4 a {
	text-decoration: none;
	margin-top: 4px;
	color: black;
}

.side-right-wrap {
	width: 22%;
	height: 100%;
	display: flex;
	justify-content: center;
	align-items: center;
}

.side-right {
	width: 90%;
	height: 90%;
	border: 1px solid gainsboro;
	display: flex;
	flex-direction: column;
	overflow: hidden;
	display: flex;
	align-items: center;
}

.srh-area-1 {
	width: 70%;
	height: 40px; /* 검색창 높이 설정 */
	position: relative; /* 부모 컨테이너를 기준으로 위치 조정 */
	margin-top: 20px;
}

/* 검색창 */
.srh-area-1 input {
	width: 100%;
	height: 40px; /* 기존보다 조금 더 높게 설정 */
	border: 1px solid ghostwhite;
	background-color: #D9D9D9;
	border-radius: 10px;
	padding-right: 40px; /* 오른쪽 아이콘 공간 확보 */
	box-sizing: border-box; /* 패딩 포함 크기 계산 */
	font-size: 16px; /* 글씨 크기도 조금 키움 */
}

#srh-icn1 {
	position: absolute; /* 부모 컨테이너 기준으로 위치 */
	right: 10px; /* 검색창 오른쪽 끝에서 10px 간격 */
	top: 50%; /* 세로 중앙 정렬 */
	transform: translateY(-50%); /* 정확한 중앙 정렬 */
	width: 20px; /* 아이콘 크기 */
	height: 20px;
	background-position: center;
	background-repeat: no-repeat;
	background-size: contain;
	background-color: transparent; /* 버튼 배경 제거 */
	border: none; /* 버튼 테두리 제거 */
	cursor: pointer; /* 커서를 포인터로 변경 */
}

.keyword-area {
	width: 100%;
	height: 20%;
	display: flex;
	flex-direction: column;
	margin-top: 10px;
}

.pop-title {
	width: 50%;
	height: 10%;
	margin-left: 10%;
	margin-bottom: 15px; /* 간격 추가 */
}

.pop-title p {
	font-size: 20px; /* 제목 글씨 크기 키움 */
	font-weight: bold; /* 강조 */
}

.pop-wrap {
	display: flex;
	flex-wrap: wrap;
	width: 80%;
	height: 20%;
	gap: 12px; /* 간격을 약간 늘림 */
	align-items: center;
	margin-left: 10%;
	margin-bottom: 10px;
}

.pop-wrap a {
	text-decoration: none;
	border: 1px solid #D9D9D9;
	background-color: #D9D9D9;
	border-radius: 12px;
	padding: 6px 10px; /* 기존 padding에서 약간 줄임 */
	font-size: 14px; /* 글씨 크기를 약간 줄임 */
	font-weight: bold;
	color: #161938;
}

.pop-right-box {
	width: 95%;
	height: 30%;
	border: 1px solid #D9D9D9;
	margin-left: 7px;
	margin-top: 20px;
	border-radius: 8px;
	display: flex;
	flex-direction: column;
}

.pop-right-title {
	display: flex;
	width: 100%;
	height: 10%;
	border: 1px solid #161938;
	background-color: #161938;
	border-radius: 8px;
}

.pop-right-box h3 {
	font-size: 20px;
	color: white;
	display: flex;
	align-items: center;
	font-weight: 700;
}

.pop-right-content {
	font-size: 20px;
	width: 100%;
	height: 10%;
	display: flex;
}

.pop-right-content span {
	padding: 3px;
	margin-right: 7px;
}

.pop-right-content p {
	padding: 3px;
	overflow: hidden; /* 넘치는 텍스트를 숨김 */
	text-overflow: ellipsis; /* 생략 부호(...) 추가 */
	white-space: nowrap; /* 텍스트를 한 줄로 제한 */
	width: 80%; /* 텍스트가 차지할 최대 너비 */
}

.pop-right-content {
	margin: 5px 0; /* 위아래 간격 추가 */
	padding-right: 3px;
	height: auto; /* 텍스트가 겹치지 않도록 높이를 자동으로 */
	display: flex;
	align-items: center; /* 순위를 텍스트와 정렬 */
}

.pop-right-img {
	position: relative;
	width: 100%;
	padding: 20px 0 20px 0;
}

.pop-right-img img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	z-index: 1;
}

.pop-right-img p:nth-child(2) {
	font-size: 23px;
}

.pop-right-img p {
	position: absolute;
	text-align: center; /* 텍스트 중앙 정렬 */
	top: 22%;
	left: 45%;
	transform: translate(-40%, -40%);
	color: white;
	font-size: 15px;
	margin: 0;
	z-index: 2;
}

.pop-right-img p+p {
	top: 45%;
}

.post-title {
	font-weight: bold;
}

.content-main p:first-child {
	margin-bottom: 10px; /* 제목과 내용 사이의 간격 */
}

.pop-title p {
	font-weight: bold; /* 글씨를 두껍게 */
	font-size: 16px; /* 글씨 크기 키우기 */
	width: 100%;
	height: 100%;
}

.content-main img {
	width: 100%; /* 부모 너비에 맞춤 */
	max-width: 300px; /* 최대 너비 제한 */
	height: 200px; /* 고정된 높이 */
	object-fit: contain; /* 비율 유지, 여백 추가 */
	display: block;
	margin: 0 auto 10px auto; /* 이미지와 아이콘 사이 간격 */
}

/* 모달 창 스타일 */
.modal {
	display: none;
	position: fixed;
	bottom: 0;
	left: 0;
	width: 100%;
	height: auto;
	z-index: 1000;
}

.modal-content {
	background-color: white;
	margin: 0 auto;
	padding: 20px;
	border-radius: 10px;
	width: 90%;
	max-width: 500px;
	box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
}

.modal-content .close {
	float: right;
	font-size: 20px;
	font-weight: bold;
	cursor: pointer;
}

.modal-content textarea {
	width: 95%;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 5px;
	margin-top: 10px;
	resize: none; /* 사용자가 직접 크기를 조정하지 못하도록 설정 */
	overflow: hidden; /* 스크롤 숨김 */
	box-sizing: border-box;
}

/* 유저 이름 스타일 수정 */
.content-top .user_id {
	font-weight: bold; /* 굵은 글씨 */
	font-size: 18px; /* 글씨 크기 키우기 */
}

.content-top .date {
	margin-top: 3px; /* 위쪽 여백 추가 */
}

/* 추천글 간격 */
.pop-right-title h3 {
	margin-left: 10px; /* 왼쪽에 10px 간격 추가 */
}



@media (max-width: 1024px) {
    body {
        width: 100%;
        height: auto;
    }

    .wrap {
        flex-direction: column;
        width: 100%;
    }

    .wrap .left-area {
        width: 100%;
        height: auto;
        gap: 20px;
    }

    .wrap .side-right-wrap {
        width: 100%;
        margin-top: 20px;
    }

    .side-right {
        width: 95%;
    }
}

/* 모바일 화면 (768px 이하) */
@media (max-width: 768px) {
    .image-container {
        height: 120px; /* 이미지 높이 축소 */
    }

    .content-main img {
        width: 80%; /* 이미지 너비 축소 */
        height: auto; /* 높이 자동 조정 */
    }

    .pop-right-box h3 {
        font-size: 18px; /* 제목 크기 조정 */
    }

    .pop-wrap a {
        font-size: 12px; /* 키워드 글씨 크기 축소 */
        padding: 4px 8px;
    }

    .content-footer {
        /* flex-direction: column; */
        align-items: flex-start;
    }

    .content-footer .footer-4 {
        margin-left: 0;
    }
}

/* 초소형 화면 (425px 이하) */
@media (max-width: 425px) {
    /* 공유하기 버튼 크기 및 위치 조정 */
    .top-image-area button {
        position: static; /* 고정된 위치 해제 */
        transform: none; /* 중앙 정렬 관련 transform 해제 */
        display: block; /* 블록 레벨로 변경 */
        margin: 10px auto; /* 버튼을 중앙 정렬 */
        padding: 6px 12px; /* 크기 줄이기 */
        font-size: 12px; /* 글씨 크기 축소 */
        border-radius: 4px; /* 모서리 둥글기 축소 */
    }

    /* 좋아요/싫어요 버튼 가로 정렬 */
    .content-footer {
        flex-direction: row; /* 가로 정렬 */
        flex-wrap: nowrap; /* 줄바꿈 방지 */
        justify-content: space-between; /* 버튼 간격 균등 */
        align-items: center; /* 세로 중앙 정렬 */
    }

    .content-footer .footer-1,
    .content-footer .footer-2 {
        display: flex; /* 버튼과 텍스트 가로 배치 */
        flex-direction: row; /* 가로 정렬 유지 */
        align-items: center; /* 세로 중앙 정렬 */
        gap: 5px; /* 버튼과 숫자 사이 간격 */
    }

    .content-footer .footer-1 div,
    .content-footer .footer-2 div {
        width: 24px; /* 아이콘 크기 조정 */
        height: 24px;
        flex-shrink: 0; /* 아이콘 크기 고정 */
    }

    .content-footer .footer-3 {
        display: flex;
        flex-direction: row;
        gap: 8px; /* 아이콘과 숫자 사이 간격 증가 */
        align-items: center;
    }
}



</style>
</head>


<body>
	<!-- 헤더 -->
	<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />
	<div class="wrap">

		<div class="left-area">
			<div class="top-image-area">
				<div class="image-container"></div>
				<div class="text-container">
					<h3>소중한 내 차를 위한</h3>
					<h3>정보 교환의 광장</h3>
				</div>
				<button onclick="location.href='post.do'">공유하기</button>
			</div>

			<c:forEach var="post" items="${posts}">
				<div class="bord-content-area">
					<div class="content-top">
						<div class="icon"></div>
						<p class="user_id">${post.carId}</p>
						<p class="date">
							<fmt:formatDate value="${post.regDate}"
								pattern="yyyy-MM-dd HH:mm" />
						</p>
					</div>

					<div class="content-main">
						<p>
							<strong>${post.title}</strong>
						</p>
						<p>${post.content}</p>
						<c:if test="${not empty post.fileName}">
							<div>
								<img src="${pageContext.request.contextPath}${post.filePath}${post.fileName}">
							</div>
						</c:if>
					</div>

					<div class="content-footer">
						<div class="footer-1" onclick="likePost(${post.postIndex})">
							<a href="#">
								<div class="like-icn"></div>
							</a>
							<p id="likeCount-${post.postIndex}">${post.likeCount}</p>
						</div>

						<div class="footer-2" onclick="unlikePost(${post.postIndex})">
							<a href="#">
								<div class="like-icn"></div>
							</a>
							<p id="unlikeCount-${post.postIndex}">${post.unlikeCount}</p>
						</div>

						<div class="footer-3">
							<div onclick="commentModal()" class="like-icn"></div>

							<p>${post.comments.size()}</p>
							<div class="share-icn"></div>
						</div>

						<div class="footer-4">
							<a href="#" onclick="deletePost(${post.postIndex})"><p>삭제</p></a>
							<p>|</p>
							<a href="#" onclick="editPost(${post.postIndex})"><p>수정</p></a>
						</div>
					</div>
					<div class="content-review">
    <h3>댓글 작성</h3>
    <textarea placeholder="댓글을 입력하세요"></textarea>
    <div>
        <button type="button" onclick="submitComment(null, ${post.postIndex})">등록</button>
        <button type="button" onclick="closeComment()">닫기</button>
    </div>
</div>


					<div class="border-bottom-area"></div>
				</div>
			</c:forEach>


		</div>

		<div class="side-right-wrap">
			<div class="side-right">

				<div class="srh-area-1">
					<form action="searchPostList.do" method="get">
						<input type="search" name="keyword" placeholder="검색" required>
						<button type="submit" id="srh-icn1"
							style="background-image: url(/CarPlanet/resources/images/searchicon.png);"></button>
					</form>
				</div>

				<div class="keyword-area">
					<div class="pop-title">
						<p>🏅 인기 키워드</p>
					</div>
					<div class="pop-wrap">
						<c:forEach var="keyword" items="${popularKeywords}"
							varStatus="status">
							<a href="searchPostList.do?keyword=${keyword}"
								class="keyword-link">${keyword}</a>
						</c:forEach>
					</div>
				</div>

				<div class="pop-right-box">
					<div class="pop-right-title">
						<span></span>
						<h3>👍 추천글</h3>
					</div>
					<c:forEach var="post" items="${recommendedPosts}"
						varStatus="status">
						<div class="pop-right-content">
							<strong><span>${status.index + 1} </span></strong>
							<p>${post.title}</p>
						</div>
					</c:forEach>
				</div>
				<div class="pop-right-img">
					<img
						src="${pageContext.request.contextPath}/resources/images/image01.png"
						alt="">
					<p>운전자의<br>소통 공간</p>
					<p>
						소중한 내 차를 위한<br>정보 교환의 광장
					</p>
				</div>

			</div>
		</div>
	</div>


	<script>
    function likePost(postIndex) {
        const requestData = {postIndex: postIndex};
        $.ajax({
            type: "post",
            url: "post/like.do",
            data: requestData,
            dataType: "json",
            success: function (resData) {
                const likeCountId = 'likeCount-' + resData.postIndex;
                const unlikeCountId = 'unlikeCount-' + resData.postIndex;
                document.getElementById(likeCountId).innerText = resData.likeCount;
                document.getElementById(unlikeCountId).innerText = resData.unlikeCount;
            },
            error: function (error) {
                console.log("게시글 좋아요 중 에러 발생:", error);
                $(location).attr('href', '/CarPlanet/Auth/Login.do');
            }
        });
    }

    function unlikePost(postIndex) {
        const requestData = {postIndex: postIndex};
        $.ajax({
            type: "post",
            url: "post/unlike.do",
            data: requestData,
            dataType: "json",
            success: function (resData) {
                const likeCountId = 'likeCount-' + resData.postIndex;
                const unlikeCountId = 'unlikeCount-' + resData.postIndex;
                document.getElementById(likeCountId).innerText = resData.likeCount;
                document.getElementById(unlikeCountId).innerText = resData.unlikeCount;
            },
            error: function (error) {
                console.log("게시글 싫어요 중 에러 발생:", error);
                $(location).attr('href', '/CarPlanet/Auth/Login.do');
            }
        });
    }
    
    // 댓글 버튼 클릭 시 모달 열기
function commentModal() {
	let modal = $(".content-review");
	$(modal).css("display", "none");
	let comment = $(event.target).closest(".content-footer").next();
	if($(comment).css("display") == "none"){
		$(comment).css("display", "block");
	}else{
		$(comment).css("display", "none");
	}
}

function closeComment() {
	$(event.target).closest(".content-review").css("display", "none");

}

// 댓글 등록 로직 수정
function submitComment(postCommentIndex, postIndex) {
    const textarea = document.querySelector(".modal-content textarea");
    const commentText = textarea.value;
    if (commentText.trim() === "") {
        alert("댓글을 입력해주세요.");
        return;
    }

    const requestData = {
        postCommentIndex: postCommentIndex,
        postIndex: postIndex,
        content: commentText
    };
    console.log(requestData);
    $.ajax({
        type: "post",
        url: "post/registerComment.do",
        data: requestData,
        dataType: "json",
        success: function (resData) {
            alert("댓글이 등록되었습니다: " + commentText);
            window.location.href = "/CarPlanet/community/getPostList.do";
        },
        error: function (xhr, status, error) {
            if (xhr.status === 401) {
                alert("로그인이 필요합니다. 로그인 페이지로 이동합니다.");
                window.location.href = "/CarPlanet/Auth/Login.do";
            } else {
                console.error("댓글 등록 중 에러 발생:", error);
            }
        }
    });


    // 댓글 입력 후 텍스트박스 초기화 및 높이 리셋
    textarea.value = "";
    textarea.style.height = "auto";

    // 모달 닫기
    document.getElementById("commentModal").style.display = "none";
}


    

    function editPost(postIndex) {
        window.location.href = "post.do?postIndex=" + postIndex;
    }

    function deletePost(postIndex) {
        if (confirm("삭제하시겠습니까?")) {
            const requestData = {postIndex: postIndex};
            $.ajax({
                type: "post",
                url: "deletePost.do",
                data: requestData,
                dataType: "json",
                success: function (resData) {
                    window.location.href = "/CarPlanet/community/getPostList.do";
                },
                error: function (xhr, status, error) {
                    if (xhr.status === 401) {
                        alert("로그인이 필요합니다. 로그인 페이지로 이동합니다.");
                        window.location.href = "/CarPlanet/Auth/Login.do";
                    } else {
                        console.error("게시글 삭제 중 에러 발생:", error);
                    }
                }
            });
        }
    }
</script>
</body>
</html>