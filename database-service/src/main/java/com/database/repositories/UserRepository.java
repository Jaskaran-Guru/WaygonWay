package com.database.repositories;

import com.database.models.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<User, String> {

    
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    Optional<User> findByUsernameOrEmail(String username, String email);

    
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);

    
    List<User> findByStatus(String status);

    
    List<User> findByRole(String role);

    
    @Query("{ 'status': 'ACTIVE' }")
    List<User> findActiveUsers();

    
    long countByStatus(String status);

    
    @Query("{ 'createdAt': { $gte: ?0, $lte: ?1 } }")
    List<User> findUsersCreatedBetween(LocalDateTime startDate, LocalDateTime endDate);

    
    @Query("{ $or: [ " +
            "{ 'firstName': { $regex: ?0, $options: 'i' } }, " +
            "{ 'lastName': { $regex: ?0, $options: 'i' } }, " +
            "{ 'username': { $regex: ?0, $options: 'i' } }, " +
            "{ 'email': { $regex: ?0, $options: 'i' } } ] }")
    List<User> searchUsers(String query);
}
