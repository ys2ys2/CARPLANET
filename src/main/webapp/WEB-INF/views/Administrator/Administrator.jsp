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

/* 모달 배경 */
.noticemodal {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	display: flex;
	justify-content: center;
	align-items: center;
	z-index: 1000;
	display: none;
}

/* 모달 콘텐츠 */
.notice-content {
	display: flex;
	flex-direction: column;
	background: #fff;
	padding: 30px;
	border-radius: 10px;
	width: 80%;
	max-width: 600px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
}

/* 제목과 공지 종류 */
.noticemodal-Title {
	display: flex;
	width: 100%;
	margin: 10px 0 10px 0;
}

#carnTitle, #noticeType {
	height: 40px;
	padding: 5px 10px;
	border-radius: 10px;
	font-size: 16px;
	border: 1px solid #ccc;
}

#carnTitle {
	flex: 2; /* 제목을 더 넓게 */
	margin-right: 15px;
}

#noticeType {
	flex: 1; /* 공지 종류를 좁게 */
}

/* 공지사항 입력 텍스트 에어리어 */
#noticeDetails {
	width: 100%;
	height: 150px;
	margin: 5px 0;
	padding: 10px;
	font-size: 16px;
	border-radius: 10px;
	border: 1px solid #ccc;
	resize: none; /* 크기 조절 금지 */
}

/* 버튼 그룹 */
.noticemodal-actions {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}

.noticemodal-actions button {
	padding: 10px 20px;
	border: none;
	border-radius: 10px;
	font-size: 16px;
	cursor: pointer;
}

#submitNotice {
	background: #007bff;
	color: #fff;
	font-weight: bold;
}

#submitNotice:hover {
	background: #0056b3;
}

#cancelNotice {
	background: #f8f9fa;
	color: #000;
}

#cancelNotice:hover {
	background: #e0e0e0;
}

a.dynamic-link:visited {
	color: black !important;
}

#user-table table {
	width: 100%;
	border-collapse: collapse;
}

#user-table th, #user-table td {
	border: 1px solid #ccc;
	padding: 10px;
	text-align: center;
	height:28px;
}

#user-table td{
	font-size: 13px;
}

#user-table th {
	background-color: #f4f4f4;
	font-weight: bold;
}

#user-table td button {
	padding: 5px 10px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

#user-table td button.delete {
	background-color: #e74c3c;
	color: white;
}

#user-table td button.promote {
	background-color: #2ecc71;
	color: white;
}
.userinfoline{
	border-bottom:1px solid black;
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
							<p>
								현재 총 <span id="noticeCount">0</span>개의 공지사항이 등록되어 있습니다.
							</p>
							<button id="addNoticeBtn"
								style="padding: 10px 20px; font-size: 16px; margin-top: 10px; cursor: pointer;">공지사항
								추가</button>
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
				<div
					style="display: flex; align-items: center; justify-content: space-between;">
					<h1 style="margin-bottom:10px">회원 관리</h1>
					<div>
						<input type="text" id="search-input" placeholder="아이디 or 닉네임"
							style="padding: 5px; border: 1px solid #ccc; border-radius: 5px;">
						<button id="search-button"
							style="padding: 5px 10px; border: none; background-color: #007bff; color: white; border-radius: 5px; cursor: pointer;">검색</button>
							<button id="reset-button"
							style="padding: 5px 10px; border: none; background-color: #007bff; color: white; border-radius: 5px; cursor: pointer;">초기화</button>
					</div>
				</div>
				<p class="userinfoline">회원 등급 안내: <b>1</b> (일반 회원) | <b>-1</b> (탈퇴 요청 회원) | <b>3</b>
					(관리자)
				</p>

				<div id="user-table" style="margin-top:15px">
					<div id="user-table">
						<table>
							<thead>
								<tr>
									<th>회원번호</th>
									<th>회원Id</th>
									<th>닉네임</th>
									<th>회원등급</th>
									<th>요청</th>
								</tr>
							</thead>
							<tbody>

							</tbody>
						</table>
					</div>
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

	<div class="noticemodal">
		<div class="notice-content">
			<h2>공지사항 입력</h2>
			<form action="noticeinput.do" method="post">
				<div class="noticemodal-Title">
					<input id="carnTitle" name="carnTitle" type="text"
						placeholder="제목입력" required> <select id="noticeType"
						name="noticeType">
						<option disabled selected>공지 종류</option>
						<option value="nomalnotice">공지 사항</option>
						<option value="updatenotice">업데이트 사항</option>
					</select>
				</div>
				<textarea id="noticeDetails" name="noticeDetails"
					placeholder="공지사항 입력" required></textarea>
				<div class="noticemodal-actions">
					<button type="submit" id="submitNotice">저장</button>
					<button type="button" id="cancelNotice">취소</button>
				</div>
			</form>
		</div>
	</div>


	<jsp:include page="/WEB-INF/views/MainPage/footer_right.jsp" />
	<jsp:include page="/WEB-INF/views/MainPage/footer.jsp" />


	<script>
		$(document).ready(function() {
			const message="${message}";
			if(message){
				alert(message);
			}
			
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
	        //모달 열기
	        $('#addNoticeBtn').on('click',function(){
	        	$('.noticemodal').css('display','flex');        	
	        })
	        
	        // 모달 닫기
   			$('#cancelNotice').on('click', function () {
       			$('.noticemodal').css('display', 'none');
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
            
         // 이벤트 위임 설정
            $(document).on('click', '.dynamic-link', function(e) {
                e.preventDefault(); // 기본 앵커 동작 막기

                // 모든 섹션 숨기기
                $('.section').removeClass('active').hide();

                // 클릭한 링크의 data-target에 맞는 섹션 표시
                const target = $(this).data('target');
                $('#' + target).addClass('active').fadeIn(); // 활성화 섹션 표시
            });
            
            $.ajax({
                url: '/CarPlanet/Admin/userCount',
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    console.log("총 회원수 : " + response);

                    const userCountHtml = '<a href="#user-management" class="dynamic-link" data-target="user-management">'
                        + response + '</a>';
                    
                    $('#userCountDisplay').html(userCountHtml);
                },
                error: function(e) {
                    console.error("회원수 조회중 오류", e);
                }
            });

			
			$.ajax({
				url:'/CarPlanet/Admin/countPost',
				type:'GET',
				dataType:'json',
				success:function(response){
					console.log("총 게시물 수 :"+response);
					const postCountHtml = '<a href="#post-management" class="dynamic-link" data-target="post-management">'
                        + response + '</a>';
                    
                    $('#postCountDisplay').html(postCountHtml);
				},
				error:function(e){
					console.error("게시물 수 조회중 오류")
				}
			});
			
			$.ajax({
				url:'/CarPlanet/Admin/countNotice',
				type:'GET',
				dataType:'json',
				success:function(response){
					console.log("총 공지사항 수 :"+response);
					$('#noticeCount').text(response);
				},
				error:function(e){
					console.error("게시물 수 조회중 오류")
				}
			});
            
            
			$.ajax({
			    url: '/CarPlanet/Admin/alluser.do', // 서버에서 제공하는 엔드포인트
			    type: 'GET', // GET 요청
			    dataType: 'json', // 응답을 JSON 형식으로 받음
			    success: function (response) {
			        console.log(response); // 전체 응답 출력
			        const tbody = $('#user-table tbody');
			        tbody.empty(); // 기존 내용을 초기화

			        response.forEach(user => {
			        	console.log(user.carIdx);
			        	
			            const row = `
			            	<tr>
		                    <td style="width:12%">`+user.carIdx+`</td>
		                    <td style="width:23%">`+user.carId+`</td>
		                    <td style="width:18%">`+user.carNickname+`</td>
		                    <td style="width:12%">`+user.carStatus+`</td>
		                    <td style="width:35%">
		                        <button class="promote" data-idx=`+user.carIdx+`>관리자위임</button>
		                        <button class="demote" data-idx=`+user.carIdx+`>권한해임</button>
		                        <button class="delete" data-idx=`+user.carIdx+`>삭제</button>
		                    </td>
		                </tr>
			            `;
			            tbody.append(row); // 테이블에 행 추가
			        });
			    },
			    error: function (e) {
			        console.error('회원목록 가져오기 실패:', e);
			    }
			});
			
			
			$(document).on('click', '#reset-button', function () {
				$.ajax({
				    url: '/CarPlanet/Admin/alluser.do', // 서버에서 제공하는 엔드포인트
				    type: 'GET', // GET 요청
				    dataType: 'json', // 응답을 JSON 형식으로 받음
				    success: function (response) {
				        console.log(response); // 전체 응답 출력
				        const tbody = $('#user-table tbody');
				        tbody.empty(); // 기존 내용을 초기화

				        response.forEach(user => {
				        	console.log(user.carIdx);
				        	
				            const row = `
				                <tr>
				                    <td style="width:12%">`+user.carIdx+`</td>
				                    <td style="width:23%">`+user.carId+`</td>
				                    <td style="width:18%">`+user.carNickname+`</td>
				                    <td style="width:12%">`+user.carStatus+`</td>
				                    <td style="width:35%">
				                        <button class="promote" data-idx=`+user.carIdx+`>관리자위임</button>
				                        <button class="demote" data-idx=`+user.carIdx+`>권한해임</button>
				                        <button class="delete" data-idx=`+user.carIdx+`>삭제</button>
				                    </td>
				                </tr>
				            `;
				            tbody.append(row); // 테이블에 행 추가
				        });
				    },
				    error: function (e) {
				        console.error('회원목록 가져오기 실패:', e);
				    }
				});
			})
			
			$(document).on('click', '#search-button', function () {
			    const keyword = $('#search-input').val().trim(); // 검색어 가져오기
			    if (keyword === '') {
			        alert('검색어를 입력해주세요.');
			        return;
			    }

			    // 서버로 검색 요청
			    $.ajax({
			        url: '/CarPlanet/Admin/searchUser.do',
			        type: 'GET', // 검색이므로 GET 사용
			        data: { keyword }, // 서버로 검색어 전달
			        dataType: 'json', // JSON 형식으로 응답받음
			        success: function (response) {
			            const tbody = $('#user-table tbody');
			            tbody.empty(); // 기존 테이블 비우기

			            if (response.length === 0) {
			                tbody.append('<tr><td colspan="6">검색 결과가 없습니다.</td></tr>');
			                return;
			            }

			            // 검색 결과 테이블에 추가
			            response.forEach(user => {
			            	const row = `
			            		<tr>
			                    <td style="width:12%">`+user.carIdx+`</td>
			                    <td style="width:23%">`+user.carId+`</td>
			                    <td style="width:18%">`+user.carNickname+`</td>
			                    <td style="width:12%">`+user.carStatus+`</td>
			                    <td style="width:35%">
			                        <button class="promote" data-idx=`+user.carIdx+`>관리자위임</button>
			                        <button class="demote" data-idx=`+user.carIdx+`>권한해임</button>
			                        <button class="delete" data-idx=`+user.carIdx+`>삭제</button>
			                    </td>
			                </tr>
				            `;
			                tbody.append(row);
			            });
			        },
			        error: function (xhr, status, error) {
			            console.error('회원 검색 중 오류 발생:', error);
			            alert('오류가 발생했습니다. 다시 시도해주세요.');
			        }
			    });
			});

			
			$(document).on('click', '.promote', function () {
			    const userIdx = $(this).data('idx');
			    if (confirm('관리자 등급으로 지정하시겠습니까?')) {
			        $.ajax({
			            url: '/CarPlanet/Admin/userPromote.do',
			            type: 'POST',
			            data: { userIdx },
			            dataType: 'json',
			            success: function (response) {
			                alert(response.message);
			                if (response.success) {
			                    location.reload();
			                }
			            },
			            error: function (xhr) {
			                if (xhr.status === 401) {
			                    alert('로그인이 필요합니다.');
			                } else if (xhr.status === 403) {
			                    alert('관리자 권한이 필요합니다.');
			                } else {
			                    alert('오류가 발생했습니다.');
			                }
			            }
			        });
			    }
			});

			
			$(document).on('click', '.demote', function () {
			    const userIdx = $(this).data('idx');
			    console.log(userIdx);

			    if (confirm('일반등급으로 내리시겠습니까?')) {
			        $.ajax({
			            url: '/CarPlanet/Admin/userdemote.do',
			            type: 'POST',
			            data: { userIdx: userIdx },
			            dataType: 'json', // 응답을 JSON으로 처리
			            success: function (response) {
			                if (response.success) {
			                    alert(response.message);
			                    location.reload();
			                } else {
			                    alert(response.message);
			                }
			            },
			            error: function (xhr, status, error) {
			                if (xhr.status === 401) {
			                    alert('로그인이 필요합니다.');
			                } else if (xhr.status === 403) {
			                    alert('관리자 권한이 필요합니다.');
			                } else {
			                    console.error('회원 강등 중 오류 발생:', error);
			                    alert('오류가 발생했습니다. 다시 시도해주세요.');
			                }
			            }
			        });
			    }
			});

			
			$(document).on('click', '.delete', function () {
			    const userIdx = $(this).data('idx'); // 버튼에 설정된 데이터 가져오기
			    console.log(userIdx);

			    if (confirm('이 회원을 삭제하시겠습니까?')) {
			        $.ajax({
			            url: '/CarPlanet/Admin/userdelete.do',
			            type: 'POST',
			            data: { userIdx: userIdx }, // 서버로 데이터 전송
			            dataType: 'json', // 응답 데이터 타입
			            success: function (response) {
			                if (response.success) {
			                    alert(response.message);
			                    location.reload();
			                } else {
			                    alert(response.message);
			                }
			            },
			            error: function (xhr, status, error) {
			                if (xhr.status === 401) {
			                    alert('로그인이 필요합니다.');
			                } else if (xhr.status === 403) {
			                    alert('관리자 권한이 필요합니다.');
			                } else {
			                    console.error('회원 강등 중 오류 발생:', error);
			                    alert('오류가 발생했습니다. 다시 시도해주세요.');
			                }
			            }
			        });
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