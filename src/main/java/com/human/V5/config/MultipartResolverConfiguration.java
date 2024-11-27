package com.human.V5.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

@Configuration
public class MultipartResolverConfiguration {
//r깃
  @Bean
  public CommonsMultipartResolver multipartResolver() {
    CommonsMultipartResolver resolver = new CommonsMultipartResolver();
    resolver.setDefaultEncoding("UTF-8"); // 인코딩 설정
    resolver.setMaxUploadSize(10 * 1024 * 1024); // 최대 업로드 크기 10MB
    return resolver;
  }
}
