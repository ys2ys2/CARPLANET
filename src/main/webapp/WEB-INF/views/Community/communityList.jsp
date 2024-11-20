<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            width: 180dvb;
            height: 150vh;
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
            height: 90%;
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
            width: 60%;
            height: 90%;
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
            background-image: url('/V5/resources/images/image01.png');
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

        .top-image-area button {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            padding: 10px 20px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            bottom: 20px; /* 기존 0에서 10px 위로 이동 */
        }


        button:hover {
            background-color: #0056b3;
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
            background-image: url('/V5/resources/images/image10.png');
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
		    width: 80%;
		    height: 20%;
		    display: flex;
		    gap: 20px;
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
            background-image: url('/V5/resources/images/image\ 49.png');
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
            background-image: url('/V5/resources/images/image\ 50.png');
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
            background-image: url('/V5/resources/images/image\ 51.png');
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            border-radius: 24px;
        }

        .content-footer .footer-3 div.share-icn {
            width: 30px;
            height: 30px;
            margin-top: 10px;
            background-image: url('/V5/resources/images/share.png');
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
            width: 80%;
            height: 30%;
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
            width: 100%;
            height: 100%;
        }

        .pop-wrap {
            display: flex;
            flex-wrap: wrap;
            width: 80%;
            height: 20%;
            gap: 10px;
            align-items: center;
            margin-left: 10%;
            margin-bottom: 10px;
        }

        .pop-wrap a {
            text-decoration: none;
            border: 1px solid #D9D9D9;
            background-color: #D9D9D9;
            border-radius: 12px;
            padding: 4px;
            font-size: 13px;
            color: #161938;

        }

        .pop-right-box {
            width: 95%;
            height: 70%;
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

        .pop-right-content {
            margin: 2px;
            padding-right: 3px;

        }

        .pop-right-content p {
            padding: 3px;
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
            font-size: 25px;
        }

        .pop-right-img p {
            position: absolute;
            top: 15%;
            left: 40%;
            transform: translate(-40%, -40%);
            color: white;
            font-size: 22px;

            margin: 0;
            z-index: 2;
        }

        .pop-right-img p + p {
            top: 35%;
        }
        
        .post-title {
		    font-weight: bold;
		}
		
		.content-main p:first-child {
		    margin-bottom: 10px; /* 제목과 내용 사이의 간격 */
		}
		
		.pop-title p {
		    font-weight: bold; /* 글씨를 두껍게 */
		    font-size: 18px; /* 글씨 크기 키우기 */
		    width: 100%;
		    height: 100%;
		}
		
		
        
    </style>
</head>
<body>

<div class="wrap">

    <div class="left-area">
        <div class="top-image-area">
            <div class="image-container"></div>
            <div class="text-container">
                <h3>소중한 내 차를 위한</h3>
                <h3>정보 교환의 광장</h3>
            </div>
            <button onclick="location.href='/V5/community/post.do'">공유하기</button>
        </div>

        <c:forEach var="post" items="${posts}">
            <div class="bord-content-area">
                <div class="content-top">
                    <div class="icon"></div>
                    <p class="user_id">${post.carId}</p>
                    <p class="date">
                        <fmt:formatDate value="${post.regDate}" pattern="yyyy-MM-dd HH:mm" />
                    </p>
                </div>

               <div class="content-main">
				    <p><strong>${post.title}</strong></p>
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
                        <a href="#">
                            <div class="like-icn"></div>
                        </a>
                        <p>${post.comments.size()}</p>
                        <div class="share-icn"></div>
                    </div>

                    <div class="footer-4">
                        <a href="#" onclick="deletePost(${post.postIndex})"><p>삭제</p></a>
                        <p>|</p>
                        <a href="#" onclick="editPost(${post.postIndex})"><p>수정</p></a>
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
			        <button type="submit" id="srh-icn1" style="background-image: url(/V5/resources/images/searchicon.png);"></button>
			    </form>
			</div>

           <div class="keyword-area">
			    <div class="pop-title">
			        <p>🏅 인기 키워드</p>
			    </div>
			    <div class="pop-wrap">
			        <c:forEach var="keyword" items="${popularKeywords}" varStatus="status">
			            <a href="searchPostList.do?keyword=${keyword}" class="keyword-link">${keyword}</a>
			        </c:forEach>
			    </div>
			</div>

            <div class="pop-right-box">
                <div class="pop-right-title">
                    <span>#3 </span>
                    <h3>👍 추천글</h3>
                </div>
                <c:forEach var="post" items="${recommendedPosts}" varStatus="status">
                    <div class="pop-right-content">
                        <strong><span>${status.index + 1} </span></strong>
                        <p>${post.title}</p>
                    </div>
                </c:forEach>
            </div>
            <div class="pop-right-img">
                <img src="${pageContext.request.contextPath}/resources/images/image01.png" alt="">
                <p>운전자의 소통 공간</p>
                <p>소중한 내 차를 위한 정보 교환의 광장</p>
            </div>

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
                const id = 'likeCount-' + resData.postIndex;
                document.getElementById(id).innerText = resData.likeCount;
            },
            error: function (error) {
                console.log("게시글 좋아요 중 에러 발생:", error);
                $(location).attr('href', '/V5/Auth/Login.do');
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
                const id = 'unlikeCount-' + resData.postIndex;
                document.getElementById(id).innerText = resData.unlikeCount;
            },
            error: function (error) {
                console.log("게시글 싫어요 중 에러 발생:", error);
                $(location).attr('href', '/V5/Auth/Login.do');
            }
        });
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
                    window.location.href = "/V5/community/getPostList.do";
                },
                error: function (xhr, status, error) {
                    if (xhr.status === 401) {
                        alert("로그인이 필요합니다. 로그인 페이지로 이동합니다.");
                        window.location.href = "/V5/Auth/Login.do";
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
