<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<title>관리자</title>


<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: Arial, sans-serif;
}

.main-container {
	position: relative;
	top: 100px;
	left: 200px;
	display: flex;
	width: 80%;
	height: 80vh;
	border: 1px solid black;
	border-radius: 25px;
}

.sidebar {
	width: 20%;
	background-color: #333;
	color: #fff;
	display: flex;
	flex-direction: column;
	border-radius: 25px 0 0 25px;
}

.sidebar ul {
	list-style: none;
	padding: 0;
}

.sidebar ul li {
	padding: 15px;
	text-align: center;
}

.sidebar ul li a {
	color: #fff;
	text-decoration: none;
	display: block;
}

.sidebar ul li a:hover {
	background-color: #575757;
}

.content {
	flex: 1;
	padding: 20px;
	overflow-y: auto;
}

.section {
	margin-bottom: 30px;
}

#summary {
	display: flex;
	height: 100%;
	flex-wrap: wrap; /* 줄바꿈을 허용하여 2x2 배치를 만듭니다 */
	justify-content: space-between;
	gap: 20px;
	padding: 10px;
	overflow: hidden;
}

.summary-box {
	width: calc(50% - 10px);
	height: 265px;
	background-color: #f0f0f0; /* 박스 배경색 */
	display: flex;
	align-items: center; /* 수직 가운데 정렬 */
	justify-content: center; /* 수평 가운데 정렬 */
	border: 1px solid #ccc;
	border-radius: 10px;
	font-size: 16px;
	color: #333;
}

.summary-content {
    text-align: center;
}

.summary-content h3 {
    margin-bottom: 10px;
    font-size: 20px;
    color: #555;
}

.summary-content .count {
    font-size: 48px; /* 큰 숫자 */
    font-weight: bold;
    color: #333;
}

</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/MainPage/header.jsp" />

	<div class="main-container">
		<div class="sidebar">
			<ul>
				<li><a href="#dashboard" class="menu-link"
					data-target="dashboard">대시보드</a></li>
				<li><a href="#user-management" class="menu-link"
					data-target="user-management">회원 관리</a></li>
				<li><a href="#post-management" class="menu-link"
					data-target="post-management">게시글 관리</a></li>
			</ul>
		</div>
		<div class="content">
			<div id="dashboard" class="section active">
				<h1>대시보드</h1>
				<hr style="margin: 10px 0 10px 0">
				<div id="summary">
					<div class="summary-box">
						<canvas id="visitorChart" width="400" height="400"></canvas>
					</div>
					<div class="summary-box">
						<div class="summary-content">
							<h3>공지사항 입력</h3>
						</div>
					</div>
					<div class="summary-box">
						<div class="summary-content">
							<h3>총 게시물 수</h3>
							<p id="postCountDisplay" class="count">0</p>
						</div>
					</div>
					<div class="summary-box">
						<div class="summary-content">
							<h3>총 회원 수</h3>
							<p id="userCountDisplay" class="count">0</p>
						</div>
					</div>
				</div>
			</div>
			<div id="user-management" class="section">
				<h1>회원 관리</h1>
				<div id="user-table">
					<!-- AJAX로 불러온 회원 목록 -->
				</div>
			</div>
			<div id="post-management" class="section">
				<h1>게시글 관리</h1>
				<div id="post-table">
					<!-- 게시글 정보 -->
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
	<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />


	<script>
		$(document).ready(function() {
			const ctx = document.getElementById('visitorChart').getContext('2d');
	        const visitorChart = new Chart(ctx, {
	            type: 'bar',
	            data: {
	                labels: [], // 날짜
	                datasets: [{
	                    label: '방문자 수',
	                    data: [], // 방문자 수
	                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
	                    borderColor: 'rgba(54, 162, 235, 1)',
	                    borderWidth: 1
	                }]
	            },
	            options: {
	                scales: {
	                    y: {
	                        beginAtZero: true
	                    }
	                }
	            }
	        });
            
	        $.ajax({
	            url: '/CarPlanet/Admin/visitor-stats',
	            type: 'GET',
	            dataType: 'json',
	            success: function(response) {
	                // 응답 데이터에서 상위 5개만 추출
	                const filteredData = response.slice(0, 5); // 최근 5일 데이터

	                // 날짜에 +1일 추가
	                const labels = filteredData.map(item => {
	                    const date = new Date(item.date); // 날짜 문자열을 Date 객체로 변환
	                    date.setDate(date.getDate() + 1); // 하루를 추가
	                    return (date.getMonth() + 1) + "-" + date.getDate(); // MM-DD 형식으로 반환
	                });

	                const data = filteredData.map(item => item.count);
	                updateChart(visitorChart, labels, data);
	            },
	            error: function(error) {
	                console.error('날짜별 방문자 데이터 로드 실패:', error);
	            }
	        });

	        function updateChart(chart, labels, data) {
	            chart.data.labels = labels.reverse(); // 날짜 순서 뒤집기 (최근 날짜부터 표시)
	            chart.data.datasets[0].data = data.reverse(); // 방문자 데이터도 뒤집기
	            chart.update();
	        }

            
            $.ajax({
                url: '/CarPlanet/Admin/track-visitor', // 방문자 추적 API 엔드포인트
                type: 'POST', // HTTP 메서드
                contentType: 'application/json', // 데이터 형식
                data: JSON.stringify({
                    url: window.location.href, // 현재 페이지 URL
                    userAgent: navigator.userAgent // 브라우저 정보
                }),
                success: function(response) {
                    console.log('방문자 데이터 전송 성공:');
                },
                error: function(error) {
                    console.error('방문자 데이터 전송 실패:', error);
                }
            });
            
            function updateChart(chart, labels, data) {
                chart.data.labels = labels.reverse(); // 날짜 순서 뒤집기 (최근 날짜부터 표시)
                chart.data.datasets[0].data = data.reverse(); // 방문자 데이터도 뒤집기
                chart.update();
            }
            
			$.ajax({
				url:'/CarPlanet/Admin/userCount',
				type:'GET',
				dataType:'json',
				success:function(response){
					console.log("총 회원수 : "+response);
					$('#userCountDisplay').text(response);
				},
				error:function(e){
					console.error("회원수 조회중 오류",e)
				}
			});
			
			$.ajax({
				url:'/CarPlanet/Admin/countPost',
				type:'GET',
				dataType:'json',
				success:function(response){
					console.log("총 게시물 수 :"+response);
					$('#postCountDisplay').text(response);
				},
				error:function(e){
					console.error("게시물 수 조회중 오류")
				}
			});
            
            
			$.ajax({
				url : '/CarPlanet/Admin/alluser.do', // 서버에서 제공하는 엔드포인트
				type : 'GET', // GET 요청
				dataType : 'json', // 응답을 json 형식으로 받음
				success : function(response) {
					// 응답을 성공적으로 받았을 때 처리
					console.log(response); // 결과를 화면에 출력 (json 내용)
				},
				error : function(e) {
					console.error("오류발생", e);

				}
			});

			$('.menu-link').on('click', function(e) {
				e.preventDefault(); // 기본 앵커 동작 막기

				// 모든 섹션 숨기기
				$('.section').removeClass('active').hide();

				// 클릭한 메뉴의 data-target에 맞는 섹션 표시
				const target = $(this).data('target');
				$('#' + target).addClass('active').fadeIn(); // 활성화 섹션 표시
			});

			// 첫 화면 로딩 시 기본 섹션 표시
			$('.section').not('.active').hide(); // 'active'가 아닌 섹션 숨기기
		});
	</script>
</body>
</html>