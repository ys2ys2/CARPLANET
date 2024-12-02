<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
<!--  slick script	-->
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>게시판</title>
<link href="https://fonts.googleapis.com/css2?family=GongGothic:wght@500&family=Pretendard:wght@400&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/communitylist.css" rel="stylesheet" type="text/css">


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
									<div class="like-badge" onclick="likePost(${post.postIndex}, event)">
								    <a href="#" style="text-decoration: none; color: inherit;">
								        <div class="like-icn">👍</div>
										 </a>
									    <p id="likeCount-${post.postIndex}">${post.likeCount}</p>
									</div>

									<div class="post-info">
										<div class="user-info">
											<img src="/CarPlanet/resources/images/image10.png"
												alt="profile" class="profile-img" /> <span
												class="author-name"
												style="color: white; font-size: 16px; font-weight: bold;">
												${not empty user.carName ? user.carName : "유저"} </span> <span
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
									<span style="font-weight: 500">${not empty user.carName ? user.carName : "유저"}</span>
									<span style="color: #666">•</span> <span style="color: #666">
										<fmt:formatDate value="${post.regDate}" pattern="yyyy-MM-dd" />
									</span>
								</div>
							</div>
							
							<h3 style="font-size: 1.25rem; margin: 1rem 0">${post.title}</h3>							
							<div class="post-content">
								<div class="post-text">
									<p>${post.content}</p>
									<a href="postDetail.do?postIndex=${post.postIndex}"
										style="color: #007bff; text-decoration: none; display: inline-block; margin-top: 0.5rem;">더보기</a>
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
	let currentIdx = 0; // 슬라이드 index 코드
	let currentPosition = 0; // 슬라이드 포지션
	
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
		const slider = document.querySelector(".post-slider");
		const sliderList = document.querySelectorAll(".post-slide-link");
		const slideWidth = sliderList[0].offsetWidth;
		if(sliderInterval !== null){
			clearInterval(sliderInterval);
		}

		if(window.innerWidth <= 768){
			sliderInterval = setInterval(()=> {
				if (currentIdx >= sliderList.length) {
					currentIdx = 0;
				} else if (currentIdx < sliderList.length) {
					currentIdx++;
				}
				
				currentPosition = -(slideWidth * currentIdx);
				slider.style.transform = "translateX(" + currentPosition + "px)";
			}, 3000);
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
					getCommentList(commentId);
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
				$(".post-item:nth-child("+ (postIndex + 1) +") .footer-3 p").text(resData.length);
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

		const slider = document.querySelector(".post-slider");
		const sliderList = document.querySelectorAll(".post-slide-link");
		const slideWidth = sliderList[0].offsetWidth;
		
		const prevBtn = document.querySelector(".nav-button:first-child");
		const nextBtn = document.querySelector(".nav-button:last-child");

		if ( !slider || !prevBtn || !nextBtn ) {
			console.error( "슬라이더 또는 버튼 요소를 찾을 수 없습니다." );
			return; // 필요한 요소가 없으면 이벤트 리스너를 등록하지 않음
		}
		
		prevBtn.addEventListener( "click", () => {
			if ( currentIdx !== 0 ) {
				currentIdx--;
				currentPosition += slideWidth;
				slider.style.transform = "translateX(" + currentPosition + "px)";
			}
			console.log( "이전 버튼 클릭", currentIdx);
		});

		nextBtn.addEventListener( "click", () => {
			if ( currentIdx < sliderList.length - 2) {
				currentIdx++;
				currentPosition -= slideWidth;
				slider.style.transform = "translateX(" + currentPosition + "px)";
			}
			console.log("다음 버튼 클릭",  currentIdx);
		});
	});
</script>
</html>