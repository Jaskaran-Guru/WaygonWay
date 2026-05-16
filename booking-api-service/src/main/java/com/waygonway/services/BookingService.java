package com.waygonway.services;

import com.waygonway.entities.Booking;
import com.waygonway.entities.Event;
import com.waygonway.repositories.BookingRepository;
import com.waygonway.repositories.EventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class BookingService {

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private EventRepository eventRepository;

    @Autowired
    private RedlockService redlockService;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private NotificationService notificationService;

    public Page<Booking> getAllBookingsPaged(Pageable pageable) {
        return bookingRepository.findAll(pageable);
    }

    public Booking updateBookingStatus(String pnr, String status) {
        Booking booking = bookingRepository.findByPnr(pnr)
                .orElseThrow(() -> new RuntimeException("Booking not found: " + pnr));
        booking.setStatus(status);
        
        Booking updated = bookingRepository.save(booking);
        if ("PAID".equalsIgnoreCase(status)) {
            notificationService.sendTicketEmail(updated);
        }
        return updated;
    }

    public Booking createBooking(Map<String, Object> bookingData) {
        String eventId = (String) bookingData.get("eventId");
        String userId = (String) bookingData.get("userId");
        String customerName = (String) bookingData.get("customerName");
        String customerEmail = (String) bookingData.get("customerEmail");
        String seats = (String) bookingData.get("seats");

        
        if (eventId == null || eventId.trim().isEmpty()) throw new IllegalArgumentException("eventId is strictly required");
        if (userId == null || userId.trim().isEmpty()) throw new IllegalArgumentException("userId is strictly required");
        if (seats == null || seats.trim().isEmpty()) throw new IllegalArgumentException("seats are strictly required");

        String lockKey = "lock:event:" + eventId;
        boolean locked = redlockService.acquireLock(lockKey, java.time.Duration.ofSeconds(10));
        
        if (!locked) {
            throw new RuntimeException("System is busy processing requests for this event. Please try again in a few seconds.");
        }

        try {
            Optional<Event> eventOpt = eventRepository.findById(eventId);
            if (eventOpt.isEmpty()) {
                throw new RuntimeException("Event not found with ID: " + eventId);
            }

            Event event = eventOpt.get();
            if (event.getAvailableSeats() <= 0) {
                throw new RuntimeException("No seats available for event: " + event.getEventName());
            }

            
            Booking booking = new Booking();
            booking.setUserId(userId);
            booking.setCustomerName(customerName);
            booking.setCustomerEmail(customerEmail);
            booking.setEventId(eventId);
            booking.setEventName(event.getEventName());
            booking.setEventCategory(event.getCategory());
            booking.setVenue(event.getVenue());
            booking.setSeats(seats);
            booking.setEventDateTime(event.getStartDateTime());
            
            int seatCount = seats != null && !seats.isEmpty() ? seats.split(",").length : 1;
            booking.setTotalAmount(event.getBasePrice() * seatCount);
            booking.setStatus("PENDING");

            Booking savedBooking = bookingRepository.save(booking);

            
            Map<String, Object> paymentResult = paymentService.createPaymentIntent(booking.getTotalAmount(), "usd");
            
            if ("PAYMENT_INTENT_CREATED".equals(paymentResult.get("status"))) {
                savedBooking.setClientSecret((String) paymentResult.get("clientSecret"));
                savedBooking.setPaymentIntentId((String) paymentResult.get("paymentIntentId"));
                bookingRepository.save(savedBooking);
            } else {
                throw new RuntimeException("Payment Initialization failed: " + paymentResult.get("message"));
            }

            
            event.setAvailableSeats(event.getAvailableSeats() - seatCount);
            eventRepository.save(event);

            return savedBooking;
        } finally {
            redlockService.releaseLock(lockKey);
        }
    }

    public Optional<Booking> getBookingByPnr(String pnr) {
        return bookingRepository.findByPnr(pnr);
    }

    public List<Booking> getUserBookings(String userId) {
        return bookingRepository.findByUserId(userId);
    }

    public List<Event> getAllEvents() {
        return eventRepository.findAll();
    }

    public List<Event> getEventsByCategory(String category) {
        return eventRepository.findByCategory(category);
    }
}
