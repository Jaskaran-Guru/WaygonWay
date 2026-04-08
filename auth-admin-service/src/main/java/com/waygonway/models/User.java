package com.waygonway.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;
import jakarta.validation.constraints.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Document(collection = "users")
public class User {

    @Id
    private String id;

    @NotBlank(message = "Username is required")
    @Indexed(unique = true)
    private String username;

    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    @Indexed(unique = true)
    private String email;

    @NotBlank(message = "Password is required")
    private String password;

    @NotBlank(message = "First name is required")
    private String firstName;

    @NotBlank(message = "Last name is required")
    private String lastName;

    private String phone;
    private String role = "USER";
    private String status = "ACTIVE";

    private Address address;
    private UserPreferences preferences;
    private LoginHistory loginHistory;
    private ProfileData profile;

    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();

    // Complete Address Information
    public static class Address {
        private String street;
        private String city;
        private String state;
        private String country = "India";
        private String zipCode;
        private String landmark;
        private String addressType = "HOME"; // HOME, OFFICE, OTHER

        // Constructors, getters, setters
        public Address() {}

        public String getStreet() { return street; }
        public void setStreet(String street) { this.street = street; }

        public String getCity() { return city; }
        public void setCity(String city) { this.city = city; }

        public String getState() { return state; }
        public void setState(String state) { this.state = state; }

        public String getCountry() { return country; }
        public void setCountry(String country) { this.country = country; }

        public String getZipCode() { return zipCode; }
        public void setZipCode(String zipCode) { this.zipCode = zipCode; }

        public String getLandmark() { return landmark; }
        public void setLandmark(String landmark) { this.landmark = landmark; }

        public String getAddressType() { return addressType; }
        public void setAddressType(String addressType) { this.addressType = addressType; }
    }

    // User Preferences
    public static class UserPreferences {
        private String preferredLanguage = "English";
        private String currency = "INR";
        private boolean emailNotifications = true;
        private boolean smsNotifications = true;
        private String seatPreference = "WINDOW"; // WINDOW, AISLE, ANY
        private String mealPreference = "VEG"; // VEG, NON_VEG, JAIN, VEGAN
        private List<String> frequentRoutes;

        // Constructors, getters, setters
        public UserPreferences() {}

        public String getPreferredLanguage() { return preferredLanguage; }
        public void setPreferredLanguage(String preferredLanguage) { this.preferredLanguage = preferredLanguage; }

        public String getCurrency() { return currency; }
        public void setCurrency(String currency) { this.currency = currency; }

        public boolean isEmailNotifications() { return emailNotifications; }
        public void setEmailNotifications(boolean emailNotifications) { this.emailNotifications = emailNotifications; }

        public boolean isSmsNotifications() { return smsNotifications; }
        public void setSmsNotifications(boolean smsNotifications) { this.smsNotifications = smsNotifications; }

        public String getSeatPreference() { return seatPreference; }
        public void setSeatPreference(String seatPreference) { this.seatPreference = seatPreference; }

        public String getMealPreference() { return mealPreference; }
        public void setMealPreference(String mealPreference) { this.mealPreference = mealPreference; }

        public List<String> getFrequentRoutes() { return frequentRoutes; }
        public void setFrequentRoutes(List<String> frequentRoutes) { this.frequentRoutes = frequentRoutes; }
    }

    // Login History & Session Data
    public static class LoginHistory {
        private LocalDateTime lastLogin;
        private String lastLoginIp;
        private String lastLoginDevice;
        private List<LoginSession> recentLogins;
        private int totalLogins = 0;
        private boolean isCurrentlyLoggedIn = false;

        public static class LoginSession {
            private LocalDateTime loginTime;
            private LocalDateTime logoutTime;
            private String ipAddress;
            private String userAgent;
            private String location;
            private String sessionId;

            // Constructors, getters, setters
            public LoginSession() {}
            public LoginSession(String sessionId, String ipAddress, String userAgent) {
                this.sessionId = sessionId;
                this.ipAddress = ipAddress;
                this.userAgent = userAgent;
                this.loginTime = LocalDateTime.now();
            }

            // All getters and setters
            public LocalDateTime getLoginTime() { return loginTime; }
            public void setLoginTime(LocalDateTime loginTime) { this.loginTime = loginTime; }

            public LocalDateTime getLogoutTime() { return logoutTime; }
            public void setLogoutTime(LocalDateTime logoutTime) { this.logoutTime = logoutTime; }

            public String getIpAddress() { return ipAddress; }
            public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

            public String getUserAgent() { return userAgent; }
            public void setUserAgent(String userAgent) { this.userAgent = userAgent; }

            public String getLocation() { return location; }
            public void setLocation(String location) { this.location = location; }

            public String getSessionId() { return sessionId; }
            public void setSessionId(String sessionId) { this.sessionId = sessionId; }
        }

        // Constructors, getters, setters for LoginHistory
        public LoginHistory() {}

        public LocalDateTime getLastLogin() { return lastLogin; }
        public void setLastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; }

        public String getLastLoginIp() { return lastLoginIp; }
        public void setLastLoginIp(String lastLoginIp) { this.lastLoginIp = lastLoginIp; }

        public String getLastLoginDevice() { return lastLoginDevice; }
        public void setLastLoginDevice(String lastLoginDevice) { this.lastLoginDevice = lastLoginDevice; }

        public List<LoginSession> getRecentLogins() { return recentLogins; }
        public void setRecentLogins(List<LoginSession> recentLogins) { this.recentLogins = recentLogins; }

        public int getTotalLogins() { return totalLogins; }
        public void setTotalLogins(int totalLogins) { this.totalLogins = totalLogins; }

        public boolean isCurrentlyLoggedIn() { return isCurrentlyLoggedIn; }
        public void setCurrentlyLoggedIn(boolean currentlyLoggedIn) { isCurrentlyLoggedIn = currentlyLoggedIn; }
    }

    // Profile Data & Statistics
    public static class ProfileData {
        private String profilePicture;
        private String bio;
        private String occupation;
        private LocalDateTime dateOfBirth;
        private String gender;
        private String nationality = "Indian";
        private String emergencyContact;
        private String emergencyContactName;
        private Map<String, Object> customFields;

        // Travel Statistics
        private int totalBookings = 0;
        private int cancelledBookings = 0;
        private double totalAmountSpent = 0.0;
        private List<String> visitedCities;

        // Constructors, getters, setters
        public ProfileData() {}

        public String getProfilePicture() { return profilePicture; }
        public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }

        public String getBio() { return bio; }
        public void setBio(String bio) { this.bio = bio; }

        public String getOccupation() { return occupation; }
        public void setOccupation(String occupation) { this.occupation = occupation; }

        public LocalDateTime getDateOfBirth() { return dateOfBirth; }
        public void setDateOfBirth(LocalDateTime dateOfBirth) { this.dateOfBirth = dateOfBirth; }

        public String getGender() { return gender; }
        public void setGender(String gender) { this.gender = gender; }

        public String getNationality() { return nationality; }
        public void setNationality(String nationality) { this.nationality = nationality; }

        public String getEmergencyContact() { return emergencyContact; }
        public void setEmergencyContact(String emergencyContact) { this.emergencyContact = emergencyContact; }

        public String getEmergencyContactName() { return emergencyContactName; }
        public void setEmergencyContactName(String emergencyContactName) { this.emergencyContactName = emergencyContactName; }

        public Map<String, Object> getCustomFields() { return customFields; }
        public void setCustomFields(Map<String, Object> customFields) { this.customFields = customFields; }

        public int getTotalBookings() { return totalBookings; }
        public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }

        public int getCancelledBookings() { return cancelledBookings; }
        public void setCancelledBookings(int cancelledBookings) { this.cancelledBookings = cancelledBookings; }

        public double getTotalAmountSpent() { return totalAmountSpent; }
        public void setTotalAmountSpent(double totalAmountSpent) { this.totalAmountSpent = totalAmountSpent; }

        public List<String> getVisitedCities() { return visitedCities; }
        public void setVisitedCities(List<String> visitedCities) { this.visitedCities = visitedCities; }
    }

    // Constructors
    public User() {
        this.preferences = new UserPreferences();
        this.loginHistory = new LoginHistory();
        this.profile = new ProfileData();
    }

    // All Main Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Address getAddress() { return address; }
    public void setAddress(Address address) { this.address = address; }

    public UserPreferences getPreferences() { return preferences; }
    public void setPreferences(UserPreferences preferences) { this.preferences = preferences; }

    public LoginHistory getLoginHistory() { return loginHistory; }
    public void setLoginHistory(LoginHistory loginHistory) { this.loginHistory = loginHistory; }

    public ProfileData getProfile() { return profile; }
    public void setProfile(ProfileData profile) { this.profile = profile; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    // Utility Methods
    public String getFullName() {
        return firstName + " " + lastName;
    }

    public boolean isActive() {
        return "ACTIVE".equals(status);
    }

    public boolean isAdmin() {
        return "ADMIN".equals(role);
    }

    public void updateLoginHistory(String sessionId, String ipAddress, String userAgent) {
        if (loginHistory == null) {
            loginHistory = new LoginHistory();
        }

        loginHistory.setLastLogin(LocalDateTime.now());
        loginHistory.setLastLoginIp(ipAddress);
        loginHistory.setLastLoginDevice(userAgent);
        loginHistory.setTotalLogins(loginHistory.getTotalLogins() + 1);
        loginHistory.setCurrentlyLoggedIn(true);

        // Add to recent logins
        if (loginHistory.getRecentLogins() == null) {
            loginHistory.setRecentLogins(new java.util.ArrayList<>());
        }

        LoginHistory.LoginSession session = new LoginHistory.LoginSession(sessionId, ipAddress, userAgent);
        loginHistory.getRecentLogins().add(0, session); // Add at beginning

        // Keep only last 10 sessions
        if (loginHistory.getRecentLogins().size() > 10) {
            loginHistory.getRecentLogins().subList(10, loginHistory.getRecentLogins().size()).clear();
        }
    }

    public void updateProfileStats(double amountSpent, String cityVisited) {
        if (profile == null) {
            profile = new ProfileData();
        }

        profile.setTotalBookings(profile.getTotalBookings() + 1);
        profile.setTotalAmountSpent(profile.getTotalAmountSpent() + amountSpent);

        if (profile.getVisitedCities() == null) {
            profile.setVisitedCities(new java.util.ArrayList<>());
        }

        if (cityVisited != null && !profile.getVisitedCities().contains(cityVisited)) {
            profile.getVisitedCities().add(cityVisited);
        }
    }

    @Override
    public String toString() {
        return "User{" +
                "id='" + id + '\'' +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + getFullName() + '\'' +
                ", role='" + role + '\'' +
                ", status='" + status + '\'' +
                ", totalBookings=" + (profile != null ? profile.getTotalBookings() : 0) +
                ", createdAt=" + createdAt +
                '}';
    }
}
