<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    
    <link href="${pageContext.request.contextPath}/resources/css/upload.css" rel="stylesheet" type="text/css">

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
