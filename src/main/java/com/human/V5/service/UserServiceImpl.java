package com.human.V5.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.human.V5.entity.UserEntity;
import com.human.V5.repository.UserRepository;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class UserServiceImpl implements UserService {

    private UserRepository repository;
    private final JavaMailSender mailSender;
    
    // 인증 코드 저장을 위한 임시 저장소
    private Map<String, String> verificationCodes = new HashMap<>();

    @Override
    public UserEntity save(UserEntity vo) {
        return repository.save(vo);
    }

    @Override
    public int countByCarId(String carId) {
        return repository.countByCarId(carId);
    }

    @Override
    public String authEmail(String email) {
        // 인증 코드 생성
        String verificationCode = generateVerificationCode();

        // 인증 코드 저장 (임시로 Map에 저장, 필요 시 DB 또는 캐시 사용)
        verificationCodes.put(email, verificationCode);

        // 이메일 전송
        sendEmail(email, verificationCode);

        return "SUCCESS"; // 성공 상태 반환
    }

    // 인증 코드 생성 메서드
    private String generateVerificationCode() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(1000000)); // 6자리 랜덤 숫자
    }

    // 이메일 전송 메서드
    private void sendEmail(String email, String verificationCode) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("이메일 인증 코드");
        message.setText("인증 코드: " + verificationCode);
        
        mailSender.send(message);
    }
    
    // 인증 코드 확인 메서드
    public boolean verifyCode(String email, String code) {
        // 입력한 인증 코드와 저장된 인증 코드 비교
        return code.equals(verificationCodes.get(email));
    }

	@Override
	public UserEntity findByCarIdAndCarPwAndCarstatus(String carId, String carPw, int i) {
		return repository.findByCarIdAndCarPwAndCarstatus(carId, carPw, 1);
	}
}
