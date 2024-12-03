$(document).ready(function () {

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
  $('#addNoticeBtn').on('click', function () {
    $('.noticemodal').css('display', 'flex');
  })

  // 모달 닫기
  $('#cancelNotice').on('click', function () {
    $('.noticemodal').css('display', 'none');
  });


  $.ajax({
    url: '/CarPlanet/Admin/visitor-stats',
    type: 'GET',
    dataType: 'json',
    success: function (response) {
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
    error: function (error) {
      console.error('날짜별 방문자 데이터 로드 실패:', error);
    }
  });

  function updateChart(chart, labels, data) {
    chart.data.labels = labels.reverse(); // 날짜 순서 뒤집기 (최근 날짜부터 표시)
    chart.data.datasets[0].data = data.reverse(); // 방문자 데이터도 뒤집기
    chart.update();
  }

  function updateChart(chart, labels, data) {
    chart.data.labels = labels.reverse(); // 날짜 순서 뒤집기 (최근 날짜부터 표시)
    chart.data.datasets[0].data = data.reverse(); // 방문자 데이터도 뒤집기
    chart.update();
  }

  // 이벤트 위임 설정
  $(document).on('click', '.dynamic-link', function (e) {
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
    success: function (response) {
      console.log("총 회원수 : " + response);

      const userCountHtml = '<a href="#user-management" class="dynamic-link" data-target="user-management">'
        + response + '</a>';

      $('#userCountDisplay').html(userCountHtml);
    },
    error: function (e) {
      console.error("회원수 조회중 오류", e);
    }
  });


  $.ajax({
    url: '/CarPlanet/Admin/countPost',
    type: 'GET',
    dataType: 'json',
    success: function (response) {
      console.log("총 게시물 수 :" + response);
      const postCountHtml = '<a href="#post-management" class="dynamic-link" data-target="post-management">'
        + response + '</a>';

      $('#postCountDisplay').html(postCountHtml);
    },
    error: function (e) {
      console.error("게시물 수 조회중 오류")
    }
  });

  $.ajax({
    url: '/CarPlanet/Admin/allpost.do', // 게시글 데이터 요청
    type: 'GET',
    dataType: 'json',
    success: function (res) {
      const postBoxContainer = $('#post-box-container'); // 박스 컨테이너 선택
      postBoxContainer.empty(); // 기존 내용 초기화

      res.forEach(post => {
        // 이미지 URL 조합
        const imageUrl = post.filePath && post.fileName
          ? `/CarPlanet/${post.filePath}${post.fileName}`
          : '/CarPlanet/resources/images/noimg2.png'; // 기본 이미지 처리
        // 게시물 카드 생성
        const postBox = `
                <div class="post-box">
                    <div>
                        <div class="imbox"><img src="${imageUrl}" alt="이미지"></div>
                        <h3>${post.title}</h3>
                        <p>${post.content || '내용 없음'}</p>
                    </div>
                    <div class="post-box-footer">
                        <span>작성자: ${post.carId}</span>
                        <div class="deletebox" data-pidx="${post.postIndex}"><img src="/CarPlanet/resources/images/postdeleteadmin.png" class="delete-post"/></div>
                    </div>
                </div>
            `;
        postBoxContainer.append(postBox); // 박스를 컨테이너에 추가
      });


    },
    error: function (e) {
      console.error('게시글 목록 가져오기 실패:', e);
    }
  });

  $(document).on('click', '.deletebox', function () {
    const postIdx = $(this).data('pidx');
    console.log(postIdx);

    // 삭제 확인 메시지 추가
    if (confirm('정말 이 게시글을 삭제하시겠습니까?')) {
      $.ajax({
        url: '/CarPlanet/Admin/deletepost', // 삭제 API URL
        type: 'POST', // HTTP 메서드
        data: { postIndex: postIdx }, // 삭제할 게시글 ID 전달
        dataType: 'json',
        success: function (response) {
          alert(response.message || '게시글이 삭제되었습니다.'); // 서버에서 오는 메시지 출력
          if (response.success) {
            location.reload(); // 페이지 새로고침
          }
        },
        error: function (xhr, status, error) {
          if (xhr.status === 401) {
            alert('로그인이 필요합니다.');
          } else if (xhr.status === 403) {
            alert('관리자 권한이 필요합니다.');
          } else {
            console.error('오류:', error); // 자세한 오류 메시지 출력
            alert('삭제 중 오류가 발생했습니다. 다시 시도해주세요.');
          }
        }
      });
    }
  });



  $.ajax({
    url: '/CarPlanet/Admin/countNotice',
    type: 'GET',
    dataType: 'json',
    success: function (response) {
      console.log("총 공지사항 수 :" + response);
      $('#noticeCount').text(response);
    },
    error: function (e) {
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
                    <td style="width:12%">`+ user.carIdx + `</td>
                    <td style="width:23%">`+ user.carId + `</td>
                    <td style="width:18%">`+ user.carNickname + `</td>
                    <td style="width:12%">`+ user.carStatus + `</td>
                    <td style="width:35%">
                        <button class="promote" data-idx=`+ user.carIdx + `>관리자</button>
                        <button class="demote" data-idx=`+ user.carIdx + `>일반회원</button>
                        <button class="delete" data-idx=`+ user.carIdx + `>삭제</button>
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

    $('#search-input').val('');

    // 셀렉트 박스 초기화
    $('#search-carstatus').val('');

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
                        <td style="width:12%">`+ user.carIdx + `</td>
                        <td style="width:23%">`+ user.carId + `</td>
                        <td style="width:18%">`+ user.carNickname + `</td>
                        <td style="width:12%">`+ user.carStatus + `</td>
                        <td style="width:35%">
                            <button class="promote" data-idx=`+ user.carIdx + `>관리자위임</button>
                            <button class="demote" data-idx=`+ user.carIdx + `>권한해임</button>
                            <button class="delete" data-idx=`+ user.carIdx + `>삭제</button>
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

  $(document).on('click', '#psearch-button', function () {
    const keyword = $('#post-input').val().trim();
    console.log(keyword);

    $.ajax({
      url: '/CarPlanet/Admin/searchPost.do', // 검색 API 엔드포인트
      type: 'GET',
      data: { keyword: keyword },
      dataType: 'json',
      success: function (response) {
        const postBoxContainer = $('#post-box-container');
        postBoxContainer.empty(); // 기존 내용 초기화

        if (response.length === 0) {
          postBoxContainer.append('<h2>해당 게시물이 없습니다.</h2>');
          return;
        }

        response.forEach(post => {
          const imageUrl = post.filePath && post.fileName
            ? `/CarPlanet/${post.filePath}${post.fileName}`
            : '/CarPlanet/resources/images/noimg2.png'; // 기본 이미지

          const postBox = `
                <div class="post-box">
                    <div>
                        <div class="imbox">
                            <img src="${imageUrl}" alt="이미지">
                        </div>
                        <h3>${post.title}</h3>
                        <p>${post.content || '내용 없음'}</p>
                    </div>
                    <div class="post-box-footer">
                        <span>작성자: ${post.carId}</span>
                        <div class="deletebox" data-pidx="${post.postIndex}">
                            <img src="/CarPlanet/resources/images/postdeleteadmin.png" class="delete-post"/>
                        </div>
                    </div>
                </div>
            `;

          postBoxContainer.append(postBox);
        });
      },
      error: function (error) {
        console.error('게시물 검색 중 오류 발생:', error);
        alert('게시물 검색 중 오류가 발생했습니다. 다시 시도해주세요.');
      }
    });
  });

  $(document).on('click', '#preset-button', function () {
    $('#post-input').val('');

    $.ajax({
      url: '/CarPlanet/Admin/allpost.do', // 게시글 데이터 요청
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        const postBoxContainer = $('#post-box-container'); // 박스 컨테이너 선택
        postBoxContainer.empty(); // 기존 내용 초기화

        res.forEach(post => {
          // 이미지 URL 조합
          const imageUrl = post.filePath && post.fileName
            ? `/CarPlanet/${post.filePath}${post.fileName}`
            : '/CarPlanet/resources/images/noimg2.png'; // 기본 이미지 처리
          // 게시물 카드 생성
          const postBox = `
                <div class="post-box">
                    <div>
                        <div class="imbox"><img src="${imageUrl}" alt="이미지"></div>
                        <h3>${post.title}</h3>
                        <p>${post.content || '내용 없음'}</p>
                    </div>
                    <div class="post-box-footer">
                        <span>작성자: ${post.carId}</span>
                        <div class="deletebox" data-pidx="${post.postIndex}"><img src="/CarPlanet/resources/images/postdeleteadmin.png" class="delete-post"/></div>
                    </div>
                </div>
            `;
          postBoxContainer.append(postBox); // 박스를 컨테이너에 추가
        });


      },
      error: function (e) {
        console.error('게시글 목록 가져오기 실패:', e);
      }
    });
  })


  $(document).on('click', '#search-button', function () {
    const keyword = $('#search-input').val().trim();
    const carStatus = $('#search-carstatus').val(); // 선택된 carStatus 값

    // 서버로 검색 요청
    $.ajax({
      url: '/CarPlanet/Admin/searchUser.do',
      type: 'GET',
      data: {
        keyword: keyword || null, // keyword가 없으면 null 전달
        carStatus: carStatus || null // carStatus가 없으면 null 전달
      },
      dataType: 'json',
      success: function (response) {
        const tbody = $('#user-table tbody');
        tbody.empty(); // 기존 테이블 비우기

        if (response.length === 0) {
          tbody.append('<tr><td colspan="5">검색 결과가 없습니다.</td></tr>');
          return;
        }

        // 검색 결과 테이블에 추가
        response.forEach(user => {
          const row = `
              <tr>
                  <td style="width:12%">`+ user.carIdx + `</td>
                  <td style="width:23%">`+ user.carId + `</td>
                  <td style="width:18%">`+ user.carNickname + `</td>
                  <td style="width:12%">`+ user.carStatus + `</td>
                  <td style="width:35%">
                      <button class="promote" data-idx=`+ user.carIdx + `>관리자위임</button>
                      <button class="demote" data-idx=`+ user.carIdx + `>권한해임</button>
                      <button class="delete" data-idx=`+ user.carIdx + `>삭제</button>
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




  $('.menu-link').on('click', function (e) {
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