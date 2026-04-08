package com.database.services;

import com.database.models.User;
import com.database.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    // Get all users
    public List<User> getAllUsers() {
        try {
            System.out.println("UserService: Getting all users");
            List<User> users = userRepository.findAll();
            System.out.println("UserService: Retrieved " + users.size() + " users");
            return users;
        } catch (Exception e) {
            System.err.println("UserService: Error getting all users - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve users", e);
        }
    }

    // Get user by ID
    public User getUserById(String userId) {
        try {
            System.out.println("UserService: Getting user by ID - " + userId);

            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isEmpty()) {
                throw new RuntimeException("User not found with ID: " + userId);
            }

            User user = userOpt.get();
            System.out.println("UserService: User found - " + user.getUsername());
            return user;
        } catch (Exception e) {
            System.err.println("UserService: Error getting user by ID - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve user", e);
        }
    }

    // Search users
    public List<User> searchUsers(String query) {
        try {
            System.out.println("UserService: Searching users with query - " + query);

            List<User> users = userRepository.searchUsers(query);

            System.out.println("UserService: Search completed - Found " + users.size() + " users");
            return users;
        } catch (Exception e) {
            System.err.println("UserService: Error searching users - " + e.getMessage());
            throw new RuntimeException("Failed to search users", e);
        }
    }

    // Get users by status
    public List<User> getUsersByStatus(String status) {
        try {
            System.out.println("UserService: Getting users by status - " + status);

            List<User> users = userRepository.findByStatus(status.toUpperCase());

            System.out.println("UserService: Retrieved " + users.size() + " users with status " + status);
            return users;
        } catch (Exception e) {
            System.err.println("UserService: Error getting users by status - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve users by status", e);
        }
    }

    // Get active users - FIXED
    public List<User> getActiveUsers() {
        try {
            System.out.println("UserService: Getting active users");

            List<User> users = userRepository.findActiveUsers(); // Using correct method

            System.out.println("UserService: Retrieved " + users.size() + " active users");
            return users;
        } catch (Exception e) {
            System.err.println("UserService: Error getting active users - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve active users", e);
        }
    }

    // Get users created today - FIXED
    public List<User> getUsersCreatedToday() {
        try {
            System.out.println("UserService: Getting users created today");

            LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
            LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);

            List<User> users = userRepository.findUsersCreatedBetween(startOfDay, endOfDay); // Using correct method

            System.out.println("UserService: Retrieved " + users.size() + " users created today");
            return users;
        } catch (Exception e) {
            System.err.println("UserService: Error getting today's users - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve today's users", e);
        }
    }

    // Get user statistics
    public Map<String, Object> getUserStatistics() {
        try {
            System.out.println("UserService: Calculating user statistics");

            List<User> allUsers = getAllUsers();

            Map<String, Object> stats = new HashMap<>();
            stats.put("totalUsers", allUsers.size());
            stats.put("activeUsers", allUsers.stream().filter(u -> "ACTIVE".equals(u.getStatus())).count());
            stats.put("inactiveUsers", allUsers.stream().filter(u -> "INACTIVE".equals(u.getStatus())).count());
            stats.put("suspendedUsers", allUsers.stream().filter(u -> "SUSPENDED".equals(u.getStatus())).count());
            stats.put("adminUsers", allUsers.stream().filter(u -> "ADMIN".equals(u.getRole())).count());
            stats.put("regularUsers", allUsers.stream().filter(u -> "USER".equals(u.getRole())).count());

            // Today's registrations
            List<User> todaysUsers = getUsersCreatedToday();
            stats.put("todaysRegistrations", todaysUsers.size());

            stats.put("generatedAt", LocalDateTime.now());

            System.out.println("UserService: Statistics calculated successfully");
            return stats;
        } catch (Exception e) {
            System.err.println("UserService: Error calculating statistics - " + e.getMessage());
            throw new RuntimeException("Failed to calculate statistics", e);
        }
    }

    // Check if user exists by username
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    // Check if user exists by email
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }
}
