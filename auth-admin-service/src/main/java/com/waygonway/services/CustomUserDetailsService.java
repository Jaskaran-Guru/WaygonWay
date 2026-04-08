package com.waygonway.services;

import com.waygonway.models.User;
import com.waygonway.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import java.util.Collections;
import java.util.Optional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String usernameOrEmail) throws UsernameNotFoundException {
        try {
            System.out.println("CustomUserDetailsService: Loading user - " + usernameOrEmail);

            Optional<User> userOpt = userRepository.findByUsernameOrEmail(usernameOrEmail, usernameOrEmail);

            if (userOpt.isEmpty()) {
                System.err.println("User not found: " + usernameOrEmail);
                throw new UsernameNotFoundException("User not found: " + usernameOrEmail);
            }

            User user = userOpt.get();

            // Check if user is active
            if (!"ACTIVE".equals(user.getStatus())) {
                System.err.println("User account is " + user.getStatus() + ": " + usernameOrEmail);
                throw new UsernameNotFoundException("User account is " + user.getStatus());
            }

            // Create UserDetails object
            UserDetails userDetails = org.springframework.security.core.userdetails.User.builder()
                    .username(user.getUsername())
                    .password(user.getPassword())
                    .authorities(Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + user.getRole())))
                    .accountExpired(false)
                    .accountLocked("SUSPENDED".equals(user.getStatus()))
                    .credentialsExpired(false)
                    .disabled(!"ACTIVE".equals(user.getStatus()))
                    .build();

            System.out.println("CustomUserDetailsService: User loaded successfully - " + user.getUsername() + " with role " + user.getRole());
            return userDetails;

        } catch (UsernameNotFoundException e) {
            throw e;
        } catch (Exception e) {
            System.err.println("CustomUserDetailsService: Error loading user - " + e.getMessage());
            throw new UsernameNotFoundException("Error loading user: " + usernameOrEmail, e);
        }
    }

    // Additional method to get User entity
    public User getUserByUsername(String username) {
        Optional<User> userOpt = userRepository.findByUsername(username);
        if (userOpt.isEmpty()) {
            throw new UsernameNotFoundException("User not found: " + username);
        }
        return userOpt.get();
    }

    // Additional method to get User entity by email
    public User getUserByEmail(String email) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new UsernameNotFoundException("User not found with email: " + email);
        }
        return userOpt.get();
    }
}
