/*
 * package com.human.V5.service;
 * 
 * 
 * import lombok.extern.slf4j.Slf4j; import
 * org.springframework.stereotype.Service; import
 * org.springframework.web.multipart.MultipartFile;
 * 
 * import com.human.V5.entity.BordEntity; import
 * com.human.V5.repository.BordRepository;
 * 
 * import java.io.File; import java.io.IOException; import java.util.List;
 * import java.util.Optional; import java.util.UUID;
 * 
 * 
 * @Service
 * 
 * @Slf4j public class BordServiceImpl implements BordService{ private final
 * BordRepository bordRepository = null;
 * 
 * @SuppressWarnings("unused") private final BordDetailService bordDetailService
 * = null;
 * 
 * 
 * @Override public BordEntity saveBord(BordEntity bord, MultipartFile file) {
 * if(!file.isEmpty()) { try { String uuid = UUID.randomUUID().toString();
 * String originalFilename = file.getOriginalFilename(); String extension =
 * originalFilename.substring(originalFilename.lastIndexOf(".")); String
 * filePath = "C:/Repo" + File.separator + uuid + extension;
 * 
 * 
 * File destinationFile = new File(filePath); file.transferTo(destinationFile);
 * // 파일을 서버에 저장
 * 
 * bord.setFilePath(filePath); bord.setFileName(uuid);
 * 
 * } catch (IOException e) { log.error("파일 저장 오류", e); } }
 * 
 * 
 * return bordRepository.save(bord); }
 * 
 * @Override public Optional<BordEntity> getBordById(Integer bordSeq) { return
 * bordRepository.findById(bordSeq); }
 * 
 * @Override public List<BordEntity> getAllBords() { return
 * bordRepository.findAll(); }
 * 
 * @Override public BordEntity updateBord(Integer bordSeq, BordEntity bord) {
 * return bordRepository.findById(bordSeq).map(existingBord -> {
 * existingBord.setTitle(bord.getTitle());
 * existingBord.setContent(bord.getContent());
 * existingBord.setFilePath(bord.getFilePath());
 * existingBord.setFileName(bord.getFileName());
 * existingBord.setLikeValue(bord.getLikeValue());
 * existingBord.setUnlikeValue(bord.getUnlikeValue()); return
 * bordRepository.save(existingBord); }).orElseThrow(() -> new
 * IllegalArgumentException("게시물이 존재하지 않습니다: " + bordSeq)); }
 * 
 * @Override public void deleteBord(Integer bordSeq) {
 * bordRepository.deleteById(bordSeq); }
 * 
 * public void upLike(BordEntity bord) {
 * BordRepository.updateUpLike(bord.getLikeValue(),bord.getLikeValue()); }
 * 
 * 
 * 
 * 
 * }
 */