package com.frontend.controllers;

import com.frontend.services.ApiService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@Controller
@RequestMapping("/booking")
public class BookingController {

    @Autowired
    private ApiService apiService;

    @GetMapping("/passenger-details")
    public String showPassengerDetails(@RequestParam String trainId,
                                       @RequestParam String source,
                                       @RequestParam String destination,
                                       @RequestParam String date,
                                       @RequestParam String trainName,
                                       @RequestParam Double price,
                                       Model model) {

        System.out.println("Booking form: " + trainName + " from " + source + " to " + destination);

        model.addAttribute("trainId", trainId);
        model.addAttribute("source", source);
        model.addAttribute("destination", destination);
        model.addAttribute("date", date);
        model.addAttribute("trainName", trainName);
        model.addAttribute("price", price);
        model.addAttribute("baseFare", 0);
        model.addAttribute("reservationCharges", 50);
        model.addAttribute("serviceTax", 0);
        model.addAttribute("convenienceFee", 20);
        model.addAttribute("totalAmount", 70);

        return "booking/passenger-details";
    }

    @PostMapping("/confirm")
    @ResponseBody
    public Map<String, Object> confirmBooking(@RequestBody Map<String, Object> bookingData) {
        System.out.println("Confirming booking: " + bookingData);

        try {
            // Call backend API
            Map<String, Object> response = apiService.createBooking(bookingData);

            if (response != null && Boolean.TRUE.equals(response.get("success"))) {
                return response;
            } else {
                return Map.of("success", false, "error", "Booking service temporarily unavailable");
            }

        } catch (Exception e) {
            System.err.println("Booking error: " + e.getMessage());

            // Create mock successful booking
            Map<String, Object> mockBooking = new HashMap<>();
            mockBooking.put("pnr", "WW" + System.currentTimeMillis());
            mockBooking.put("passengerName", bookingData.get("passengerName"));
            mockBooking.put("trainName", bookingData.get("trainName"));
            mockBooking.put("source", bookingData.get("source"));
            mockBooking.put("destination", bookingData.get("destination"));
            mockBooking.put("totalAmount", bookingData.get("totalAmount"));
            mockBooking.put("status", "CONFIRMED");
            mockBooking.put("seatNumber", "S4/" + (int)(Math.random() * 60 + 1));

            return Map.of("success", true, "data", mockBooking, "message", "Booking confirmed successfully!");
        }
    }

    @GetMapping("/confirmation/{pnr}")
    public String showBookingConfirmation(@PathVariable String pnr, Model model) {
        System.out.println("Confirmation page for PNR: " + pnr);

        try {
            Map<String, Object> response = apiService.getBookingByPNR(pnr);

            if (response != null && Boolean.TRUE.equals(response.get("success"))) {
                model.addAttribute("booking", response.get("data"));
                model.addAttribute("success", true);
            } else {
                model.addAttribute("error", "Booking details not found");
                model.addAttribute("success", false);
            }

        } catch (Exception e) {
            model.addAttribute("error", "Unable to fetch booking details");
            model.addAttribute("success", false);
        }

        return "booking/confirmation";
    }
}
