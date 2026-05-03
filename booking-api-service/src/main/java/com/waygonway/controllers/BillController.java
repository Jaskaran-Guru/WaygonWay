package com.waygonway.controllers;

import com.waygonway.entities.Booking;
import com.waygonway.services.BookingService;
import com.waygonway.services.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/v1/bookings/bill")
public class BillController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private NotificationService notificationService;

    @GetMapping("/{pnr}")
    public ResponseEntity<byte[]> downloadBill(@PathVariable String pnr) {
        Optional<Booking> bookingOpt = bookingService.getBookingByPnr(pnr);
        
        if (bookingOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Booking booking = bookingOpt.get();
        
        // Ensure only PAID bookings can have a bill generated
        if (!"PAID".equalsIgnoreCase(booking.getStatus())) {
            return ResponseEntity.badRequest().body("Bill can only be generated for paid bookings.".getBytes());
        }

        try {
            byte[] pdfBytes = notificationService.generateBillPdf(booking);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDispositionFormData("attachment", "Bill_" + pnr + ".pdf");
            headers.setCacheControl("must-revalidate, post-check=0, pre-check=0");
            
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(pdfBytes);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
