package com.human.V5.repository;

import com.human.V5.dto.PostCommentDto;
import com.human.V5.entity.PostCommentEntity;
import java.util.List;
import java.util.Map;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import javax.persistence.Tuple;

public interface PostCommentRepository extends JpaRepository<PostCommentEntity, Integer> {
  List<PostCommentEntity> findAllByPostIndexIn(List<Integer> postIndex);

  @Query(  value="   select post_comment.* " +
          "        , car_member.car_nickname" +
          "        , count(post_comment_like_b.post_comment_index) over (partition by post_comment_like_b.post_comment_index) as post_comment_b_cnt " +
          "        , count(post_comment_like_p.post_comment_index) over (partition by post_comment_like_p.post_comment_index) as post_comment_p_cnt " +
          "     from Car_Post_comment post_comment " +
          "left join (select * from Car_Post_comment_like where type = 1) post_comment_like_b" +
          "       on post_comment.post_comment_index = post_comment_like_b.post_comment_index " +
          "left join (select * from Car_Post_comment_like where type = 0) post_comment_like_p" +
          "       on post_comment.post_comment_index = post_comment_like_p.post_comment_index " +
          "left join Car_member car_member" +
          "       on post_comment.car_id = car_member.car_id"+
          "    where post_comment.post_index = :postIndex"
          ,nativeQuery = true)
  List<Object[]> findAllByPostIndex(@Param("postIndex") Integer postIndex);
  
}
