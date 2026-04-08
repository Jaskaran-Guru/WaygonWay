package com.waygonway.services;

import com.waygonway.models.User;
import com.waygonway.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

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

    // Get users with pagination
    public Page<User> getUsersWithPagination(int page, int size, String sortBy, String sortDir) {
        try {
            System.out.println("UserService: Getting users with pagination - Page: " + page + ", Size: " + size);

            Sort sort = sortDir.equalsIgnoreCase("desc") ?
                    Sort.by(sortBy).descending() :
                    Sort.by(sortBy).ascending();

            Pageable pageable = PageRequest.of(page, size, sort);
            Page<User> users = userRepository.findAll(pageable);

            System.out.println("UserService: Retrieved page " + page + " with " + users.getContent().size() + " users");
            return users;

        } catch (Exception e) {
            System.err.println("UserService: Error getting users with pagination - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve users with pagination", e);
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

    // Update user
    public User updateUser(String userId, User updatedUser) {
        try {
            System.out.println("UserService: Updating user - " + userId);

            User existingUser = getUserById(userId);

            // Update fields
            if (updatedUser.getFirstName() != null) {
                existingUser.setFirstName(updatedUser.getFirstName());
            }
            if (updatedUser.getLastName() != null) {
                existingUser.setLastName(updatedUser.getLastName());
            }
            if (updatedUser.getPhone() != null) {
                existingUser.setPhone(updatedUser.getPhone());
            }
            if (updatedUser.getAddress() != null) {
                existingUser.setAddress(updatedUser.getAddress());
            }
            if (updatedUser.getStatus() != null) {
                existingUser.setStatus(updatedUser.getStatus());
            }
            if (updatedUser.getRole() != null) {
                existingUser.setRole(updatedUser.getRole());
            }

            existingUser.setUpdatedAt(LocalDateTime.now());

            User savedUser = userRepository.save(existingUser);
            System.out.println("UserService: User updated successfully - " + savedUser.getUsername());

            return savedUser;

        } catch (Exception e) {
            System.err.println("UserService: Error updating user - " + e.getMessage());
            throw new RuntimeException("Failed to update user", e);
        }
    }

    // Delete user
    public Map<String, Object> deleteUser(String userId) {
        try {
            System.out.println("UserService: Deleting user - " + userId);

            User user = getUserById(userId);
            userRepository.deleteById(userId);

            Map<String, Object> result = new HashMap<>();
            result.put("deleted", true);
            result.put("userId", userId);
            result.put("username", user.getUsername());
            result.put("deletedAt", LocalDateTime.now());

            System.out.println("UserService: User deleted successfully - " + user.getUsername());
            return result;

        } catch (Exception e) {
            System.err.println("UserService: Error deleting user - " + e.getMessage());
            throw new RuntimeException("Failed to delete user", e);
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

    // Get users by role
    public List<User> getUsersByRole(String role) {
        try {
            System.out.println("UserService: Getting users by role - " + role);

            List<User> users = userRepository.findByRole(role.toUpperCase());

            System.out.println("UserService: Retrieved " + users.size() + " users with role " + role);
            return users;

        } catch (Exception e) {
            System.err.println("UserService: Error getting users by role - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve users by role", e);
        }
    }

    // Update user status
    public User updateUserStatus(String userId, String status) {
        try {
            System.out.println("UserService: Updating user status - " + userId + " to " + status);

            User user = getUserById(userId);
            user.setStatus(status.toUpperCase());
            user.setUpdatedAt(LocalDateTime.now());

            User savedUser = userRepository.save(user);
            System.out.println("UserService: User status updated - " + savedUser.getUsername());

            return savedUser;

        } catch (Exception e) {
            System.err.println("UserService: Error updating user status - " + e.getMessage());
            throw new RuntimeException("Failed to update user status", e);
        }
    }

    // Update user role
    public User updateUserRole(String userId, String role) {
        try {
            System.out.println("UserService: Updating user role - " + userId + " to " + role);

            User user = getUserById(userId);
            user.setRole(role.toUpperCase());
            user.setUpdatedAt(LocalDateTime.now());

            User savedUser = userRepository.save(user);
            System.out.println("UserService: User role updated - " + savedUser.getUsername());

            return savedUser;

        } catch (Exception e) {
            System.err.println("UserService: Error updating user role - " + e.getMessage());
            throw new RuntimeException("Failed to update user role", e);
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
            LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
            LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);
            List<User> todaysUsers = userRepository.findUsersCreatedBetween(startOfDay, endOfDay);
            stats.put("todaysRegistrations", todaysUsers.size());

            // City-wise distribution
            Map<String, Long> cityStats = allUsers.stream()
                    .filter(u -> u.getAddress() != null && u.getAddress().getCity() != null)
                    .collect(Collectors.groupingBy(
                            u -> u.getAddress().getCity(),
                            Collectors.counting()
                    ));
            stats.put("cityDistribution", cityStats);

            // State-wise distribution
            Map<String, Long> stateStats = allUsers.stream()
                    .filter(u -> u.getAddress() != null && u.getAddress().getState() != null)
                    .collect(Collectors.groupingBy(
                            u -> u.getAddress().getState(),
                            Collectors.counting()
                    ));
            stats.put("stateDistribution", stateStats);

            stats.put("generatedAt", LocalDateTime.now());

            System.out.println("UserService: Statistics calculated successfully");
            return stats;

        } catch (Exception e) {
            System.err.println("UserService: Error calculating statistics - " + e.getMessage());
            throw new RuntimeException("Failed to calculate statistics", e);
        }
    }

    // Export user data
    public Map<String, Object> exportUserData() {
        try {
            System.out.println("UserService: Exporting user data");

            List<User> users = getAllUsers();

            Map<String, Object> exportData = new HashMap<>();
            exportData.put("users", users);
            exportData.put("totalCount", users.size());
            exportData.put("exportedAt", LocalDateTime.now());
            exportData.put("format", "JSON");

            System.out.println("UserService: Data exported successfully - " + users.size() + " users");
            return exportData;

        } catch (Exception e) {
            System.err.println("UserService: Error exporting data - " + e.getMessage());
            throw new RuntimeException("Failed to export user data", e);
        }
    }

    // Get users created today
    public List<User> getUsersCreatedToday() {
        try {
            System.out.println("UserService: Getting today's users");

            LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
            LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);

            List<User> todaysUsers = userRepository.findUsersCreatedBetween(startOfDay, endOfDay);

            System.out.println("UserService: Retrieved " + todaysUsers.size() + " users created today");
            return todaysUsers;

        } catch (Exception e) {
            System.err.println("UserService: Error getting today's users - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve today's users", e);
        }
    }

    // Bulk update user status
    public Map<String, Object> bulkUpdateUserStatus(List<String> userIds, String status) {
        try {
            System.out.println("UserService: Bulk updating user status - " + userIds.size() + " users to " + status);

            List<String> updated = new ArrayList<>();
            List<String> failed = new ArrayList<>();

            for (String userId : userIds) {
                try {
                    updateUserStatus(userId, status);
                    updated.add(userId);
                } catch (Exception e) {
                    failed.add(userId);
                    System.err.println("Failed to update user " + userId + ": " + e.getMessage());
                }
            }

            Map<String, Object> result = new HashMap<>();
            result.put("totalRequested", userIds.size());
            result.put("successfullyUpdated", updated.size());
            result.put("failed", failed.size());
            result.put("updatedUserIds", updated);
            result.put("failedUserIds", failed);
            result.put("newStatus", status);
            result.put("updatedAt", LocalDateTime.now());

            System.out.println("UserService: Bulk update completed - " + updated.size() + " successful, " + failed.size() + " failed");
            return result;

        } catch (Exception e) {
            System.err.println("UserService: Error in bulk update - " + e.getMessage());
            throw new RuntimeException("Failed to perform bulk update", e);
        }
    }

    // Get users by city
    public List<User> getUsersByCity(String city) {
        try {
            System.out.println("UserService: Getting users by city - " + city);

            List<User> users = userRepository.findByCity(city);

            System.out.println("UserService: Retrieved " + users.size() + " users from " + city);
            return users;

        } catch (Exception e) {
            System.err.println("UserService: Error getting users by city - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve users by city", e);
        }
    }

    // Get users by state
    public List<User> getUsersByState(String state) {
        try {
            System.out.println("UserService: Getting users by state - " + state);

            List<User> users = userRepository.findByState(state);

            System.out.println("UserService: Retrieved " + users.size() + " users from " + state);
            return users;

        } catch (Exception e) {
            System.err.println("UserService: Error getting users by state - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve users by state", e);
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
