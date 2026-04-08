package com.database.services;

import com.database.models.Ticket;
import com.database.models.Train;
import com.database.repositories.TicketRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class TicketService {

    @Autowired
    private TicketRepository ticketRepository;

    @Autowired
    private TrainService trainService;

    // Generate PNR
    private String generatePNR() {
        Random random = new Random();
        StringBuilder pnr = new StringBuilder();

        // PNR format: 3 letters + 7 digits
        String letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        for (int i = 0; i < 3; i++) {
            pnr.append(letters.charAt(random.nextInt(letters.length())));
        }

        for (int i = 0; i < 7; i++) {
            pnr.append(random.nextInt(10));
        }

        return pnr.toString();
    }

    // Generate unique PNR
    private String generateUniquePNR() {
        String pnr;
        do {
            pnr = generatePNR();
        } while (ticketRepository.findByPnr(pnr).isPresent());

        return pnr;
    }

    // Book ticket
    public Ticket bookTicket(Ticket ticketRequest) {
        try {
            System.out.println("TicketService: Booking ticket for user - " + ticketRequest.getUserId());

            // Get train details
            Train train = trainService.getTrainById(ticketRequest.getTrainId());

            int seatsRequested = ticketRequest.getPassengers().size();

            // Check seat availability
            if (!train.hasAvailableSeats() || train.getAvailableSeats() < seatsRequested) {
                throw new RuntimeException("Not enough seats available. Available: " + train.getAvailableSeats() + ", Requested: " + seatsRequested);
            }

            // Generate unique PNR
            String pnr = generateUniquePNR();
            ticketRequest.setPnr(pnr);

            // Set train details in ticket
            ticketRequest.setTrainNumber(train.getTrainNumber());
            ticketRequest.setTrainName(train.getTrainName());
            ticketRequest.setSourceStation(train.getSource());
            ticketRequest.setDestinationStation(train.getDestination());

            // Generate seat numbers
            List<String> seatNumbers = generateSeatNumbers(train, seatsRequested);
            ticketRequest.setSeatNumbers(seatNumbers);

            // Assign seat numbers to passengers
            for (int i = 0; i < ticketRequest.getPassengers().size() && i < seatNumbers.size(); i++) {
                ticketRequest.getPassengers().get(i).setSeatNumber(seatNumbers.get(i));
            }

            // Set booking details
            ticketRequest.setBookingDate(LocalDateTime.now());
            ticketRequest.setBookingStatus("CONFIRMED");
            ticketRequest.setPaymentStatus("PAID");
            ticketRequest.setCreatedAt(LocalDateTime.now());
            ticketRequest.setUpdatedAt(LocalDateTime.now());

            // Calculate total amount if not set
            if (ticketRequest.getTotalAmount() == 0) {
                double totalAmount = train.getPrice() * seatsRequested;
                ticketRequest.setTotalAmount(totalAmount);
            }

            // Save ticket
            Ticket savedTicket = ticketRepository.save(ticketRequest);

            // Update train seat availability
            trainService.bookSeats(train.getId(), seatsRequested);

            System.out.println("TicketService: Ticket booked successfully - PNR: " + pnr);
            return savedTicket;

        } catch (Exception e) {
            System.err.println("TicketService: Error booking ticket - " + e.getMessage());
            throw new RuntimeException("Failed to book ticket: " + e.getMessage(), e);
        }
    }

    // Generate seat numbers
    private List<String> generateSeatNumbers(Train train, int seatsCount) {
        List<String> seatNumbers = new ArrayList<>();
        Random random = new Random();

        // Simple seat numbering: Coach-SeatNumber (e.g., S1-01, S2-15)
        int coachCount = (train.getTotalSeats() / 80) + 1; // Assume 80 seats per coach

        for (int i = 0; i < seatsCount; i++) {
            int coach = random.nextInt(coachCount) + 1;
            int seatNum = random.nextInt(80) + 1;
            String seatNumber = String.format("S%d-%02d", coach, seatNum);
            seatNumbers.add(seatNumber);
        }

        return seatNumbers;
    }

    // Get ticket by PNR
    public Ticket getTicketByPNR(String pnr) {
        try {
            System.out.println("TicketService: Getting ticket by PNR - " + pnr);

            Optional<Ticket> ticketOpt = ticketRepository.findByPnr(pnr);
            if (ticketOpt.isEmpty()) {
                throw new RuntimeException("Ticket not found with PNR: " + pnr);
            }

            Ticket ticket = ticketOpt.get();
            System.out.println("TicketService: Ticket found - " + ticket.getPnr());
            return ticket;

        } catch (Exception e) {
            System.err.println("TicketService: Error getting ticket by PNR - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve ticket", e);
        }
    }

    // Get user tickets
    public List<Ticket> getUserTickets(String userId) {
        try {
            System.out.println("TicketService: Getting tickets for user - " + userId);

            List<Ticket> tickets = ticketRepository.findByUserId(userId);

            System.out.println("TicketService: Retrieved " + tickets.size() + " tickets for user");
            return tickets;

        } catch (Exception e) {
            System.err.println("TicketService: Error getting user tickets - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve user tickets", e);
        }
    }

    // Get upcoming tickets for user
    public List<Ticket> getUpcomingTickets(String userId) {
        try {
            System.out.println("TicketService: Getting upcoming tickets for user - " + userId);

            List<Ticket> tickets = ticketRepository.findUpcomingTicketsForUser(userId, LocalDateTime.now());

            System.out.println("TicketService: Retrieved " + tickets.size() + " upcoming tickets");
            return tickets;

        } catch (Exception e) {
            System.err.println("TicketService: Error getting upcoming tickets - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve upcoming tickets", e);
        }
    }

    // Cancel ticket
    public Ticket cancelTicket(String pnr, String userId) {
        try {
            System.out.println("TicketService: Cancelling ticket - PNR: " + pnr);

            Ticket ticket = getTicketByPNR(pnr);

            // Verify user ownership
            if (!ticket.getUserId().equals(userId)) {
                throw new RuntimeException("Ticket does not belong to this user");
            }

            // Check if already cancelled
            if (ticket.isCancelled()) {
                throw new RuntimeException("Ticket is already cancelled");
            }

            // Check cancellation policy (example: can cancel up to 2 hours before departure)
            LocalDateTime departureTime = ticket.getTravelDate();
            if (LocalDateTime.now().isAfter(departureTime.minusHours(2))) {
                throw new RuntimeException("Cannot cancel ticket within 2 hours of departure");
            }

            // Cancel ticket
            ticket.setBookingStatus("CANCELLED");
            ticket.setPaymentStatus("REFUNDED");
            ticket.setUpdatedAt(LocalDateTime.now());

            Ticket savedTicket = ticketRepository.save(ticket);

            // Release seats back to train
            trainService.cancelSeats(ticket.getTrainId(), ticket.getPassengerCount());

            System.out.println("TicketService: Ticket cancelled successfully - PNR: " + pnr);
            return savedTicket;

        } catch (Exception e) {
            System.err.println("TicketService: Error cancelling ticket - " + e.getMessage());
            throw new RuntimeException("Failed to cancel ticket: " + e.getMessage(), e);
        }
    }

    // Get all tickets
    public List<Ticket> getAllTickets() {
        try {
            System.out.println("TicketService: Getting all tickets");
            List<Ticket> tickets = ticketRepository.findAll();
            System.out.println("TicketService: Retrieved " + tickets.size() + " tickets");
            return tickets;
        } catch (Exception e) {
            System.err.println("TicketService: Error getting all tickets - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve tickets", e);
        }
    }

    // Get tickets by status
    public List<Ticket> getTicketsByStatus(String status) {
        try {
            System.out.println("TicketService: Getting tickets by status - " + status);
            List<Ticket> tickets = ticketRepository.findByBookingStatus(status);
            System.out.println("TicketService: Retrieved " + tickets.size() + " tickets with status " + status);
            return tickets;
        } catch (Exception e) {
            System.err.println("TicketService: Error getting tickets by status - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve tickets by status", e);
        }
    }

    // Get ticket statistics
    public Map<String, Object> getTicketStatistics() {
        try {
            System.out.println("TicketService: Calculating ticket statistics");

            List<Ticket> allTickets = getAllTickets();
            List<Ticket> confirmedTickets = ticketRepository.findConfirmedTickets();
            List<Ticket> cancelledTickets = ticketRepository.findCancelledTickets();
            List<Ticket> paidTickets = ticketRepository.findPaidConfirmedTickets();

            // Today's bookings
            LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
            LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);
            List<Ticket> todaysBookings = ticketRepository.findTicketsBookedToday(startOfDay, endOfDay);

            Map<String, Object> stats = new HashMap<>();
            stats.put("totalTickets", allTickets.size());
            stats.put("confirmedTickets", confirmedTickets.size());
            stats.put("cancelledTickets", cancelledTickets.size());
            stats.put("todaysBookings", todaysBookings.size());

            // Revenue calculation
            double totalRevenue = paidTickets.stream()
                    .mapToDouble(Ticket::getTotalAmount)
                    .sum();
            stats.put("totalRevenue", Math.round(totalRevenue * 100.0) / 100.0);

            double todaysRevenue = todaysBookings.stream()
                    .filter(t -> "PAID".equals(t.getPaymentStatus()))
                    .mapToDouble(Ticket::getTotalAmount)
                    .sum();
            stats.put("todaysRevenue", Math.round(todaysRevenue * 100.0) / 100.0);

            // Passenger statistics
            int totalPassengers = allTickets.stream()
                    .mapToInt(Ticket::getPassengerCount)
                    .sum();
            stats.put("totalPassengers", totalPassengers);

            // Average ticket value
            double avgTicketValue = totalRevenue / Math.max(paidTickets.size(), 1);
            stats.put("averageTicketValue", Math.round(avgTicketValue * 100.0) / 100.0);

            // Popular routes
            Map<String, Long> routeStats = allTickets.stream()
                    .filter(t -> t.getSourceStation() != null && t.getDestinationStation() != null)
                    .collect(Collectors.groupingBy(
                            t -> t.getSourceStation() + " to " + t.getDestinationStation(),
                            Collectors.counting()
                    ));
            stats.put("popularRoutes", routeStats);

            stats.put("generatedAt", LocalDateTime.now());

            System.out.println("TicketService: Statistics calculated successfully");
            return stats;

        } catch (Exception e) {
            System.err.println("TicketService: Error calculating statistics - " + e.getMessage());
            throw new RuntimeException("Failed to calculate statistics", e);
        }
    }

    // Search tickets
    public List<Ticket> searchTickets(String searchQuery) {
        try {
            System.out.println("TicketService: Searching tickets - " + searchQuery);

            // Search by PNR pattern
            List<Ticket> tickets = ticketRepository.findByPnrContaining(searchQuery);

            System.out.println("TicketService: Search completed - Found " + tickets.size() + " tickets");
            return tickets;

        } catch (Exception e) {
            System.err.println("TicketService: Error searching tickets - " + e.getMessage());
            throw new RuntimeException("Failed to search tickets", e);
        }
    }

    // Get tickets by date range
    public List<Ticket> getTicketsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        try {
            System.out.println("TicketService: Getting tickets by date range");

            List<Ticket> tickets = ticketRepository.findByBookingDateBetween(startDate, endDate);

            System.out.println("TicketService: Retrieved " + tickets.size() + " tickets in date range");
            return tickets;

        } catch (Exception e) {
            System.err.println("TicketService: Error getting tickets by date range - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve tickets by date range", e);
        }
    }
}
