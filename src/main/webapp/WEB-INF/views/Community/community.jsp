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
            border: 1px solid gainsboro;
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
            padding: 10px;
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
            width: 100%;
            display: flex;
            position: relative;
            margin-top: 20px;
        }

        .srh-area-1 input {
            width: 100%;
            padding: 10px;
            border: 1px solid #D9D9D9;
            background-color: #D9D9D9;
            border-radius: 10px;
        }

        #srh-icn1 {
            width: 20px;
            height: 20px;
            background-position: center;
            background-repeat: no-repeat;
            background-size: contain;
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
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
            margin-top: 20px;
            border-radius: 10px;
            padding: 10px;
        }

        .pop-right-title {
            display: flex;
            background-color: #161938;
            color: white;
            padding: 5px;
            border-radius: 5px;
            font-weight: bold;
            align-items: center;
            gap: 5px;
        }

        .pop-right-content {
            font-size: 12px;
            display: flex;
            gap: 5px;
            margin-top: 5px;
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
    </style>
</head>
<body>

    <div class="wrap">

        <!-- 폼 시작: 게시물 제목과 내용, 파일 첨부 등 입력받는 부분 -->
        <form action="<%= request.getContextPath() %>/submitForm" method="post" enctype="multipart/form-data">
            <input id="form-title" name="form-title" type="text" placeholder="제목을 입력해주세요">
            <input id="form-content" name="form-content" type="text" placeholder="어떤 정보를 공유하고 싶으신가요?">
            
            <!-- 파일 첨부 영역 -->
            <div class="content-img">
                <label class="form-file-area" for="form-file-area">파일 첨부</label>
                <input type="file" id="form-file-area" name="file">
                
                <div class="form-file-bimage">
                    <img src="${pageContext.request.contextPath}/resources/images/${imageSrc != null ? imageSrc : 'image90.png'}" alt="미리보기 이미지">
                </div>
            </div>

            <div class="content-btn-area">
                <button id="content-btn1" type="button" onclick="window.history.back();">돌아가기</button>
                <button id="content-btn2" type="submit">공유하기</button>
            </div>
        </form>

        <!-- 사이드바 영역 -->
        <div class="side-right-wrap">
            <div class="side-right">
                <div class="srh-area-1">
                    <form action="<%= request.getContextPath() %>/search" method="get">
                        <input type="search" placeholder="검색" name="searchQuery">
                        <div style="background-image: url(images/searchIcon.png);" id="srh-icn1"></div>
                    </form>
                </div>
                
                <div class="keyword-area">
                    <div class="pop-title">인기 키워드</div>
                    <div class="pop-wrap">
                        <a href="#">주유소</a>
                        <a href="#">전기 자동차</a>
                        <a href="#">주유 포인트 적립</a>
                        <a href="#">충전소</a>
                        <a href="#">LPG 충전소</a>
                        <a href="#">셀프 주유소</a>
                        <a href="#">주유소 카페</a>
                        <a href="#">이벤트</a>
                    </div>

                    <div class="pop-right-box">
                        <div class="pop-right-title">
                            <span>#3</span>
                            <h3>추천글</h3>
                        </div>
                        <div class="pop-right-content"><span>1</span>연료 품질이 우수하고 서비스가 뛰어난 곳</div>
                        <div class="pop-right-content"><span>2</span>연료 품질이 우수하고 서비스가 뛰어난 곳</div>
                        <div class="pop-right-content"><span>3</span>연료 품질이 우수하고 서비스가 뛰어난 곳</div>
                        <div class="pop-right-content"><span>4</span>주유소에서 제공하는 무료 서비스들</div>

                        <div class="pop-right-img">
                            <img src="${pageContext.request.contextPath}/resources/images/sample-image.jpg" alt="추천 이미지">
                            <p>추천글</p>
                            <p>더 많은 정보를 확인해보세요</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

</body>
</html>
                        
