<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <script src="${pageContext.request.contextPath}/resources/js/chatbot.js"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/chatbot.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css?ver=1.0"> 

</head>
<body>

<div class="footer-company-info">
  <h1>CAR PLANET</h1>
  <p>주소: 충청남도 천안시 동남구<br>이메일: car@PLANET.com</p>
  <p>대표전화: 02-1234-5678 <br> 책임자: 진영신</p>
  
  <!-- 이용약관 및 공지사항 -->
  <p>
    <a href="#" class="terms">이용약관</a> 
    <a href="#" class="notice">공지사항</a>
  </p>

  <!-- 개인정보 처리방침 및 저작권 정책 -->
  <p>
    <a href="#" class="privacy">개인정보<br> 처리방침</a> 
    <a href="#" class="copyright">저작권<br> 정책</a>
  </p>

<!-- 마이페이지와 커뮤니티 -->
<div class="icon-links-row">
  <div class="icon-item">
    <a href="${pageContext.request.contextPath}/mypage">
      <img src="${pageContext.request.contextPath}/resources/images/MyPage.png" alt="마이페이지" class="icon">
      <span>마이페이지</span>
    </a>
  </div>
  <div class="icon-item1">
    <a href="${pageContext.request.contextPath}/community/getPostList.do">
      <img src="${pageContext.request.contextPath}/resources/images/Community2.png" alt="커뮤니티" class="icon">
      <span>커뮤니티</span>
    </a>
  </div>
</div>

<!-- 카카오톡 및 챗봇 -->
<div class="icon-links-row">
  <div class="icon-item">
    <a href="javascript:void(0);" onclick="openChatBotModal()">
      <img src="${pageContext.request.contextPath}/resources/images/talk.png" alt="카카오톡 문의하기" class="icon">
      <span>카카오톡<br>문의하기</span>
    </a>
  </div>
  <div class="icon-item">
    <a href="javascript:void(0);" onclick="openModal()">
      <img src="${pageContext.request.contextPath}/resources/images/free-icon.png" alt="챗봇 문의하기" class="icon">
      <span>챗봇<br>문의하기</span>
    </a>
  </div>
</div>


<!-- 카카오톡 팝업 모달 -->
<div id="kakaoModal" class="kakao-modal">
  <div class="kakao-modal-content">
    <!-- X 닫기 버튼 -->
<span class="kakao-close" onclick="closeChatBotModal()">&#x2715;</span>
    <iframe 
      src="http://pf.kakao.com/_CxgFxdn/chat" 
      frameborder="0" 
      style="width: 100%; height: 300px;"></iframe>
  </div>
</div>


  <!-- 챗봇 문의하기 모달 -->
  <div id="myModal" class="modal">
    <div class="modal-content">
        <!-- 헤더 내 X 버튼 -->
        <div class="chat-header">
            <span class="close" onclick="closeModal()">&times;</span> <!-- X 버튼 -->
            CAR PLANET 챗봇
        </div>

        <!-- 챗봇 인터페이스 -->
        <div class="chat-container">
            <div class="chat-content" id="chatContent">
                <!-- 초기 안내 메시지 -->
                <div class="message question">
                    안녕하세요.😊 <br>
                    CAR PLANET 입니다.<br> 어떤 내용이 궁금하신가요?<br>
                    궁금하신 내용을 메시지 입력란에<br> 직접 입력해 주시거나 <br>문의자 유형을 선택해 주세요.
                </div>
            </div>

            <!-- 메인 FAQ 버튼 메시지 형태로 추가 -->
            <div class="message buttons" id="mainButtons">
                <button onclick="showSubButtons('electric')">전기차 충전소</button>
                <button onclick="showSubButtons('station')">주유소</button>
                <button onclick="showSubButtons('parking')">주차장</button>
                <button onclick="showSubButtons('community')">커뮤니티</button>
                <button onclick="showSubButtons('commu')">우리동네 주유소</button>
            </div>

            <!-- 사용자 입력 영역 -->
               <div class="chat-input">
            <input type="text" id="userInput" placeholder="메세지 입력" onkeydown="handleKeyPress(event)"/>
            <button onclick="sendMessage()">➤</button>
        </div>
        </div>
    </div>
  </div> <!-- 모달 닫기 -->

</div> <!-- .footer-company-info 닫힘 -->

<!-- 스크롤 시 footer 고정 스크립트  -->
<script>
/* 푸터 고정 스크립트 수정 */
window.addEventListener('scroll', function () {
  const footer = document.querySelector('.footer-company-info');
  const documentHeight = document.documentElement.scrollHeight;
  const viewportHeight = window.innerHeight;
  const scrollPosition = window.scrollY;

  if (scrollPosition + viewportHeight >= documentHeight) {
    footer.style.position = 'fixed';  // 고정된 위치 유지
    footer.style.bottom = '0';
  } else {
    footer.style.position = 'fixed';  // 항상 고정되도록 설정
    footer.style.bottom = '0';
  }
});



</script>

<script>
//카카오톡 모달 열기
function openChatBotModal() {
  document.getElementById("kakaoModal").style.display = "block"; // ID 수정
}

// 카카오톡 모달 닫기
function closeChatBotModal() {
  document.getElementById("kakaoModal").style.display = "none"; // ID 수정
}

// ESC 키로 모달 닫기
window.addEventListener("keydown", function (event) {
  if (event.key === "Escape") {
    closeChatBotModal();
  }
});

</script>

</body>
</html>
