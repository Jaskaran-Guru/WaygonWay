<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --navy: #0a0f2e;
            --royal: #1a2b6b;
            --cobalt: #1e3a8a;
            --azure: #2563eb;
            --sky: #3b82f6;
            --ice: #93c5fd;
            --gold: #f59e0b;
            --gold-light: #fcd34d;
            --emerald: #10b981;
            --emerald-dim: rgba(16,185,129,0.12);
            --white: #ffffff;
            --glass: rgba(255,255,255,0.05);
            --glass-border: rgba(255,255,255,0.1);
            --text-muted: rgba(255,255,255,0.45);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background-color: var(--navy);
            font-family: 'DM Sans', sans-serif;
            min-height: 100vh;
            padding-top: 76px;
        }

        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background:
                radial-gradient(ellipse 70% 55% at 10% 5%, rgba(37,99,235,0.38) 0%, transparent 60%),
                radial-gradient(ellipse 55% 65% at 90% 90%, rgba(30,58,138,0.4) 0%, transparent 55%),
                radial-gradient(ellipse 40% 40% at 50% 50%, rgba(10,15,46,0.85) 0%, transparent 100%);
            z-index: 0;
            pointer-events: none;
        }

        body::after {
            content: '';
            position: fixed;
            inset: 0;
            background-image:
                linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
            background-size: 60px 60px;
            z-index: 0;
            pointer-events: none;
        }

        /*  Navbar  */
        .navbar {
            background: rgba(10,15,46,0.75);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--glass-border);
            padding: 0.85rem 0;
        }

        .navbar-brand {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.5rem !important;
            color: var(--white) !important;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .navbar-brand .brand-icon {
            width: 34px;
            height: 34px;
            background: linear-gradient(135deg, var(--azure), var(--gold));
            border-radius: 9px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }

        .nav-link {
            color: rgba(255,255,255,0.65) !important;
            font-size: 0.88rem;
            padding: 0.4rem 0.9rem !important;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .nav-link:hover {
            color: var(--white) !important;
            background: var(--glass);
        }

        .btn-nav-search {
            background: linear-gradient(135deg, var(--azure), var(--sky));
            border: none;
            color: white !important;
            font-size: 0.85rem;
            font-weight: 600;
            padding: 0.42rem 1.1rem;
            border-radius: 8px;
            transition: all 0.25s ease;
            text-decoration: none;
        }

        .btn-nav-search:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(37,99,235,0.35);
        }

        /*  Container  */
        .container { position: relative; z-index: 1; padding-top: 2.5rem; padding-bottom: 3rem; }

        /*  Page Header  */
        .page-header { text-align: center; margin-bottom: 2.2rem; animation: fade-up 0.5s ease both; }

        .page-header h2 {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 2rem;
            color: var(--white);
            letter-spacing: -0.5px;
            margin-bottom: 6px;
        }

        .page-header p {
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        /*  Step Indicator  */
        .step-indicator {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0;
            margin-bottom: 2rem;
            animation: fade-up 0.5s ease 0.05s both;
        }

        .step-wrapper {
            display: flex;
            align-items: center;
        }

        .step {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 0.95rem;
            position: relative;
            z-index: 1;
        }

        .step.active {
            background: linear-gradient(135deg, var(--azure), var(--sky));
            color: white;
            box-shadow: 0 0 0 4px rgba(59,130,246,0.2);
        }

        .step.inactive {
            background: rgba(255,255,255,0.07);
            border: 1px solid var(--glass-border);
            color: rgba(255,255,255,0.3);
        }

        .step-line {
            width: 60px;
            height: 1px;
            background: rgba(255,255,255,0.1);
        }

        /*  Train Info Banner  */
        .train-info {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(59,130,246,0.25);
            border-radius: 20px;
            padding: 1.6rem 2rem;
            margin-bottom: 1.8rem;
            position: relative;
            overflow: hidden;
            animation: fade-up 0.55s ease 0.1s both;
        }

        .train-info::before {
            content: '';
            position: absolute;
            left: 0; top: 0; bottom: 0;
            width: 4px;
            background: linear-gradient(180deg, var(--azure), var(--sky));
            border-radius: 4px 0 0 4px;
        }

        .train-info h4 {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            color: var(--white);
            font-size: 1.15rem;
            margin-bottom: 6px;
        }

        .train-info p {
            color: rgba(255,255,255,0.55);
            font-size: 0.88rem;
            margin-bottom: 4px;
        }

        .train-info h6 {
            color: rgba(255,255,255,0.45);
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 4px;
        }

        .train-info .fare-highlight {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.6rem;
            color: var(--gold-light);
        }

        .train-info .dep-time {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 1.2rem;
            color: var(--white);
        }

        /*  Booking Card  */
        .booking-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--glass-border);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 2.5rem;
            margin-bottom: 2rem;
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.04),
                0 28px 70px rgba(0,0,0,0.38),
                inset 0 1px 0 rgba(255,255,255,0.07);
            animation: fade-up 0.6s ease 0.15s both;
        }

        /*  Section Headings  */
        .section-heading {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 1.4rem;
        }

        .section-heading .s-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            flex-shrink: 0;
        }

        .section-heading .s-icon.blue  { background: rgba(59,130,246,0.15); color: var(--ice); }
        .section-heading .s-icon.green { background: rgba(16,185,129,0.15); color: #6ee7b7; }

        .section-heading h5 {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            color: var(--white);
            font-size: 1rem;
            margin: 0;
        }

        .section-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--glass-border), transparent);
            margin: 1.8rem 0;
        }

        /*  Form Elements  */
        .form-label {
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.4);
            margin-bottom: 7px;
        }

        .form-control, .form-select {
            background: rgba(255,255,255,0.06) !important;
            border: 1px solid rgba(255,255,255,0.1) !important;
            border-radius: 12px !important;
            padding: 13px 18px !important;
            color: var(--white) !important;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.92rem !important;
            transition: all 0.22s ease;
        }

        .form-control::placeholder { color: rgba(255,255,255,0.25) !important; }

        .form-control:focus, .form-select:focus {
            background: rgba(255,255,255,0.09) !important;
            border-color: rgba(59,130,246,0.55) !important;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.14) !important;
        }

        .form-select option { background: #111827; color: var(--white); }

        input[type="date"]::-webkit-calendar-picker-indicator { filter: invert(0.65); cursor: pointer; }

        .form-control.is-invalid {
            border-color: rgba(239,68,68,0.5) !important;
            box-shadow: 0 0 0 3px rgba(239,68,68,0.12) !important;
        }

        /*  Fare Breakdown  */
        .fare-breakdown {
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            padding: 1.5rem;
        }

        .fare-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            font-size: 0.88rem;
            color: rgba(255,255,255,0.55);
        }

        .fare-row span:last-child { color: rgba(255,255,255,0.8); font-weight: 500; }

        .fare-total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 12px;
            margin-top: 4px;
            border-top: 1px solid var(--glass-border);
        }

        .fare-total-row .label {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 0.95rem;
            color: var(--white);
        }

        .fare-total-row .value {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.3rem;
            color: #6ee7b7;
        }

        /*  Benefits List  */
        .benefits-list {
            margin-top: 1.4rem;
            padding-top: 1.2rem;
            border-top: 1px solid var(--glass-border);
        }

        .benefits-list .benefit-title {
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.35);
            margin-bottom: 10px;
        }

        .benefit-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.82rem;
            color: rgba(255,255,255,0.55);
            margin-bottom: 7px;
        }

        .benefit-item .check {
            width: 18px;
            height: 18px;
            background: rgba(16,185,129,0.15);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #34d399;
            font-size: 0.6rem;
            flex-shrink: 0;
        }

        /*  Checkboxes  */
        .form-check-input {
            background-color: rgba(255,255,255,0.07) !important;
            border-color: rgba(255,255,255,0.2) !important;
            border-radius: 5px !important;
        }

        .form-check-input:checked {
            background-color: var(--azure) !important;
            border-color: var(--azure) !important;
        }

        .form-check-label {
            color: rgba(255,255,255,0.5);
            font-size: 0.82rem;
        }

        .form-check-label a { color: var(--ice); }

        /*  Book Button  */
        .btn-book {
            background: linear-gradient(135deg, var(--emerald) 0%, #059669 100%);
            border: none;
            border-radius: 14px !important;
            padding: 15px 28px !important;
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 0.95rem;
            letter-spacing: 0.8px;
            color: white !important;
            text-transform: uppercase;
            width: 100%;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .btn-book::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.15), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .btn-book:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 35px rgba(16,185,129,0.4);
        }

        .btn-book:hover::before { opacity: 1; }
        .btn-book:active { transform: translateY(0); }

        /*  Alert  */
        .alert-danger {
            background: rgba(239,68,68,0.1) !important;
            border: 1px solid rgba(239,68,68,0.25) !important;
            border-radius: 12px !important;
            color: #fca5a5 !important;
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
        }

        /*  Animations  */
        @keyframes fade-up {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<!-- Navigation -->
<nav class="navbar navbar-expand-lg fixed-top">
    <div class="container">
        <a class="navbar-brand" href="/">
            <span class="brand-icon"><i class="fas fa-train"></i></span>
            WaygonWay
        </a>
        <div class="navbar-nav ms-auto d-flex align-items-center gap-2">
            <a class="nav-link" href="/dashboard">Dashboard</a>
            <a class="nav-link" href="/my-bookings">My Bookings</a>
            <a class="btn-nav-search" href="/search">New Search</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">

            <!-- Progress Steps -->
            <div class="step-indicator">
                <div class="step-wrapper">
                    <div class="step active">1</div>
                </div>
                <div class="step-line"></div>
                <div class="step-wrapper">
                    <div class="step inactive">2</div>
                </div>
                <div class="step-line"></div>
                <div class="step-wrapper">
                    <div class="step inactive">3</div>
                </div>
            </div>

            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fas fa-ticket-alt me-3" style="color:var(--ice)"></i>Book Your Ticket</h2>
                <p>Step 1: Passenger Details</p>
            </div>

            <!-- Selected Train Info -->
            <c:if test="${not empty selectedEvent}">
                <div class="train-info">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h4><i class="fas fa-train me-2" style="color:var(--ice)"></i>${selectedEvent.eventName}</h4>
                            <p class="mb-1">Train No: ${selectedEvent.eventCode}</p>
                            <p class="mb-0"><i class="fas fa-route me-2"></i>${selectedEvent.source}  ${selectedEvent.destination}</p>
                        </div>
                        <div class="col-md-3">
                            <h6>Departure</h6>
                            <div class="dep-time">08:00 AM</div>
                        </div>
                        <div class="col-md-3">
                            <h6>Base Fare</h6>
                            <div class="fare-highlight">${selectedEvent.price}</div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Booking Form -->
            <div class="booking-card">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                    </div>
                </c:if>

                <form action="/book-ticket" method="post" id="bookingForm">
                    <input type="hidden" name="eventId" value="${selectedEvent.id}">

                    <div class="row">
                        <!-- Passenger Details -->
                        <div class="col-md-8">
                            <div class="section-heading">
                                <div class="s-icon blue"><i class="fas fa-user"></i></div>
                                <h5>Passenger Information</h5>
                            </div>

                            <div class="row">
                                <div class="col-md-8 mb-3">
                                    <label class="form-label">Full Name *</label>
                                    <input type="text" class="form-control" name="passengerName"
                                           placeholder="Enter full name as per ID proof" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Age *</label>
                                    <input type="number" class="form-control" name="passengerAge"
                                           min="1" max="120" placeholder="Age" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Gender *</label>
                                    <select class="form-select" name="passengerGender" required>
                                        <option value="">Select Gender</option>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Mobile Number</label>
                                    <input type="tel" class="form-control" name="mobileNumber"
                                           placeholder="10-digit mobile number" pattern="[0-9]{10}">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Email Address</label>
                                <input type="email" class="form-control" name="email"
                                       placeholder="Email for booking confirmation" value="${user.email}">
                            </div>

                            <div class="section-divider"></div>

                            <div class="section-heading">
                                <div class="s-icon blue"><i class="fas fa-train"></i></div>
                                <h5>Journey Details</h5>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Travel Class *</label>
                                    <select class="form-select" name="trainClass" id="trainClass" required onchange="updateFare()">
                                        <option value="">Select Class</option>
                                        <option value="SL" data-fare="500">Sleeper (SL) - 500</option>
                                        <option value="3A" data-fare="1200">AC 3 Tier (3A) - 1,200</option>
                                        <option value="2A" data-fare="1800">AC 2 Tier (2A) - 1,800</option>
                                        <option value="1A" data-fare="3000">AC First Class (1A) - 3,000</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Journey Date *</label>
                                    <input type="date" class="form-control" name="journeyDate"
                                           id="journeyDate" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Boarding Station</label>
                                    <select class="form-select" name="boardingStation">
                                        <option value="${selectedEvent.source}">${selectedEvent.source} (Origin)</option>
                                        <option value="Intermediate">Intermediate Station</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Food Preference</label>
                                    <select class="form-select" name="foodPreference">
                                        <option value="">No Meal</option>
                                        <option value="Veg">Vegetarian</option>
                                        <option value="NonVeg">Non-Vegetarian</option>
                                        <option value="Vegan">Vegan</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Fare Breakdown -->
                        <div class="col-md-4">
                            <div class="section-heading">
                                <div class="s-icon green"><i class="fas fa-receipt"></i></div>
                                <h5>Fare Breakdown</h5>
                            </div>

                            <div class="fare-breakdown">
                                <div class="fare-row">
                                    <span>Base Fare</span>
                                    <span id="baseFare">0</span>
                                </div>
                                <div class="fare-row">
                                    <span>Reservation Charges</span>
                                    <span id="reservationCharges">50</span>
                                </div>
                                <div class="fare-row">
                                    <span>Service Tax</span>
                                    <span id="serviceTax">0</span>
                                </div>
                                <div class="fare-row">
                                    <span>Convenience Fee</span>
                                    <span id="convenienceFee">20</span>
                                </div>
                                <div class="fare-total-row">
                                    <span class="label">Total Amount</span>
                                    <span class="value" id="totalAmount">70</span>
                                </div>

                                <div class="benefits-list">
                                    <div class="benefit-title">Included Benefits</div>
                                    <div class="benefit-item">
                                        <span class="check"><i class="fas fa-check"></i></span>
                                        Free Cancellation
                                    </div>
                                    <div class="benefit-item">
                                        <span class="check"><i class="fas fa-check"></i></span>
                                        SMS &amp; Email Updates
                                    </div>
                                    <div class="benefit-item">
                                        <span class="check"><i class="fas fa-check"></i></span>
                                        24/7 Customer Support
                                    </div>
                                </div>
                            </div>

                            <div class="mt-4">
                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="checkbox" id="terms" required>
                                    <label class="form-check-label" for="terms">
                                        I agree to the <a href="#">Terms &amp; Conditions</a>
                                    </label>
                                </div>

                                <div class="form-check mb-4">
                                    <input class="form-check-input" type="checkbox" id="notifications">
                                    <label class="form-check-label" for="notifications">
                                        Send me booking updates via SMS &amp; Email
                                    </label>
                                </div>

                                <button type="submit" class="btn btn-success btn-book w-100">
                                    <i class="fas fa-credit-card me-2"></i>Proceed to Pay
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Set minimum date to today
    document.getElementById('journeyDate').min = new Date().toISOString().split('T')[0];

    // Set default date to tomorrow
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    document.getElementById('journeyDate').value = tomorrow.toISOString().split('T')[0];

    function updateFare() {
        const classSelect = document.getElementById('trainClass');
        const selectedOption = classSelect.options[classSelect.selectedIndex];
        const baseFare = selectedOption.getAttribute('data-fare') || 0;

        const reservationCharges = 50;
        const serviceTax = Math.round(baseFare * 0.05);
        const convenienceFee = 20;
        const total = parseInt(baseFare) + reservationCharges + serviceTax + convenienceFee;

        document.getElementById('baseFare').textContent = '' + baseFare;
        document.getElementById('serviceTax').textContent = '' + serviceTax;
        document.getElementById('totalAmount').textContent = '' + total;
    }

    // Form validation
    document.getElementById('bookingForm').addEventListener('submit', function(e) {
        const requiredFields = this.querySelectorAll('[required]');
        let isValid = true;

        requiredFields.forEach(field => {
            if (!field.value.trim()) {
                field.classList.add('is-invalid');
                isValid = false;
            } else {
                field.classList.remove('is-invalid');
            }
        });

        if (!isValid) {
            e.preventDefault();
            alert('Please fill in all required fields.');
        }
    });

    // Auto-capitalize name
    document.querySelector('input[name="passengerName"]').addEventListener('input', function() {
        this.value = this.value.toUpperCase();
    });
</script>
</body>
</html>
