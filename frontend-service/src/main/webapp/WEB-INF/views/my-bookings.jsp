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
            --cyan: #06b6d4;
            --cyan-light: #67e8f9;
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

        .btn-logout {
            background: rgba(239, 68, 68, 0.12);
            border: 1.5px solid rgba(239, 68, 68, 0.3);
            color: #fca5a5 !important;
            font-size: 0.9rem;
            font-weight: 600;
            padding: 0.5rem 1.4rem;
            border-radius: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-logout:hover {
            background: rgba(239, 68, 68, 0.2);
            transform: translateY(-2px);
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
            margin-bottom: 3rem;
            animation: fade-up 0.7s ease both;
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

        @keyframes fade-up {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /*  Booking Card  */
        .booking-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.08) 0%, rgba(255, 255, 255, 0.04) 100%);
            border: 1.5px solid rgba(212, 175, 55, 0.2);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border-radius: 24px;
            padding: 2.2rem 2.5rem;
            margin-bottom: 1.8rem;
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.05),
                0 20px 60px rgba(0, 0, 0, 0.4),
                inset 0 1px 0 rgba(255,255,255,0.08);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            animation: fade-up 0.7s ease both;
        }

        .booking-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.5);
            border-color: rgba(77, 168, 218, 0.35);
        }

        /* Stagger cards */
        .booking-card:nth-child(1) { animation-delay: 0s; }
        .booking-card:nth-child(2) { animation-delay: 0.1s; }
        .booking-card:nth-child(3) { animation-delay: 0.15s; }
        .booking-card:nth-child(4) { animation-delay: 0.2s; }
        .booking-card:nth-child(5) { animation-delay: 0.25s; }

        /*  PNR Badge  */
        .pnr-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, rgba(77, 168, 218, 0.15), rgba(50, 130, 184, 0.1));
            border: 1.5px solid rgba(77, 168, 218, 0.35);
            color: var(--aqua);
            border-radius: 12px;
            padding: 6px 16px;
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(77, 168, 218, 0.15);
        }

        /*  Status Badge  */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.15), rgba(52, 211, 153, 0.1));
            border: 1.5px solid rgba(16, 185, 129, 0.35);
            color: var(--emerald-light);
            border-radius: 100px;
            padding: 5px 14px;
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.15);
        }

        /*  Train Name  */
        .train-name {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 1.3rem;
            color: var(--white);
            margin-bottom: 1.2rem;
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: -0.3px;
        }

        .train-name .t-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: linear-gradient(135deg, rgba(77, 168, 218, 0.2), rgba(50, 130, 184, 0.15));
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--aqua);
            font-size: 0.9rem;
            flex-shrink: 0;
            box-shadow: 0 4px 15px rgba(77, 168, 218, 0.2);
        }

        /*  Detail Items  */
        .detail-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.9rem;
            color: rgba(254, 246, 228, 0.7);
            margin-bottom: 10px;
            font-weight: 500;
        }

        .detail-item .d-dot {
            width: 26px;
            height: 26px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            flex-shrink: 0;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        }

        .d-dot.blue {
            background: linear-gradient(135deg, rgba(77, 168, 218, 0.2), rgba(50, 130, 184, 0.15));
            color: var(--aqua);
        }

        .d-dot.amber {
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.2), rgba(244, 208, 63, 0.15));
            color: var(--gold-light);
        }

        .d-dot.green {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.2), rgba(52, 211, 153, 0.15));
            color: var(--emerald-light);
        }

        .d-dot.cyan {
            background: linear-gradient(135deg, rgba(6, 182, 212, 0.2), rgba(103, 232, 249, 0.15));
            color: var(--cyan-light);
        }

        .detail-item strong { color: var(--white); font-weight: 700; }

        /*  Fare  */
        .fare-amount {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            font-size: 1.8rem;
            color: var(--emerald-light);
            line-height: 1;
            margin-bottom: 6px;
            letter-spacing: -0.5px;
        }

        .fare-label {
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            color: rgba(254, 246, 228, 0.4);
        }

        /*  Action Buttons  */
        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            padding: 10px 16px;
            border-radius: 12px;
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1.5px solid;
            width: 100%;
            margin-bottom: 10px;
            background: transparent;
            text-decoration: none;
        }

        .action-btn:last-child { margin-bottom: 0; }

        .action-btn.view {
            border-color: rgba(77, 168, 218, 0.35);
            color: var(--aqua);
        }

        .action-btn.view:hover {
            background: rgba(77, 168, 218, 0.15);
            border-color: var(--aqua);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(77, 168, 218, 0.25);
        }

        .action-btn.download {
            border-color: rgba(6, 182, 212, 0.35);
            color: var(--cyan-light);
        }

        .action-btn.download:hover {
            background: rgba(6, 182, 212, 0.15);
            border-color: var(--cyan);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(6, 182, 212, 0.25);
        }

        .action-btn.cancel {
            border-color: rgba(239, 68, 68, 0.3);
            color: #fca5a5;
        }

        .action-btn.cancel:hover {
            background: rgba(239, 68, 68, 0.12);
            border-color: rgba(239, 68, 68, 0.5);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(239, 68, 68, 0.2);
        }

        /*  Card Divider  */
        .card-vdivider {
            width: 1px;
            background: linear-gradient(180deg, transparent, rgba(212, 175, 55, 0.3), transparent);
            align-self: stretch;
            margin: 0 2rem;
            flex-shrink: 0;
        }

        /*  Pagination  */
        .pagination .page-link {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.06), rgba(255, 255, 255, 0.03)) !important;
            border: 1.5px solid rgba(212, 175, 55, 0.2) !important;
            color: rgba(254, 246, 228, 0.6) !important;
            border-radius: 10px !important;
            margin: 0 4px;
            font-size: 0.9rem;
            font-weight: 600;
            padding: 8px 16px;
            transition: all 0.3s ease;
        }

        .pagination .page-item.active .page-link {
            background: linear-gradient(135deg, var(--ocean), var(--aqua)) !important;
            border-color: var(--ocean) !important;
            color: white !important;
            box-shadow: 0 4px 15px rgba(50, 130, 184, 0.3);
        }

        .pagination .page-item.disabled .page-link {
            opacity: 0.3;
        }

        .pagination .page-link:hover:not(.disabled) {
            background: rgba(212, 175, 55, 0.12) !important;
            color: var(--gold-light) !important;
            transform: translateY(-2px);
        }

        /*  Empty State  */
        .empty-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.08) 0%, rgba(255, 255, 255, 0.04) 100%);
            border: 1.5px solid rgba(212, 175, 55, 0.2);
            border-radius: 28px;
            padding: 5rem 3rem;
            text-align: center;
            animation: fade-up 0.7s ease both;
            box-shadow: 0 30px 90px rgba(0, 0, 0, 0.5);
        }

        .empty-icon-wrap {
            width: 90px;
            height: 90px;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.06), rgba(255, 255, 255, 0.03));
            border: 1.5px solid rgba(212, 175, 55, 0.2);
            border-radius: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            color: rgba(254, 246, 228, 0.25);
            margin: 0 auto 1.8rem;
        }

        .empty-card h4 {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 1.4rem;
            color: rgba(254, 246, 228, 0.6);
            margin-bottom: 10px;
            letter-spacing: -0.3px;
        }

        .empty-card p {
            color: rgba(254, 246, 228, 0.4);
            font-size: 0.95rem;
            margin-bottom: 2.5rem;
        }

        .btn-primary-gradient {
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            border: none;
            border-radius: 14px !important;
            padding: 14px 32px !important;
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            font-size: 0.95rem;
            color: white !important;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(50, 130, 184, 0.3);
        }

        .btn-primary-gradient:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(50, 130, 184, 0.45);
        }

        .btn-outline-glass {
            background: transparent;
            border: 1.5px solid rgba(212, 175, 55, 0.25) !important;
            border-radius: 14px !important;
            padding: 14px 32px !important;
            font-size: 0.95rem;
            font-weight: 600;
            color: rgba(254, 246, 228, 0.65) !important;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .btn-outline-glass:hover {
            background: rgba(212, 175, 55, 0.1);
            color: var(--gold-light) !important;
            transform: translateY(-3px);
        }

        /*  Modal  */
        .modal-content {
            background: rgba(26, 11, 46, 0.95);
            border: 1.5px solid rgba(212, 175, 55, 0.25);
            border-radius: 24px;
            color: var(--white);
            backdrop-filter: blur(30px);
            box-shadow: 0 30px 90px rgba(0, 0, 0, 0.6);
        }

        .modal-header {
            background: linear-gradient(135deg, rgba(77, 168, 218, 0.2), rgba(50, 130, 184, 0.15)) !important;
            border-bottom: 1.5px solid rgba(212, 175, 55, 0.2) !important;
            border-radius: 24px 24px 0 0 !important;
            padding: 1.5rem 2rem;
        }

        .modal-header .modal-title {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            color: var(--white);
            font-size: 1.2rem;
            letter-spacing: -0.3px;
        }

        .modal-body {
            padding: 2rem;
            color: rgba(254, 246, 228, 0.75);
        }

        .modal-footer {
            border-top: 1.5px solid rgba(212, 175, 55, 0.2) !important;
            padding: 1.2rem 2rem;
        }

        .modal-footer .btn-secondary {
            background: rgba(255, 255, 255, 0.08) !important;
            border: 1.5px solid rgba(212, 175, 55, 0.25) !important;
            color: rgba(254, 246, 228, 0.7) !important;
            border-radius: 12px !important;
            font-size: 0.9rem;
            font-weight: 600;
            padding: 10px 24px;
        }

        .modal-footer .btn-primary {
            background: linear-gradient(135deg, var(--ocean), var(--aqua)) !important;
            border: none !important;
            border-radius: 12px !important;
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            font-size: 0.9rem;
            color: white !important;
            padding: 10px 24px;
            box-shadow: 0 6px 20px rgba(50, 130, 184, 0.3);
        }

        .btn-close-white {
            filter: invert(0.8);
            opacity: 0.8;
        }

        /* Modal inner detail text */
        #bookingDetails h6 {
            color: var(--gold-light);
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            margin-bottom: 6px;
        }

        #bookingDetails p {
            color: var(--white);
            font-size: 0.95rem;
            font-weight: 500;
            margin-bottom: 1.2rem;
        }

        /*  Responsive  */
        @media (max-width: 768px) {
            .booking-card {
                padding: 1.8rem 1.5rem;
            }
            .page-header h2 {
                font-size: 2rem;
            }
            .card-vdivider {
                display: none !important;
            }
        }

        @media (max-width: 576px) {
            .booking-card {
                padding: 1.5rem 1.2rem;
            }
            .empty-card {
                padding: 3rem 2rem;
            }
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
            <a class="nav-link" href="/search">Search Trains</a>
            <a class="btn-logout" href="/logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">

            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fas fa-ticket-alt me-3" style="color:var(--aqua)"></i>My Bookings</h2>
                <p>Manage all your train reservations</p>
            </div>

            <c:choose>
                <c:when test="${not empty bookings}">
                    <c:forEach var="booking" items="${bookings}">
                        <div class="booking-card">
                            <div class="d-flex">
                                <!-- Left: Info -->
                                <div class="flex-grow-1">
                                    <!-- Top row: PNR + Status -->
                                    <div class="d-flex align-items-center gap-2 mb-3 flex-wrap">
                                        <span class="pnr-badge">
                                            <i class="fas fa-barcode" style="font-size:0.75rem"></i> PNR: ${booking.pnr}
                                        </span>
                                        <span class="status-badge">
                                            <i class="fas fa-check-circle" style="font-size:0.7rem"></i>${booking.status}
                                        </span>
                                    </div>

                                    <!-- Train Name -->
                                    <div class="train-name">
                                        <div class="t-icon"><i class="fas fa-train"></i></div>
                                        ${booking.trainName}
                                    </div>

                                    <!-- Details Grid -->
                                    <div class="row g-0">
                                        <div class="col-md-6">
                                            <div class="detail-item">
                                                <span class="d-dot blue"><i class="fas fa-route"></i></span>
                                                <strong>${booking.source}</strong>&nbsp;&nbsp;<strong>${booking.destination}</strong>
                                            </div>
                                            <div class="detail-item">
                                                <span class="d-dot amber"><i class="fas fa-calendar"></i></span>
                                                Journey: ${booking.journeyDate}
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="detail-item">
                                                <span class="d-dot green"><i class="fas fa-user"></i></span>
                                                Passenger: ${booking.passengerName}
                                            </div>
                                            <div class="detail-item">
                                                <span class="d-dot cyan"><i class="fas fa-chair"></i></span>
                                                Class: ${booking.trainClass}
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Vertical Divider -->
                                <div class="card-vdivider d-none d-md-block"></div>

                                <!-- Right: Fare + Actions -->
                                <div class="d-flex flex-column align-items-end justify-content-between" style="min-width:180px">
                                    <div class="text-end mb-3">
                                        <div class="fare-amount">${booking.totalAmount}</div>
                                        <div class="fare-label">Total Fare</div>
                                    </div>

                                    <div style="width:100%">
                                        <button class="action-btn view"
                                                onclick="viewDetails('${booking.pnr}')">
                                            <i class="fas fa-eye"></i>View Details
                                        </button>
                                        <button class="action-btn download"
                                                onclick="downloadTicket('${booking.pnr}')">
                                            <i class="fas fa-download"></i>Download
                                        </button>
                                        <c:if test="${booking.status != 'CANCELLED'}">
                                            <button class="action-btn cancel"
                                                    onclick="cancelBooking('${booking.pnr}')">
                                                <i class="fas fa-times"></i>Cancel
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Pagination -->
                    <div class="text-center mt-4">
                        <nav>
                            <ul class="pagination justify-content-center">
                                <li class="page-item disabled">
                                    <span class="page-link">Previous</span>
                                </li>
                                <li class="page-item active">
                                    <span class="page-link">1</span>
                                </li>
                                <li class="page-item disabled">
                                    <span class="page-link">Next</span>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-card">
                        <div class="empty-icon-wrap"><i class="fas fa-ticket-alt"></i></div>
                        <h4>No Bookings Found</h4>
                        <p>You haven't made any train reservations yet.</p>
                        <div class="d-flex justify-content-center gap-3 flex-wrap">
                            <a href="/search" class="btn-primary-gradient">
                                <i class="fas fa-search me-2"></i>Search Trains
                            </a>
                            <a href="/dashboard" class="btn-outline-glass">
                                <i class="fas fa-home me-2"></i>Go to Dashboard
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</div>

<!-- Booking Details Modal -->
<div class="modal fade" id="detailsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-ticket-alt me-2"></i>Booking Details
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="bookingDetails">
                    <!-- Booking details will be loaded here -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" onclick="printTicket()">
                    <i class="fas fa-print me-2"></i>Print Ticket
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function viewDetails(pnr) {
        // Fetch and show booking details
        document.getElementById('bookingDetails').innerHTML =
            '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading details...</div>';

        const modal = new bootstrap.Modal(document.getElementById('detailsModal'));
        modal.show();

        // Here you would typically make an AJAX call to get booking details
        setTimeout(() => {
            document.getElementById('bookingDetails').innerHTML = `
                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="fw-bold">PNR Number</h6>
                            <p>${pnr}</p>
                            <h6 class="fw-bold">Booking Status</h6>
                            <p><span class="badge bg-success">Confirmed</span></p>
                        </div>
                        <div class="col-md-6">
                            <h6 class="fw-bold">Booking Date</h6>
                            <p>28-09-2025</p>
                            <h6 class="fw-bold">Journey Date</h6>
                            <p>29-09-2025</p>
                        </div>
                    </div>
                `;
        }, 1000);
    }

    function downloadTicket(pnr) {
        alert('Downloading ticket for PNR: ' + pnr);
        // Implement ticket download functionality
    }

    function cancelBooking(pnr) {
        if (confirm('Are you sure you want to cancel this booking?')) {
            window.location.href = '/cancel-booking?pnr=' + pnr;
        }
    }

    function printTicket() {
        window.print();
    }
</script>
</body>
</html>
