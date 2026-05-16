package com.waygonway.services;

import com.waygonway.entities.TransportBooking;
import com.waygonway.entities.TransportSchedule;
import com.waygonway.repositories.TransportBookingRepository;
import com.waygonway.repositories.TransportScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class TransportService {

    @Autowired
    private TransportScheduleRepository scheduleRepository;

    @Autowired
    private TransportBookingRepository bookingRepository;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private RedlockService redlockService;

    public List<TransportSchedule> searchSchedules(String type, String source, String destination) {
        if (source != null && destination != null) {
            if (type != null && !type.isEmpty()) {
                return scheduleRepository.findByTypeAndSourceAndDestination(type, source, destination);
            }
            return scheduleRepository.findBySourceAndDestination(source, destination);
        } else if (type != null && !type.isEmpty()) {
            return scheduleRepository.findByType(type);
        }
        return scheduleRepository.findAll();
    }

    public TransportBooking createTransportBooking(Map<String, Object> bookingData) {

        String scheduleId = (String) bookingData.get("scheduleId");
        String userId = (String) bookingData.get("userId");
        String customerName = (String) bookingData.get("customerName");
        String customerEmail = (String) bookingData.get("customerEmail");
        int passengerCount = bookingData.get("passengerCount") != null ? 
                             Integer.parseInt(bookingData.get("passengerCount").toString()) : 1;

        if (scheduleId == null || userId == null || passengerCount <= 0) {
            throw new IllegalArgumentException("Invalid booking parameters");
        }

        String lockKey = "lock:transport:" + scheduleId;
        boolean locked = redlockService.acquireLock(lockKey, java.time.Duration.ofSeconds(10));

        if (!locked) {
            throw new RuntimeException("System is busy processing requests for this schedule.");
        }

        try {
            Optional<TransportSchedule> scheduleOpt = scheduleRepository.findById(scheduleId);
            if (scheduleOpt.isEmpty()) {
                throw new RuntimeException("Schedule not found.");
            }

            TransportSchedule schedule = scheduleOpt.get();
            if (schedule.getAvailableSeats() < passengerCount) {
                throw new RuntimeException("Not enough seats available.");
            }

            TransportBooking booking = new TransportBooking();
            booking.setUserId(userId);
            booking.setCustomerName(customerName);
            booking.setCustomerEmail(customerEmail);
            booking.setScheduleId(scheduleId);
            booking.setTransportType(schedule.getType());
            booking.setOperatorName(schedule.getOperatorName());
            booking.setSource(schedule.getSource());
            booking.setDestination(schedule.getDestination());
            booking.setDepartureTime(schedule.getDepartureTime());
            booking.setPassengerCount(passengerCount);

            double totalAmount = schedule.getBasePrice() * passengerCount;
            booking.setTotalAmount(totalAmount);
            booking.setStatus("PENDING");

            
            TransportBooking savedBooking = bookingRepository.save(booking);

            
            Map<String, Object> paymentResult = paymentService.createPaymentIntent(totalAmount, "usd");
            if (!"PAYMENT_INTENT_CREATED".equals(paymentResult.get("status"))) {
                throw new RuntimeException("Payment Initialization failed.");
            }

            
            schedule.setAvailableSeats(schedule.getAvailableSeats() - passengerCount);
            scheduleRepository.save(schedule);

            return savedBooking;
        } finally {
            redlockService.releaseLock(lockKey);
        }
    }

    public TransportBooking confirmBookingStatus(String pnr, String status) {

        TransportBooking booking = bookingRepository.findByPnr(pnr)
                .orElseThrow(() -> new RuntimeException("Booking not found: " + pnr));
        booking.setStatus(status);
        return bookingRepository.save(booking);
    }
    
    public List<TransportBooking> getUserBookings(String userId) {
        return bookingRepository.findByUserId(userId);
    }
    
    public List<TransportBooking> getAllBookings() {
        return bookingRepository.findAll();
    }

    public TransportSchedule createSchedule(TransportSchedule schedule) {
        if (schedule.getAvailableSeats() == 0) {
            schedule.setAvailableSeats(schedule.getTotalSeats());
        }
        return scheduleRepository.save(schedule);
    }

    public void deleteSchedule(String id) {
        scheduleRepository.deleteById(id);
    }
}

