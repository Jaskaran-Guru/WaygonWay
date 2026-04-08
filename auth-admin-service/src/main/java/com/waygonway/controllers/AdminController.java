package com.waygonway.controllers;

import com.waygonway.models.ApiResponse;
import com.waygonway.models.User;
import com.waygonway.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/admin")
@CrossOrigin(origins = "*", maxAge = 3600)
public class AdminController {

    @Autowired
    private UserService userService;

    // Get all users
    @GetMapping("/users")
    public ResponseEntity<ApiResponse<List<User>>> getAllUsers() {
        try {
            System.out.println("AdminController: Getting all users");

            List<User> users = userService.getAllUsers();

            ApiResponse<List<User>> response = ApiResponse.success("Users retrieved successfully", users);
            response.addMeta("totalUsers", users.size());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("AdminController: Error getting users - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to retrieve users: " + e.getMessage())
            );
        }
    }

    // Get users with pagination
    @GetMapping("/users/paged")
    public ResponseEntity<ApiResponse<org.springframework.data.domain.Page<User>>> getUsersPaged(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String sortBy,
            @RequestParam(defaultValue = "asc") String sortDir) {
        try {
            System.out.println("AdminController: Getting paged users - Page: " + page + ", Size: " + size);

            org.springframework.data.domain.Page<User> users = userService.getUsersWithPagination(page, size, sortBy, sortDir);

            return ResponseEntity.ok(
                    ApiResponse.success("Paged users retrieved successfully", users)
            );

        } catch (Exception e) {
            System.err.println("AdminController: Paged users error - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to retrieve paged users: " + e.getMessage())
            );
        }
    }

    // Get user statistics
    @GetMapping("/statistics")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getUserStatistics() {
        try {
            System.out.println("AdminController: Getting user statistics");

            Map<String, Object> stats = userService.getUserStatistics();

            return ResponseEntity.ok(
                    ApiResponse.success("Statistics retrieved successfully", stats)
            );

        } catch (Exception e) {
            System.err.println("AdminController: Statistics error - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to retrieve statistics: " + e.getMessage())
            );
        }
    }

    // Update user status
    @PutMapping("/users/{userId}/status")
    public ResponseEntity<ApiResponse<User>> updateUserStatus(
            @PathVariable String userId,
            @RequestBody Map<String, String> request) {
        try {
            String status = request.get("status");
            System.out.println("AdminController: Updating user status - " + userId + " to " + status);

            User user = userService.updateUserStatus(userId, status);

            return ResponseEntity.ok(
                    ApiResponse.success("User status updated successfully", user)
            );

        } catch (Exception e) {
            System.err.println("AdminController: Update status error - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to update user status: " + e.getMessage())
            );
        }
    }

    // Update user role
    @PutMapping("/users/{userId}/role")
    public ResponseEntity<ApiResponse<User>> updateUserRole(
            @PathVariable String userId,
            @RequestBody Map<String, String> request) {
        try {
            String role = request.get("role");
            System.out.println("AdminController: Updating user role - " + userId + " to " + role);

            User user = userService.updateUserRole(userId, role);

            return ResponseEntity.ok(
                    ApiResponse.success("User role updated successfully", user)
            );

        } catch (Exception e) {
            System.err.println("AdminController: Update role error - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to update user role: " + e.getMessage())
            );
        }
    }

    // Delete user
    @DeleteMapping("/users/{userId}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> deleteUser(@PathVariable String userId) {
        try {
            System.out.println("AdminController: Deleting user - " + userId);

            Map<String, Object> result = userService.deleteUser(userId);

            return ResponseEntity.ok(
                    ApiResponse.success("User deleted successfully", result)
            );

        } catch (Exception e) {
            System.err.println("AdminController: Delete user error - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to delete user: " + e.getMessage())
            );
        }
    }

    // Search users
    @GetMapping("/users/search")
    public ResponseEntity<ApiResponse<List<User>>> searchUsers(@RequestParam String query) {
        try {
            System.out.println("AdminController: Searching users - " + query);

            List<User> users = userService.searchUsers(query);

            ApiResponse<List<User>> response = ApiResponse.success("Search completed successfully", users);
            response.addMeta("query", query);
            response.addMeta("resultCount", users.size());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("AdminController: Search error - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Search failed: " + e.getMessage())
            );
        }
    }

    // Bulk update users
    @PutMapping("/users/bulk-status")
    public ResponseEntity<ApiResponse<Map<String, Object>>> bulkUpdateUserStatus(
            @RequestBody Map<String, Object> request) {
        try {
            @SuppressWarnings("unchecked")
            List<String> userIds = (List<String>) request.get("userIds");
            String status = (String) request.get("status");

            System.out.println("AdminController: Bulk updating " + userIds.size() + " users to " + status);

            Map<String, Object> result = userService.bulkUpdateUserStatus(userIds, status);

            return ResponseEntity.ok(
                    ApiResponse.success("Bulk update completed", result)
            );

        } catch (Exception e) {
            System.err.println("AdminController: Bulk update error - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Bulk update failed: " + e.getMessage())
            );
        }
    }

    // Get users by city/state
    @GetMapping("/users/city/{city}")
    public ResponseEntity<ApiResponse<List<User>>> getUsersByCity(@PathVariable String city) {
        try {
            System.out.println("AdminController: Getting users by city - " + city);

            List<User> users = userService.getUsersByCity(city);

            ApiResponse<List<User>> response = ApiResponse.success("Users retrieved successfully", users);
            response.addMeta("city", city);
            response.addMeta("count", users.size());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("AdminController: Get users by city error - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Failed to retrieve users: " + e.getMessage())
            );
        }
    }

    // Export user data
    @GetMapping("/users/export")
    public ResponseEntity<ApiResponse<Map<String, Object>>> exportUserData() {
        try {
            System.out.println("AdminController: Exporting user data");

            Map<String, Object> exportData = userService.exportUserData();

            return ResponseEntity.ok(
                    ApiResponse.success("User data exported successfully", exportData)
            );

        } catch (Exception e) {
            System.err.println("AdminController: Export error - " + e.getMessage());
            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Export failed: " + e.getMessage())
            );
        }
    }
}
