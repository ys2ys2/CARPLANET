package com.human.V5.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.human.V5.dto.PostCommentDto;
import com.human.V5.dto.PostDto;
import com.human.V5.dto.PostLikeDto;
import com.human.V5.entity.PostCommentEntity;
import com.human.V5.entity.PostCommentLikeEntity;
import com.human.V5.entity.PostEntity;
import com.human.V5.entity.PostLikeEntity;
import com.human.V5.entity.PostSearchLogEntity;
import com.human.V5.repository.PostCommentLikeRepository;
import com.human.V5.repository.PostCommentRepository;
import com.human.V5.repository.PostLikeRepository;
import com.human.V5.repository.PostRepository;
import com.human.V5.repository.PostSearchLogRepository;
import com.human.V5.repository.UserRepository;
import com.human.V5.vo.PostVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class CommunityServiceImpl implements CommunityService {

  private PostRepository postRepository;
  private PostLikeRepository postLikeRepository;
  private PostCommentRepository postCommentRepository;
  private PostCommentLikeRepository postCommentLikeRepository;
  private PostSearchLogRepository postSearchLogRepository;
  private UserRepository userRepository;

  @Override
  public PostEntity save(PostEntity entity) {
    return postRepository.save(entity);
  }
  

  @Transactional
  @Override
  public PostEntity updatePost(PostEntity entity) {
    return postRepository.save(entity);
  }

  @Transactional
  @Override
  public PostEntity deletePost(Integer postIndex, String userId) {
    PostEntity post = postRepository.findById(postIndex).orElse(null);
    if (post == null) return null;
    if (!post.getCarId().equals(userId)) return null;

    postRepository.deleteById(postIndex);
    return post;
  }

  @Override
  public PostEntity getPost(Integer postIndex) {
    return postRepository.findById(postIndex).orElse(null);
  }

  @Override
  public List<PostDto> getPostDto(Integer postIndex) {
    List<PostEntity> post = new ArrayList<>();
    post.add(postRepository.findById(postIndex).orElse(null));
    return convertPostDto(post);
  }

  @Transactional
  @Override
  public List<PostDto> getPostList(Pageable pageable) {
    List<PostEntity> postList = postRepository.findAllByOrderByRegDateDesc(pageable).getContent();
    return convertPostDto(postList);
  }

  /**
   * 글 제목으로 검색
   */
  @Transactional
  @Override
  public List<PostDto> searchPostList(Pageable pageable, String keyword) {
    String searchKeyword = "%" + keyword + "%";
    List<PostEntity> postList = postRepository.findAllByTitleLikeOrContentLikeOrderByRegDateDesc(searchKeyword, searchKeyword, pageable).getContent();
    postSearchLogRepository.save(PostSearchLogEntity.builder().keyword(keyword).build());
    return convertPostDto(postList);
  }

  /**
   * 추천 게시글 검색 (좋아요 많은순 10개)
   */
  @Transactional
  @Override
  public List<PostDto> getRecommendedPostList() {
    List<PostEntity> postList = postRepository.findRecommendedPosts();
    return convertPostDto(postList);
  }

  @Transactional
  @Override
  public PostLikeDto like(Integer postIndex, String carId) {
    List<PostLikeEntity> likeAndUnlike = postLikeRepository.findAllByPostIndexAndCarId(postIndex, carId);
    PostLikeEntity like = likeAndUnlike.stream()
            .filter(l -> Boolean.TRUE.equals(l.getType())) // type이 true인 요소만 필터링
            .findFirst()
            .orElse(null);
    PostLikeEntity unlike = likeAndUnlike.stream()
            .filter(l -> Boolean.FALSE.equals(l.getType())) // type이 true인 요소만 필터링
            .findFirst()
            .orElse(null);

    if (like == null) {
      PostLikeEntity newLike = PostLikeEntity.builder()
        .postIndex(postIndex)
        .type(true)
        .carId(carId)
        .build();

      postLikeRepository.save(newLike);
      if (unlike != null) {
        postLikeRepository.deleteById(unlike.getPostLikeIndex());
      }
    } else {
      postLikeRepository.deleteById(like.getPostLikeIndex());
    }

    PostLikeDto postLikeDto = new PostLikeDto();
    postLikeDto.setPostIndex(postIndex);
    postLikeDto.setLikeCount((int) postLikeRepository.countByPostIndexAndType(postIndex, true));
    postLikeDto.setUnlikeCount((int) postLikeRepository.countByPostIndexAndType(postIndex, false));
    return postLikeDto;
  }

  @Transactional
  @Override
  public PostLikeDto unlike(Integer postIndex, String carId) {
    List<PostLikeEntity> likeAndUnlike = postLikeRepository.findAllByPostIndexAndCarId(postIndex, carId);
    PostLikeEntity like = likeAndUnlike.stream()
            .filter(l -> Boolean.TRUE.equals(l.getType())) // type이 true인 요소만 필터링
            .findFirst()
            .orElse(null);
    PostLikeEntity unlike = likeAndUnlike.stream()
            .filter(l -> Boolean.FALSE.equals(l.getType())) // type이 true인 요소만 필터링
            .findFirst()
            .orElse(null);

    if (unlike == null) {
      PostLikeEntity newUnlike = PostLikeEntity.builder()
        .postIndex(postIndex)
        .type(false)
        .carId(carId)
        .build();

      postLikeRepository.save(newUnlike);

      if (like != null) {
        postLikeRepository.deleteById(like.getPostLikeIndex());
      }
    } else {
      postLikeRepository.deleteById(unlike.getPostLikeIndex());
    }

    PostLikeDto postLikeDto = new PostLikeDto();
    postLikeDto.setPostIndex(postIndex);
    postLikeDto.setLikeCount((int) postLikeRepository.countByPostIndexAndType(postIndex, true));
    postLikeDto.setUnlikeCount((int) postLikeRepository.countByPostIndexAndType(postIndex, false));
    return postLikeDto;
  }

  @Transactional
  @Override
  public PostCommentEntity saveComment(PostCommentEntity entity) {
    // 존재하지 않는 글에는 코멘트 작성 불가
    postRepository.findById(entity.getPostIndex()).orElseThrow(IllegalArgumentException::new);

    return postCommentRepository.save(entity);
  }

  @Override
  public PostCommentEntity updateComment(Integer postCommentIndex, String content, String userId) {
    PostCommentEntity comment = postCommentRepository.findById(postCommentIndex).orElse(null);
    if (comment == null) return null;
    if (!comment.getCarId().equals(userId)) return null;

    comment.setContent(content);
    comment.setModDate(new Date());

    return postCommentRepository.save(comment);
  }

  @Override
  public PostCommentEntity deleteComment(Integer postCommentIndex, String userId) {
    PostCommentEntity comment = postCommentRepository.findById(postCommentIndex).orElse(null);
    if (comment == null) return null;
    if (!comment.getCarId().equals(userId)) return null;

    postCommentRepository.deleteById(postCommentIndex);

    return comment;
  }


  @Transactional
  @Override
  public Integer commentLike(Integer postCommentIndex, String carId) {
    PostCommentLikeEntity like = postCommentLikeRepository.findFirstByPostCommentIndexAndCarIdAndType(postCommentIndex, carId, true);
    if (like == null) {
      PostCommentLikeEntity newLike = PostCommentLikeEntity.builder()
        .postCommentIndex(postCommentIndex)
        .type(true)
        .carId(carId)
        .build();

      postCommentLikeRepository.save(newLike);
    } else {
      postCommentLikeRepository.deleteById(like.getPostCommentLikeIndex());
    }

    return (int) postCommentLikeRepository.countByPostCommentIndexAndType(postCommentIndex, true);
  }

  @Transactional
  @Override
  public Integer commentUnlike(Integer postCommentIndex, String carId) {
    PostCommentLikeEntity unlike = postCommentLikeRepository.findFirstByPostCommentIndexAndCarIdAndType(postCommentIndex, carId, false);
    if (unlike == null) {
      PostCommentLikeEntity newUnlike = PostCommentLikeEntity.builder()
        .postCommentIndex(postCommentIndex)
        .type(false)
        .carId(carId)
        .build();

      postCommentLikeRepository.save(newUnlike);
    } else {
      postCommentLikeRepository.deleteById(unlike.getPostCommentLikeIndex());
    }

    return (int) postCommentLikeRepository.countByPostCommentIndexAndType(postCommentIndex, false);
  }

  /**
   * 인기 키워드 조회
   */
  @Transactional
  @Override
  public List<String> getPopularKeywordList() {
    return postSearchLogRepository.findPopularKeywords(10);
  }

  private List<PostDto> convertPostDto(List<PostEntity> postList) {
    List<Integer> postIndexes = postList.stream().map(PostEntity::getPostIndex)
      .collect(Collectors.toList());

    Map<Integer, List<PostCommentEntity>> postComments = postCommentRepository.findAllByPostIndexIn(
      postIndexes).stream().collect(
      Collectors.groupingBy(PostCommentEntity::getPostIndex));

    Set<String> carIdSet = new HashSet<>();
    postList.forEach(post -> {
      carIdSet.add(post.getCarId());
    });

    postComments.values().forEach(comments -> {
      comments.forEach(comment -> {
        carIdSet.add(comment.getCarId());
      });
    });

	/*
	 * List<UserEntity> users = userRepository.findAllByCarIdIn(new
	 * ArrayList<>(carIdSet)); Map<String, String> userNickNameMap = new
	 * HashMap<>(); users.forEach(userEntity -> {
	 * userNickNameMap.put(userEntity.getCarId(), userEntity.getCarNickname()); });
	 */

    Map<Integer, List<PostLikeEntity>> postLikes = postLikeRepository.findAllByPostIndexIn(
      postIndexes).stream().collect(
      Collectors.groupingBy(PostLikeEntity::getPostIndex));

    return postList.stream().map(p -> {
      List<PostLikeEntity> postLikeList = postLikes.get(p.getPostIndex());
      Integer likeCount = 0;
      Integer unlikeCount = 0;
      if (postLikeList != null) {
        likeCount = (int) postLikeList.stream().filter(obj -> obj.getType() == true).count();
        unlikeCount = (int) postLikeList.stream().filter(obj -> obj.getType() == false).count();
      }
      /**
       * 댓글 좋아요/싫어요 수 계산
       */
      List<PostCommentEntity> postCommentList = postComments.get(p.getPostIndex());
      List<PostCommentDto> comments = new ArrayList<>();

      if (postCommentList != null) {
        List<Integer> postCommentIndexes = postCommentList.stream().map(PostCommentEntity::getPostCommentIndex)
          .collect(Collectors.toList());

        Map<Integer, List<PostCommentLikeEntity>> postCommentsLikes = postCommentLikeRepository.findAllByPostCommentIndexIn(postCommentIndexes).stream().collect(
          Collectors.groupingBy(PostCommentLikeEntity::getPostCommentIndex));

        comments = postCommentList.stream().map(c -> {
          List<PostCommentLikeEntity> postCommentLikeList = postCommentsLikes.get(c.getPostCommentIndex());
          Integer commentLikeCount = 0;
          Integer commentUnlikeCount = 0;
          if (postCommentLikeList != null) {
            commentLikeCount = (int) postCommentLikeList.stream().filter(obj -> obj.getType() == true).count();
            commentUnlikeCount = (int) postCommentLikeList.stream().filter(obj -> obj.getType() == false).count();
          }


          PostCommentDto commentDto = new PostCommentDto();
          commentDto.setPostCommentIndex(c.getPostCommentIndex());
          commentDto.setPostIndex(c.getPostIndex());
          commentDto.setContent(c.getContent());
		/* commentDto.setCarId(userNickNameMap.get(c.getCarId())); */
          commentDto.setLikeCount(commentLikeCount);
          commentDto.setUnlikeCount(commentUnlikeCount);
          commentDto.setRegDate(c.getRegDate());
          commentDto.setModDate(c.getModDate());

          return commentDto;
        }).collect(Collectors.toList());
      }

      PostDto dto = new PostDto();
      dto.setPostIndex(p.getPostIndex());
      dto.setTitle(p.getTitle());
      dto.setContent(p.getContent());
      dto.setFilePath(p.getFilePath());
      dto.setFileName(p.getFileName());
	/* dto.setCarId(userNickNameMap.get(p.getCarId())); */
      dto.setLikeCount(likeCount);
      dto.setUnlikeCount(unlikeCount);
      dto.setComments(comments);
      dto.setRegDate(p.getRegDate());
      dto.setModDate(p.getModDate());
      return dto;
    }).collect(Collectors.toList());
  }
  
  
  @Transactional
  @Override
  public List<PostEntity> getMyPostEntities(String carId, Pageable pageable) {
      // Repository에서 데이터를 가져옵니다.
      Page<PostEntity> postPage = postRepository.findByCarId(carId, pageable);
      return postPage.getContent(); // 엔티티 리스트 반환
  }



  
  
  
}
