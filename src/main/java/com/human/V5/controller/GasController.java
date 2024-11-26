package com.human.V5.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

@Controller
@RequestMapping("/Gas") // 공통 URL 정의
public class GasController {
	
	
	@GetMapping("Gasmap.do")
	public String Gas() {
		return "GAS_Map/gasmap";
	}
	
	// 오피넷 API 호출 메서드 추가
    @GetMapping("/getNearbyStations")
    @ResponseBody
    public ResponseEntity<String> getNearbyStations(
            @RequestParam double x,
            @RequestParam double y,
            @RequestParam int radius,
            @RequestParam int sort,
            @RequestParam String prodcd) {

        String apiUrl = String.format(
                "https://www.opinet.co.kr/api/aroundAll.do?code=F241121473&x=%f&y=%f&radius=%d&sort=%d&prodcd=%s&out=json",
                x, y, radius, sort, prodcd
        );

        RestTemplate restTemplate = new RestTemplate();
        try {
            String response = restTemplate.getForObject(apiUrl, String.class);
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .body(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("API 호출 실패");
        }
    }
    
    @GetMapping("/getStationDetails")
    @ResponseBody
    public ResponseEntity<String> getStationDetails(@RequestParam String id) {
        String apiUrl = String.format(
            "https://www.opinet.co.kr/api/detailById.do?code=F241121473&id=%s&out=json", id
        );

        RestTemplate restTemplate = new RestTemplate();
        try {
            String response = restTemplate.getForObject(apiUrl, String.class);
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .body(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("API 호출 실패");
        }
    }
    
    
}
