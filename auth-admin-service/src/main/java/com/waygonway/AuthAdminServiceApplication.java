package com.waygonway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;
import java.util.Arrays;
import jakarta.annotation.PostConstruct; // FIXED: jakarta instead of javax

@SpringBootApplication
public class AuthAdminServiceApplication {

    public static void main(String[] args) {
        System.out.println("Starting WaygonWay Auth Admin Service...");
        SpringApplication.run(AuthAdminServiceApplication.class, args);
        System.out.println("WaygonWay Auth Admin Service started successfully!");
    }

    @PostConstruct // NOW WORKS
    public void init() {
        System.out.println("Initializing Auth Admin Service...");
        System.out.println("Service: WaygonWay Auth Admin Service");
        System.out.println("Features: JWT Authentication, User Management, Admin Panel");
        System.out.println("Database: MongoDB");
        System.out.println("Status: Ready to serve requests");
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        System.out.println("Creating BCrypt Password Encoder bean");
        return new BCryptPasswordEncoder(12);
    }

    @Bean
    public CorsFilter corsFilter() {
        System.out.println("Configuring CORS Filter");

        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);
        config.setAllowedOriginPatterns(Arrays.asList("*"));
        config.setAllowedHeaders(Arrays.asList("*"));
        config.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"));
        config.setExposedHeaders(Arrays.asList("Authorization"));

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);

        return new CorsFilter(source);
    }
}
