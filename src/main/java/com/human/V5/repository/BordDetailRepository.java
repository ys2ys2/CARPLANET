/*
 * package com.human.V5.repository;
 * 
 * import java.util.Optional;
 * 
 * import org.apache.ibatis.annotations.Param; import
 * org.springframework.data.jpa.repository.JpaRepository; import
 * org.springframework.data.jpa.repository.Modifying; import
 * org.springframework.data.jpa.repository.Query; import
 * org.springframework.stereotype.Repository; import
 * org.springframework.transaction.annotation.Transactional;
 * 
 * import com.human.V5.entity.BordDetailEntity;
 * 
 * @Repository public interface BordDetailRepository extends
 * JpaRepository<BordDetailEntity,Integer> {
 * 
 * @Modifying
 * 
 * @Transactional
 * 
 * @Query("UPDATE BordDetail b " + "SET b.likeChk = :likeChk " +
 * "WHERE b.bordSeq = :bordSeq and b.userId = :userId") int
 * updateLikeChk(@Param("bordSeq") Integer bordSeq,
 * 
 * @Param("likeChk") Integer likeChk,
 * 
 * @Param("userId") String userId);
 * 
 * Optional<BordDetailEntity> findById(Integer bordSeq); }
 */