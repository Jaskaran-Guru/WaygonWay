package com.database.repositories;

import com.database.models.Ticket;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface TicketRepository extends MongoRepository<Ticket, String> {

    
    Optional<Ticket> findByPnr(String pnr);

    
    List<Ticket> findByUserId(String userId);
    Page<Ticket> findByUserId(String userId, Pageable pageable);

    
    List<Ticket> findByTrainId(String trainId);

    
    List<Ticket> findByBookingStatus(String bookingStatus);

    
    List<Ticket> findByPaymentStatus(String paymentStatus);

    
    List<Ticket> findByUserIdAndBookingStatus(String userId, String bookingStatus);

    
    @Query("{ 'bookingDate': { $gte: ?0, $lte: ?1 } }")
    List<Ticket> findByBookingDateBetween(LocalDateTime startDate, LocalDateTime endDate);

    
    @Query("{ 'travelDate': { $gte: ?0, $lte: ?1 } }")
    List<Ticket> findByTravelDateBetween(LocalDateTime startDate, LocalDateTime endDate);

    
    @Query("{ 'bookingDate': { $gte: ?0, $lt: ?1 } }")
    List<Ticket> findTicketsBookedToday(LocalDateTime startOfDay, LocalDateTime endOfDay);

    
    @Query("{ 'userId': ?0, 'travelDate': { $gte: ?1 }, 'bookingStatus': 'CONFIRMED' }")
    List<Ticket> findUpcomingTicketsForUser(String userId, LocalDateTime currentTime);

    
    @Query("{ 'userId': ?0, 'travelDate': { $lt: ?1 } }")
    List<Ticket> findPastTicketsForUser(String userId, LocalDateTime currentTime);

    
    @Query("{ 'bookingStatus': 'CONFIRMED' }")
    List<Ticket> findConfirmedTickets();

    
    @Query("{ 'bookingStatus': 'CANCELLED' }")
    List<Ticket> findCancelledTickets();

    
    long countByBookingStatus(String bookingStatus);

    
    long countByUserId(String userId);

    
    List<Ticket> findByTrainNumber(String trainNumber);

    
    @Query("{ 'sourceStation': ?0, 'destinationStation': ?1 }")
    List<Ticket> findByRoute(String source, String destination);

    
    @Query("{ 'totalAmount': { $gte: ?0 } }")
    List<Ticket> findTicketsWithAmountGreaterThan(double amount);

    
    @Query("{ 'pnr': { $regex: ?0, $options: 'i' } }")
    List<Ticket> findByPnrContaining(String pnrPattern);

    
    @Query("{ 'userId': ?0, 'travelDate': { $gte: ?1, $lte: ?2 } }")
    List<Ticket> findByUserIdAndTravelDateBetween(String userId, LocalDateTime startDate, LocalDateTime endDate);

    
    @Query("{ 'bookingStatus': 'CONFIRMED', 'paymentStatus': 'PAID' }")
    List<Ticket> findPaidConfirmedTickets();
}
