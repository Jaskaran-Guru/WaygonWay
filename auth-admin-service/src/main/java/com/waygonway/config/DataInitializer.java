package com.waygonway.config;

import com.waygonway.models.User;
import com.waygonway.repositories.UserRepository;
import com.waygonway.utils.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class DataInitializer implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataInitializer.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordUtil passwordUtil;

    @Override
    public void run(String... args) throws Exception {
        logger.info("DataInitializer: Attempting to check/seed initial data...");

        try {
            // Create admin user if not exists
            if (!userRepository.existsByUsername("admin")) {
                logger.info("DataInitializer: Creating default admin user");

                User admin = new User();
                admin.setUsername("admin");
                admin.setEmail("admin@waygonway.com");
                admin.setPassword(passwordUtil.hashPassword("admin123"));
                admin.setFirstName("System");
                admin.setLastName("Administrator");
                admin.setPhone("9999999999");
                admin.setRole("ADMIN");
                admin.setStatus("ACTIVE");

                // Set address
                User.Address address = new User.Address();
                address.setCity("New Delhi");
                address.setState("Delhi");
                address.setCountry("India");
                address.setZipCode("110001");
                admin.setAddress(address);

                userRepository.save(admin);
                logger.info("DataInitializer: Default admin user created");
            }

            // Create demo user if not exists
            if (!userRepository.existsByUsername("user")) {
                logger.info("DataInitializer: Creating demo user");

                User user = new User();
                user.setUsername("user");
                user.setEmail("user@waygonway.com");
                user.setPassword(passwordUtil.hashPassword("user123"));
                user.setFirstName("Demo");
                user.setLastName("User");
                user.setPhone("8888888888");
                user.setRole("USER");
                user.setStatus("ACTIVE");

                // Set address
                User.Address address = new User.Address();
                address.setCity("Mumbai");
                address.setState("Maharashtra");
                address.setCountry("India");
                address.setZipCode("400001");
                user.setAddress(address);

                userRepository.save(user);
                logger.info("DataInitializer: Demo user created");
            }

            long userCount = userRepository.count();
            logger.info("DataInitializer: Total users in database: {}", userCount);
            logger.info("DataInitializer: Initial data setup completed");
        } catch (Exception e) {
            logger.error("DataInitializer: Failed to complete data seeding at startup. The application will continue, but data might be missing. Error: {}", e.getMessage());
        }
    }
}
