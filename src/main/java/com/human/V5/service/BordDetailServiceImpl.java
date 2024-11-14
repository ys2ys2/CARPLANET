/*
 * package com.human.V5.service;
 * 
 * import org.springframework.stereotype.Service;
 * 
 * import com.human.V5.entity.BordDetailEntity; import
 * com.human.V5.repository.BordDetailRepository;
 * 
 * import java.util.Optional;
 * 
 * @Service public class BordDetailServiceImpl implements BordDetailService{
 * 
 * private final BordDetailRepository bordDetailRepository = null;
 * 
 * @Override public Optional<BordDetailEntity> getBordById(Integer bordSeq) {
 * return bordDetailRepository.findById(bordSeq); }
 * 
 * @Override public void existLikeUserId(BordDetailEntity bordDetail) { if
 * (bordDetail.getLikeChk() == 1) { bordDetail.setLikeChk(0);
 * bordDetailRepository.updateLikeChk(bordDetail.getBordSeq(),
 * bordDetail.getLikeChk(), bordDetail.getUserId());
 * 
 * } else { bordDetail.setLikeChk(1);
 * bordDetailRepository.updateLikeChk(bordDetail.getBordSeq(),
 * bordDetail.getLikeChk(), bordDetail.getUserId()); } }
 * 
 * 
 * }
 */