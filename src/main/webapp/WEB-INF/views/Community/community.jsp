<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 목록</title>
    <link rel="stylesheet" href="<c:url value='/resources/css/community.css' />">
</head>
<body>
    <div class="container">
        <!-- 사이드바 -->
        <div class="sidebar">
            <h3>인기 키워드</h3>
            <ul>
                <c:forEach var="keyword" items="${popularKeywords}">
                    <li>${keyword}</li>
                </c:forEach>
            </ul>

            <h3>추천글</h3>
            <ul>
                <c:forEach var="recommendation" items="${recommendations}">
                    <li>${recommendation.rank}. ${recommendation.title}</li>
                </c:forEach>
            </ul>
        </div>

        <!-- 커뮤니티 목록 -->
        <div class="community-list">
            <h2>커뮤니티 목록</h2>
            <c:forEach var="post" items="${posts}">
                <div class="post-item">
                    <div class="post-header">
                        <h3>${post.title}</h3>
                        <span>작성자: ${post.memberId}</span>
                        <span>작성일: ${post.createdAt}</span>
                    </div>
                    <p>${post.content}</p>
                    <!-- 좋아요, 댓글, 공유 아이콘 -->
                    <div class="post-actions">
                        <span>좋아요: ${post.likesCount}</span>
                        <span>댓글: ${post.commentsCount}</span>
                        <span>공유</span>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>
