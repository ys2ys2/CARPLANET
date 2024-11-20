<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
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
            font-style: italic;
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

        .wrap form {
            display: flex;
            flex-direction: column;
            width: 60%;
            height: 90%;
            gap: 25px;
            border: 1px solid gainsboro;
            justify-content: center;
            align-items: center;
        }

        #form-title {
            width: 80%;
            height: 7%;
            border: 1px solid gainsboro;
            border-radius: 10px;
        }

        #form-content {
            width: 80%;
            height: 45%;
            border: 1px solid gainsboro;
            border-radius: 10px;
        }

        .content-img {
            width: 50%;
            height: 20%;
            border: 1px solid gainsboro;
            border-radius: 12px;
            overflow: hidden;
            display: flex;
            align-self: flex-start;
            margin-left: 10%;
        }

        .form-file-area {
            width: 30%;
            height: 100%;
            background-color: #161938;
            border: 1px solid #161938;
            border-top-left-radius: 12px;
            border-bottom-left-radius: 12px;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        #form-file-area {
            display: none;
        }

        .form-file-bimage {
            width: 70%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .content-btn-area {
            width: 80%;
            height: 5%;
            display: flex;
            justify-content: flex-end;
            gap: 20px;
        }

        #content-btn1 {
            background-color: #161938;
            border: 1px solid #161938;
            color: white;
            font-weight: 700;
            width: 90px;
            height: 40px;
            border-radius: 8px;
        }

        #content-btn2 {
            background-color: #161938;
            border: 1px solid #161938;
            color: white;
            font-weight: 700;
            width: 90px;
            height: 40px;
            border-radius: 8px;
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
            height: 5%;
            display: flex;
            position: relative;
            margin-top: 20px;
        }

        .srh-area-1 input {
            width: 100%;
            height: 90%;
            border: 1px solid ghostwhite;
            background-color: #D9D9D9;
            border-radius: 10px;
        }

        #srh-icn1 {
            width: 10%;
            height: 50%;
            background-position: center;
            background-repeat: no-repeat;
            background-size: contain;
            position: absolute;
            right: 14px;
            display: inline-block;
            margin-top: 7px;
        }

        .keyword-area {
            width: 80%;
            height: 100%;
            display: flex;
            flex-direction: column;
            margin-top: 10px;
        }

        .pop-title {
            width: 50%;
            height: 10%;
            margin-left: 10%;
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
            font-size: 13px;
            color: white;
            display: flex;
            align-items: center;
            font-weight: 700;
        }

        .pop-right-content {
            font-size: 11px;
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
            height: 200px;
            padding: 20px 0 20px 0;
        }

        .pop-right-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: 1;
        }

        .pop-right-img p:nth-child(2) {
            font-size: 12px;
        }

        .pop-right-img p {
            position: absolute;
            top: 15%;
            left: 40%;
            transform: translate(-40%, -40%);
            color: white;
            font-size: 11px;
            margin: 0;
            z-index: 2;
        }

        .pop-right-img p + p {
            top: 35%;
        }
    </style>
</head>
<body>

    <!-- 전체 내용 감싸는 div -->
    <div class="wrap">

        <!-- 폼 시작: 게시물 제목과 내용, 파일 첨부 등 입력받는 부분 -->
        <form action="<%= request.getContextPath() %>/submitForm" method="post" enctype="multipart/form-data">
            <!-- 제목 입력 필드 -->
            <input id="form-title" name="form-title" type="text" placeholder="제목을 입력해주세요">
            <!-- 내용 입력 필드 -->
            <input id="form-content" name="form-content" type="text" placeholder="어떤 정보를 공유하고 싶으신가요?">
            
            <!-- 파일 첨부 영역 -->
            <div class="content-img">
                <label class="form-file-area" for="form-file-area">파일 첨부</label>
                <input type="file" id="form-file-area" name="file">
                
               <!-- 첨부된 이미지 미리보기 영역 (서버에서 전달된 이미지 경로 사용) -->
				<div class="form-file-bimage">
				    <img src="${pageContext.request.contextPath}/resources/images/${imageSrc != null ? imageSrc : 'image90.png'}" class="log-logo2" style="width: 100%; position: absolute;" alt="">
				</div>

            
            <!-- 버튼 영역 -->
            <div class="content-btn-area">
                <!-- 돌아가기 버튼 (이전 페이지로 돌아감) -->
                <button id="content-btn1" type="button" onclick="window.history.back();">돌아가기</button>
                <!-- 공유하기 버튼 (폼 제출) -->
                <button id="content-btn2" type="submit">공유하기</button>
            </div>
        </form>

        <!-- 사이드바 영역 -->
        <div class="side-right-wrap">
            <div class="side-right">
                <!-- 검색 영역 -->
                <div class="srh-area-1">
                    <form action="<%= request.getContextPath() %>/search" method="get">
                        <input type="search" placeholder="검색" name="searchQuery">
                        <div style="background-image: url(images/searchIcon.png);" id="srh-icn1"></div>
                    </form>
                </div>
                
                <!-- 인기 키워드 영역 -->
                <div class="keyword-area">
                    <div class="pop-title">
                        <p>인기 키워드</p>
                    </div>
                    <div class="pop-wrap">
                        <!-- 인기 키워드 목록 -->
                        <a href="#">주유소</a>
                        <a href="#">전기 자동차</a>
                        <a href="#">주유 포인트 적립</a>
                        <a href="#">충전소</a>
                        <a href="#">LPG 충전소</a>
                        <a href="#">셀프 주유소</a>
                        <a href="#">주유소 카페</a>
                        <a href="#">이벤트</a>
                    </div>

                    <!-- 추천글 영역 -->
                    <div class="pop-right-box">
                        <div class="pop-right-title">
                            <span>#3</span>
                            <h3>추천글</h3>
                        </div>
                        <div class="pop-right-content">
                            <span>1 </span>
                            <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                        </div>
                        <div class="pop-right-content">
                            <span>2</span>
                            <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                        </div>
                        <div class="pop-right-content">
                            <span>3</span>
                            <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                        </div>
                        <div class="pop-right-content">
                            <span>4</span>
                            <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                        </div>
                        <div class="pop-right-content">
                            <span>5</span>
                            <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                        </div>
                        <div class="pop-right-content">
                            <span>6</span>
                            <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                        </div>
                        <div class="pop-right-content">
                            <span>7</span>
                            <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                        </div>
                    </div>
                    
                    <!-- 광고 또는 이미지 영역 -->
                    <div class="pop-right-img">
                        <img src="images/image01.png" alt="">
                        <p>운전자의 소통 공간</p>
                        <p>소중한 내 차를 위한 정보 교환의 광장</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
