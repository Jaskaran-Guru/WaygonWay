package com.frontend.clients;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.client.HttpClientErrorException;

import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.Arrays;
import java.util.ArrayList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class DatabaseServiceClient {

    private static final Logger logger = LoggerFactory.getLogger(DatabaseServiceClient.class);

    @Value("${waygonway.services.database:http://localhost:8083}")
    private String databaseServiceUrl;

    private final RestTemplate restTemplate;

    public DatabaseServiceClient() {
        this.restTemplate = new RestTemplate();
    }

    // Create ticket in database-service
    public Map<String, Object> createTicket(Map<String, Object> ticketData) {
        logger.info("Creating ticket via database-service");
        logger.info("Data: {}", ticketData);

        try {
            Map<String, Object> request = new HashMap<>();
            request.put("userId", ticketData.get("userId"));
            request.put("trainId", ticketData.get("trainNumber"));
            request.put("fromStation", ticketData.get("fromStation"));
            request.put("toStation", ticketData.get("toStation"));
            request.put("journeyDate", ticketData.get("journeyDate"));
            request.put("travelClass", ticketData.get("travelClass"));
            request.put("totalFare", ticketData.get("totalFare"));
            request.put("passengers", ticketData.get("passengers"));
            request.put("pnr", "WW" + System.currentTimeMillis());
            request.put("status", "CONFIRMED");

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(request, headers);

            ResponseEntity<Map> response = restTemplate.postForEntity(
                    databaseServiceUrl + "/api/tickets",
                    entity,
                    Map.class
            );

            logger.info("Ticket created: {}", response.getBody());
            return response.getBody();

        } catch (Exception e) {
            logger.error("Error: {}", e.getMessage());
            Map<String, Object> error = new HashMap<>();
            error.put("error", true);
            error.put("message", e.getMessage());
            return error;
        }
    }

    // Get user tickets
    public List<Map<String, Object>> getUserTickets(String userId) {
        try {
            ResponseEntity<Map[]> response = restTemplate.getForEntity(
                    databaseServiceUrl + "/api/tickets/user/" + userId,
                    Map[].class
            );

            List<Map<String, Object>> tickets = Arrays.asList(response.getBody());
            logger.info("Found {} tickets for user", tickets.size());
            return tickets;

        } catch (Exception e) {
            logger.error("Error getting tickets: {}", e.getMessage());
            return Arrays.asList();
        }
    }

    // Get ticket by PNR
    public Map<String, Object> getTicketByPNR(String pnr) {
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity(
                    databaseServiceUrl + "/api/tickets/pnr/" + pnr,
                    Map.class
            );

            logger.info("PNR found: {}", response.getBody());
            return response.getBody();

        } catch (Exception e) {
            logger.error("PNR not found: {}", e.getMessage());
            Map<String, Object> error = new HashMap<>();
            error.put("error", true);
            error.put("message", "PNR not found");
            return error;
        }
    }

    // Register user
    public Map<String, Object> registerUser(String name, String email, String password, String phone) {
        try {
            Map<String, Object> request = new HashMap<>();
            request.put("name", name);
            request.put("email", email);
            request.put("password", password);
            request.put("phone", phone);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(request, headers);

            ResponseEntity<Map> response = restTemplate.postForEntity(
                    databaseServiceUrl + "/api/users/register",
                    entity,
                    Map.class
            );

            return response.getBody();

        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", true);
            error.put("message", e.getMessage());
            return error;
        }
    }

    // Authenticate user
    public Map<String, Object> authenticateUser(String email, String password) {
        try {
            Map<String, Object> request = new HashMap<>();
            request.put("email", email);
            request.put("password", password);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(request, headers);

            ResponseEntity<Map> response = restTemplate.postForEntity(
                    databaseServiceUrl + "/api/users/login",
                    entity,
                    Map.class
            );

            return response.getBody();

        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", true);
            error.put("message", e.getMessage());
            return error;
        }
    }

    // ========== NEW METHOD - GET ALL USERS ==========

    /**
     * Get all users for admin panel
     */
    public List<Map<String, Object>> getAllUsers() {
        logger.info("[DatabaseServiceClient] Getting all users from database-service");

        try {
            ResponseEntity<Map[]> response = restTemplate.getForEntity(
                    databaseServiceUrl + "/api/users",
                    Map[].class
            );

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                List<Map<String, Object>> users = Arrays.asList(response.getBody());
                logger.info("Retrieved {} users from database-service", users.size());
                return users;
            } else {
                logger.warn("No users found or error: {}", response.getStatusCode());
                return new ArrayList<>();
            }

        } catch (HttpClientErrorException e) {
            logger.error("HTTP Error getting all users: {} - {}", e.getStatusCode(), e.getResponseBodyAsString());
            return new ArrayList<>();

        } catch (Exception e) {
            logger.error("Error getting all users: {}", e.getMessage(), e);
            return new ArrayList<>();
        }
    }

    // ========== HEALTH CHECK ==========

    /**
     * Check if database-service is healthy
     */
    public boolean isServiceHealthy() {
        try {
            ResponseEntity<String> response = restTemplate.getForEntity(
                    databaseServiceUrl + "/actuator/health",
                    String.class
            );

            boolean healthy = response.getStatusCode() == HttpStatus.OK;
            logger.info(healthy ? "Database service is healthy" : "Database service unhealthy");
            return healthy;

        } catch (Exception e) {
            logger.error("Database service health check failed: {}", e.getMessage());
            return false;
        }
    }
}
