package com.waygonway.services;

import com.waygonway.models.User;
import com.waygonway.models.AuthResponse;
import com.waygonway.models.LoginRequest;
import com.waygonway.models.RegisterRequest;
import com.waygonway.repositories.UserRepository;
import com.waygonway.utils.PasswordUtil;
import com.waygonway.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordUtil passwordUtil;

    @Autowired
    private JwtUtil jwtUtil;

    // Enhanced login with complete data tracking
    public AuthResponse login(LoginRequest loginRequest, String sessionId, String ipAddress, String userAgent) {
        try {
            System.out.println("AuthService: Enhanced login attempt for - " + loginRequest.getUsernameOrEmail());

            Optional<User> userOpt = userRepository.findByUsernameOrEmail(
                    loginRequest.getUsernameOrEmail(),
                    loginRequest.getUsernameOrEmail()
            );

            if (userOpt.isEmpty()) {
                throw new RuntimeException("User not found");
            }

            User user = userOpt.get();

            if (!"ACTIVE".equals(user.getStatus())) {
                throw new RuntimeException("Account is " + user.getStatus().toLowerCase());
            }

            if (!passwordUtil.verifyPassword(loginRequest.getPassword(), user.getPassword())) {
                throw new RuntimeException("Invalid credentials");
            }

            // Update login history with complete data
            user.updateLoginHistory(sessionId, ipAddress, userAgent);
            user.setUpdatedAt(LocalDateTime.now());

            // Save updated user with login history
            userRepository.save(user);

            String token = jwtUtil.generateToken(user.getUsername(), user.getId(), user.getRole());

            AuthResponse authResponse = new AuthResponse(
                    token,
                    user.getId(),
                    user.getUsername(),
                    user.getEmail(),
                    user.getRole()
            );
            authResponse.setStatus(user.getStatus());
            authResponse.setExpiresAt(LocalDateTime.now().plusDays(1));

            System.out.println("AuthService: Enhanced login successful for - " + user.getUsername());
            return authResponse;

        } catch (Exception e) {
            System.err.println("AuthService: Enhanced login failed - " + e.getMessage());
            throw new RuntimeException("Login failed: " + e.getMessage(), e);
        }
    }

    // Enhanced registration with complete profile setup
    public AuthResponse register(RegisterRequest registerRequest, String sessionId, String ipAddress, String userAgent) {
        try {
            System.out.println("AuthService: Enhanced registration attempt for - " + registerRequest.getUsername());

            if (userRepository.existsByUsername(registerRequest.getUsername())) {
                throw new RuntimeException("Username already exists");
            }

            if (userRepository.existsByEmail(registerRequest.getEmail())) {
                throw new RuntimeException("Email already exists");
            }

            // Create complete user profile
            User newUser = new User();
            newUser.setUsername(registerRequest.getUsername());
            newUser.setEmail(registerRequest.getEmail());
            newUser.setPassword(passwordUtil.hashPassword(registerRequest.getPassword()));
            newUser.setFirstName(registerRequest.getFirstName());
            newUser.setLastName(registerRequest.getLastName());
            newUser.setPhone(registerRequest.getPhone());
            newUser.setRole("USER");
            newUser.setStatus("ACTIVE");

            // Set complete address
            if (registerRequest.getCity() != null || registerRequest.getState() != null) {
                User.Address address = new User.Address();
                address.setCity(registerRequest.getCity());
                address.setState(registerRequest.getState());
                address.setCountry("India");
                newUser.setAddress(address);
            }

            // Initialize preferences with defaults
            User.UserPreferences preferences = new User.UserPreferences();
            preferences.setPreferredLanguage("English");
            preferences.setCurrency("INR");
            preferences.setEmailNotifications(true);
            preferences.setSmsNotifications(true);
            newUser.setPreferences(preferences);

            // Initialize profile data
            User.ProfileData profile = new User.ProfileData();
            profile.setNationality("Indian");
            newUser.setProfile(profile);

            // Record initial login
            newUser.updateLoginHistory(sessionId, ipAddress, userAgent);

            // Save complete user profile
            User savedUser = userRepository.save(newUser);

            String token = jwtUtil.generateToken(savedUser.getUsername(), savedUser.getId(), savedUser.getRole());

            AuthResponse authResponse = new AuthResponse(
                    token,
                    savedUser.getId(),
                    savedUser.getUsername(),
                    savedUser.getEmail(),
                    savedUser.getRole()
            );
            authResponse.setStatus(savedUser.getStatus());
            authResponse.setExpiresAt(LocalDateTime.now().plusDays(1));

            System.out.println("AuthService: Enhanced registration successful for - " + savedUser.getUsername());
            return authResponse;

        } catch (Exception e) {
            System.err.println("AuthService: Enhanced registration failed - " + e.getMessage());
            throw new RuntimeException("Registration failed: " + e.getMessage(), e);
        }
    }

    // Get user from token
    public User getUserFromToken(String token) {
        try {
            System.out.println("AuthService: Getting user from token");

            String userId = jwtUtil.getUserIdFromToken(token);

            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isEmpty()) {
                throw new RuntimeException("User not found");
            }

            User user = userOpt.get();
            System.out.println("AuthService: User found - " + user.getUsername());
            return user;

        } catch (Exception e) {
            System.err.println("AuthService: Error getting user from token - " + e.getMessage());
            throw new RuntimeException("Failed to get user from token", e);
        }
    }

    // Change password
    public Map<String, Object> changePassword(String userId, String oldPassword, String newPassword) {
        try {
            System.out.println("AuthService: Changing password for user - " + userId);

            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isEmpty()) {
                throw new RuntimeException("User not found");
            }

            User user = userOpt.get();

            // Verify old password
            if (!passwordUtil.verifyPassword(oldPassword, user.getPassword())) {
                throw new RuntimeException("Current password is incorrect");
            }

            // Hash and set new password
            user.setPassword(passwordUtil.hashPassword(newPassword));
            user.setUpdatedAt(LocalDateTime.now());

            userRepository.save(user);

            Map<String, Object> response = Map.of(
                    "success", true,
                    "message", "Password changed successfully",
                    "userId", userId,
                    "updatedAt", user.getUpdatedAt()
            );

            System.out.println("AuthService: Password changed successfully for - " + user.getUsername());
            return response;

        } catch (Exception e) {
            System.err.println("AuthService: Error changing password - " + e.getMessage());
            throw new RuntimeException("Failed to change password: " + e.getMessage(), e);
        }
    }

    // Logout user
    public Map<String, Object> logout(String token) {
        try {
            System.out.println("AuthService: Processing logout");

            // Get user from token
            User user = getUserFromToken(token);

            // Update login history - set currently logged in to false
            if (user.getLoginHistory() != null) {
                user.getLoginHistory().setCurrentlyLoggedIn(false);

                // Update last session logout time
                if (user.getLoginHistory().getRecentLogins() != null &&
                        !user.getLoginHistory().getRecentLogins().isEmpty()) {

                    User.LoginHistory.LoginSession lastSession = user.getLoginHistory().getRecentLogins().get(0);
                    lastSession.setLogoutTime(LocalDateTime.now());
                }
            }

            user.setUpdatedAt(LocalDateTime.now());
            userRepository.save(user);

            Map<String, Object> response = Map.of(
                    "success", true,
                    "message", "Logged out successfully",
                    "username", user.getUsername(),
                    "logoutTime", LocalDateTime.now()
            );

            System.out.println("AuthService: Logout successful for - " + user.getUsername());
            return response;

        } catch (Exception e) {
            System.err.println("AuthService: Error during logout - " + e.getMessage());
            throw new RuntimeException("Logout failed: " + e.getMessage(), e);
        }
    }

    // Update user profile completely
    public User updateUserProfile(String userId, Map<String, Object> profileData) {
        try {
            System.out.println("AuthService: Updating complete user profile - " + userId);

            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isEmpty()) {
                throw new RuntimeException("User not found");
            }

            User user = userOpt.get();

            // Update basic info
            if (profileData.containsKey("firstName")) {
                user.setFirstName((String) profileData.get("firstName"));
            }
            if (profileData.containsKey("lastName")) {
                user.setLastName((String) profileData.get("lastName"));
            }
            if (profileData.containsKey("phone")) {
                user.setPhone((String) profileData.get("phone"));
            }

            // Update address
            if (profileData.containsKey("address")) {
                @SuppressWarnings("unchecked")
                Map<String, String> addressData = (Map<String, String>) profileData.get("address");

                User.Address address = user.getAddress();
                if (address == null) {
                    address = new User.Address();
                }

                if (addressData.get("street") != null) address.setStreet(addressData.get("street"));
                if (addressData.get("city") != null) address.setCity(addressData.get("city"));
                if (addressData.get("state") != null) address.setState(addressData.get("state"));
                if (addressData.get("country") != null) address.setCountry(addressData.get("country"));
                if (addressData.get("zipCode") != null) address.setZipCode(addressData.get("zipCode"));
                if (addressData.get("landmark") != null) address.setLandmark(addressData.get("landmark"));

                user.setAddress(address);
            }

            // Update preferences
            if (profileData.containsKey("preferences")) {
                @SuppressWarnings("unchecked")
                Map<String, Object> prefData = (Map<String, Object>) profileData.get("preferences");

                User.UserPreferences prefs = user.getPreferences();
                if (prefs == null) {
                    prefs = new User.UserPreferences();
                }

                if (prefData.containsKey("preferredLanguage")) {
                    prefs.setPreferredLanguage((String) prefData.get("preferredLanguage"));
                }
                if (prefData.containsKey("seatPreference")) {
                    prefs.setSeatPreference((String) prefData.get("seatPreference"));
                }
                if (prefData.containsKey("mealPreference")) {
                    prefs.setMealPreference((String) prefData.get("mealPreference"));
                }
                if (prefData.containsKey("emailNotifications")) {
                    prefs.setEmailNotifications((Boolean) prefData.get("emailNotifications"));
                }
                if (prefData.containsKey("smsNotifications")) {
                    prefs.setSmsNotifications((Boolean) prefData.get("smsNotifications"));
                }

                user.setPreferences(prefs);
            }

            // Update profile data
            if (profileData.containsKey("profile")) {
                @SuppressWarnings("unchecked")
                Map<String, Object> profData = (Map<String, Object>) profileData.get("profile");

                User.ProfileData profile = user.getProfile();
                if (profile == null) {
                    profile = new User.ProfileData();
                }

                if (profData.containsKey("bio")) {
                    profile.setBio((String) profData.get("bio"));
                }
                if (profData.containsKey("occupation")) {
                    profile.setOccupation((String) profData.get("occupation"));
                }
                if (profData.containsKey("gender")) {
                    profile.setGender((String) profData.get("gender"));
                }
                if (profData.containsKey("emergencyContact")) {
                    profile.setEmergencyContact((String) profData.get("emergencyContact"));
                }
                if (profData.containsKey("emergencyContactName")) {
                    profile.setEmergencyContactName((String) profData.get("emergencyContactName"));
                }

                user.setProfile(profile);
            }

            user.setUpdatedAt(LocalDateTime.now());
            User savedUser = userRepository.save(user);

            System.out.println("AuthService: Complete user profile updated - " + savedUser.getUsername());
            return savedUser;

        } catch (Exception e) {
            System.err.println("AuthService: Error updating user profile - " + e.getMessage());
            throw new RuntimeException("Failed to update user profile", e);
        }
    }

    // Validate token and get user
    public User validateTokenAndGetUser(String token) {
        try {
            System.out.println("AuthService: Validating token and getting user");

            if (!jwtUtil.validateToken(token)) {
                throw new RuntimeException("Invalid or expired token");
            }

            return getUserFromToken(token);

        } catch (Exception e) {
            System.err.println("AuthService: Token validation failed - " + e.getMessage());
            throw new RuntimeException("Token validation failed", e);
        }
    }

    // Get all users (for admin)
    public List<User> getAllUsers() {
        try {
            System.out.println("AuthService: Getting all users");
            List<User> users = userRepository.findAll();
            System.out.println("AuthService: Retrieved " + users.size() + " users");
            return users;
        } catch (Exception e) {
            System.err.println("AuthService: Error getting all users - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve users", e);
        }
    }

    // Search users
    public List<User> searchUsers(String query) {
        try {
            System.out.println("AuthService: Searching users - " + query);
            List<User> users = userRepository.searchUsers(query);
            System.out.println("AuthService: Search completed - Found " + users.size() + " users");
            return users;
        } catch (Exception e) {
            System.err.println("AuthService: Error searching users - " + e.getMessage());
            throw new RuntimeException("Failed to search users", e);
        }
    }

    // Get user statistics
    public Map<String, Object> getUserStatistics() {
        try {
            System.out.println("AuthService: Calculating user statistics");

            List<User> allUsers = getAllUsers();

            Map<String, Object> stats = new HashMap<>();
            stats.put("totalUsers", allUsers.size());
            stats.put("activeUsers", allUsers.stream().filter(User::isActive).count());
            stats.put("adminUsers", allUsers.stream().filter(User::isAdmin).count());
            stats.put("regularUsers", allUsers.stream().filter(u -> !u.isAdmin()).count());

            // Users registered today
            LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
            LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);

            long todaysUsers = allUsers.stream()
                    .filter(u -> u.getCreatedAt().isAfter(startOfDay) && u.getCreatedAt().isBefore(endOfDay))
                    .count();
            stats.put("todaysRegistrations", todaysUsers);

            // Currently logged in users
            long loggedInUsers = allUsers.stream()
                    .filter(u -> u.getLoginHistory() != null && u.getLoginHistory().isCurrentlyLoggedIn())
                    .count();
            stats.put("currentlyLoggedIn", loggedInUsers);

            stats.put("generatedAt", LocalDateTime.now());

            System.out.println("AuthService: Statistics calculated successfully");
            return stats;

        } catch (Exception e) {
            System.err.println("AuthService: Error calculating statistics - " + e.getMessage());
            throw new RuntimeException("Failed to calculate statistics", e);
        }
    }

    // Simple login method (backward compatibility)
    public AuthResponse login(LoginRequest loginRequest) {
        return login(loginRequest, "WEB-SESSION", "127.0.0.1", "WebApp");
    }

    // Simple registration method (backward compatibility)
    public AuthResponse register(RegisterRequest registerRequest) {
        return register(registerRequest, "WEB-SESSION", "127.0.0.1", "WebApp");
    }
}
