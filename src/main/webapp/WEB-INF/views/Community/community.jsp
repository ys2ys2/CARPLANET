<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            margin: 5;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            width: 100vw;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: Arial, sans-serif;
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

        .wrap {
            border: 1px solid gainsboro;
            width: 90%;
            max-width: 1200px;
            margin: 30px auto;
            display: flex;
            gap: 20px;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
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
            background-color: #161938;
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
            background-color: #161938;
            border: none;
            color: white;
            font-weight: 700;
            width: 90px;
            height: 40px;
            border-radius: 8px;
            cursor: pointer;
        }

        .side-right-wrap {
            width: 30%;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .side-right {
            width: 100%;
            border: 1px solid gainsboro;
            padding: 20px;
            border-radius: 10px;
        }

       .srh-area-1 {
		    width: 100%; /* 부모 요소 가로 길이 */
		    display: flex;
		    margin-top: 20px;
		}
		
		.srh-area-1 input {
		    width: 100%; /* 검색창을 부모의 가로 길이로 확장 */
		    height: 50px; /* 높이를 키워 더 명확히 보이도록 설정 */
		    padding: 10px 45px 10px 15px; /* 오른쪽에 돋보기 공간 확보 */
		    border: 1px solid #D9D9D9;
		    background-color: #D9D9D9;
		    border-radius: 10px;
		    font-size: 16px;
		    box-sizing: border-box; /* 패딩 포함 크기 계산 */
		}

		
		#srh-icn1 {
		    position: absolute; /* 검색창 내부 위치 고정 */
		    right: 15px; /* 검색창 내부 오른쪽에 배치 */
		    top: 50%; /* 수직 중앙 배치 */
		    transform: translateY(-50%);
		    width: 20px; /* 돋보기 아이콘 크기 */
		    height: 20px;
		    background-position: center;
		    background-repeat: no-repeat;
		    background-size: contain;
		    pointer-events: none; /* 클릭되지 않도록 설정 */
		}



        .keyword-area {
            margin-top: 20px;
        }

        .pop-title {
            font-weight: bold;
            margin-bottom: 10px;
        }

        .pop-wrap {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .pop-wrap a {
            text-decoration: none;
            border: 1px solid #D9D9D9;
            background-color: #D9D9D9;
            border-radius: 12px;
            padding: 5px 10px;
            font-size: 13px;
            color: #161938;
        }

        .pop-right-box {
		    width: 100%;
		    border: 1px solid #D9D9D9;
		    margin-top: 10px; /* 상단 여백 감소 */
		    border-radius: 10px;
		    padding: 5px; /* 내부 여백 감소 */
		    background-color: #f8f9fa; /* 배경색 추가 */
		}
		
		.pop-right-title {
		    display: flex;
		    align-items: center;
		    background-color: #161938;
		    color: white;
		    padding: 1px 10px; /* 세로 패딩 줄임 */
		    border-radius: 5px;
		    font-weight: bold;
		    font-size: 16px;
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
		    color: #161938; /* 순위 글씨 색상 */
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
        
        /* 태블릿 화면 (1024px 이하) */
		@media (max-width: 1024px) {
		    .srh-area-1 input {
		    width: 120%; /* 너비를 20% 더 확장 */
		    height: 50px; /* 높이는 그대로 유지 */
		    padding: 10px 45px 10px 15px; /* 오른쪽에 돋보기 공간 확보 */
		    border: 1px solid #D9D9D9;
		    background-color: #D9D9D9;
		    border-radius: 10px;
		    font-size: 16px;
		    box-sizing: border-box; /* 패딩 포함 크기 계산 */
		}

		
		    #srh-icn1 {
		        width: 18px; /* 돋보기 아이콘 크기 축소 */
		        height: 18px;
		        right: 10px; /* 아이콘 간격 축소 */
		    }
		}
		
		/* 모바일 화면 (768px 이하) */
		@media (max-width: 768px) {
		    .srh-area-1 input {
		        width: 100%; /* 너비는 최대한 화면에 맞춤 */
		        height: 40px; /* 높이 줄임 */
		        font-size: 13px; /* 글자 크기 더 축소 */
		    }
		
		    #srh-icn1 {
		        width: 16px; /* 돋보기 아이콘 크기 더 축소 */
		        height: 16px;
		    }
		}
		
		/* 초소형 화면 (480px 이하) */
		@media (max-width: 480px) {
		    .srh-area-1 input {
		        width: 100%;
		        height: 35px; /* 높이 더 줄임 */
		        font-size: 12px; /* 글자 크기 소형화 */
		    }
		
		    #srh-icn1 {
		        width: 14px; /* 아이콘 크기 최소화 */
		        height: 14px;
		    }
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
		    background-image: url(/V5/resources/images/searchicon.png); /* 돋보기 아이콘 경로 */
		    background-position: center;
		    background-repeat: no-repeat;
		    background-size: contain;
		    pointer-events: none; /* 클릭되지 않도록 설정 */
		}
		
		/* 반응형 디자인 */
		@media (max-width: 1024px) {
		    .srh-area-1 input {
		        width: 90%; /* 검색창 너비 줄임 */
		        height: 45px; /* 높이 축소 */
		        font-size: 14px;
		    }
		    #srh-icn1 {
		        width: 18px; /* 돋보기 크기 축소 */
		        height: 18px;
		        right: 10px; /* 오른쪽 간격 축소 */
		    }
		}

		@media (max-width: 768px) {
		    .srh-area-1 input {
		        width: 100%;
		        height: 40px; /* 높이 축소 */
		        font-size: 13px;
		    }
		    #srh-icn1 {
		        width: 16px; /* 돋보기 크기 더 축소 */
		        height: 16px;
		    }
		}
		
		@media (max-width: 480px) {
		    .srh-area-1 input {
		        width: 100%;
		        height: 35px; /* 높이 최소화 */
		        font-size: 12px; /* 글자 크기 소형화 */
		    }
		    #srh-icn1 {
		        width: 14px;
		        height: 14px;
		    }
		}
	
	/* 스마트폰 모드 (768px 이하일 때) */
	@media (max-width: 768px) {
	    .side-right-wrap { 
	        display: none; /* 오른쪽 섹션 전체 숨기기 */
	    }
	}
		
        
        
    </style>
</head>
<body>

<div class="wrap">
    <!-- 폼 시작: 게시물 제목과 내용, 파일 첨부 등 입력받는 부분 -->
    <form id="registerPost"
          action="<c:if test='${post != null}'>updatePost.do</c:if><c:if test='${post == null}'>registerPost.do</c:if>"
          method="post" enctype="multipart/form-data" accept-charset="UTF-8">
        <c:if test="${post != null}">
            <input type="hidden" name="postIndex" value="${post.postIndex}">
        </c:if>
        <input id="form-title" name="title" type="text" placeholder="제목을 입력해주세요"
               value="${post != null ? post.title : ''}">
        <textarea id="form-content" name="content" placeholder="어떤 정보를 공유하고 싶으신가요?">${post != null ? post.content : ''}</textarea>


        <!-- 파일 첨부 영역 -->
        <div class="content-img">
            <label class="form-file-area" for="form-file-area">파일 첨부</label>
            <input type="file" id="form-file-area" name="file" accept="image/*" onchange="setThumbnail(event);">

            <div class="form-file-bimage">
                <img id="preview" alt="미리보기 이미지"
                     src="<c:if test='${post != null && post.filePath != null && post.fileName != null}'>/V5${post.filePath}${post.fileName}</c:if><c:if test='${post == null || post.filePath == null}'>${pageContext.request.contextPath}/resources/images/image90.png</c:if>">
            </div>
        </div>

        <div class="content-btn-area">
            <button id="content-btn1" type="button" onclick="window.location.href='/V5/community/getPostList.do';">돌아가기</button>
            <button id="content-btn2" type="submit">공유하기</button>
        </div>
    </form>

    <!-- 사이드바 영역 -->
    <div class="side-right-wrap">
        <div class="side-right">
            <div class="srh-area-1">
			    <form action="<%= request.getContextPath() %>/search" method="get" style="position: relative;width:100%">
			        <!-- 검색창 -->
			        <input type="search" name="searchQuery" placeholder="검색" required>
			        <!-- 돋보기 아이콘 -->
			        <span id="srh-icn1"></span>
			    </form>
			</div>




            <div class="keyword-area">
                <div class="pop-title">
                    <p>🏅 인기 키워드</p>
                </div>
                <div class="pop-wrap">
                    <c:forEach var="keyword" items="${popularKeywords}" varStatus="status">
                        <a href="#">${keyword}</a>
                    </c:forEach>
                </div>

                <div class="pop-right-box">
				    <div class="pop-right-title">
				        <h3>👍 추천글</h3>
				    </div>
				    <c:forEach var="post" items="${recommendedPosts}" varStatus="status">
				        <div class="pop-right-content">
				            <span class="rank">${status.index + 1}</span>
				            <p class="title">${post.title}</p>
				        </div>
				    </c:forEach>
				</div>

                <%-- <div class="pop-right-img">
                    <img src="${pageContext.request.contextPath}/resources/images/image01.png" alt="">
                    <p>운전자의 소통 공간</p>
                    <p>소중한 내 차를 위한 정보 교환의 광장</p>
                </div> --%>
            </div>
        </div>
    </div>
</div>


<script>
    function setThumbnail(event) {
        var reader = new FileReader();

        reader.onload = function (event) {
            var img = document.getElementById("preview");
            img.setAttribute("src", event.target.result);
        };
        reader.readAsDataURL(event.target.files[0]);
    }
</script>
</body>
</html>
                        
