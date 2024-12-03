<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<link rel="stylesheet" type="text/css"
		  href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" />
	<!--  slick css		-->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<!--  jquery		-->
	<script type="text/javascript"
			src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
	<!--  slick script	-->
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>게시판</title>
	<link
			href="https://fonts.googleapis.com/css2?family=GongGothic:wght@500&family=Pretendard:wght@400&display=swap"
			rel="stylesheet">

	<style>
		@charset "UTF-8";

		* {
			margin: 0;
			padding: 0;
		}

		/* 전체 기본 폰트 */
		body {
			margin: 0;
			padding: 0;
			background: #eff2f7;
			font-family: 'Pretendard-Regular', -apple-system, BlinkMacSystemFont,
			"Segoe UI", Roboto, sans-serif;
		}

		/* 소제목에 GongGothicMedium 적용 */
		h1, h2, h3, .keyword-title, .recommended-title, .popular-title {
			font-family: 'GongGothicMedium', sans-serif;
			font-weight: 500;
		}

		/* 일반 텍스트는 Pretendard-Regular로 설정 */
		p, span, a, .post-text, .user-info, .footer-4 a {
			font-family: 'Pretendard-Regular', sans-serif;
			font-weight: 400;
		}

		/* 인기글 좋아요 밑줄 */
		.like-badge a {
			text-decoration: none; /* 밑줄 제거 */
			color: inherit; /* 기존 색상 유지 */
		}

		.like-badge a:hover {
			text-decoration: none; /* 호버 시에도 밑줄 제거 */
		}

		/* 추가된 스타일 */
		.keyword-title {
			font-size: 18px;
			font-weight: bold;
			margin: 0;
		}

		p, span, .post-text {
			font-size: 15px;
			color: #333;
		}

		.header {
			background: white;
			border-bottom: 1px solid #eee;
		}

		.header-inner {
			width: 95%;
			margin: 0 auto;
			padding: 1rem 1.5rem;
			display: flex;
			justify-content: space-between;
			align-items: center;
		}

		.content-area {
			flex: 1;
			overflow: hidden;
		}

		.keyword-section {
			background: white;
			border-radius: 12px;
			padding: 20px;
		}

		.search-box {
			position: relative; /* 부모 요소를 기준으로 배치 */
			background: #e8e8e8;
			border-radius: 8px;
			padding: 0; /* 내부 패딩 제거 */
			display: flex;
			align-items: center;
			margin-bottom: 24px;
			height: 15px; /* 검색창 높이를 얇게 조정 */
		}

		.search-input {
			border: none; background : transparent;
			width: 100%; /* 입력 필드가 박스를 채우도록 설정 */
			font-size: 14px; /* 글씨 크기 */
			outline: none;
			padding: 8px 12px;
			background: transparent; /* 패딩을 줄여서 얇게 보이게 */
		}

		.keyword-header {
			display: flex;
			align-items: center;
			gap: 8px;
			margin-bottom: 16px;
		}

		.trophy-icon {
			color: #ffd700;
			font-size: 24px;
		}

		.keyword-title {
			font-size: 18px;
			font-weight: bold;
			margin: 0;
		}

		.keyword-grid {
			display: flex;
			flex-wrap: wrap;
			gap: 8px;
		}

		.keyword-tag {
			background: #f0f0f0;
			padding: 8px 16px;
			border-radius: 20px;
			font-size: 14px;
			color: #333;
			cursor: pointer;
			text-decoration: none; /* 밑줄 제거 */
		}

		.keyword-tag:hover {
			text-decoration: none; /* 호버 상태에서도 밑줄 제거 */
		}

		.popular-posts {
			overflow: hidden;
			background: white;
			padding: 24px;
			border-radius: 8px;
		}

		.popular-posts .post-image {
			width: 100%;
		}

		.popular-header {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 20px;
		}

		.popular-title {
			font-family: 'GongGothicMedium', sans-serif;
			/* GongGothicMedium 폰트 적용 */
			font-size: 24px;
			font-weight: 500; /* GongGothic의 Medium(500) 설정 */
			color: #333;
			margin: 0;
		}

		.navigation-buttons {
			display: flex;
			gap: 12px;
		}

		.nav-button {
			width: 32px;
			height: 32px;
			border: 1px solid #e0e0e0;
			border-radius: 50%;
			background: white;
			display: flex;
			align-items: center;
			justify-content: center;
			cursor: pointer;
			color: #666;
		}

		.post-slider--wrapper {
			overflow: hidden;
			position:relative;
			height: 300px;
		}

		.post-image {
			/* width: 100%; */
			/* height: 100%; */
			object-fit: cover;
		}

		<!-- search-icon 스타일을 하나로 합침 -->
		.search-icon {
			position: absolute;
			right: 10px;
			top: 50%;
			transform: translateY(-50%);
			border: none;
			background: none;
			font-size: 18px;
			cursor: pointer;
			color: #666;
		}

		.like-badge {
			position: absolute;
			top: 16px;
			right: 16px;
			background: rgba(255, 255, 255, 0.15);
			backdrop-filter: blur(4px);
			border: 1px solid rgba(0, 0, 0, 0.7);
			padding: 8px 16px;
			border-radius: 8px;
			display: flex;
			align-items: center;
			gap: 4px;
		}

		.post-info {
			position: absolute;
			bottom: 0;
			left: 0;
			right: 0;
			padding: 20px;
			color: white;
		}

		.user-info {
			display: flex;
			align-items: center;
			gap: 8px;
		}

		.profile-img {
			width: 24px;
			height: 24px;
			border-radius: 50%;
		}

		.separator {
			color: rgba(255, 255, 255, 0.7);
		}

		.date {
			color: #000000;
		}

		.main-container {
			padding: 1rem 2rem; /* 상하 여백 1rem, 좌우 여백 2rem */
			margin: 0 auto; /* 중앙 정렬 */
			display: flex;
			gap: 16px;
			max-width: 1092px;
		}

		.search-bar {
			background: white;
			padding: 2rem 1rem;
			border-radius: 8px;
			margin-bottom: 1rem;
			display: flex;
			align-items: center;
			gap: 1rem;
		}

		/* 인기 게시물 스타일 */
		.popular-posts {
			background: white;
			padding: 2rem;
			border-radius: 8px;
			margin-bottom: 2rem;
		}

		/* 공통 스타일을 하나로 합침 */
		.post-slider {
			display: flex;
			gap: 16px;
			transition: transform 0.3s ease-in-out;
			width: 4000px;
		}

		/* 반응형으로 크기를 설정 */
		.post-slide {
			position: relative;
			max-width: 300px;
			height: 300px;
			border-radius: 12px;
			overflow: hidden;
			flex-shrink: 0;
		}
		.post-slide::before {
			content: '';
			position: absolute;
			top: 0;
			left: 0;
			width: 100%;
			height: 100%;
			background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
		}

		.post-items {
			background: white;
			border-radius: 8px;
			padding: 0 2rem;
		}

		.post-item {
			padding: 2rem 0;
			border-bottom: 1px solid #e0e0e0;
		}

		.post-item:last-child {
			border-bottom: none;
		}

		.profile-section {
			display: flex;
			align-items: center;
			gap: 1rem;
		}

		.profile-image {
			width: 40px;
			height: 40px;
			border-radius: 50%;
			background: #e0e0e0;
		}

		.user-info {
			display: flex;
			gap: 0.5rem;
			align-items: center;
		}

		.post-content {
			display: flex;
			justify-content: space-between;
			gap: 2rem;
			margin: 1rem 0;
		}

		.post-text {
			flex: 1;
		}

		.post-text p {
			display: -webkit-box; /* Flexbox와 유사한 레이아웃 */
			/*-webkit-line-clamp: 4; !* 최대 표시할 줄 수 *!*/
			/*-webkit-box-orient: vertical; !* 블록 방향 지정 *!*/
			overflow: hidden; /* 넘치는 텍스트 숨김 */
			text-overflow: ellipsis; /* 넘친 부분에 '...' 표시 */
			white-space: normal; /* 줄바꿈 허용 */
		}

		.post-items .post-image {
			width: 200px;
			flex-shrink: 0;
		}

		.post-image img {
			width: 100%; /* 부모 요소 너비에 맞춤 */
			height: 100%; /* 기존 100px에서 크기 증가 */
			/* border-radius: 8px; */
			object-fit: cover; /* 이미지 비율 유지 */
		}

		.post-footer {
			display: flex;
			justify-content: space-between;
			align-items: center;
		}

		.interaction-buttons {
			display: flex;
			gap: 2rem;
		}

		.edit-buttons {
			display: flex;
			gap: 1rem;
			color: #666;
		}

		button {
			background: none;
			border: none;
			cursor: pointer;
			padding: 0;
		}

		/* 사이드바 스타일 */
		.sidebar {
			width: 300px;
			border-radius: 8px;
		}

		.author-name {
			font-size: 16px; /* 이름의 크기를 키움 */
			font-weight: bold; /* 이름을 강조 */
		}

		.tag-container {
			display: flex;
			flex-wrap: wrap;
			gap: 0.5rem;
			margin-bottom: 2rem;
		}

		.tag {
			background: #f0f0f0;
			padding: 0.5rem 1rem;
			border-radius: 20px;
			font-size: 0.9rem;
		}

		.recommended-posts {
			padding: 1rem;
		}

		.keyword-section, .recommended-section {
			background: white;
			border-radius: 12px;
			padding: 20px;
		}

		.keyword-section {
			margin-bottom: 24px;
		}

		.search-box {
			background: #e8e8e8;
			border-radius: 8px;
			padding: 12px 16px;
			display: flex;
			align-items: center;
			margin-bottom: 24px;
			position: relative;
		}

		.search-input {
			border: none;
			background: transparent;
			width: 100%;
			font-size: 14px;
			outline: none;
			padding-right: 30px;
		}

		.search-icon {
			position: absolute;
			right: 16px;
			top: 55%; /* 약간 아래로 내림 */
			transform: translateY(-50%);
			color: #666;
			font-size: 20px;
		}

		.keyword-header {
			display: flex;
			align-items: center;
			gap: 8px;
			margin-bottom: 16px;
		}

		.trophy-icon {
			color: #ffd700;
			font-size: 24px;
		}

		.keyword-title, .recommended-title {
			font-size: 18px;
			font-weight: bold;
			margin: 0;
		}

		.keyword-grid {
			display: flex;
			flex-wrap: wrap;
			gap: 8px;
		}

		.keyword-tag {
			background: #f0f0f0;
			padding: 8px 16px;
			border-radius: 20px;
			font-size: 14px;
			color: #333;
			cursor: pointer;
		}

		.recommended-list {
			display: flex;
			flex-direction: column;
			margin-top: 16px; /* 추천글 목록과 제목 간의 간격 */
		}

		.recommended-item {
			padding: 12px 0;
			border-bottom: 1px solid #eee;
			display: flex;
			gap: 12px;
			color: #333;
			text-decoration: none;
		}

		.recommended-item:last-child {
			border-bottom: none;
		}

		.recommended-number {
			font-size: 16px;
			font-weight: 500;
			color: #007bff;
			min-width: 24px;
		}

		.recommended-text {
			display: -webkit-box; /* Flexbox 대신 지원 범위를 고려해 사용 */
			-webkit-line-clamp: 1; /* 몇 줄을 표시할지 지정 (여기선 1줄) */
			-webkit-box-orient: vertical; /* 블록 방향 지정 */
			overflow: hidden; /* 넘치는 내용 숨김 */
			text-overflow: ellipsis; /* 숨겨진 내용에 '...' 표시 */
			white-space: normal; /* 줄바꿈 허용 */
		}

		.more-link {
			display: block;
			text-align: right;
			color: #666;
			text-decoration: none;
			font-size: 14px;
			margin-top: 12px;
		}

		.writing-icon {
			width: 60px;
			height: 60px;
			border-radius: 50%;
			object-fit: cover;
			background-color: #e0e0e0;
			margin-left: 20px; /* 왼쪽에 20px 간격 추가 */
		}

		/* 추가된 스타일: 고정된 글 작성 버튼 */
		#fixedWriteButton {
			position: fixed; /* 화면에 고정 */
			bottom: 20px; /* 화면 아래에서 20px 띄우기 */
			right: 20px; /* 화면 오른쪽에서 20px 띄우기 */
			width: 60px; /* 버튼 크기 */
			height: 60px;
			border-radius: 50%; /* 동그랗게 만들기 */
			background-color: #007bff; /* 버튼 배경색 */
			border: none; /* 테두리 제거 */
			box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2); /* 그림자 추가 */
			cursor: pointer; /* 클릭 가능하도록 커서 변경 */
			z-index: 1000; /* 다른 요소 위에 표시 */
			display: flex;
			align-items: center;
			justify-content: center;
		}

		#fixedWriteButton img {
			width: 40px; /* 아이콘 크기 */
			height: 40px;
			object-fit: cover;
		}

		#fixedWriteButton:hover {
			/* background-color: #0056b3; */ /* 호버 시 배경색 변경 */
			transform: scale(1.1); /* 약간 확대 */
			transition: all 0.2s ease; /* 부드러운 애니메이션 */
		}

		.search-bar span {
			font-size: 16px; /* 텍스트 크기를 기본보다 키움 (기존보다 큰 값 사용) */
			/*  font-weight: bold; /* 필요하면 글자 두께를 조정 */
			color: #333; /* 필요에 따라 색상 변경 */
		}

		/* 댓글 간격 */
		.content-review .comment {
			display: flex;
			align-items: flex-start;
			margin-bottom: 15px; /* 댓글 아이템 간 간격 */
			gap: 10px; /* 프로필 이미지와 텍스트 간 간격 */
		}

		.content-review .comment .icon {
			width: 30px;
			height: 30px;
			background-image: url('/CarPlanet/resources/images/image10.png');
			background-position: center;
			background-repeat: no-repeat;
			background-size: cover;
			border-radius: 50%;
		}

		.content-review .comment p {
			margin: 0; /* 기본 마진 제거 */
			color: #555; /* 텍스트 색상 */
		}

		.content-review .user_id {
			font-weight: bold;
			margin-bottom: 4px; /* 유저명 아래 여백 */
		}

		.content-review .date {
			font-size: 12px;
			color: #888;
			margin-left: 8px; /* 유저명과 날짜 사이 간격 */
			margin-bottom: 4px; /* 날짜 아래 여백 */
		}

		.content-review .comment p:last-child {
			margin-top: 8px; /* 댓글 텍스트와 날짜 사이 간격 */
		}

		.content-review {
			display: none; /* 기본적으로 숨김 */
			/*  width: 96%; /* 게시글 너비에 맞춤 */
			margin-top: 15px; /* 게시글과 간격 추가 */
			background-color: white;
			padding: 15px;
			border-radius: 8px;
			box-shadow: 0 4px 6px rgba(0, 0, 0, 0.04);
		}

		.content-review h3 {
			font-size: 16px;
			margin-bottom: 10px;
			font-weight: bold;
		}

		.content-review textarea {
			width: 97%; /* 너비를 댓글 창에 맞춤 */
			min-height: 60px; /* 최소 높이 */
			border: 1px solid #ccc;
			border-radius: 5px;
			padding: 10px;
			font-size: 14px;
			resize: none; /* 크기 조정 비활성화 */
			margin-bottom: 10px;
		}

		.content-review button {
			background-color: #007bff; /* 버튼 색상 */
			color: white;
			border: none;
			border-radius: 5px;
			padding: 8px 12px;
			font-size: 14px;
			cursor: pointer;
		}

		.content-review button:hover {
			background-color: #003f7f; /* 호버 시 색상 변경 */
		}

		/* 좋아요, 싫어요 밑줄 제거 */
		.footer-1 a, .footer-2 a {
			text-decoration: none; /* 밑줄 제거 */
		}

		/* 좋아요, 싫어요, 댓글, 공유하기 */
		.content-footer {
			width: 100%;
			display: flex;
			gap: 20px;
			margin-bottom: 15px;
			align-items: center;
		}

		.content-footer div {
			display: flex;
			align-items: center;
			gap: 5px;
		}

		.content-footer .like-icn, .content-footer .unlike-icn, .content-footer .comment-icn,
		.content-footer .share-icn {
			font-size: 24px; /* 이모지 크기 */
			cursor: pointer;
		}

		.content-footer p {
			font-size: 16px; /* 텍스트 크기 */
			margin: 0;
			color: #555; /* 텍스트 색상 */
		}

		.footer-4 {
			margin-left: auto; /* 오른쪽 끝으로 밀기 */
			display: flex;
			gap: 10px; /* 삭제와 수정 버튼 사이 간격 */
			align-items: center;
		}

		.footer-4 a {
			text-decoration: none;
			color: #007bff; /* 링크 색상 */
			font-size: 16px; /* 링크 크기 */
			font-weight: bold; /* 버튼을 조금 더 강조 */
			display: inline-flex;
			align-items: center;
		}

		.footer-4 a:hover {
			text-decoration: underline; /* 호버 시 밑줄 표시 */
			color: #0056b3; /* 호버 시 색상 변경 */
		}

		/* 모바일 */
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

		/* 모바일 화면 (1024px 이하) */
		@media ( max-width : 1024px) {
			.sidebar {
				display: none; /* 오른쪽 창 숨기기 */
			}
			.content-area {
				width: 100%; /* 콘텐츠 영역을 전체 너비로 확장 */
			}
		}

		/* 모바일 화면 (768px 이하) */
		@media ( max-width : 768px) {
			.post-content {
				display: flex;
				flex-direction: column; /* 사진과 내용을 세로로 정렬 */
				gap: 1rem; /* 간격 추가 */
			}
			.post-text {
				order: 1; /* 내용이 위로 올라오도록 순서 지정 */
			}
			.post-image {
				order: 2; /* 사진이 내용 아래로 이동 */
				width: 100%; /* 사진 너비를 부모에 맞춤 */
				max-width: 400px; /* 사진 최대 너비 제한 */
				margin: 0 auto; /* 사진을 가운데 정렬 */
			}
			.post-image img {
				width: 100%; /* 이미지가 부모 요소를 채우도록 설정 */
				height: auto; /* 비율 유지 */
				object-fit: cover; /* 이미지 비율 유지 */
			}

			.post-slide-link {
				max-width: calc(100vw - 130px) !important;
				width: calc(100vw - 130px) !important;
			}

			.post-slider {
				width: calc((100vw - 100px) * 10);
			}
		}

		/* 초소형 화면 (425px 이하) */
		@media ( max-width : 425px) {
			.popular-posts .post-slide {
				width: calc(100vw - 130px) !important;
			}
			.post-content {
				flex-direction: column; /* 사진과 내용을 세로로 정렬 */
			}
			.post-image {
				margin-top: 1rem; /* 내용과 사진 사이 간격 추가 */
			}
			.post-text {
				font-size: 14px; /* 글씨 크기를 조정 */
			}
			.post-slide-link{
				max-width: calc(100vw - 130px) !important;
				width: calc(100vw - 130px) !important;
			}
			.post-slider {
				width: calc((100vw - 100px) * 10);
			}
		}

		/* 인기 게시물 */
		.post-placeholder {
			display: flex;
			align-items: center;
			justify-content: center;
			background: #dff4ff; /* 연 하늘색 배경 */
			height: 100%; /* 부모 요소 높이 채우기 */
			color: #007bff; /* 텍스트 색상 */
			font-size: 18px; /* 텍스트 크기 */
			font-weight: bold; /* 텍스트 강조 */
			text-align: center;
			border-radius: 12px; /* 둥근 모서리 */
		}

		/* 기존 그라데이션 스타일 유지 */
		.post-info {
			position: absolute;
			bottom: 0;
			left: 0;
			right: 0;
			padding: 20px;
			color: white;
		}

		/* 링크 스타일 초기화 */
		.post-slide-link {
			text-decoration: none;
			color: inherit;
			max-width: 300px;
			display: flex;
			flex-direction: column;
			flex: 1;
		}

		.whitespace{
			-webkit-line-clamp: 4; /* 최대 표시할 줄 수 */
			-webkit-box-orient: vertical; /* 블록 방향 지정 */
		}

	</style>
</head>
<body>
<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />

<div class="main-container">
	<!-- 왼쪽 영역 -->
	<div class="content-area">
		<!-- 기존 글 작성 버튼 -->
		<div class="search-bar">
			<button onclick="location.href='post.do'">
				<img src="/CarPlanet/resources/images/writing.png" alt="writing"
					 class="writing-icon" />
			</button>
			<span>오늘 있었던 일을 기록하고 공유해보세요.</span>
		</div>

		<!-- 고정된 글 작성 버튼 -->
		<button onclick="location.href='post.do'" id="fixedWriteButton">
			<img src="/CarPlanet/resources/images/writing.png" alt="글 작성" />
		</button>

		<!-- 인기 게시글 섹션 -->
		<div class="popular-posts">
			<div class="popular-header">
				<h2 class="popular-title">인기 게시글</h2>
				<div class="navigation-buttons">
					<button class="nav-button">&lt;</button>
					<button class="nav-button">&gt;</button>
				</div>
			</div>
			<div class="post-slider--wrapper">
				<div class="post-slider">
					<c:forEach var="post" items="${recommendedPosts}">
						<a href="searchPostList.do?postIndex=${post.postIndex}"
						   class="post-slide-link">
							<div class="post-slide">


								<c:choose>
									<c:when test="${not empty post.fileName}">
										<img
												src="${pageContext.request.contextPath}${post.filePath}${post.fileName}"
												alt="${post.title}" class="post-image" />
									</c:when>
									<c:otherwise>
										<div class="post-placeholder">
											<p>${post.title}</p>
										</div>
									</c:otherwise>
								</c:choose>
									<%-- 	<div class="like-badge" onclick="likePost(${post.postIndex}, event)">
                                               <a href="#" style="text-decoration: none; color: inherit;">
                                                   <div class="like-icn">👍</div>
                                             </a>
                                               <p id="likeCount-${post.postIndex}">${post.likeCount}</p>
                                        </div> --%>

								<div class="post-info">
									<h3 style="font-size: 1.25rem; margin: 1rem 0">${post.title}</h3>
									<div class="user-info">

										<img src="/CarPlanet/resources/images/image10.png"
											 alt="profile" class="profile-img" /> <span
											class="author-name"
											style="color: white; font-size: 16px; font-weight: bold;">
											${not empty post.carId ? post.carId : "유저"} </span> <span
											class="separator" style="color: white;">•</span> <span
											class="date" style="color: white; font-size: 12px;">
											<fmt:formatDate value="${post.regDate}" pattern="yyyy-MM-dd" />
										</span>
									</div>
								</div>

							</div>
						</a>
					</c:forEach>
				</div>
			</div>
		</div>
		<!-- 일반 게시물 -->
		<div class="post-items">
			<c:forEach var="post" items="${posts}">
				<div class="post-item">
					<div class="profile-section">
						<img src="/CarPlanet/resources/images/image10.png" alt="profile"
							 class="profile-image" />
						<div class="user-info">
							<span style="font-weight: 500">${not empty post.carId ? post.carId : "유저"}</span>
							<span style="color: #666">•</span> <span style="color: #666">
									<fmt:formatDate value="${post.regDate}" pattern="yyyy-MM-dd" />
								</span>
						</div>
					</div>

					<h3 style="font-size: 1.25rem; margin: 1rem 0">${post.title}</h3>
					<div class="post-content">
						<div class="post-text">
							<p class="${fn:length(post.content) > 200 ? 'whitespace' : ''}">${post.content}</p>
							<c:if test="${fn:length(post.content) > 200}">
								<a href="#" style="color: #007bff; text-decoration: none; display: inline-block; margin-top: 0.5rem;">더보기</a>
							</c:if>
						</div>

						<c:if test="${not empty post.fileName}">
							<div class="post-image">
								<img
										src="${pageContext.request.contextPath}${post.filePath}${post.fileName}"
										alt="post attachment" />
							</div>
						</c:if>
					</div>

					<div class="content-footer">
						<!-- 좋아요 -->
							<%-- <div class="footer-1"
								onclick="likePost(${post.postIndex}, event)"> --%>
						<div class="footer-1" data-post-index="${post.postIndex}">
							<a href="#">
								<div class="like-icn">👍</div>
							</a>
							<p id="sub-likeCount-${post.postIndex}">${post.likeCount}</p>
						</div>

							<%-- <div class="footer-2"
								onclick="unlikePost(${post.postIndex}, event)"> --%>
						<div class="footer-2" data-post-index="${post.postIndex}">
							<a href="#">
								<div class="unlike-icn">👎</div>
							</a>
							<p id="sub-unlikeCount-${post.postIndex}">${post.unlikeCount}</p>
						</div>


						<!-- 댓글 아이콘 -->
						<div class="footer-3">
							<div onclick="commentModal(event, ${post.postIndex})"
								 class="comment-icn">💬</div>
							<!-- 댓글 이모지 -->
							<p>${post.comments.size()}</p>
						</div>

						<!-- 수정 및 삭제 -->
						<div class="footer-4">
							<a href="#" onclick="deletePost(${post.postIndex})"><p>삭제</p></a>
							<!-- 삭제 이모지 -->
							<p>|</p>
							<a href="#" onclick="editPost(${post.postIndex})"><p>수정</p></a>
							<!-- 수정 이모지 -->
						</div>
					</div>

					<div class="content-review">
						<div class="comment-box">
<%--							<c:forEach var="comment" items="${post.comments}"--%>
<%--									   varStatus="status">--%>
<%--								<div class="comment">--%>
<%--									<div class="icon"></div>--%>
<%--									<!-- 프로필 이미지 -->--%>
<%--									<div>--%>
<%--										<p class="user_id">${not empty comment.carId ? comment.carId : "유저"}</p>--%>
<%--										<!-- 유저 이름 -->--%>
<%--										<p>${comment.content}</p>--%>
<%--										<!-- 댓글 텍스트 -->--%>
<%--										<p class="date">--%>
<%--											<fmt:formatDate value="${comment.regDate}"--%>
<%--															pattern="yyyy-MM-dd HH:mm" />--%>
<%--											<button type="button"--%>
<%--													onclick="deleteComment(${comment.postCommentIndex})"--%>
<%--													style="border: none; background: none; cursor: pointer; color: rgb(0, 0, 0); font-size: 14px;">❌</button>--%>
<%--										</p>--%>
<%--										<div style="display: flex; gap: 10px; margin-top: 5px;">--%>
<%--												&lt;%&ndash; <button type="button"--%>
<%--													onclick="editComment(${comment.postCommentIndex})"--%>
<%--	  												style="border: none; background: none; cursor: pointer; color:  rgb(0, 0, 0); font-size: 14px;">수정</button> &ndash;%&gt;--%>
<%--										</div>--%>
<%--									</div>--%>
<%--								</div>--%>
<%--							</c:forEach>--%>
						</div>

						<h3>댓글 작성</h3>
						<textarea placeholder="댓글을 입력하세요" id="textarea${post.postIndex}"></textarea>
						<div>
							<button type="button"
									onclick="submitComment(null, ${post.postIndex})">등록</button>
							<button type="button" onclick="closeComment(this)">닫기</button>
						</div>
					</div>

					<div class="border-bottom-area"></div>
				</div>
			</c:forEach>
		</div>
	</div>

	<!-- 오른쪽 사이드바 -->
	<div class="sidebar">
		<div class="keyword-section">
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

			<div class="keyword-header">
				<span class="trophy-icon">🏆</span>
				<h2 class="keyword-title">인기 키워드</h2>
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

		<div class="recommended-section">
			<h2 class="recommended-title">추천글</h2>
			<div class="recommended-list">
				<c:forEach var="post" items="${recommendedPosts}"
						   varStatus="status">
					<a href="searchPostList.do?postIndex=${post.postIndex}"
					   class="recommended-item"> <span class="recommended-number">${status.index + 1}</span>
						<span class="recommended-text">${post.title}</span>
					</a>
				</c:forEach>
			</div>
			<!-- <a href="#" class="more-link">더보기</a> -->
		</div>
	</div>

</div>

</body>
<script>
	let sliderInterval = null;
	let popularIndex = 0;
	let isSlide = true;
	let currentIdx = 0;
	let currentPosition = 0;
	//jQuery구문: window.onload 이벤트 처리
	$(function(){

		let reqURL; //ajax로 요청을 보낼 URL 변수
		let postIndex; //게시글 번호

		//좋아요 버튼에 대한 jQuery객체
		$(".footer-1").on("click", function(event){
			reqURL = "post/like.do";
			postIndex = $(this).data("postIndex");
			handleLikeOrUnlikePost(postIndex, reqURL, event);
		});

		//싫어요 버튼에 대한 jQuery객체
		$(".footer-2").on("click", function(event){
			reqURL = "post/unlike.do";
			postIndex = $(this).data("postIndex");
			handleLikeOrUnlikePost(postIndex, reqURL, event);
		});

		$(".post-text a").on("click", function(event){
			event.preventDefault();
			showPostText(event);
		});

		window.addEventListener("resize", ()=> {
			popularPostSlider();
		});

		popularPostSlider();



	})//end of jQuery구문

	function popularPostSlider(){
		if(sliderInterval !== null){
			clearInterval(sliderInterval);
			$(".post-slider").css({transform:"none"});
		}

		if(window.innerWidth <= 768){
			$(".post-slide-link").css({position: "absolute", left: "-100%"});
			$(".post-slide-link").eq(popularIndex).css({position:"absolute", left: "0px"});
			sliderInterval = setInterval(()=> {
				if(!isSlide) return false;
				isSlide = false;
				// 현재 보이는 슬라이드를 숨김
				$(".post-slide-link").eq(popularIndex).animate({position: "absolute", left: "-100%"}, 'slow', function(){$(".post-slide-link").eq(popularIndex).css({position: "absolute", left: "-100%"})});

				// 다음 슬라이드 Index를 계산 후 슬라이드를 나타나게함
				let next = popularIndex >= $(".post-slide-link").length - 1 ? 0 : popularIndex + 1;
				$(".post-slide-link").eq(next).css({position:"absolute", left: "100%"}).animate({position:"absolute", left: "0px"}, 'slow', function(){isSlide = true});

				// 다음 슬라이드 번호가 현재 슬라이드 번호로 치환
				popularIndex = next;
			}, 3000);
		} else {
			$(".post-slide-link").css({position:"relative", left: "0px"});
		}
	}

	function handleLikeOrUnlikePost(postIndex, reqURL, event) {
		event.preventDefault(); // 기본 동작 방지: a 태그
		const requestData = { postIndex: postIndex };
		$.ajax({
			type: "post",
			url: reqURL,
			data: requestData,
			dataType: "json",
			success: function (resData) {
				const likeCountId = '#sub-likeCount-' + resData.postIndex;
				const unlikeCountId = '#sub-unlikeCount-' + resData.postIndex;
				/* document.getElementById(likeCountId).innerText = resData.likeCount;
                document.getElementById(unlikeCountId).innerText = resData.unlikeCount; */
				$(likeCountId).text(resData.likeCount);
				$(unlikeCountId).text(resData.unlikeCount);

				console.log("좋아요 개수:"+resData.likeCount+", 싫어요 개수:"+resData.unlikeCount);
			},
			error: function (error) {
				console.log("게시글 좋아요 중 에러 발생:", error);
				$(location).attr('href', '/CarPlanet/Auth/Login.do');
			}
		});
	}

	/* function likePost(postIndex, event) {
           event.preventDefault(); // 기본 동작 방지
           const requestData = { postIndex: postIndex };
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

       function unlikePost(postIndex, event) {
           event.preventDefault(); // 기본 동작 방지
           const requestData = { postIndex: postIndex };
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
       } */


	function commentModal(event, postIndex) {
		// 클릭된 게시글의 댓글 창 가져오기
		const reviewElement = $(event.target).closest(".content-footer").next(".content-review");

		// 모든 댓글 창을 닫기
		$(".content-review").slideUp(300);

		// 클릭된 댓글 창 열기
		if ($(reviewElement).css("display") === "none") {
			$(reviewElement).slideDown(300); // 댓글 창 열기
			getCommentList(postIndex);
		}
	}


	function closeComment(button) {
		// 클릭된 버튼에서 가장 가까운 .content-review 요소를 찾고 숨김
		$(button).closest(".content-review").slideUp(300);
	}

	// 댓글 등록 로직 수정
	function submitComment(postCommentIndex, postIndex) {
		const textareaId = "#textarea"+postIndex;
		const textarea = document.querySelector(textareaId);
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
				// 댓글 등록 후 댓글을 동적으로 추가하는 방식으로 개선
				// const commentListElement = document.querySelector(".comment-list");
				// const newCommentElement = document.createElement("li");
				// newCommentElement.textContent = commentText;  // 새로운 댓글 내용
				// commentListElement.appendChild(newCommentElement);  // 댓글 목록에 추가
				// textarea.value = "";  // 텍스트박스 초기화
				// textarea.style.height = "auto";  // 높이 리셋
				getCommentList(postIndex);
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
		// document.getElementById("commentModal").style.display = "none";
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

	function showPost(postIndex) {
		window.location.href = "/CarPlanet/community/getPostList.do?postIndex=" + postIndex;
	}

	function editComment(commentId) {
		// 댓글 요소 찾기
		const commentElement = document.getElementById(`comment-`+commentId);
		const contentElement = commentElement.querySelector(".content");
		const editButton = commentElement.querySelector("button[onclick^='editComment']");

		// 기존 내용 저장
		const currentContent = contentElement.textContent;

		// input 요소 생성
		const inputElement = document.createElement("input");
		inputElement.type = "text";
		inputElement.value = currentContent;
		inputElement.className = "edit-input";

		contentElement.replaceWith(inputElement);

		editButton.textContent = "저장";
		editButton.style.color = "green";
		editButton.onclick = function () {
			saveComment(commentId, inputElement.value);
		};
	}

	function saveComment(commentId, newContent) {
		const commentElement = document.getElementById(`comment-`+commentId);
		const inputElement = commentElement.querySelector(".edit-input");
		const editButton = commentElement.querySelector("button[onclick^='editComment']");

		// p 태그로 새 내용 생성
		const contentElement = document.createElement("p");
		contentElement.className = "content";
		contentElement.textContent = newContent;

		// input 요소를 p 태그로 교체
		inputElement.replaceWith(contentElement);

		// 저장 버튼을 수정 버튼으로 교체
		editButton.textContent = "수정";
		editButton.style.color = "blue";
		editButton.onclick = function () {
			editComment(commentId);
		};

		contentElement.style.display = "block";
		if (confirm("저장하시겠습니까?")) {
			const requestData = {postCommentIndex: commentId, content: newContent};
			$.ajax({
				type: "post",
				url: "post/updateComment.do",
				data: requestData,
				dataType: "json",
				success: function (resData) {
					console.log(resData);
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

	function deleteComment(postCommentIndex) {
		if (confirm("삭제하시겠습니까?")) {
			const requestData = {postCommentIndex: postCommentIndex};
			$.ajax({
				type: "post",
				url: "post/deleteComment.do",
				data: requestData,
				dataType: "json",
				success: function (resData) {
					// const commentElement = document.getElementById(`comment-`+postCommentIndex);
					// commentElement.remove();
					// const commentCountElement = document.querySelector(".commentCount");
					// // 현재 댓글 개수 가져오기
					// let currentCount = parseInt(commentCountElement.textContent, 10);
					//
					// // 댓글 개수를 1 줄임 (최소 0을 유지)
					// currentCount = Math.max(0, currentCount - 1);
					// commentCountElement.textContent = currentCount;
					getCommentList(resData.postIndex);
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

	function getCommentList(postIndex){
		$.ajax({
			type: "get",
			url: "post/comment/list.do",
			data: {postIndex: postIndex},
			dataType: "json",
			success: function (resData) {
				$(".comment-box .comment").remove();
				let div = $(".comment-box");

				resData.forEach(e => {
					let regDate = new Date(e.regDate);
					$(`<div class="comment">
									<div class="icon"></div>
									<!-- 프로필 이미지 -->
									<div>
										<p class="user_id">\${e.carId !== null ? e.carId : "유저"}</p>
										<!-- 유저 이름 -->
										<p>\${e.content}</p>
										<!-- 댓글 텍스트 -->
										<p class="date">
											\${regDate.getFullYear()}-\${(regDate.getMonth()+1).toString().padStart(2, '0')}-\${regDate.getDate().toString().padStart(2, '0')} \${regDate.getHours().toString().padStart(2, '0')}:\${regDate.getMinutes().toString().padStart(2, '0')}
											<button type="button"
													onclick="deleteComment(\${e.postCommentIndex})"
													style="border: none; background: none; cursor: pointer; color: rgb(0, 0, 0); font-size: 14px;">❌</button>
										</p>
										<div style="display: flex; gap: 10px; margin-top: 5px;">
												<%-- <button type="button"
													onclick="editComment(${comment.postCommentIndex})"
	  												style="border: none; background: none; cursor: pointer; color:  rgb(0, 0, 0); font-size: 14px;">수정</button> --%>
										</div>
									</div>
								</div>`).appendTo(div);
				});

				// 댓글 갯수 수정
				$(".post-item:nth-last-child("+ (postIndex) +") .footer-3 p").text(resData.length);
			},
			error: function (xhr, status, error) {
				console.error("게시글 댓글 조회 시 에러:", error);
			}
		});
	}

	function showPostText(event){
		let textEl = $(event.target).parent().find("p");
		$(textEl).removeClass("whitespace");

		$(event.target).remove();
	}

	/* 인기 게시글 */
	document.addEventListener("DOMContentLoaded", function () {

		const sliderList = document.querySelectorAll(".post-slide-link");
		const slideWidth = sliderList[0].offsetWidth;

		const slider = document.querySelector(".post-slider");
		const prevBtn = document.querySelector(".nav-button:first-child");
		const nextBtn = document.querySelector(".nav-button:last-child");

		if ( !slider || !prevBtn || !nextBtn ) {
			console.error( "슬라이더 또는 버튼 요소를 찾을 수 없습니다." );
			return; // 필요한 요소가 없으면 이벤트 리스너를 등록하지 않음
		}
		let currentPosition = 0;

		prevBtn.addEventListener( "click", () => {
			if(window.innerWidth <= 768){
				if(!isSlide) return false;
				isSlide = false;

				// 현재 보이는 슬라이드를 숨김
				$(".post-slide-link").eq(popularIndex).animate({position: "absolute", left: "100%"}, 'slow', function(){$(".post-slide-link").eq(popularIndex).css({position: "absolute", left: "100%"})});

				// 다음 슬라이드 Index를 계산 후 슬라이드를 나타나게함
				let prev = popularIndex <= 0 ? $(".post-slide-link").length - 1 : popularIndex - 1;
				$(".post-slide-link").eq(prev).css({position:"absolute", left: "-100%"}).animate({position:"absolute", left: "0px"}, 'slow', function(){isSlide = true});

				// 다음 슬라이드 번호가 현재 슬라이드 번호로 치환
				popularIndex = prev;
			} else {
				if ( currentIdx !== 0 ) {
					currentIdx--;
					currentPosition += slideWidth;
					slider.style.transform = "translateX(" + currentPosition + "px)";
				}
			}
		});

		nextBtn.addEventListener( "click", () => {
			if(window.innerWidth <= 768){
				if(!isSlide) return false;

				isSlide = false;

				// 현재 보이는 슬라이드를 숨김
				$(".post-slide-link").eq(popularIndex).animate({position: "absolute", left: "-100%"}, 'slow', function(){$(".post-slide-link").eq(popularIndex).css({position: "absolute", left: "-100%"})});

				// 다음 슬라이드 Index를 계산 후 슬라이드를 나타나게함
				let next = popularIndex >= $(".post-slide-link").length - 1 ? 0 : popularIndex + 1;
				$(".post-slide-link").eq(next).css({position:"absolute", left: "100%"}).animate({position:"absolute", left: "0px"}, 'slow', function(){isSlide = true});

				// 다음 슬라이드 번호가 현재 슬라이드 번호로 치환
				popularIndex = next;
			} else {
				if ( currentIdx < sliderList.length - 2) {
					currentIdx++;
					currentPosition -= slideWidth;
					slider.style.transform = "translateX(" + currentPosition + "px)";
				}
			}
		});
	});
</script>
</html>