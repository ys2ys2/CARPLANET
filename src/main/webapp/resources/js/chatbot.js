// 모달 열기
function openModal() {
    document.getElementById("myModal").style.display = "block";
}

// 모달 닫기
function closeModal() {
    document.getElementById("myModal").style.display = "none";
}

// 사용자가 모달 외부를 클릭하면 닫기
window.onclick = function(event) {
    const modal = document.getElementById("myModal");
    if (event.target === modal) {
        closeModal();
    }
}

// FAQ 버튼을 통해 질문을 전송하는 함수
function sendFAQ(question) {
    // 사용자의 질문을 대화창에 추가
    addMessage(question, "answer");
    const answerText = getAnswer(question);
    setTimeout(() => addMessage(answerText, "question"), 500); // 챗봇 답변 추가
}

// 계정/로그인 하위 질문 버튼을 대화창에 메시지 형태로 표시하는 함수
function showSubButtons(category) {
    let messageText = "";

    if (category === 'account') {
        messageText = "계정/로그인 관련 질문을 선택해 주세요.";
        addMessage(messageText, "question");

        const buttons = [
            { text: "회원가입", action: "회원가입 하는 방법" },
            { text: "탈퇴", action: "탈퇴하는 방법" },
            { text: "로그인 유형", action: "로그인 유형" },
            { text: "아이디/비밀번호 찾기", action: "아이디/비밀번호 찾기" }
        ];
        addButtons(buttons);
    } else if (category === 'schedule') {
        messageText = "여행일정 관련 질문을 선택해 주세요.";
        addMessage(messageText, "question");

        const buttons = [
            { text: "일정 추가 방법", action: "일정 추가 방법" },
            { text: "일정 삭제 방법", action: "일정 삭제 방법" },
            { text: "일정 공유 방법", action: "일정 공유 방법" }
        ];
        addButtons(buttons);
    } else if (category === 'community') {
        messageText = "커뮤니티 관련 질문을 선택해 주세요.";
        addMessage(messageText, "question");

        const buttons = [
            { text: "커뮤니티 이용 방법", action: "커뮤니티 이용 방법" },
            { text: "커뮤니티 매너", action: "커뮤니티 매너" }
        ];
        addButtons(buttons);
    }
}

// 버튼 목록을 메세지 형태로 추가하는 함수
function addButtons(buttons) {
    const chatContent = document.getElementById("chatContent");

    // 버튼 컨테이너 생성
    const buttonContainer = document.createElement("div");
    buttonContainer.classList.add("message", "buttons");

    buttons.forEach(btn => {
        const button = document.createElement("button");
        button.innerText = btn.text;
        button.onclick = () => sendFAQ(btn.action); // 각 버튼 클릭 시 FAQ 전송
        buttonContainer.appendChild(button);
    });

    // 뒤로 가기 버튼 추가
    const backButton = document.createElement("button");
    backButton.innerText = "뒤로";
    backButton.onclick = goBackToMain;
    buttonContainer.appendChild(backButton);

    // 대화창에 버튼 메시지 추가
    chatContent.appendChild(buttonContainer);
    chatContent.scrollTop = chatContent.scrollHeight;
}

// 메인 FAQ 버튼으로 돌아가기
function goBackToMain() {
    addMessage("이전으로 돌아갑니다.", "question");

    const chatContent = document.getElementById("chatContent");

    // 버튼 컨테이너 생성
    const buttonContainer = document.createElement("div");
    buttonContainer.classList.add("message", "buttons");

    // 계정/로그인 버튼
    const accountButton = document.createElement("button");
    accountButton.innerText = "계정/로그인";
    accountButton.onclick = () => showSubButtons('account');
    buttonContainer.appendChild(accountButton);

    // 여행일정 버튼
    const scheduleButton = document.createElement("button");
    scheduleButton.innerText = "여행일정";
    scheduleButton.onclick = () => showSubButtons('schedule');
    buttonContainer.appendChild(scheduleButton);

    // 커뮤니티 버튼
    const communityButton = document.createElement("button");
    communityButton.innerText = "커뮤니티";
    communityButton.onclick = () => showSubButtons('community');
    buttonContainer.appendChild(communityButton);

    // 대화창에 버튼 메시지 추가
    chatContent.appendChild(buttonContainer);
    chatContent.scrollTop = chatContent.scrollHeight;
}

// 사용자가 입력한 메시지를 전송하는 함수
function sendMessage() {
    const userInput = document.getElementById("userInput");
    const messageText = userInput.value.trim();

    if (messageText) {
        addMessage(messageText, "answer");

        // FAQ 답변 추가
        setTimeout(() => {
            const answerText = getAnswer(messageText);
            addMessage(answerText, "question");
        }, 500); // 지연 효과로 자연스러움 추가

        userInput.value = ""; // 입력란 비우기
    }
}

// enter키를 눌렀을 때 메세지 전송 함수
function handleKeyPress(event) {
    if (event.key === "Enter") {
        sendMessage();
    }
}

// 메시지를 추가하는 함수
function addMessage(text, type) {
    const chatContent = document.getElementById("chatContent");
    const message = document.createElement("div");
    message.classList.add("message", type);
    message.innerText = text;
    chatContent.appendChild(message);

    // 새로운 메시지가 추가될 때 스크롤을 맨 아래로 이동
    chatContent.scrollTop = chatContent.scrollHeight;
}

// FAQ에 따른 고정된 답변 반환 함수
function getAnswer(question) {
    if (question.includes("회원가입")) {
        return "홈페이지 화면 좌측상단에 회원가입 버튼을 통해 가능하며, 약관 동의 및 정보입력 해주시면 가입이 완료됩니다.";
    } else if (question.includes("탈퇴")) {
        return "마이페이지 > 프로필 편집 > 회원탈퇴 버튼을 통해 탈퇴가 가능합니다.";
    } else if (question.includes("로그인 유형")) {
        return "이메일 간편가입, 카카오, 네이버, 구글을 통해 간편하게 로그인이 가능합니다.";
    } else if (question.includes("아이디/비밀번호 찾기")) {
        return "로그인 페이지에서 아이디/비밀번호 찾기 옵션을 사용해 주세요.";
    } else if (question.includes("일정 추가 방법")) {
        return "여행일정은 구글지도와 날짜 별로 쉽고 간편하게 여행 일정을 작성할 수 있습니다.";
    } else if (question.includes("일정 삭제 방법")) {
        return "여행 일정은 여행일정 페이지에서 삭제할 수 있습니다.";
    } else if (question.includes("일정 공유 방법")) {
        return "마이페이지에서 내 일정을 확인하고 공유해 보세요!🙂";
    } else if (question.includes("커뮤니티 이용 방법")) {
        return "커뮤니티에서 다양한 여행 지식과 정보를 얻을 수 있습니다. 😄";
    } else if (question.includes("커뮤니티 매너")) {
        return "커뮤니티를 이용할 때는 건강한 소통 문화를 지양하고 규칙을 준수함으로써 모두가 즐겁고 안전한 환경을 유지할 수 있도록 합니다.";
    } else {
        return "죄송합니다. 해당 질문에 대한 답변을 찾을 수 없습니다.";
    }
}
