package com.waygonway.services;

import com.waygonway.repositories.BookingRepository;
import com.waygonway.repositories.EventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class DashboardService {

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private EventRepository eventRepository;

    public Map<String, Object> getDashboardStats() {
        var bookings = bookingRepository.findAll();
        var events = eventRepository.findAll();

        double totalRevenue = bookings.stream()
                .filter(b -> "PAID".equals(b.getStatus()) || "CONFIRMED".equals(b.getStatus())) 
                .mapToDouble(b -> b.getTotalAmount() != null ? b.getTotalAmount() : 0.0)
                .sum();

        Map<String, Long> categoryDistribution = bookings.stream()
                .collect(Collectors.groupingBy(b -> b.getEventCategory() != null ? b.getEventCategory() : "Other", Collectors.counting()));

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalRevenue", totalRevenue);
        stats.put("totalBookings", (long) bookings.size());
        stats.put("totalEvents", (long) events.size());
        stats.put("categoryDistribution", categoryDistribution);
        stats.put("recentBookings", bookings.stream()
                .sorted((b1, b2) -> b2.getBookingDateTime().compareTo(b1.getBookingDateTime()))
                .limit(5)
                .collect(Collectors.toList()));

        return stats;
    }
}
