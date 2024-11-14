<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f4f4f4;
        }

        .wrap {
            display: flex;
            width: 80%;
            max-width: 1200px;
            margin: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        form {
            flex: 2;
            padding: 20px;
            display: flex;
            flex-direction: column;
        }

        form input[type="text"], 
        form input[type="file"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        #form-content {
            height: 150px; /* 세로 길이를 넓힘 */
            resize: vertical; /* 사용자가 크기 조정 가능 */
        }

        .content-img {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }

        .content-img img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .content-btn-area {
            display: flex;
            justify-content: flex-end; /* 오른쪽 정렬 */
            gap: 10px;
        }

        .content-btn-area button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        #content-btn1 {
            background-color: #ccc;
            color: #333;
        }

        #content-btn2 {
            background-color: #133653;
            color: #fff;
        }

        .side-right {
            flex: 1;
            background-color: #f7f7f7;
            padding: 20px;
            border-left: 1px solid #ddd;
        }

        .srh-area {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .srh-area input[type="text"] {
            flex: 1;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .keyword-area {
            margin-bottom: 20px;
        }

        .pop-title {
            display: flex;
            align-items: center;
            gap: 5px;
            margin-bottom: 10px;
        }

        .pop-wrap a {
            display: inline-block;
            margin: 5px 0;
            padding: 5px 10px;
            background-color: #eee;
            color: #333;
            text-decoration: none;
            border-radius: 5px;
        }

        .pop-right-box {
            margin-top: 20px;
        }

        .pop-right-title {
            display: flex;
            align-items: center;
            gap: 5px;
            margin-bottom: 10px;
        }

        .pop-right-content {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fff;
            margin-bottom: 10px;
        }

        .pop-right-img {
            text-align: center;
            margin-top: 20px;
        }

        .pop-right-img img {
            width: 100%;
            height: auto;
            border-radius: 5px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

    <div class="wrap">

        <form action="#">
            <input id="form-title" name="form-title" type="text" placeholder="제목을 입력하세요">
            <input id="form-content" name="form-content" type="text" placeholder="어떤 정보를 공유하고 싶으신가요?">
            <div class="content-img">
                <input type="file">
                <img src="#" alt="이미지 미리보기">
            </div>
            <div class="content-btn-area">
                <button id="content-btn1">돌아가기</button>
                <button id="content-btn2">공유하기</button>
            </div>
        </form>

        <div class="side-right">
            <div class="srh-area">
                <input type="text" placeholder="검색어를 입력하세요">
                <span>#1</span>
            </div>
            <div class="keyword-area">
                <div class="pop-title">
                    <span>#2</span>
                    <p>인기 키워드</p>
                </div>
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
                    <div class="pop-right-content">
                        <span>1</span>
                        <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                    </div>
                    <div class="pop-right-content">
                        <span>1</span>
                        <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                    </div>
                    <div class="pop-right-content">
                        <span>1</span>
                        <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                    </div>
                    <div class="pop-right-content">
                        <span>1</span>
                        <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                    </div>
                    <div class="pop-right-content">
                        <span>1</span>
                        <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                    </div>
                    <div class="pop-right-content">
                        <span>1</span>
                        <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                    </div>
                    <div class="pop-right-content">
                        <span>1</span>
                        <p>연료 품질이 우수하고 서비스가 뛰어난 곳</p>
                    </div>
                </div>
                <div class="pop-right-img">
                    <img src="#" alt="운전자의 소통 공간">
                    <p>운전자의 소통 공간</p>
                    <p>소중한 내 차를 위한 정보 교환의 광장</p>
                </div>
            </div>
        </div>

    </div>
    
</body>
</html>
