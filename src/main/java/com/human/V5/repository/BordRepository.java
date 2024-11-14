/*
 * package com.human.V5.repository;
 * 
 * 
 * import java.util.List; import java.util.Optional;
 * 
 * import org.apache.ibatis.annotations.Param; import
 * org.springframework.data.jpa.repository.JpaRepository; import
 * org.springframework.data.jpa.repository.Modifying; import
 * org.springframework.data.jpa.repository.Query; import
 * org.springframework.stereotype.Repository; import
 * org.springframework.transaction.annotation.Transactional;
 * 
 * import com.human.V5.entity.BordEntity;
 * 
 * @Repository public interface BordRepository extends JpaRepository<BordEntity,
 * Integer> {
 * 
 * @Modifying
 * 
 * @Transactional
 * 
 * @Query("UPDATE Bord b SET b.likeValue = :likeValue WHERE b.bordSeq = :bordSeq"
 * ) static int updateUpLike(@Param("bordSeq") Integer bordSeq,
 * 
 * @Param("likeValue") Integer likeValue) {
 * 
 * return 0; }
 * 
 * Optional<BordEntity> findById(Integer bordSeq);
 * 
 * BordEntity save(BordEntity bord);
 * 
 * List<BordEntity> findAll();
 * 
 * void deleteById(Integer bordSeq);
 * 
 * }
 */