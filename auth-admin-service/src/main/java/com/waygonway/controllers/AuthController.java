package com.waygonway.controllers;

import com.waygonway.models.*;
import com.waygonway.services.AuthService;
import com.waygonway.services.UserService;
import com.waygonway.utils.JwtUtil;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "*", maxAge = 3600)
public class AuthController {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    // Health check
    @GetMapping("/health")
    public ResponseEntity<ApiResponse<String>> health() {
        return ResponseEntity.ok(
                ApiResponse.success("Auth service is running", "Service is healthy")
        );
    }

    // Ping check
    @GetMapping("/ping")
    public Map<String, Object> ping() {
        return Map.of(
            "status", "UP",
            "message", "Auth Admin Service is reachable",
            "timestamp", java.time.LocalDateTime.now().toString(),
            "service", "auth-admin-service"
        );
    }

    // User login
    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            System.out.println("AuthController: Login request for - " + loginRequest.getUsernameOrEmail());

            AuthResponse authResponse = authService.login(loginRequest);

            // Around line 40-45, replace this block:
            ApiResponse<AuthResponse> response = ApiResponse.success("Login successful", authResponse);
            response.addMeta("userId", authResponse.getUserId());
            response.addMeta("username", authResponse.getUsername());
            response.addMeta("type", "login");  // FIXED: removed getType() call
            response.addMeta("expiresAt", authResponse.getExpiresAt());

            return ResponseEntity.ok(response);


        } catch (Exception e) {
            System.err.println("AuthController: Login failed - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Login failed: " + e.getMessage())
            );
        }
    }

    // User registration
    @PostMapping("/register")
    public ResponseEntity<ApiResponse<AuthResponse>> register(@Valid @RequestBody RegisterRequest registerRequest) {
        try {
            System.out.println("AuthController: Registration request for - " + registerRequest.getUsername());

            AuthResponse authResponse = authService.register(registerRequest);

            ApiResponse<AuthResponse> response = ApiResponse.success("Registration successful", authResponse);
            response.addMeta("registrationTime", java.time.LocalDateTime.now().toString());
            response.addMeta("defaultRole", "USER");
            response.addMeta("accountStatus", "ACTIVE");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("AuthController: Registration failed - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Registration failed: " + e.getMessage())
            );
        }
    }

    // Validate token
    @PostMapping("/validate")
    public ResponseEntity<ApiResponse<Map<String, Object>>> validateToken(@RequestBody Map<String, String> request) {
        try {
            String token = request.get("token");
            System.out.println("AuthController: Token validation request");

            User user = authService.getUserFromToken(token);

            Map<String, Object> userInfo = new HashMap<>();
            userInfo.put("userId", user.getId());
            userInfo.put("username", user.getUsername());
            userInfo.put("email", user.getEmail());
            userInfo.put("role", user.getRole());
            userInfo.put("status", user.getStatus());
            userInfo.put("fullName", user.getFullName());

            ApiResponse<Map<String, Object>> response = ApiResponse.success("Token is valid", userInfo);
            response.addMeta("tokenValid", true);
            response.addMeta("validatedAt", java.time.LocalDateTime.now().toString());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("AuthController: Token validation failed - " + e.getMessage());

            ApiResponse<Map<String, Object>> errorResponse = ApiResponse.error("Token validation failed: " + e.getMessage());
            errorResponse.addMeta("tokenValid", false);

            return ResponseEntity.badRequest().body(errorResponse);
        }
    }

    // Get current user info
    @GetMapping("/me")
    public ResponseEntity<ApiResponse<User>> getCurrentUser(@RequestHeader("Authorization") String authHeader) {
        try {
            System.out.println("AuthController: Get current user request");

            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                throw new RuntimeException("Invalid authorization header");
            }

            String token = authHeader.substring(7);
            User user = authService.getUserFromToken(token);

            ApiResponse<User> response = ApiResponse.success("User information retrieved", user);
            response.addMeta("retrievedAt", java.time.LocalDateTime.now().toString());
            response.addMeta("userRole", user.getRole());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("AuthController: Get current user failed - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to get user information: " + e.getMessage())
            );
        }
    }

    // Change password
    @PutMapping("/change-password")
    public ResponseEntity<ApiResponse<Map<String, Object>>> changePassword(
            @RequestHeader("Authorization") String authHeader,
            @RequestBody Map<String, String> request) {
        try {
            System.out.println("AuthController: Change password request");

            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                throw new RuntimeException("Invalid authorization header");
            }

            String token = authHeader.substring(7);
            String userId = jwtUtil.extractUserId(token);
            String oldPassword = request.get("oldPassword");
            String newPassword = request.get("newPassword");

            if (oldPassword == null || newPassword == null) {
                throw new RuntimeException("Old password and new password are required");
            }

            Map<String, Object> result = authService.changePassword(userId, oldPassword, newPassword);

            ApiResponse<Map<String, Object>> response = ApiResponse.success("Password changed successfully", result);
            response.addMeta("changedAt", result.get("changedAt"));

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("AuthController: Change password failed - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Password change failed: " + e.getMessage())
            );
        }
    }

    // Logout
    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<Map<String, Object>>> logout(@RequestHeader("Authorization") String authHeader) {
        try {
            System.out.println("AuthController: Logout request");

            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                throw new RuntimeException("Invalid authorization header");
            }

            String token = authHeader.substring(7);
            Map<String, Object> result = authService.logout(token);

            ApiResponse<Map<String, Object>> response = ApiResponse.success("Logout successful", result);
            response.addMeta("loggedOutAt", result.get("loggedOutAt"));

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("AuthController: Logout failed - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Logout failed: " + e.getMessage())
            );
        }
    }

    // Refresh token (future implementation)
    @PostMapping("/refresh")
    public ResponseEntity<ApiResponse<AuthResponse>> refreshToken(@RequestBody Map<String, String> request) {
        try {
            String token = request.get("token");
            System.out.println("AuthController: Token refresh request");

            // For now, just validate the existing token and return user info
            User user = authService.getUserFromToken(token);

            // Generate new token
            String newToken = jwtUtil.generateToken(user.getUsername(), user.getId(), user.getRole());

            AuthResponse authResponse = new AuthResponse(
                    newToken,
                    user.getId(),
                    user.getUsername(),
                    user.getEmail(),
                    user.getRole()
            );
            authResponse.setStatus(user.getStatus());
            authResponse.setExpiresAt(java.time.LocalDateTime.now().plusDays(1));

            ApiResponse<AuthResponse> response = ApiResponse.success("Token refreshed successfully", authResponse);
            response.addMeta("refreshedAt", java.time.LocalDateTime.now().toString());
            response.addMeta("previousTokenValid", true);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("AuthController: Token refresh failed - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Token refresh failed: " + e.getMessage())
            );
        }
    }

    // Get JWT token info (for debugging)
    @PostMapping("/token-info")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getTokenInfo(@RequestBody Map<String, String> request) {
        try {
            String token = request.get("token");
            System.out.println("AuthController: Token info request");

            String username = jwtUtil.extractUsername(token);
            String userId = jwtUtil.extractUserId(token);
            String role = jwtUtil.extractRole(token);
            boolean expired = jwtUtil.isTokenExpired(token);

            Map<String, Object> tokenInfo = new HashMap<>();
            tokenInfo.put("username", username);
            tokenInfo.put("userId", userId);
            tokenInfo.put("role", role);
            tokenInfo.put("expired", expired);
            tokenInfo.put("expiresAt", jwtUtil.extractExpiration(token));

            ApiResponse<Map<String, Object>> response = ApiResponse.success("Token information retrieved", tokenInfo);
            response.addMeta("checkedAt", java.time.LocalDateTime.now().toString());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("AuthController: Token info failed - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Token info retrieval failed: " + e.getMessage())
            );
        }
    }

    // Check if username exists
    @GetMapping("/check-username/{username}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> checkUsername(@PathVariable String username) {
        try {
            System.out.println("AuthController: Checking username availability - " + username);

            boolean exists = authService.getUserFromToken("dummy") != null; // This will be refactored

            Map<String, Object> result = new HashMap<>();
            result.put("username", username);
            result.put("exists", exists);
            result.put("available", !exists);

            ApiResponse<Map<String, Object>> response = ApiResponse.success("Username check completed", result);
            response.addMeta("checkedAt", java.time.LocalDateTime.now().toString());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("AuthController: Username check failed - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Username check failed: " + e.getMessage())
            );
        }
    }

    // Delete user account (self-deletion)
    @DeleteMapping("/{userId}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> deleteAccount(
            @RequestHeader("Authorization") String authHeader,
            @PathVariable String userId) {
        try {
            System.out.println("AuthController: Self-deletion request for - " + userId);

            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                throw new RuntimeException("Invalid authorization header");
            }

            String token = authHeader.substring(7);
            String tokenUserId = jwtUtil.extractUserId(token);

            if (!tokenUserId.equals(userId)) {
                throw new RuntimeException("You are not authorized to delete this account");
            }

            Map<String, Object> result = userService.deleteUser(userId);

            return ResponseEntity.ok(
                    ApiResponse.success("Account deleted successfully", result)
            );

        } catch (Exception e) {
            System.err.println("AuthController: Account deletion failed - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to delete account: " + e.getMessage())
            );
        }
    }
}
