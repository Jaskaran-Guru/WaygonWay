package com.database.controllers;

import com.database.models.ApiResponse;
import com.database.models.User;
import com.database.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/users")
@CrossOrigin(origins = "*", maxAge = 3600)
public class UserController {

    @Autowired
    private UserService userService;

    // Health check
    @GetMapping("/health")
    public ResponseEntity<ApiResponse<String>> health() {
        return ResponseEntity.ok(
                ApiResponse.success("Database service is running", "User service is healthy")
        );
    }

    // Get all users
    @GetMapping
    public ResponseEntity<ApiResponse<List<User>>> getAllUsers() {
        try {
            System.out.println("UserController: Getting all users");

            List<User> users = userService.getAllUsers();

            ApiResponse<List<User>> response = ApiResponse.success("Users retrieved successfully", users);
            response.addMeta("totalCount", users.size());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("UserController: Error getting users - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to retrieve users: " + e.getMessage())
            );
        }
    }

    // Get user by ID
    @GetMapping("/{userId}")
    public ResponseEntity<ApiResponse<User>> getUserById(@PathVariable String userId) {
        try {
            System.out.println("UserController: Getting user by ID - " + userId);

            User user = userService.getUserById(userId);

            return ResponseEntity.ok(
                    ApiResponse.success("User retrieved successfully", user)
            );

        } catch (Exception e) {
            System.err.println("UserController: Error getting user - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to retrieve user: " + e.getMessage())
            );
        }
    }

    // Search users
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<User>>> searchUsers(@RequestParam String query) {
        try {
            System.out.println("UserController: Searching users - " + query);

            List<User> users = userService.searchUsers(query);

            ApiResponse<List<User>> response = ApiResponse.success("Search completed successfully", users);
            response.addMeta("query", query);
            response.addMeta("resultCount", users.size());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("UserController: Search error - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Search failed: " + e.getMessage())
            );
        }
    }

    // Get users by status
    @GetMapping("/status/{status}")
    public ResponseEntity<ApiResponse<List<User>>> getUsersByStatus(@PathVariable String status) {
        try {
            System.out.println("UserController: Getting users by status - " + status);

            List<User> users = userService.getUsersByStatus(status);

            ApiResponse<List<User>> response = ApiResponse.success("Users retrieved successfully", users);
            response.addMeta("status", status);
            response.addMeta("count", users.size());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("UserController: Error getting users by status - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to retrieve users: " + e.getMessage())
            );
        }
    }

    // Get user statistics
    @GetMapping("/statistics")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getUserStatistics() {
        try {
            System.out.println("UserController: Getting user statistics");

            Map<String, Object> stats = userService.getUserStatistics();

            ApiResponse<Map<String, Object>> response = ApiResponse.success("Statistics retrieved successfully", stats);
            response.addMeta("generatedAt", stats.get("generatedAt"));

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("UserController: Statistics error - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to retrieve statistics: " + e.getMessage())
            );
        }
    }
}
