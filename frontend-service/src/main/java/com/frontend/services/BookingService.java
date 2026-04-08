package com.frontend.services;

import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class BookingService {

    public List<Map<String, Object>> getUserBookings(String userId) {
        System.out.println("HARDCODED: Getting bookings for " + userId);

        List<Map<String, Object>> bookings = new ArrayList<>();

        // Hardcoded Booking 1
        Map<String, Object> booking1 = new HashMap<>();
        booking1.put("pnr", "WW123456789");
        booking1.put("fromStation", "New Delhi");
        booking1.put("toStation", "Mumbai Central");
        booking1.put("trainNumber", "12951");
        booking1.put("trainName", "Rajdhani Express");
        booking1.put("journeyDate", "2025-10-15");
        booking1.put("status", "CONFIRMED");
        booking1.put("totalFare", 2832.0);
        booking1.put("bookingTime", "28/09/2025 16:30");

        List<Map<String, Object>> passengers1 = new ArrayList<>();
        Map<String, Object> p1 = new HashMap<>();
        p1.put("name", "John Demo");
        p1.put("age", 25);
        passengers1.add(p1);
        booking1.put("passengers", passengers1);

        // Hardcoded Booking 2
        Map<String, Object> booking2 = new HashMap<>();
        booking2.put("pnr", "WW987654321");
        booking2.put("fromStation", "Bangalore");
        booking2.put("toStation", "Chennai");
        booking2.put("trainNumber", "12639");
        booking2.put("trainName", "Brindavan Express");
        booking2.put("journeyDate", "2025-10-20");
        booking2.put("status", "CONFIRMED");
        booking2.put("totalFare", 1416.0);
        booking2.put("bookingTime", "27/09/2025 14:15");

        List<Map<String, Object>> passengers2 = new ArrayList<>();
        Map<String, Object> p2 = new HashMap<>();
        p2.put("name", "Jane Demo");
        p2.put("age", 28);
        passengers2.add(p2);
        booking2.put("passengers", passengers2);

        bookings.add(booking1);
        bookings.add(booking2);

        System.out.println("HARDCODED: Returning " + bookings.size() + " bookings");
        return bookings;
    }

    public Map<String, Object> createBooking(Map<String, Object> bookingData) {
        System.out.println("HARDCODED: Creating booking");

        Map<String, Object> result = new HashMap<>();
        result.put("pnr", "WW" + System.currentTimeMillis());
        result.put("status", "CONFIRMED");

        return result;
    }

    public Optional<Map<String, Object>> getBookingByPNR(String pnr) {
        System.out.println("HARDCODED: PNR search for " + pnr);

        if ("WW123456789".equals(pnr) || "WW987654321".equals(pnr)) {
            Map<String, Object> booking = new HashMap<>();
            booking.put("pnr", pnr);
            booking.put("status", "CONFIRMED");
            booking.put("fromStation", "New Delhi");
            booking.put("toStation", "Mumbai");
            return Optional.of(booking);
        }

        return Optional.empty();
    }
}
