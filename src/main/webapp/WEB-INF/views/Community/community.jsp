<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="${pageContext.request.contextPath}/resources/css/community.css" rel="stylesheet" type="text/css">



<title>게시판</title>

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
                <input type="hidden" name="originalFilePath" value="${post.filePath}">
                <input type="hidden" name="originalFileName" value="${post.fileName}">
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