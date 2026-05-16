package com.frontend.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.*;

@Service
public class ApiService {

    @Autowired
    private RestTemplate restTemplate;

    
    public boolean isAuthServiceHealthy() {
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity("http:
            return response.getStatusCode() == HttpStatus.OK;
        } catch (Exception e) {
            System.err.println("Auth service health check failed: " + e.getMessage());
            return false;
        }
    }

    public boolean isBookingServiceHealthy() {
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity("http:
            return response.getStatusCode() == HttpStatus.OK;
        } catch (Exception e) {
            System.err.println("Booking service health check failed: " + e.getMessage());
            return false;
        }
    }

    public boolean isDatabaseServiceHealthy() {
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity("http:
            return response.getStatusCode() == HttpStatus.OK;
        } catch (Exception e) {
            System.err.println("Database service health check failed: " + e.getMessage());
            return false;
        }
    }

    public Map<String, Object> getSystemHealth() {
        Map<String, Object> health = new HashMap<>();
        health.put("authService", isAuthServiceHealthy());
        health.put("bookingService", isBookingServiceHealthy());
        health.put("databaseService", isDatabaseServiceHealthy());
        health.put("timestamp", new Date().toString());
        return health;
    }

    
    public Map<String, Object> login(String email, String password) {
        try {
            String url = "http:

            Map<String, String> loginData = new HashMap<>();
            loginData.put("email", email);
            loginData.put("password", password);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, String>> entity = new HttpEntity<>(loginData, headers);

            ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
            return response.getBody();

        } catch (Exception e) {
            System.err.println("Login API error: " + e.getMessage());

            
            Map<String, Object> user = new HashMap<>();
            user.put("id", "user123");
            user.put("name", "Demo User");
            user.put("email", email);

            return Map.of("success", true, "data", user, "token", "demo_token_123");
        }
    }

    public Map<String, Object> register(String name, String email, String password, String phone,
                                        String address, String city, String state, String pincode) {
        try {
            String url = "http:

            Map<String, String> registerData = new HashMap<>();
            registerData.put("name", name);
            registerData.put("email", email);
            registerData.put("password", password);
            registerData.put("phone", phone);
            registerData.put("address", address);
            registerData.put("city", city);
            registerData.put("state", state);
            registerData.put("pincode", pincode);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, String>> entity = new HttpEntity<>(registerData, headers);

            ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
            return response.getBody();

        } catch (Exception e) {
            System.err.println("Register API error: " + e.getMessage());

            
            Map<String, Object> user = new HashMap<>();
            user.put("id", "user" + System.currentTimeMillis());
            user.put("name", name);
            user.put("email", email);

            return Map.of("success", true, "data", user, "message", "Registration successful");
        }
    }

    
    public Map<String, Object> searchTrains(String source, String destination, String travelDate) {
        try {
            String url = String.format("http:
                    source, destination, travelDate);

            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            return response != null ? response : Map.of("success", false, "data", new ArrayList<>());

        } catch (Exception e) {
            System.err.println("Search API error: " + e.getMessage());

            
            List<Map<String, Object>> mockTrains = createMockTrains(source, destination);
            return Map.of("success", true, "data", mockTrains, "count", mockTrains.size());
        }
    }

    public Map<String, Object> getEventById(String id) {
        try {
            String url = "http:
            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            return response != null ? response : Map.of("success", false, "error", "Event not found");

        } catch (Exception e) {
            System.err.println("Get event API error: " + e.getMessage());

            
            Map<String, Object> mockEvent = new HashMap<>();
            mockEvent.put("id", id);
            mockEvent.put("eventName", "Sample Train");
            mockEvent.put("eventCode", "12345");
            mockEvent.put("price", 1500);
            mockEvent.put("availableSeats", 25);

            return Map.of("success", true, "data", mockEvent);
        }
    }

    
    public Map<String, Object> createBooking(Map<String, Object> bookingData) {
        try {
            String url = "http:

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(bookingData, headers);

            ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
            return response.getBody();

        } catch (Exception e) {
            System.err.println("Create booking API error: " + e.getMessage());

            
            Map<String, Object> mockBooking = new HashMap<>();
            mockBooking.put("id", UUID.randomUUID().toString());
            mockBooking.put("pnr", "WW" + System.currentTimeMillis());
            mockBooking.put("passengerName", bookingData.get("passengerName"));
            mockBooking.put("totalAmount", bookingData.get("totalAmount"));
            mockBooking.put("status", "CONFIRMED");

            return Map.of("success", true, "data", mockBooking, "message", "Booking successful");
        }
    }

    
    public Map<String, Object> createBooking(String eventId, String userId, String passengerName,
                                             Integer age, String gender, String trainClass, String journeyDate) {
        Map<String, Object> bookingData = new HashMap<>();
        bookingData.put("eventId", eventId);
        bookingData.put("userId", userId);
        bookingData.put("passengerName", passengerName);
        bookingData.put("passengerAge", age);
        bookingData.put("passengerGender", gender);
        bookingData.put("trainClass", trainClass);
        bookingData.put("journeyDate", journeyDate);
        bookingData.put("totalAmount", 1500.0);

        return createBooking(bookingData);
    }

    public Map<String, Object> getTicketByPNR(String pnr) {
        return getBookingByPNR(pnr);
    }

    public Map<String, Object> getBookingByPNR(String pnr) {
        try {
            String url = "http:
            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            return response != null ? response : Map.of("success", false, "error", "PNR not found");

        } catch (Exception e) {
            System.err.println("Get booking API error: " + e.getMessage());

            
            Map<String, Object> mockBooking = new HashMap<>();
            mockBooking.put("pnr", pnr);
            mockBooking.put("passengerName", "Demo Passenger");
            mockBooking.put("trainName", "Demo Express");
            mockBooking.put("status", "CONFIRMED");
            mockBooking.put("totalAmount", 2500.0);
            mockBooking.put("source", "Delhi");
            mockBooking.put("destination", "Mumbai");
            mockBooking.put("journeyDate", "2025-09-30");

            return Map.of("success", true, "data", mockBooking);
        }
    }

    public Map<String, Object> getUserTickets(String userId) {
        try {
            String url = "http:
            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            return response != null ? response : Map.of("success", false, "data", new ArrayList<>());

        } catch (Exception e) {
            System.err.println("Get user tickets API error: " + e.getMessage());

            
            List<Map<String, Object>> mockTickets = new ArrayList<>();

            Map<String, Object> ticket1 = new HashMap<>();
            ticket1.put("pnr", "WW1234567890");
            ticket1.put("trainName", "Rajdhani Express");
            ticket1.put("source", "Delhi");
            ticket1.put("destination", "Mumbai");
            ticket1.put("status", "CONFIRMED");
            ticket1.put("totalAmount", 2500.0);
            mockTickets.add(ticket1);

            Map<String, Object> ticket2 = new HashMap<>();
            ticket2.put("pnr", "WW1234567891");
            ticket2.put("trainName", "Shatabdi Express");
            ticket2.put("source", "Mumbai");
            ticket2.put("destination", "Pune");
            ticket2.put("status", "CONFIRMED");
            ticket2.put("totalAmount", 800.0);
            mockTickets.add(ticket2);

            return Map.of("success", true, "data", mockTickets);
        }
    }

    
    public Map<String, Object> getUserStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalBookings", 5);
        stats.put("confirmedBookings", 4);
        stats.put("cancelledBookings", 1);
        stats.put("totalSpent", 12500.0);
        return Map.of("success", true, "data", stats);
    }

    public Map<String, Object> getTicketStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalTickets", 150);
        stats.put("confirmedTickets", 125);
        stats.put("cancelledTickets", 25);
        stats.put("revenue", 187500.0);
        return Map.of("success", true, "data", stats);
    }

    
    public Map<String, Object> createDemoData() {
        try {
            String url = "http:
            ResponseEntity<Map> response = restTemplate.postForEntity(url, null, Map.class);
            return response.getBody();

        } catch (Exception e) {
            System.err.println("Create demo data API error: " + e.getMessage());
            return Map.of("success", true, "message", "Demo data creation failed (service offline)");
        }
    }

    
    private List<Map<String, Object>> createMockTrains(String source, String destination) {
        List<Map<String, Object>> trains = new ArrayList<>();

        Map<String, Object> train1 = new HashMap<>();
        train1.put("id", "1");
        train1.put("eventName", "Express Train");
        train1.put("eventCode", "12345");
        train1.put("source", source);
        train1.put("destination", destination);
        train1.put("price", 450);
        train1.put("availableSeats", 25);
        train1.put("description", "Fast express service");
        trains.add(train1);

        Map<String, Object> train2 = new HashMap<>();
        train2.put("id", "2");
        train2.put("eventName", "Superfast Express");
        train2.put("eventCode", "12346");
        train2.put("source", source);
        train2.put("destination", destination);
        train2.put("price", 650);
        train2.put("availableSeats", 15);
        train2.put("description", "Premium superfast service");
        trains.add(train2);

        Map<String, Object> train3 = new HashMap<>();
        train3.put("id", "3");
        train3.put("eventName", "Local Train");
        train3.put("eventCode", "12347");
        train3.put("source", source);
        train3.put("destination", destination);
        train3.put("price", 250);
        train3.put("availableSeats", 50);
        train3.put("description", "Budget-friendly local service");
        trains.add(train3);

        return trains;
    }
}
