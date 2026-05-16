package com.database.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;
import jakarta.validation.constraints.*;
import java.time.LocalDateTime;
import java.util.List;

@Document(collection = "tickets")
public class Ticket {

    @Id
    private String id;

    @NotBlank(message = "PNR is required")
    @Indexed(unique = true)
    private String pnr;

    @NotBlank(message = "User ID is required")
    private String userId;

    @NotBlank(message = "Train ID is required")
    private String trainId;

    @NotEmpty(message = "At least one passenger is required")
    private List<PassengerInfo> passengers;

    @NotEmpty(message = "At least one seat is required")
    private List<String> seatNumbers;

    @DecimalMin(value = "0.0", message = "Total amount must be non-negative")
    private double totalAmount;

    @NotNull(message = "Booking date is required")
    private LocalDateTime bookingDate;

    @NotNull(message = "Travel date is required")
    private LocalDateTime travelDate;

    private String bookingStatus = "CONFIRMED"; 
    private String paymentStatus = "PAID"; 

    private String sourceStation;
    private String destinationStation;
    private String trainNumber;
    private String trainName;

    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();

    
    public static class PassengerInfo {
        @NotBlank(message = "Passenger name is required")
        private String name;

        @Min(value = 1, message = "Age must be at least 1")
        @Max(value = 120, message = "Age must be less than 120")
        private int age;

        @NotBlank(message = "Gender is required")
        private String gender;

        private String seatNumber;
        private String berthPreference; 

        
        public PassengerInfo() {}

        public PassengerInfo(String name, int age, String gender) {
            this.name = name;
            this.age = age;
            this.gender = gender;
        }

        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }

        public int getAge() { return age; }
        public void setAge(int age) { this.age = age; }

        public String getGender() { return gender; }
        public void setGender(String gender) { this.gender = gender; }

        public String getSeatNumber() { return seatNumber; }
        public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }

        public String getBerthPreference() { return berthPreference; }
        public void setBerthPreference(String berthPreference) { this.berthPreference = berthPreference; }

        @Override
        public String toString() {
            return "PassengerInfo{" +
                    "name='" + name + '\'' +
                    ", age=" + age +
                    ", gender='" + gender + '\'' +
                    ", seatNumber='" + seatNumber + '\'' +
                    '}';
        }
    }

    
    public Ticket() {}

    public Ticket(String pnr, String userId, String trainId, List<PassengerInfo> passengers,
                  double totalAmount, LocalDateTime travelDate) {
        this.pnr = pnr;
        this.userId = userId;
        this.trainId = trainId;
        this.passengers = passengers;
        this.totalAmount = totalAmount;
        this.travelDate = travelDate;
        this.bookingDate = LocalDateTime.now();
    }

    
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getPnr() { return pnr; }
    public void setPnr(String pnr) { this.pnr = pnr; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getTrainId() { return trainId; }
    public void setTrainId(String trainId) { this.trainId = trainId; }

    public List<PassengerInfo> getPassengers() { return passengers; }
    public void setPassengers(List<PassengerInfo> passengers) { this.passengers = passengers; }

    public List<String> getSeatNumbers() { return seatNumbers; }
    public void setSeatNumbers(List<String> seatNumbers) { this.seatNumbers = seatNumbers; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public LocalDateTime getBookingDate() { return bookingDate; }
    public void setBookingDate(LocalDateTime bookingDate) { this.bookingDate = bookingDate; }

    public LocalDateTime getTravelDate() { return travelDate; }
    public void setTravelDate(LocalDateTime travelDate) { this.travelDate = travelDate; }

    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getSourceStation() { return sourceStation; }
    public void setSourceStation(String sourceStation) { this.sourceStation = sourceStation; }

    public String getDestinationStation() { return destinationStation; }
    public void setDestinationStation(String destinationStation) { this.destinationStation = destinationStation; }

    public String getTrainNumber() { return trainNumber; }
    public void setTrainNumber(String trainNumber) { this.trainNumber = trainNumber; }

    public String getTrainName() { return trainName; }
    public void setTrainName(String trainName) { this.trainName = trainName; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    
    public boolean isConfirmed() {
        return "CONFIRMED".equalsIgnoreCase(bookingStatus);
    }

    public boolean isCancelled() {
        return "CANCELLED".equalsIgnoreCase(bookingStatus);
    }

    public boolean isPaid() {
        return "PAID".equalsIgnoreCase(paymentStatus);
    }

    public int getPassengerCount() {
        return passengers != null ? passengers.size() : 0;
    }

    @Override
    public String toString() {
        return "Ticket{" +
                "id='" + id + '\'' +
                ", pnr='" + pnr + '\'' +
                ", userId='" + userId + '\'' +
                ", trainId='" + trainId + '\'' +
                ", passengerCount=" + getPassengerCount() +
                ", totalAmount=" + totalAmount +
                ", bookingStatus='" + bookingStatus + '\'' +
                ", travelDate=" + travelDate +
                '}';
    }
}
