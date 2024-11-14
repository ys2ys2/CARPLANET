<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 목록</title>
</head>
<body>
    <h2>커뮤니티 목록</h2>

    <!-- 게시글 리스트 출력 -->
    <c:forEach var="community" items="${communityList}">
        <div class="post-item">
            <h3>${community.title}</h3>
            <p>${community.content}</p>
            <span>작성자: ${community.memberId}</span>
            <span>작성일: ${community.createdAt}</span>
            <span>좋아요: ${community.likesCount}</span>
            <span>댓글: ${community.commentsCount}</span>
        </div>
    </c:forEach>

    <!-- 검색 폼 -->
    <h3>검색</h3>
    <form action="/community/search" method="get">
        <input type="text" name="keyword" placeholder="제목으로 검색">
        <button type="submit">검색</button>
    </form>

    <!-- 업로드 버튼 -->
    <a href="/community/upload">새 게시글 업로드</a>
</body>
</html>
