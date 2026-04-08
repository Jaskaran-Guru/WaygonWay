package com.database.services;

import com.database.models.Train;
import com.database.repositories.TrainRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class TrainService {

    @Autowired
    private TrainRepository trainRepository;

    // Get all trains
    public List<Train> getAllTrains() {
        try {
            System.out.println("TrainService: Getting all trains");
            List<Train> trains = trainRepository.findAll();
            System.out.println("TrainService: Retrieved " + trains.size() + " trains");
            return trains;
        } catch (Exception e) {
            System.err.println("TrainService: Error getting all trains - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve trains", e);
        }
    }

    // Get train by ID
    public Train getTrainById(String trainId) {
        try {
            System.out.println("TrainService: Getting train by ID - " + trainId);
            Optional<Train> trainOpt = trainRepository.findById(trainId);
            if (trainOpt.isEmpty()) {
                throw new RuntimeException("Train not found with ID: " + trainId);
            }
            Train train = trainOpt.get();
            System.out.println("TrainService: Train found - " + train.getTrainNumber());
            return train;
        } catch (Exception e) {
            System.err.println("TrainService: Error getting train by ID - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve train", e);
        }
    }

    // Get train by number
    public Train getTrainByNumber(String trainNumber) {
        try {
            System.out.println("TrainService: Getting train by number - " + trainNumber);
            Optional<Train> trainOpt = trainRepository.findByTrainNumber(trainNumber);
            if (trainOpt.isEmpty()) {
                throw new RuntimeException("Train not found with number: " + trainNumber);
            }
            Train train = trainOpt.get();
            System.out.println("TrainService: Train found - " + train.getTrainName());
            return train;
        } catch (Exception e) {
            System.err.println("TrainService: Error getting train by number - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve train", e);
        }
    }

    // Search trains by route
    public List<Train> searchTrainsByRoute(String source, String destination) {
        try {
            System.out.println("TrainService: Searching trains from " + source + " to " + destination);
            List<Train> trains = trainRepository.findAvailableTrainsByRoute(source, destination);
            System.out.println("TrainService: Found " + trains.size() + " available trains");
            return trains;
        } catch (Exception e) {
            System.err.println("TrainService: Error searching trains - " + e.getMessage());
            throw new RuntimeException("Failed to search trains", e);
        }
    }

    // Add new train
    public Train addTrain(Train train) {
        try {
            System.out.println("TrainService: Adding new train - " + train.getTrainNumber());

            // Check if train number already exists
            if (trainRepository.findByTrainNumber(train.getTrainNumber()).isPresent()) {
                throw new RuntimeException("Train with number " + train.getTrainNumber() + " already exists");
            }

            train.setCreatedAt(LocalDateTime.now());
            train.setUpdatedAt(LocalDateTime.now());

            Train savedTrain = trainRepository.save(train);
            System.out.println("TrainService: Train added successfully - " + savedTrain.getTrainNumber());
            return savedTrain;
        } catch (Exception e) {
            System.err.println("TrainService: Error adding train - " + e.getMessage());
            throw new RuntimeException("Failed to add train", e);
        }
    }

    // Update train
    public Train updateTrain(String trainId, Train updatedTrain) {
        try {
            System.out.println("TrainService: Updating train - " + trainId);

            Train existingTrain = getTrainById(trainId);

            // Update fields
            if (updatedTrain.getTrainName() != null) {
                existingTrain.setTrainName(updatedTrain.getTrainName());
            }
            if (updatedTrain.getSource() != null) {
                existingTrain.setSource(updatedTrain.getSource());
            }
            if (updatedTrain.getDestination() != null) {
                existingTrain.setDestination(updatedTrain.getDestination());
            }
            if (updatedTrain.getDepartureTime() != null) {
                existingTrain.setDepartureTime(updatedTrain.getDepartureTime());
            }
            if (updatedTrain.getArrivalTime() != null) {
                existingTrain.setArrivalTime(updatedTrain.getArrivalTime());
            }
            if (updatedTrain.getTotalSeats() > 0) {
                existingTrain.setTotalSeats(updatedTrain.getTotalSeats());
            }
            if (updatedTrain.getPrice() > 0) {
                existingTrain.setPrice(updatedTrain.getPrice());
            }
            if (updatedTrain.getStatus() != null) {
                existingTrain.setStatus(updatedTrain.getStatus());
            }
            if (updatedTrain.getTrainType() != null) {
                existingTrain.setTrainType(updatedTrain.getTrainType());
            }

            existingTrain.setUpdatedAt(LocalDateTime.now());

            Train savedTrain = trainRepository.save(existingTrain);
            System.out.println("TrainService: Train updated successfully - " + savedTrain.getTrainNumber());
            return savedTrain;
        } catch (Exception e) {
            System.err.println("TrainService: Error updating train - " + e.getMessage());
            throw new RuntimeException("Failed to update train", e);
        }
    }

    // Delete train
    public Map<String, Object> deleteTrain(String trainId) {
        try {
            System.out.println("TrainService: Deleting train - " + trainId);

            Train train = getTrainById(trainId);
            trainRepository.deleteById(trainId);

            Map<String, Object> result = new HashMap<>();
            result.put("deleted", true);
            result.put("trainId", trainId);
            result.put("trainNumber", train.getTrainNumber());
            result.put("deletedAt", LocalDateTime.now());

            System.out.println("TrainService: Train deleted successfully - " + train.getTrainNumber());
            return result;
        } catch (Exception e) {
            System.err.println("TrainService: Error deleting train - " + e.getMessage());
            throw new RuntimeException("Failed to delete train", e);
        }
    }

    // Book seats (reduce available seats)
    public boolean bookSeats(String trainId, int seatsToBook) {
        try {
            System.out.println("TrainService: Booking " + seatsToBook + " seats for train - " + trainId);

            Train train = getTrainById(trainId);

            if (train.getAvailableSeats() < seatsToBook) {
                throw new RuntimeException("Not enough seats available. Available: " + train.getAvailableSeats() + ", Requested: " + seatsToBook);
            }

            train.setAvailableSeats(train.getAvailableSeats() - seatsToBook);
            train.setUpdatedAt(LocalDateTime.now());

            trainRepository.save(train);

            System.out.println("TrainService: Seats booked successfully. Remaining seats: " + train.getAvailableSeats());
            return true;
        } catch (Exception e) {
            System.err.println("TrainService: Error booking seats - " + e.getMessage());
            throw new RuntimeException("Failed to book seats", e);
        }
    }

    // Cancel seats (increase available seats)
    public boolean cancelSeats(String trainId, int seatsToCancel) {
        try {
            System.out.println("TrainService: Cancelling " + seatsToCancel + " seats for train - " + trainId);

            Train train = getTrainById(trainId);

            int newAvailableSeats = train.getAvailableSeats() + seatsToCancel;
            if (newAvailableSeats > train.getTotalSeats()) {
                newAvailableSeats = train.getTotalSeats();
            }

            train.setAvailableSeats(newAvailableSeats);
            train.setUpdatedAt(LocalDateTime.now());

            trainRepository.save(train);

            System.out.println("TrainService: Seats cancelled successfully. Available seats: " + train.getAvailableSeats());
            return true;
        } catch (Exception e) {
            System.err.println("TrainService: Error cancelling seats - " + e.getMessage());
            throw new RuntimeException("Failed to cancel seats", e);
        }
    }

    // Get trains with available seats
    public List<Train> getTrainsWithAvailableSeats() {
        try {
            System.out.println("TrainService: Getting trains with available seats");
            List<Train> trains = trainRepository.findTrainsWithAvailableSeats();
            System.out.println("TrainService: Found " + trains.size() + " trains with available seats");
            return trains;
        } catch (Exception e) {
            System.err.println("TrainService: Error getting available trains - " + e.getMessage());
            throw new RuntimeException("Failed to retrieve available trains", e);
        }
    }

    // Get train statistics
    public Map<String, Object> getTrainStatistics() {
        try {
            System.out.println("TrainService: Calculating train statistics");

            List<Train> allTrains = getAllTrains();

            Map<String, Object> stats = new HashMap<>();
            stats.put("totalTrains", allTrains.size());
            stats.put("activeTrains", allTrains.stream().filter(Train::isActive).count());
            stats.put("trainsWithSeats", allTrains.stream().filter(Train::hasAvailableSeats).count());

            // Calculate total and available seats
            int totalSeats = allTrains.stream().mapToInt(Train::getTotalSeats).sum();
            int availableSeats = allTrains.stream().mapToInt(Train::getAvailableSeats).sum();
            stats.put("totalSeats", totalSeats);
            stats.put("availableSeats", availableSeats);
            stats.put("bookedSeats", totalSeats - availableSeats);

            // Calculate average occupancy
            double avgOccupancy = allTrains.stream()
                    .mapToDouble(Train::getOccupancyPercentage)
                    .average()
                    .orElse(0.0);
            stats.put("averageOccupancy", Math.round(avgOccupancy * 100.0) / 100.0);

            stats.put("generatedAt", LocalDateTime.now());

            System.out.println("TrainService: Statistics calculated successfully");
            return stats;
        } catch (Exception e) {
            System.err.println("TrainService: Error calculating statistics - " + e.getMessage());
            throw new RuntimeException("Failed to calculate statistics", e);
        }
    }
}
