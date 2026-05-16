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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --deep-plum: #1a0b2e;
            --royal-purple: #2d1b4e;
            --midnight: #16213e;
            --teal: #0f4c75;
            --ocean: #3282b8;
            --aqua: #4da8da;
            --gold: #d4af37;
            --gold-light: #f4d03f;
            --rose-gold: #b76e79;
            --emerald: #10b981;
            --emerald-light: #34d399;
            --cream: #fef6e4;
            --white: #ffffff;
            --glass: rgba(255, 255, 255, 0.05);
            --glass-border: rgba(255, 255, 255, 0.15);
            --text-muted: rgba(254, 246, 228, 0.6);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background: linear-gradient(135deg, var(--deep-plum) 0%, var(--midnight) 50%, var(--teal) 100%);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            padding-top: 85px;
            position: relative;
        }

        /*  Background Effects  */
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background:
                radial-gradient(circle at 20% 15%, rgba(212, 175, 55, 0.09) 0%, transparent 50%),
                radial-gradient(circle at 80% 75%, rgba(50, 130, 184, 0.12) 0%, transparent 50%),
                radial-gradient(circle at 50% 50%, rgba(45, 27, 78, 0.6) 0%, transparent 100%);
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
            background-size: 50px 50px;
            z-index: 0;
            pointer-events: none;
            opacity: 0.4;
        }

        /*  Navbar  */
        .navbar {
            background: rgba(26, 11, 46, 0.85);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-bottom: 1px solid rgba(212, 175, 55, 0.2);
            padding: 1rem 0;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            font-size: 1.6rem !important;
            color: var(--white) !important;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .navbar-brand .brand-icon {
            width: 38px;
            height: 38px;
            background: linear-gradient(135deg, var(--gold) 0%, var(--rose-gold) 100%);
            border-radius: 11px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: var(--deep-plum);
            font-size: 1rem;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
        }

        .nav-link {
            color: rgba(255,255,255,0.75) !important;
            font-weight: 500;
            font-size: 0.9rem;
            padding: 0.5rem 1rem !important;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .nav-link:hover {
            color: var(--gold-light) !important;
            background: rgba(212, 175, 55, 0.1);
        }

        .btn-nav-search {
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            border: none;
            color: white !important;
            font-size: 0.9rem;
            font-weight: 600;
            padding: 0.5rem 1.4rem;
            border-radius: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
            box-shadow: 0 4px 15px rgba(50, 130, 184, 0.25);
        }

        .btn-nav-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(50, 130, 184, 0.35);
        }

        /*  Container  */
        .container { 
            position: relative; 
            z-index: 1; 
            padding-top: 3rem; 
            padding-bottom: 3.5rem; 
        }

        /*  Page Header  */
        .page-header { 
            text-align: center; 
            margin-bottom: 2.5rem; 
            animation: fade-up 0.6s ease both; 
        }

        .page-header h2 {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            font-size: 2.4rem;
            color: var(--white);
            letter-spacing: -0.8px;
            margin-bottom: 8px;
        }

        .page-header p {
            color: var(--text-muted);
            font-size: 1rem;
            letter-spacing: 0.3px;
        }

        /*  Step Indicator  */
        .step-indicator {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0;
            margin-bottom: 2.8rem;
            animation: fade-up 0.6s ease 0.1s both;
        }

        .step-wrapper {
            display: flex;
            align-items: center;
        }

        .step {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 1.1rem;
            position: relative;
            z-index: 1;
            transition: all 0.3s ease;
        }

        .step.active {
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            color: white;
            box-shadow: 0 0 0 4px rgba(50, 130, 184, 0.2), 0 8px 20px rgba(50, 130, 184, 0.3);
        }

        .step.inactive {
            background: rgba(255,255,255,0.06);
            border: 2px solid rgba(212, 175, 55, 0.2);
            color: rgba(254, 246, 228, 0.4);
        }

        .step-line {
            width: 70px;
            height: 2px;
            background: linear-gradient(90deg, rgba(212, 175, 55, 0.2), rgba(50, 130, 184, 0.2));
        }

        /*  Train Info Banner  */
        .train-info {
            background: linear-gradient(135deg, rgba(50, 130, 184, 0.08), rgba(77, 168, 218, 0.04));
            border: 1.5px solid rgba(77, 168, 218, 0.3);
            border-radius: 24px;
            padding: 2rem 2.5rem;
            margin-bottom: 2.2rem;
            position: relative;
            overflow: hidden;
            animation: fade-up 0.7s ease 0.15s both;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
        }

        .train-info::before {
            content: '';
            position: absolute;
            left: 0; top: 0; bottom: 0;
            width: 5px;
            background: linear-gradient(180deg, var(--ocean), var(--aqua));
            border-radius: 5px 0 0 5px;
        }

        .train-info h4 {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            color: var(--white);
            font-size: 1.4rem;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        .train-info p {
            color: rgba(254, 246, 228, 0.65);
            font-size: 0.95rem;
            margin-bottom: 4px;
        }

        .train-info h6 {
            color: var(--text-muted);
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            margin-bottom: 6px;
        }

        .train-info .fare-highlight {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            font-size: 1.8rem;
            color: var(--gold-light);
            letter-spacing: -0.5px;
        }

        .train-info .dep-time {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 1.4rem;
            color: var(--white);
            letter-spacing: -0.5px;
        }

        /*  Booking Card  */
        .booking-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.08) 0%, rgba(255, 255, 255, 0.04) 100%);
            border: 1px solid rgba(212, 175, 55, 0.2);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-radius: 28px;
            padding: 3rem 3.5rem;
            margin-bottom: 2rem;
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.05),
                0 30px 90px rgba(0, 0, 0, 0.5),
                inset 0 1px 0 rgba(255,255,255,0.1);
            animation: fade-up 0.8s ease 0.2s both;
        }

        /*  Section Headings  */
        .section-heading {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 1.8rem;
        }

        .section-heading .s-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            flex-shrink: 0;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .section-heading .s-icon.blue {
            background: linear-gradient(135deg, rgba(77, 168, 218, 0.2), rgba(50, 130, 184, 0.15));
            color: var(--aqua);
        }

        .section-heading .s-icon.green {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.2), rgba(52, 211, 153, 0.15));
            color: var(--emerald-light);
        }

        .section-heading h5 {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            color: var(--white);
            font-size: 1.2rem;
            margin: 0;
            letter-spacing: -0.3px;
        }

        .section-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(212, 175, 55, 0.3), transparent);
            margin: 2.2rem 0;
            position: relative;
        }

        .section-divider::before {
            content: '';
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            width: 6px;
            height: 6px;
            background: var(--gold);
            border-radius: 50%;
            box-shadow: 0 0 10px var(--gold);
        }

        /*  Form Elements  */
        .form-label {
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: var(--gold-light);
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            background: rgba(255, 255, 255, 0.08) !important;
            border: 1.5px solid rgba(212, 175, 55, 0.25) !important;
            border-radius: 14px !important;
            padding: 14px 20px !important;
            color: var(--white) !important;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem !important;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .form-control::placeholder { 
            color: rgba(254, 246, 228, 0.35) !important; 
            font-weight: 400;
        }

        .form-control:focus, .form-select:focus {
            background: rgba(255, 255, 255, 0.12) !important;
            border-color: var(--gold) !important;
            box-shadow: 0 0 0 4px rgba(212, 175, 55, 0.15) !important;
            outline: none;
        }

        .form-select option { 
            background: var(--deep-plum); 
            color: var(--white); 
            padding: 12px;
        }

        input[type="date"]::-webkit-calendar-picker-indicator { 
            filter: invert(0.7) sepia(1) saturate(5) hue-rotate(10deg);
            cursor: pointer;
        }

        .form-control.is-invalid {
            border-color: rgba(239, 68, 68, 0.6) !important;
            box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.15) !important;
        }

        /*  Fare Breakdown  */
        .fare-breakdown {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.06), rgba(255, 255, 255, 0.03));
            border: 1.5px solid rgba(212, 175, 55, 0.2);
            border-radius: 20px;
            padding: 2rem 1.8rem;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        .fare-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            font-size: 0.9rem;
            color: rgba(254, 246, 228, 0.65);
        }

        .fare-row span:last-child { 
            color: rgba(255,255,255,0.85); 
            font-weight: 600; 
        }

        .fare-total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 16px;
            margin-top: 8px;
            border-top: 1.5px solid rgba(212, 175, 55, 0.25);
        }

        .fare-total-row .label {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 1.05rem;
            color: var(--white);
            letter-spacing: -0.3px;
        }

        .fare-total-row .value {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            font-size: 1.6rem;
            color: var(--emerald-light);
            letter-spacing: -0.5px;
        }

        /*  Benefits List  */
        .benefits-list {
            margin-top: 1.8rem;
            padding-top: 1.5rem;
            border-top: 1.5px solid rgba(212, 175, 55, 0.2);
        }

        .benefits-list .benefit-title {
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: var(--gold-light);
            margin-bottom: 12px;
        }

        .benefit-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.88rem;
            color: rgba(254, 246, 228, 0.7);
            margin-bottom: 10px;
            font-weight: 500;
        }

        .benefit-item .check {
            width: 22px;
            height: 22px;
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.2), rgba(52, 211, 153, 0.15));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--emerald-light);
            font-size: 0.7rem;
            flex-shrink: 0;
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.2);
        }

        /*  Checkboxes  */
        .form-check-input {
            background-color: rgba(255,255,255,0.08) !important;
            border: 1.5px solid rgba(212, 175, 55, 0.3) !important;
            border-radius: 6px !important;
            width: 20px;
            height: 20px;
        }

        .form-check-input:checked {
            background-color: var(--ocean) !important;
            border-color: var(--ocean) !important;
        }

        .form-check-label {
            color: rgba(254, 246, 228, 0.65);
            font-size: 0.88rem;
            font-weight: 500;
        }

        .form-check-label a { 
            color: var(--aqua); 
            text-decoration: none;
            font-weight: 600;
        }

        .form-check-label a:hover { 
            color: var(--gold-light);
        }

        /*  Book Button  */
        .btn-book {
            background: linear-gradient(135deg, var(--emerald) 0%, #059669 100%);
            border: none;
            border-radius: 16px !important;
            padding: 18px 32px !important;
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            font-size: 1rem;
            letter-spacing: 1.5px;
            color: white !important;
            text-transform: uppercase;
            width: 100%;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 8px 30px rgba(16, 185, 129, 0.35);
        }

        .btn-book::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.2), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .btn-book::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .btn-book:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 40px rgba(16, 185, 129, 0.45);
        }

        .btn-book:hover::before { opacity: 1; }
        
        .btn-book:active { 
            transform: translateY(-1px); 
        }

        .btn-book:active::after {
            width: 300px;
            height: 300px;
        }

        /*  Alert  */
        .alert-danger {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.12), rgba(239, 68, 68, 0.08)) !important;
            border: 1.5px solid rgba(239, 68, 68, 0.3) !important;
            border-radius: 16px !important;
            color: #fca5a5 !important;
            font-size: 0.95rem;
            font-weight: 500;
            margin-bottom: 2rem;
            padding: 1rem 1.5rem;
            box-shadow: 0 4px 20px rgba(239, 68, 68, 0.15);
        }

        /*  Animations  */
        @keyframes fade-up {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /*  Responsive  */
        @media (max-width: 768px) {
            .booking-card { padding: 2rem 1.8rem; }
            .container { padding-top: 2rem; }
            .page-header h2 { font-size: 2rem; }
            .train-info { padding: 1.5rem 1.8rem; }
        }

        @media (max-width: 576px) {
            .booking-card { padding: 1.5rem 1.2rem; }
            .train-info { padding: 1.2rem 1.5rem; }
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
                <h2><i class="fas fa-ticket-alt me-3" style="color:var(--aqua)"></i>Book Your Ticket</h2>
                <p>Step 1: Passenger Details</p>
            </div>

            <!-- Selected Train Info -->
            <c:if test="${not empty selectedEvent}">
                <div class="train-info">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h4><i class="fas fa-train me-2" style="color:var(--aqua)"></i>${selectedEvent.eventName}</h4>
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
