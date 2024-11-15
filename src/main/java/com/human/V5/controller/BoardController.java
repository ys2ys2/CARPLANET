/*
 * package com.human.V5.controller;
 * 
 * import java.util.List; import java.util.Optional;
 * 
 * import org.springframework.stereotype.Controller; import
 * org.springframework.ui.Model; import
 * org.springframework.web.bind.annotation.GetMapping; import
 * org.springframework.web.bind.annotation.ModelAttribute; import
 * org.springframework.web.bind.annotation.PostMapping; import
 * org.springframework.web.bind.annotation.RequestParam; import
 * org.springframework.web.multipart.MultipartFile;
 * 
 * import com.human.V5.entity.BordDetailEntity; import
 * com.human.V5.entity.BordEntity; import
 * com.human.V5.repository.BordRepository; import
 * com.human.V5.service.BordDetailService; import
 * com.human.V5.service.BordService;
 * 
 * import lombok.extern.slf4j.Slf4j;
 * 
 * @Controller
 * 
 * @Slf4j public class BoardController {
 * 
 * @SuppressWarnings("unused") private final BordRepository bordRepository =
 * null;
 * 
 * private final BordService bordService = null; private final BordDetailService
 * bordDetailService = null;
 * 
 * 
 * @GetMapping("/main.do") public String getMain(Model model) { BordEntity vo =
 * new BordEntity(); vo.setTitle("test"); model.addAttribute("vo",vo);
 * 
 * List<BordEntity> bordList = bordService.getAllBords();
 * model.addAttribute("bordList", bordList);
 * 
 * 
 * 
 * return "main"; }
 * 
 * @GetMapping("/bord.do") public String getBord(Model model) {
 * 
 * return "bord"; }
 * 
 * 
 * @PostMapping("/bord/save.do") public String saveBord(Model
 * model, @ModelAttribute BordEntity bord,@RequestParam("file") MultipartFile
 * file){
 * 
 * log.info("데이터 : " + bord.getTitle()); log.info("파일 : " +
 * file.getOriginalFilename());
 * 
 * bordService.saveBord(bord,file);
 * 
 * 
 * return "redirect:/bord/main.do"; }
 * 
 * 
 * @GetMapping("/bord/upLike.do") public String upLike(Model
 * model, @ModelAttribute BordDetailEntity bordDetail){
 * 
 * log.info(bordDetail.getBordSeq().toString()); bordDetail.setUserId("test");
 * log.info(bordDetail.getUserId());
 * 
 * //사용자가 좋아요를 중복했는지 먼저 확인 bordDetailService.existLikeUserId(bordDetail);
 * Optional<BordDetailEntity> bordDetailOpt =
 * bordDetailService.getBordById(bordDetail.getBordSeq());
 * 
 * if (bordDetailOpt.isPresent()) { BordEntity bord = new BordEntity();
 * BordDetailEntity existingBordDetail = bordDetailOpt.get();
 * 
 * // 중복이라면 -1 if (existingBordDetail.getLikeChk() == 1) {
 * bord.setLikeValue(bord.getLikeValue() != null ? bord.getLikeValue() - 1 :
 * -1); // 기본값 설정 bord.setBordSeq(bordDetail.getBordSeq());
 * BordService.upLike(bord); log.info("중복"); } else {
 * bord.setLikeValue(bord.getLikeValue() != null ? bord.getLikeValue() + 1 : 1);
 * // 기본값 설정 bord.setBordSeq(bordDetail.getBordSeq()); BordService.upLike(bord);
 * log.info("x"); } }
 * 
 * 
 * 
 * 
 * 
 * return "redirect:/bord/main"; }
 * 
 * }
 */