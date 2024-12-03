package com.human.V5.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
        try {
            // MimeMessage 객체 생성
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

            // 수신자 설정
            helper.setTo(email);
            // 제목 설정
            helper.setSubject("이메일 인증 코드");

            String htmlContent = "<html>" +
                    "<body style='font-family: Arial, sans-serif; line-height: 1.6;'>" +
                    "<div style='max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;'>" +
                    "<h2 style='color: #464B79;'>안녕하세요! 카플래닛을 이용해주셔서 감사합니다.</h2>" +
                    "<p>아래 코드를 사용하여 이메일 인증을 완료해주세요:</p>" +
                    "<div style='background-color: #f9f9f9; padding: 10px; border: 1px dashed #ddd; border-radius: 5px; text-align: center;'>" +
                    "<h1 style='color: #333;'>" + verificationCode + "</h1>" +
                    "</div>" +
                    "<p>이 코드는 <b>10분</b> 동안만 유효합니다.</p>" +
                    "<p>감사합니다.<br><b>CarPlanet</b> 팀</p>" +
                    "<hr style='border: none; border-top: 1px solid #ddd;'>" +
                    "<p style='font-size: 12px; color: #999;'>본 이메일은 발신 전용입니다. 문의 사항은 support@carplanet.com으로 연락해주세요.</p>" +
                    "</div>" +
                    "</body>" +
                    "</html>";

            helper.setText(htmlContent, true);

            // 이메일 전송
            mailSender.send(mimeMessage);

        } catch (MessagingException e) {
            e.printStackTrace();
            System.err.println("이메일 전송 중 오류 발생: " + e.getMessage());
        }
    }
    
    // 인증 코드 확인 메서드
    public boolean verifyCode(String email, String code) {
        // 입력한 인증 코드와 저장된 인증 코드 비교
        return code.equals(verificationCodes.get(email));
    }

	@Override
	public UserEntity findByCarIdAndCarPw(String carId, String carPw) {
		return repository.findByCarIdAndCarPw(carId, carPw);
	}

	@Override
	public UserEntity findByKakaoId(String kakaoId) {
		 return repository.findByCarId(kakaoId);
	}

	@Override
	public UserEntity findByGoogleId(String googleId) {
		// TODO Auto-generated method stub
		return repository.findByCarId(googleId);
	}

	@Override
	public List<UserEntity> findByNameAndEmail(String name, String email) {
		// TODO Auto-generated method stub
		return repository.findByCarNameAndEmail(name, email);
	}
	
	@Override
	public UserEntity findByIdAndEmail(String id, String email) {
	    return repository.findByCarIdAndEmail(id, email);
	}

	@Override
	public String generateTemporaryPassword() {
	    int length = 8; // 임시 비밀번호 길이
	    String charSet = "0123456789";
	    StringBuilder password = new StringBuilder();
	    Random random = new Random();

	    for (int i = 0; i < length; i++) {
	        int index = random.nextInt(charSet.length());
	        password.append(charSet.charAt(index));
	    }

	    return password.toString();
	}

	@Transactional
	@Override
	public void updatePassword(String id, String tempPassword) {
	    UserEntity user = repository.findByCarId(id);

	    if (user != null) {
	        user.updatePassword(tempPassword); // 커스텀 메서드 사용
	    }
	}

	@Override
	public void sendTemporaryPasswordEmail(String email, String tempPassword) {
	    try {
	        MimeMessage mimeMessage = mailSender.createMimeMessage();
	        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

	        helper.setTo(email);
	        helper.setSubject("임시 비밀번호 발급");
	        
	        String htmlContent = "<html>" +
	                "<body style='font-family: Arial, sans-serif; line-height: 1.6;'>" +
	                "<div style='max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;'>" +
	                "<h2 style='color: #464B79;'>안녕하세요! 카플래닛을 이용해주셔서 감사합니다.</h2>" +
	                "<p>임시 비밀번호가 발급되었습니다:</p>" +
	                "<div style='background-color: #f9f9f9; padding: 10px; border: 1px dashed #ddd; border-radius: 5px; text-align: center;'>" +
	                "<h1 style='color: #333;'>" + tempPassword + "</h1>" +
	                "</div>" +
	                "<p>로그인 후 반드시 비밀번호를 변경해주세요.</p>" +
	                "<p>감사합니다.<br><b>CarPlanet</b> 팀</p>" +
	                "<hr style='border: none; border-top: 1px solid #ddd;'>" +
	                "<p style='font-size: 12px; color: #999;'>본 이메일은 발신 전용입니다. 문의 사항은 support@carplanet.com으로 연락해주세요.</p>" +
	                "</div>" +
	                "</body>" +
	                "</html>";

	        helper.setText(htmlContent, true);

	        mailSender.send(mimeMessage);

	    } catch (MessagingException e) {
	        e.printStackTrace();
	        System.err.println("임시 비밀번호 이메일 전송 중 오류 발생: " + e.getMessage());
	    }
	}

	@Override
	public boolean existsByCarNickname(String carNickname) {
		// TODO Auto-generated method stub
		return repository.existsByCarNickname(carNickname);
	}

	@Override
	public UserEntity findByCarId(String carId) {
		// TODO Auto-generated method stub
		return repository.findByCarId(carId);
	}

	@Override
	public void updateUser(UserEntity userEntity) {
		repository.save(userEntity);		
	}

	@Override
	public UserEntity findByCarIdAndCarPwAndCarStatusIn(String carId, String carPw, List<Integer> carStatusList) {
		// TODO Auto-generated method stub
		return repository.findByCarIdAndCarPwAndCarStatusIn(carId, carPw, carStatusList);
	}

	@Override
    @Transactional
    public void updateStatus(String carIdx, int status) {
        // 1. carIdx를 int로 변환
        int id = Integer.parseInt(carIdx);

        // 2. carIdx로 UserEntity 조회
        UserEntity userEntity = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        // 3. carStatus 값 업데이트
        userEntity.setUserStatus(status);

        // 4. 변경된 엔티티 저장
        repository.save(userEntity);
    }

	
}
