package com.frontend.controllers;

import com.frontend.services.ApiService;
import com.frontend.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;

import java.util.*;

@Controller
public class HomeController {

    @Autowired
    private ApiService apiService;

    @Autowired
    private UserService userService;

    // ========== HOME PAGE ==========

    @GetMapping("/")
    public String home(Model model, HttpSession session) {
        System.out.println("HomeController: Home page accessed");

        // Get current user data
        Map<String, Object> currentUser = userService.getCurrentUser(session);
        boolean isLoggedIn = userService.isLoggedIn(session);
        boolean isAdmin = userService.isAdmin(session);

        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("isAdmin", isAdmin);
        model.addAttribute("pageTitle", "Home - WaygonWay");

        // Service health checks
        model.addAttribute("authServiceHealthy", apiService.isAuthServiceHealthy());
        model.addAttribute("bookingServiceHealthy", apiService.isBookingServiceHealthy());
        model.addAttribute("databaseServiceHealthy", apiService.isDatabaseServiceHealthy());

        return "index";
    }

    // ========== AUTHENTICATION PAGES ==========

    @GetMapping("/login")
    public String loginPage(Model model, HttpSession session) {
        System.out.println("HomeController: Login page accessed");

        if (userService.isLoggedIn(session)) {
            return "redirect:/dashboard";
        }

        model.addAttribute("pageTitle", "Login - WaygonWay");
        return "login";
    }

    @PostMapping("/login")
    public String loginSubmit(@RequestParam String usernameOrEmail,
                              @RequestParam String password,
                              Model model, HttpSession session) {
        System.out.println("HomeController: Login attempt for - " + usernameOrEmail);

        try {
            Map<String, Object> response = apiService.login(usernameOrEmail, password);

            if (response.get("success").equals(true)) {
                @SuppressWarnings("unchecked")
                Map<String, Object> userData = (Map<String, Object>) response.get("data");

                userService.setUserSession(session, userData);

                System.out.println("Login successful for user: " + userData.get("username"));
                return "redirect:/dashboard";

            } else {
                String errorMsg = (String) response.get("error");
                model.addAttribute("errorMessage", errorMsg);
                model.addAttribute("pageTitle", "Login - WaygonWay");
                return "login";
            }

        } catch (Exception e) {
            System.err.println("Login error: " + e.getMessage());
            model.addAttribute("errorMessage", "Login failed. Please try again.");
            model.addAttribute("pageTitle", "Login - WaygonWay");
            return "login";
        }
    }

    @GetMapping("/register")
    public String registerPage(Model model, HttpSession session) {
        System.out.println("HomeController: Register page accessed");

        if (userService.isLoggedIn(session)) {
            return "redirect:/dashboard";
        }

        model.addAttribute("pageTitle", "Register - WaygonWay");
        return "register";
    }

    @PostMapping("/register")
    public String registerSubmit(@RequestParam String firstName,
                                 @RequestParam String lastName,
                                 @RequestParam String email,
                                 @RequestParam String username,
                                 @RequestParam String password,
                                 @RequestParam(required = false) String phone,
                                 @RequestParam(required = false) String city,
                                 @RequestParam(required = false) String state,
                                 Model model, HttpSession session) {
        System.out.println("HomeController: Registration attempt for - " + username);

        try {
            Map<String, Object> response = apiService.register(
                    username, email, password, firstName, lastName, phone, city, state);

            if (response.get("success").equals(true)) {
                System.out.println("Registration successful for user: " + username);
                model.addAttribute("successMessage", "Registration successful! Please login to continue.");
                model.addAttribute("pageTitle", "Login - WaygonWay");
                return "login";

            } else {
                String errorMsg = (String) response.get("error");
                model.addAttribute("errorMessage", errorMsg);
                model.addAttribute("pageTitle", "Register - WaygonWay");
                return "register";
            }

        } catch (Exception e) {
            System.err.println("Registration error: " + e.getMessage());
            model.addAttribute("errorMessage", "Registration failed. Please try again.");
            model.addAttribute("pageTitle", "Register - WaygonWay");
            return "register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, Model model) {
        System.out.println("HomeController: Logout accessed");

        userService.clearUserSession(session);
        model.addAttribute("successMessage", "Logged out successfully!");
        return "redirect:/";
    }

    // ========== USER PAGES ==========

    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        System.out.println("HomeController: Dashboard accessed");

        if (!userService.isLoggedIn(session)) {
            return "redirect:/login";
        }

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", true);
        model.addAttribute("pageTitle", "Dashboard - WaygonWay");

        // Get user bookings count
        try {
            String userId = userService.getUserId(session);
            if (userId != null) {
                Map<String, Object> response = apiService.getUserTickets(userId);
                if (response.get("success").equals(true)) {
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> bookings = (List<Map<String, Object>>) response.get("data");
                    model.addAttribute("bookings", bookings);
                    model.addAttribute("bookingCount", bookings.size());
                } else {
                    model.addAttribute("bookings", new ArrayList<>());
                    model.addAttribute("bookingCount", 0);
                }
            }
        } catch (Exception e) {
            System.err.println("Error getting user bookings: " + e.getMessage());
            model.addAttribute("bookings", new ArrayList<>());
            model.addAttribute("bookingCount", 0);
        }

        return "dashboard";
    }

    @GetMapping("/my-bookings")
    public String myBookings(Model model, HttpSession session) {
        System.out.println("HomeController: My bookings page accessed");

        if (!userService.isLoggedIn(session)) {
            return "redirect:/login";
        }

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", true);
        model.addAttribute("pageTitle", "My Bookings - WaygonWay");

        // Get user bookings
        try {
            String userId = userService.getUserId(session);
            System.out.println("Fetching bookings for user ID: " + userId);

            if (userId != null) {
                Map<String, Object> response = apiService.getUserTickets(userId);

                if (response.get("success").equals(true)) {
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> bookings = (List<Map<String, Object>>) response.get("data");
                    model.addAttribute("bookings", bookings);
                    System.out.println("Found " + bookings.size() + " bookings");
                } else {
                    model.addAttribute("bookings", new ArrayList<>());
                    System.out.println("No bookings found or API error");
                }
            } else {
                model.addAttribute("bookings", new ArrayList<>());
                System.out.println("User ID is null");
            }
        } catch (Exception e) {
            System.err.println("Error getting user bookings: " + e.getMessage());
            model.addAttribute("bookings", new ArrayList<>());
        }

        return "my-bookings";
    }

    // ========== SEARCH & BOOKING PAGES ==========

    @GetMapping("/search")
    public String searchPage(Model model, HttpSession session) {
        System.out.println("HomeController: Search page accessed");

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        boolean isLoggedIn = userService.isLoggedIn(session);

        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("pageTitle", "Search Trains - WaygonWay");

        return "search";
    }

    @PostMapping("/search")
    public String searchTrains(@RequestParam String source,
                               @RequestParam String destination,
                               @RequestParam String travelDate,
                               @RequestParam(required = false) String trainClass,
                               @RequestParam(required = false, defaultValue = "false") boolean flexibleDates,
                               @RequestParam(required = false, defaultValue = "true") boolean availableOnly,
                               Model model, HttpSession session) {
        System.out.println("HomeController: Train search - " + source + " to " + destination);

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        boolean isLoggedIn = userService.isLoggedIn(session);

        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("pageTitle", "Search Results - WaygonWay");

        // Store search query
        Map<String, Object> searchQuery = new HashMap<>();
        searchQuery.put("source", source);
        searchQuery.put("destination", destination);
        searchQuery.put("travelDate", travelDate);
        searchQuery.put("trainClass", trainClass);
        searchQuery.put("flexibleDates", flexibleDates);
        searchQuery.put("availableOnly", availableOnly);
        model.addAttribute("searchQuery", searchQuery);

        // Search trains
        try {
            Map<String, Object> response = apiService.searchTrains(source, destination, travelDate);

            if (response.get("success").equals(true)) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> trains = (List<Map<String, Object>>) response.get("data");
                model.addAttribute("trains", trains);
                System.out.println("Found " + trains.size() + " trains");
            } else {
                model.addAttribute("trains", new ArrayList<>());
                System.out.println("No trains found or API error");
            }
        } catch (Exception e) {
            System.err.println("Error searching trains: " + e.getMessage());
            model.addAttribute("trains", new ArrayList<>());
        }

        return "search-results";
    }

    @GetMapping("/pnr-status")
    public String pnrStatusPage(Model model, HttpSession session) {
        System.out.println("HomeController: PNR status page accessed");

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        boolean isLoggedIn = userService.isLoggedIn(session);

        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("pageTitle", "PNR Status - WaygonWay");

        return "pnr-status";
    }

    @PostMapping("/pnr-status")
    public String checkPNRStatus(@RequestParam String pnr,
                                 Model model, HttpSession session) {
        System.out.println("HomeController: PNR check for - " + pnr);

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        boolean isLoggedIn = userService.isLoggedIn(session);

        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("pageTitle", "PNR Status - WaygonWay");
        model.addAttribute("searchedPNR", pnr);

        // Check PNR status
        try {
            Map<String, Object> response = apiService.getTicketByPNR(pnr);

            if (response.get("success").equals(true)) {
                @SuppressWarnings("unchecked")
                Map<String, Object> booking = (Map<String, Object>) response.get("data");
                model.addAttribute("booking", booking);
                model.addAttribute("pnrFound", true);
                System.out.println("PNR found: " + pnr);
            } else {
                model.addAttribute("pnrFound", false);
                model.addAttribute("errorMessage", "PNR not found. Please check and try again.");
                System.out.println("PNR not found: " + pnr);
            }
        } catch (Exception e) {
            System.err.println("Error checking PNR: " + e.getMessage());
            model.addAttribute("pnrFound", false);
            model.addAttribute("errorMessage", "Error checking PNR status. Please try again.");
        }

        return "pnr-status";
    }

    // ========== BOOKING MANAGEMENT ==========

    @GetMapping("/book-ticket")
    public String bookTicketPage(@RequestParam(required = false) String eventId,
                                 Model model, HttpSession session) {
        System.out.println("HomeController: Book ticket page accessed");

        if (!userService.isLoggedIn(session)) {
            return "redirect:/login";
        }

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", true);
        model.addAttribute("pageTitle", "Book Ticket - WaygonWay");

        // Get event details if eventId provided
        if (eventId != null) {
            try {
                Map<String, Object> response = apiService.getEventById(eventId);
                if (response.get("success").equals(true)) {
                    model.addAttribute("selectedEvent", response.get("data"));
                }
            } catch (Exception e) {
                System.err.println("Error getting event details: " + e.getMessage());
            }
        }

        return "book-ticket";
    }

    @PostMapping("/book-ticket")
    public String bookTicketSubmit(@RequestParam String eventId,
                                   @RequestParam String passengerName,
                                   @RequestParam Integer passengerAge,
                                   @RequestParam String passengerGender,
                                   @RequestParam String trainClass,
                                   @RequestParam String journeyDate,
                                   Model model, HttpSession session) {
        System.out.println("HomeController: Ticket booking attempt");

        if (!userService.isLoggedIn(session)) {
            return "redirect:/login";
        }

        try {
            String userId = userService.getUserId(session);
            Map<String, Object> response = apiService.createBooking(
                    userId, eventId, passengerName, passengerAge,
                    passengerGender, trainClass, journeyDate);

            if (response.get("success").equals(true)) {
                @SuppressWarnings("unchecked")
                Map<String, Object> booking = (Map<String, Object>) response.get("data");
                String pnr = (String) booking.get("pnr");

                model.addAttribute("successMessage", "Booking successful! Your PNR is: " + pnr);
                return "redirect:/booking-confirmation?pnr=" + pnr;
            } else {
                model.addAttribute("errorMessage", response.get("error"));
                return "book-ticket";
            }
        } catch (Exception e) {
            System.err.println("Booking error: " + e.getMessage());
            model.addAttribute("errorMessage", "Booking failed. Please try again.");
            return "book-ticket";
        }
    }

    @GetMapping("/booking-confirmation")
    public String bookingConfirmation(@RequestParam String pnr,
                                      Model model, HttpSession session) {
        System.out.println("HomeController: Booking confirmation for PNR: " + pnr);

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        boolean isLoggedIn = userService.isLoggedIn(session);

        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("pageTitle", "Booking Confirmation - WaygonWay");

        // Get booking details
        try {
            Map<String, Object> response = apiService.getTicketByPNR(pnr);
            if (response.get("success").equals(true)) {
                model.addAttribute("booking", response.get("data"));
                model.addAttribute("pnr", pnr);
            }
        } catch (Exception e) {
            System.err.println("Error getting booking details: " + e.getMessage());
        }

        return "booking-confirmation";
    }

    // ========== ADMIN PAGES ==========

    @GetMapping("/admin-dashboard")
    public String adminDashboard(Model model, HttpSession session) {
        System.out.println("HomeController: Admin dashboard accessed");

        if (!userService.isAdmin(session)) {
            return "redirect:/login";
        }

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", true);
        model.addAttribute("isAdmin", true);
        model.addAttribute("pageTitle", "Admin Dashboard - WaygonWay");

        // Get admin statistics
        try {
            Map<String, Object> userStats = apiService.getUserStatistics();
            Map<String, Object> bookingStats = apiService.getTicketStatistics();

            model.addAttribute("userStats", userStats.get("data"));
            model.addAttribute("bookingStats", bookingStats.get("data"));

        } catch (Exception e) {
            System.err.println("Error getting admin stats: " + e.getMessage());
            model.addAttribute("userStats", new HashMap<>());
            model.addAttribute("bookingStats", new HashMap<>());
        }

        return "admin-dashboard";
    }

    @GetMapping("/admin/create-demo-data")
    public String createDemoData(Model model, HttpSession session) {
        System.out.println("HomeController: Creating demo train data");

        if (!userService.isAdmin(session)) {
            return "redirect:/login";
        }

        try {
            Map<String, Object> response = apiService.createDemoData();

            if (response.get("success").equals(true)) {
                model.addAttribute("successMessage", "Demo train data created successfully!");
            } else {
                model.addAttribute("errorMessage", "Failed to create demo data");
            }

        } catch (Exception e) {
            System.err.println("Error creating demo data: " + e.getMessage());
            model.addAttribute("errorMessage", "Error: " + e.getMessage());
        }

        return "redirect:/admin-dashboard";
    }

    // ========== SYSTEM STATUS ==========

    @GetMapping("/system-status")
    public String systemStatus(Model model, HttpSession session) {
        System.out.println("HomeController: System status page accessed");

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        boolean isLoggedIn = userService.isLoggedIn(session);

        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("pageTitle", "System Status - WaygonWay");

        // Check service health
        Map<String, Object> systemHealth = apiService.getSystemHealth();
        model.addAttribute("systemHealth", systemHealth);
        model.addAttribute("authServiceHealthy", systemHealth.get("auth"));
        model.addAttribute("bookingServiceHealthy", systemHealth.get("booking"));
        model.addAttribute("databaseServiceHealthy", systemHealth.get("database"));
        model.addAttribute("frontendHealthy", true);

        return "system-status";
    }

    // ========== PROFILE & SETTINGS ==========

    @GetMapping("/profile")
    public String profilePage(Model model, HttpSession session) {
        System.out.println("HomeController: Profile page accessed");

        if (!userService.isLoggedIn(session)) {
            return "redirect:/login";
        }

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", true);
        model.addAttribute("pageTitle", "Profile - WaygonWay");

        return "profile";
    }

    @GetMapping("/settings")
    public String settingsPage(Model model, HttpSession session) {
        System.out.println("HomeController: Settings page accessed");

        if (!userService.isLoggedIn(session)) {
            return "redirect:/login";
        }

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", true);
        model.addAttribute("pageTitle", "Settings - WaygonWay");

        return "settings";
    }

    // ========== API ENDPOINTS FOR AJAX ==========

    @GetMapping("/api/health-check")
    @ResponseBody
    public Map<String, Object> healthCheck() {
        System.out.println("HomeController: Health check API called");

        Map<String, Object> health = apiService.getSystemHealth();
        return Map.of("success", true, "data", health);
    }

    @GetMapping("/api/user-session")
    @ResponseBody
    public Map<String, Object> getUserSession(HttpSession session) {
        System.out.println("HomeController: User session API called");

        Map<String, Object> sessionInfo = userService.getSessionInfo(session);
        return Map.of("success", true, "data", sessionInfo);
    }

    // ========== ERROR HANDLERS ==========

    @GetMapping("/error")
    public String errorPage(Model model) {
        System.out.println("HomeController: Error page accessed");
        model.addAttribute("pageTitle", "Error - WaygonWay");
        return "error";
    }

    // ========== HELP & SUPPORT ==========

    @GetMapping("/help")
    public String helpPage(Model model, HttpSession session) {
        System.out.println("HomeController: Help page accessed");

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        boolean isLoggedIn = userService.isLoggedIn(session);

        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("pageTitle", "Help & Support - WaygonWay");

        return "help";
    }

    @GetMapping("/contact")
    public String contactPage(Model model, HttpSession session) {
        System.out.println("HomeController: Contact page accessed");

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        boolean isLoggedIn = userService.isLoggedIn(session);

        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("pageTitle", "Contact Us - WaygonWay");

        return "contact";
    }

    @GetMapping("/about")
    public String aboutPage(Model model, HttpSession session) {
        System.out.println("ℹ️ HomeController: About page accessed");

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        boolean isLoggedIn = userService.isLoggedIn(session);

        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("pageTitle", "About Us - WaygonWay");

        return "about";
    }

    // ========== CATCH-ALL FOR UNDEFINED ROUTES ==========

    @RequestMapping("/{path:[^\\.]*}")
    public String handleUndefinedRoutes(@PathVariable String path,
                                        Model model, HttpSession session) {
        System.out.println("HomeController: Undefined route accessed - /" + path);

        // Skip API and static resource paths
        if (path.startsWith("api") || path.startsWith("css") ||
                path.startsWith("js") || path.startsWith("images")) {
            return "forward:/error";
        }

        Map<String, Object> currentUser = userService.getCurrentUser(session);
        boolean isLoggedIn = userService.isLoggedIn(session);

        model.addAttribute("user", currentUser);
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("pageTitle", "Page Not Found - WaygonWay");
        model.addAttribute("requestedPath", "/" + path);

        return "error-404";
    }
}
