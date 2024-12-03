package com.human.V5.controller;

import com.human.V5.entity.UserEntity;
import com.human.V5.entity.PostCommentEntity;
import com.human.V5.entity.PostEntity;
import com.human.V5.dto.PostCommentDto;
import com.human.V5.dto.PostCommentLikeDto;
import com.human.V5.dto.PostDto;
import com.human.V5.dto.PostLikeDto;
import com.human.V5.service.CommunityService;
import com.human.V5.vo.PostCommentVO;
import com.human.V5.vo.PostVO;
import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/community")
@AllArgsConstructor
public class CommunityController {

  private CommunityService communityService;
  private final ServletContext servletContext;
  private final static String IMAGE_UPLOAD_DIR = "/resources/images/community/";
 
  

  /**
   * 게시글 목록 조회
   */
  @GetMapping("/getPostList.do")
  public ModelAndView getPostList(HttpServletRequest request, Integer postIndex) {
    ModelAndView mav = new ModelAndView();
    if (postIndex == null) {
      mav.addObject("posts", communityService.getPostList(PageRequest.of(0, 10)));
    } else {
      mav.addObject("posts", communityService.getPostDto(postIndex));
    }
    // TODO, paging 처리 필요시 jsp 수정필요
    mav.addObject("recommendedPosts", communityService.getRecommendedPostList());
    mav.addObject("popularKeywords", communityService.getPopularKeywordList());
    mav.setViewName("Community/communityList");
    return mav;
  }

  /**
   * 게시글 검색
   */
  @GetMapping("/searchPostList.do")
  public ModelAndView searchPostList(HttpServletRequest request, String keyword, Integer postIndex) {
    ModelAndView mav = new ModelAndView();
    // TODO, paging 처리 필요시 jsp 수정필요
    mav.addObject("posts", communityService.searchPostList(PageRequest.of(0, 10), keyword, postIndex));
    mav.addObject("recommendedPosts", communityService.getRecommendedPostList());
    mav.addObject("popularKeywords", communityService.getPopularKeywordList());
    mav.setViewName("Community/communityList");
    return mav;
  }


  /**
   * 게시글 등록/수정
   */
  @GetMapping("/post.do")
  public ModelAndView post(HttpServletRequest request, ModelAndView mav, Integer postIndex) {
    String viewName = null;
    String userId = getCurrentUserId(request);
    if (userId != null) {
      mav.addObject("popularKeywords", communityService.getPopularKeywordList());
      mav.addObject("recommendedPosts", communityService.getRecommendedPostList());
      if (postIndex != null) {
        PostEntity post = communityService.getPost(postIndex);
        if (post != null && post.getCarId().equals(userId)) {
          mav.addObject("post", post);
          viewName = "Community/community";
        } else {
          viewName = "Community/communityList";
        }
      } else {
        viewName = "Community/community";
      }
    } else {
      viewName = "redirect:/Auth/Login.do";
    }
    mav.setViewName(viewName);
    return mav;
    
  }

  @PostMapping("/registerPost.do")
  public String registerPost(HttpServletRequest request, PostVO vo) throws IOException {
    String userId = getCurrentUserId(request);
    if (userId == null) {
      return "redirect:/Auth/Login.do";
    }

    /**
     * 업로드된 파일 저장
     */
    MultipartFile file = vo.getFile();
    String originalFilename = file.getOriginalFilename();
    
    if (file != null && file.getSize() > 0) {
      try {
        String realPath = servletContext.getRealPath(IMAGE_UPLOAD_DIR);

        File directory = new File(realPath);
        if (!directory.exists()) {
          directory.mkdirs();
        }

        String filePath = realPath + originalFilename;
        file.transferTo(new File(filePath));
      } catch (IOException e) {
        e.printStackTrace();
        throw e;
      }
    }
    
    //JSP에서 입력된 값을 Entity에 세팅
    PostEntity entity = PostEntity.builder()
  	      .title(vo.getTitle())
  	      .content(vo.getContent())
  	      .carId(userId)
  	      .fileName(originalFilename)
  	      .filePath(IMAGE_UPLOAD_DIR)
  	      .build();

    communityService.save(entity);

    return "redirect:/community/getPostList.do";
  }

  @PostMapping("/updatePost.do")
  public String updatePost(HttpServletRequest request, PostVO vo) throws IOException {
    String userId = getCurrentUserId(request);
    if (userId == null) {
      return "redirect:/Auth/Login.do";
    }

    PostEntity entity = communityService.getPost(vo.getPostIndex());
    if (entity == null) {
      // 존재하지 않는 게시물은 삭제 불가
      return "redirect:/community/getPostList.do";
    }
    
    /**
     * 업로드된 파일 저장
     */
    MultipartFile file = vo.getFile();
    String fileName = vo.getOriginalFileName();
    String filePath = vo.getOriginalFilePath();
    if (file != null && file.getSize() > 0) {
      try {
        String realPath = servletContext.getRealPath(IMAGE_UPLOAD_DIR);

        File directory = new File(realPath);
        if (!directory.exists()) {
          directory.mkdirs();
        }

        String path = realPath + file.getOriginalFilename();
        file.transferTo(new File(path));
      } catch (IOException e) {
        e.printStackTrace();
        throw e;
      }
      filePath = IMAGE_UPLOAD_DIR;
      fileName = file.getOriginalFilename();
    }


    //JSP에서 입력된 값을 Entity에 세팅
    entity.setTitle(vo.getTitle());
    entity.setContent(vo.getContent());
    entity.setFileName(fileName);
    entity.setFilePath(filePath);

    communityService.updatePost(entity);

    return "redirect:/community/getPostList.do";
  }

  @PostMapping("/deletePost.do")
  public ResponseEntity<List<PostDto>> deletePost(HttpServletRequest request, PostVO vo) throws IOException {
    ModelAndView mav = new ModelAndView();

    String userId = getCurrentUserId(request);
    if (userId == null) {
      return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value()).body(null);
    }

    communityService.deletePost(vo.getPostIndex(), userId);

    return ResponseEntity.ok().body(communityService.getPostList(PageRequest.of(0, 10)));
  }


  /**
   * 게시글 좋아요/싫어요
   */
  @PostMapping("/post/like.do")
  public ResponseEntity<PostLikeDto> like(HttpServletRequest request, Integer postIndex) {
	  
	  System.out.println("like 실행");  
	  
    String userId = getCurrentUserId(request);
    if (getCurrentUserId(request) != null) {
      return ResponseEntity.ok(communityService.like(postIndex, userId));
    } else {
      return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value()).body(null);
    }
  }

  @PostMapping("/post/unlike.do")
  public ResponseEntity<PostLikeDto> unlike(HttpServletRequest request, Integer postIndex) {
	  
	 System.out.println("unlike 실행"); 
	  
    String userId = getCurrentUserId(request);
    if (getCurrentUserId(request) != null) {
      return ResponseEntity.ok(communityService.unlike(postIndex, userId));
    } else {
      return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value()).body(null);
    }
  }

  /**
   * 게시글 댓글
   */
  @PostMapping("/post/registerComment.do")
  public ResponseEntity<PostCommentDto> registerComment(HttpServletRequest request,
    PostCommentVO vo) {
    String userId = getCurrentUserId(request);
    if (getCurrentUserId(request) != null) {
      PostCommentEntity entity = PostCommentEntity.builder()
        .postIndex(vo.getPostIndex())
        .content(vo.getContent())
        .carId(userId)
        .build();

      PostCommentEntity newComment = communityService.saveComment(entity);

      PostCommentDto dto = new PostCommentDto();
      dto.setPostCommentIndex(newComment.getPostCommentIndex());
      dto.setPostIndex(newComment.getPostIndex());
      dto.setContent(newComment.getContent());
      dto.setCarId(newComment.getCarId());
      dto.setRegDate(newComment.getRegDate());
      dto.setModDate(newComment.getModDate());
      return ResponseEntity.ok(dto);
    } else {
      return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value()).body(null);
    }
  }

  /**
   * 게시글 댓글 수정
   */
  @PostMapping("/post/updateComment.do")
  public ResponseEntity<PostCommentDto> updateComment(HttpServletRequest request,
    PostCommentVO vo) {
    String userId = getCurrentUserId(request);
    if (getCurrentUserId(request) != null) {
      PostCommentEntity comment = communityService.updateComment(vo.getPostCommentIndex(),
        vo.getContent(), userId);

      PostCommentDto dto = new PostCommentDto();
      dto.setPostCommentIndex(comment.getPostCommentIndex());
      dto.setPostIndex(comment.getPostIndex());
      dto.setContent(comment.getContent());
      dto.setCarId(comment.getCarId());
      dto.setRegDate(comment.getRegDate());
      dto.setModDate(comment.getModDate());
      return ResponseEntity.ok(dto);
    } else {
      return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value()).body(null);
    }
  }

  /**
   * 게시글 댓글 삭제
   */
  @PostMapping("/post/deleteComment.do")
  public ResponseEntity<PostCommentDto> deleteComment(HttpServletRequest request,
    PostCommentVO vo) {
    String userId = getCurrentUserId(request);
    if (getCurrentUserId(request) != null) {
      PostCommentEntity comment = communityService.deleteComment(vo.getPostCommentIndex(), userId);

      PostCommentDto dto = new PostCommentDto();
      dto.setPostCommentIndex(comment.getPostCommentIndex());
      dto.setPostIndex(comment.getPostIndex());
      dto.setContent(comment.getContent());
      dto.setCarId(comment.getCarId());
      dto.setRegDate(comment.getRegDate());
      dto.setModDate(comment.getModDate());
      return ResponseEntity.ok(dto);
    } else {
      return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value()).body(null);
    }
  }

  /**
   * 게시글 댓글 좋아요/싫어요
   */
  @PostMapping("/post/comment/like.do")
  public ResponseEntity<PostCommentLikeDto> commentLike(HttpServletRequest request,
    Integer postCommentIndex) {
    String userId = getCurrentUserId(request);
    if (getCurrentUserId(request) != null) {
      PostCommentLikeDto dto = new PostCommentLikeDto();
      dto.setPostCommentIndex(postCommentIndex);
      dto.setLikeCount(communityService.commentLike(postCommentIndex, userId));
      return ResponseEntity.ok(dto);
    } else {
      return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value()).body(null);
    }
  }

  @PostMapping("/post/comment/unlike.do")
  public ResponseEntity<PostCommentLikeDto> commentUnlike(HttpServletRequest request,
    Integer postCommentIndex) {
    String userId = getCurrentUserId(request);
    if (getCurrentUserId(request) != null) {
      PostCommentLikeDto dto = new PostCommentLikeDto();
      dto.setPostCommentIndex(postCommentIndex);
      dto.setUnlikeCount(communityService.commentUnlike(postCommentIndex, userId));
      return ResponseEntity.ok(dto);
    } else {
      return ResponseEntity.status(HttpStatus.UNAUTHORIZED.value()).body(null);
    }
  }

  // 게시글 댓글 조회
  @GetMapping("/post/comment/list.do")
  public ResponseEntity<List<PostCommentDto>> commentList(HttpServletRequest request, Integer postIndex) {
    List<PostCommentDto> dtoList = communityService.getPostCommentList(postIndex);
    return ResponseEntity.ok(dtoList);
  }


  private String getCurrentUserId(HttpServletRequest request) {
    UserEntity user = (UserEntity) request.getSession().getAttribute("user");
    if (user != null) {
      return user.getCarId();
    } else {
      return null;
    }
  }
}
