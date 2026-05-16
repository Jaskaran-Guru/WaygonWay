package com.waygonway.utils;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Component
public class JwtUtil {

    @Value("${jwt.secret:waygonway-secret-key-2025}")
    private String secretKey;

    @Value("${jwt.expiration:86400}") 
    private Long expirationTime;

    private Algorithm getAlgorithm() {
        return Algorithm.HMAC256(secretKey);
    }

    
    public String generateToken(String username, String userId, String role) {
        try {
            Date expirationDate = Date.from(
                    LocalDateTime.now()
                            .plusSeconds(expirationTime)
                            .atZone(ZoneId.systemDefault())
                            .toInstant()
            );

            return JWT.create()
                    .withSubject(username)
                    .withClaim("userId", userId)
                    .withClaim("role", role)
                    .withIssuedAt(new Date())
                    .withExpiresAt(expirationDate)
                    .withIssuer("waygonway")
                    .sign(getAlgorithm());

        } catch (Exception e) {
            throw new RuntimeException("Error generating JWT token", e);
        }
    }

    
    public boolean validateToken(String token) {
        try {
            JWTVerifier verifier = JWT.require(getAlgorithm())
                    .withIssuer("waygonway")
                    .build();

            verifier.verify(token);
            return true;

        } catch (JWTVerificationException e) {
            return false;
        }
    }

    
    public String getUsernameFromToken(String token) {
        try {
            DecodedJWT decodedJWT = JWT.decode(token);
            return decodedJWT.getSubject();
        } catch (Exception e) {
            throw new RuntimeException("Error extracting username from token", e);
        }
    }

    
    public String getUserIdFromToken(String token) {
        try {
            DecodedJWT decodedJWT = JWT.decode(token);
            return decodedJWT.getClaim("userId").asString();
        } catch (Exception e) {
            throw new RuntimeException("Error extracting userId from token", e);
        }
    }

    
    public String getRoleFromToken(String token) {
        try {
            DecodedJWT decodedJWT = JWT.decode(token);
            return decodedJWT.getClaim("role").asString();
        } catch (Exception e) {
            throw new RuntimeException("Error extracting role from token", e);
        }
    }

    
    public boolean isTokenExpired(String token) {
        try {
            DecodedJWT decodedJWT = JWT.decode(token);
            return decodedJWT.getExpiresAt().before(new Date());
        } catch (Exception e) {
            return true;
        }
    }

    
    public String extractUsername(String token) {
        return getUsernameFromToken(token);
    }

    
    public String extractUserId(String token) {
        return getUserIdFromToken(token);
    }

    
    public String extractRole(String token) {
        return getRoleFromToken(token);
    }

    
    public Date extractExpiration(String token) {
        try {
            DecodedJWT decodedJWT = JWT.decode(token);
            return decodedJWT.getExpiresAt();
        } catch (Exception e) {
            throw new RuntimeException("Error extracting expiration from token", e);
        }
    }

    
    public LocalDateTime getTokenExpiration(String token) {
        try {
            Date expirationDate = extractExpiration(token);
            return expirationDate.toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDateTime();
        } catch (Exception e) {
            throw new RuntimeException("Error getting token expiration", e);
        }
    }

    
    public long getRemainingMinutes(String token) {
        try {
            LocalDateTime expiration = getTokenExpiration(token);
            LocalDateTime now = LocalDateTime.now();

            if (expiration.isBefore(now)) {
                return 0; 
            }

            return java.time.Duration.between(now, expiration).toMinutes();
        } catch (Exception e) {
            return 0;
        }
    }

    
    public String refreshToken(String oldToken) {
        try {
            if (isTokenExpired(oldToken)) {
                throw new RuntimeException("Cannot refresh expired token");
            }

            String username = getUsernameFromToken(oldToken);
            String userId = getUserIdFromToken(oldToken);
            String role = getRoleFromToken(oldToken);

            return generateToken(username, userId, role);

        } catch (Exception e) {
            throw new RuntimeException("Error refreshing token", e);
        }
    }
}
