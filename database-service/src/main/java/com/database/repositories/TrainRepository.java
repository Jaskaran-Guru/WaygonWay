package com.database.repositories;

import com.database.models.Train;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface TrainRepository extends MongoRepository<Train, String> {

    
    Optional<Train> findByTrainNumber(String trainNumber);

    
    List<Train> findBySourceAndDestination(String source, String destination);
    Page<Train> findBySourceAndDestination(String source, String destination, Pageable pageable);

    
    List<Train> findBySource(String source);

    
    List<Train> findByDestination(String destination);

    
    List<Train> findByStatus(String status);

    
    @Query("{ 'status': 'ACTIVE' }")
    List<Train> findActiveTrains();

    
    @Query("{ 'availableSeats': { $gt: 0 }, 'status': 'ACTIVE' }")
    List<Train> findTrainsWithAvailableSeats();

    
    @Query("{ 'departureTime': { $gte: ?0, $lte: ?1 } }")
    List<Train> findByDepartureTimeBetween(LocalDateTime startTime, LocalDateTime endTime);

    
    @Query("{ 'price': { $gte: ?0, $lte: ?1 } }")
    List<Train> findByPriceRange(double minPrice, double maxPrice);

    
    @Query("{ 'trainName': { $regex: ?0, $options: 'i' } }")
    List<Train> findByTrainNameContaining(String trainName);

    
    @Query("{ 'source': ?0, 'destination': ?1, 'availableSeats': { $gt: 0 }, 'status': 'ACTIVE' }")
    List<Train> findAvailableTrainsByRoute(String source, String destination);

    
    @Query("{ 'departureTime': { $gte: ?0, $lt: ?1 } }")
    List<Train> findTrainsDepartingToday(LocalDateTime startOfDay, LocalDateTime endOfDay);

    
    long countByStatus(String status);

    
    @Query(value = "{ 'status': 'ACTIVE' }", count = true)
    long countActiveTrains();

    
    List<Train> findByTrainType(String trainType);

    
    @Query("{ 'stoppages': { $in: [?0] } }")
    List<Train> findTrainsWithStoppage(String stoppage);

    
    @Query("{ $or: [ " +
            "{ 'trainName': { $regex: ?0, $options: 'i' } }, " +
            "{ 'trainNumber': { $regex: ?0, $options: 'i' } }, " +
            "{ 'source': { $regex: ?0, $options: 'i' } }, " +
            "{ 'destination': { $regex: ?0, $options: 'i' } } ] }")
    List<Train> searchTrains(String query);
}
