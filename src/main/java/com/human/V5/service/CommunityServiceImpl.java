package com.human.V5.service;

import com.human.V5.entity.*;
import com.human.V5.dto.PostCommentDto;
import com.human.V5.dto.PostDto;
import com.human.V5.repository.PostCommentLikeRepository;
import com.human.V5.repository.PostCommentRepository;
import com.human.V5.repository.PostLikeRepository;
import com.human.V5.repository.PostRepository;
import com.human.V5.repository.PostSearchLogRepository;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@AllArgsConstructor
public class CommunityServiceImpl implements CommunityService {

  private PostRepository postRepository;
  private PostLikeRepository postLikeRepository;
  private PostCommentRepository postCommentRepository;
  private PostCommentLikeRepository postCommentLikeRepository;
  private PostSearchLogRepository postSearchLogRepository;

  @Override
  public PostEntity save(PostEntity entity) {
    return postRepository.save(entity);
  }

  @Transactional
  @Override
  public PostEntity updatePost(Integer postIndex, String title, String content, String userId, String fileName, String filePath) {
    PostEntity post = postRepository.findById(postIndex).orElse(null);
    if (post == null) return null;
    if (!post.getCarId().equals(userId)) return null;

    post.setTitle(title);
    post.setContent(content);
    post.setFileName(fileName);
    post.setFilePath(filePath);
    post.setModDate(new Date());

    return postRepository.save(post);
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
    List<PostEntity> postList = postRepository.findAllByContentLikeOrderByRegDateDesc(keyword, pageable).getContent();
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
  public Integer like(Integer postIndex, String carId) {
    PostLikeEntity like = postLikeRepository.findByPostIndexAndCarIdAndType(postIndex, carId, true);
    if (like == null) {
      PostLikeEntity newLike = PostLikeEntity.builder()
        .postIndex(postIndex)
        .type(true)
        .carId(carId)
        .build();

      postLikeRepository.save(newLike);
    } else {
      postLikeRepository.deleteById(like.getPostLikeIndex());
    }

    return (int) postLikeRepository.countByPostIndexAndType(postIndex, true);
  }

  @Transactional
  @Override
  public Integer unlike(Integer postIndex, String carId) {
    PostLikeEntity unlike = postLikeRepository.findByPostIndexAndCarIdAndType(postIndex, carId, false);
    if (unlike == null) {
      PostLikeEntity newUnlike = PostLikeEntity.builder()
        .postIndex(postIndex)
        .type(false)
        .carId(carId)
        .build();

      postLikeRepository.save(newUnlike);
    } else {
      postLikeRepository.deleteById(unlike.getPostLikeIndex());
    }

    return (int) postLikeRepository.countByPostIndexAndType(postIndex, false);
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
          commentDto.setCarId(c.getCarId());
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
      dto.setCarId(p.getCarId());
      dto.setLikeCount(likeCount);
      dto.setUnlikeCount(unlikeCount);
      dto.setComments(comments);
      dto.setRegDate(p.getRegDate());
      dto.setModDate(p.getModDate());
      return dto;
    }).collect(Collectors.toList());
  }
}
