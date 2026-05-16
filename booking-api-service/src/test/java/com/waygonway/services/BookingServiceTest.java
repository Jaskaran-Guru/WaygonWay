package com.waygonway.services;

import com.waygonway.entities.Booking;
import com.waygonway.entities.Event;
import com.waygonway.repositories.BookingRepository;
import com.waygonway.repositories.EventRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class BookingServiceTest {

    @Mock
    private BookingRepository bookingRepository;

    @Mock
    private EventRepository eventRepository;

    @Mock
    private RedlockService redlockService;

    @Mock
    private PaymentService paymentService;

    @InjectMocks
    private BookingService bookingService;

    private Event testEvent;

    @BeforeEach
    void setUp() {
        testEvent = new Event();
        testEvent.setId("EVT-100");
        testEvent.setEventName("Test Concert");
        testEvent.setAvailableSeats(50);
        testEvent.setBasePrice(100.0);
    }

    @Test
    void testCreateBooking_Success_WithStripeIntent() {
        when(redlockService.acquireLock(anyString(), any())).thenReturn(true);
        when(eventRepository.findById("EVT-100")).thenReturn(Optional.of(testEvent));
        when(bookingRepository.save(any(Booking.class))).thenAnswer(i -> i.getArguments()[0]);
        when(paymentService.createPaymentIntent(200.0, "usd")).thenReturn(Map.of(
                "status", "PAYMENT_INTENT_CREATED",
                "clientSecret", "pi_secret",
                "paymentIntentId", "pi_id"
        ));

        Map<String, Object> requestData = Map.of(
                "eventId", "EVT-100",
                "userId", "USER-1",
                "customerName", "John Doe",
                "seats", "A1,A2" 
        );

        Booking result = bookingService.createBooking(requestData);

        assertNotNull(result);
        assertEquals("PENDING", result.getStatus());
        assertEquals(200.0, result.getTotalAmount());
        assertEquals("pi_secret", result.getClientSecret());
        assertEquals(48, testEvent.getAvailableSeats()); 
        
        verify(redlockService).releaseLock("lock:event:EVT-100");
        verify(eventRepository).save(testEvent);
    }

    @Test
    void testCreateBooking_FailsWhenSystemBusy_LockContention() {
        when(redlockService.acquireLock(anyString(), any())).thenReturn(false);

        Map<String, Object> requestData = Map.of(
                "eventId", "EVT-100",
                "userId", "USER-1",
                "seats", "A1,A2"
        );

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            bookingService.createBooking(requestData);
        });

        assertTrue(exception.getMessage().contains("System is busy"));
        verify(eventRepository, never()).findById(anyString());
    }

    @Test
    void testCreateBooking_FailsWhenSoldOut() {
        testEvent.setAvailableSeats(0);
        when(redlockService.acquireLock(anyString(), any())).thenReturn(true);
        when(eventRepository.findById("EVT-100")).thenReturn(Optional.of(testEvent));

        Map<String, Object> requestData = Map.of(
                "eventId", "EVT-100",
                "userId", "USER-1",
                "seats", "B1"
        );

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            bookingService.createBooking(requestData);
        });

        assertTrue(exception.getMessage().contains("No seats available"));
        verify(bookingRepository, never()).save(any());
        verify(redlockService).releaseLock(anyString());
    }
}
