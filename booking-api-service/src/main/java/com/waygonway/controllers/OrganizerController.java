package com.waygonway.controllers;

import com.waygonway.entities.Booking;
import com.waygonway.entities.Event;
import com.waygonway.repositories.BookingRepository;
import com.waygonway.repositories.EventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/organizer")
@CrossOrigin(origins = "*")
public class OrganizerController {

    @Autowired
    private EventRepository eventRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @GetMapping("/events")
    public Map<String, Object> getOrganizerEvents(@RequestParam String organizerId) {
        List<Event> events = eventRepository.findByOrganizerId(organizerId);
        return Map.of("success", true, "data", events);
    }

    @GetMapping("/bookings")
    public Map<String, Object> getOrganizerBookings(@RequestParam String organizerId) {
        
        List<Event> events = eventRepository.findByOrganizerId(organizerId);
        List<String> eventIds = events.stream().map(Event::getId).collect(Collectors.toList());
        
        if (eventIds.isEmpty()) {
            return Map.of("success", true, "data", List.of());
        }

        
        List<Booking> bookings = bookingRepository.findByEventIdIn(eventIds);
        return Map.of("success", true, "data", bookings);
    }

    @GetMapping("/dashboard-stats")
    public Map<String, Object> getDashboardStats(@RequestParam String organizerId) {
        List<Event> events = eventRepository.findByOrganizerId(organizerId);
        List<String> eventIds = events.stream().map(Event::getId).collect(Collectors.toList());
        
        List<Booking> bookings = eventIds.isEmpty() ? List.of() : bookingRepository.findByEventIdIn(eventIds);
        
        long totalEvents = events.size();
        long totalBookings = bookings.size();
        
        double totalRevenue = bookings.stream()
            .filter(b -> "PAID".equalsIgnoreCase(b.getStatus()))
            .mapToDouble(b -> b.getTotalAmount() != null ? b.getTotalAmount() : 0.0)
            .sum();

        long ticketsSold = bookings.stream()
            .filter(b -> "PAID".equalsIgnoreCase(b.getStatus()) || "CONFIRMED".equalsIgnoreCase(b.getStatus()))
            .mapToLong(b -> {
                String seats = b.getSeats();
                return seats != null && !seats.isEmpty() ? seats.split(",").length : 1;
            })
            .sum();

        return Map.of(
            "success", true,
            "data", Map.of(
                "totalEvents", totalEvents,
                "totalBookings", totalBookings,
                "totalRevenue", totalRevenue,
                "ticketsSold", ticketsSold
            )
        );
    }
}
