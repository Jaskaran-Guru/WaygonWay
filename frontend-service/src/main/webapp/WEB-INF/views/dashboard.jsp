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

        /* Dropdown */
        .dropdown-menu {
            background: rgba(26, 11, 46, 0.95);
            border: 1.5px solid rgba(212, 175, 55, 0.25);
            border-radius: 16px;
            padding: 10px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.6);
            min-width: 200px;
            backdrop-filter: blur(20px);
        }

        .dropdown-item {
            color: rgba(254, 246, 228, 0.7);
            font-size: 0.9rem;
            font-weight: 500;
            border-radius: 10px;
            padding: 10px 16px;
            transition: all 0.2s ease;
        }

        .dropdown-item:hover {
            background: rgba(212, 175, 55, 0.12);
            color: var(--white);
        }

        .dropdown-divider {
            border-color: rgba(212, 175, 55, 0.2);
            margin: 8px 0;
        }

        /*  Container  */
        .container {
            position: relative;
            z-index: 1;
            padding-top: 3rem;
            padding-bottom: 3.5rem;
        }

        /*  Base Card  */
        .dashboard-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.08) 0%, rgba(255, 255, 255, 0.04) 100%);
            border: 1px solid rgba(212, 175, 55, 0.2);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-radius: 28px;
            padding: 2.5rem 3rem;
            margin-bottom: 2rem;
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.05),
                0 30px 90px rgba(0, 0, 0, 0.5),
                inset 0 1px 0 rgba(255,255,255,0.1);
            animation: fade-up 0.7s ease both;
        }

        .dashboard-card:nth-child(1) { animation-delay: 0s; }
        .dashboard-card:nth-child(2) { animation-delay: 0.1s; }
        .dashboard-card:nth-child(3) { animation-delay: 0.15s; }
        .dashboard-card:nth-child(4) { animation-delay: 0.2s; }

        @keyframes fade-up {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /*  Welcome Card  */
        .welcome-text {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            font-size: 2rem;
            color: var(--white);
            letter-spacing: -0.8px;
        }

        .welcome-text .name-accent {
            background: linear-gradient(135deg, var(--aqua), var(--gold-light));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .welcome-sub {
            color: var(--text-muted);
            font-size: 1rem;
            margin-top: 6px;
            letter-spacing: 0.3px;
        }

        .btn-book-new {
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            border: none;
            border-radius: 14px !important;
            padding: 15px 32px !important;
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            font-size: 0.95rem;
            letter-spacing: 1px;
            color: white !important;
            text-transform: uppercase;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 8px 25px rgba(50, 130, 184, 0.3);
        }

        .btn-book-new:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(50, 130, 184, 0.45);
        }

        /*  Stat Cards  */
        .stat-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.06), rgba(255, 255, 255, 0.03));
            border: 1.5px solid var(--glass-border);
            border-radius: 20px;
            padding: 2rem 1.6rem;
            margin-bottom: 1rem;
            text-align: center;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .stat-card::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.05) 0%, transparent 70%);
            opacity: 0;
            transition: opacity 0.4s ease;
        }

        .stat-card:hover {
            transform: translateY(-6px) scale(1.02);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
        }

        .stat-card:hover::after { opacity: 1; }

        .stat-card.s-blue {
            border-color: rgba(77, 168, 218, 0.3);
            background: linear-gradient(135deg, rgba(77, 168, 218, 0.08), rgba(50, 130, 184, 0.04));
        }

        .stat-card.s-blue .stat-icon {
            background: linear-gradient(135deg, rgba(77, 168, 218, 0.2), rgba(50, 130, 184, 0.15));
            color: var(--aqua);
            box-shadow: 0 8px 20px rgba(77, 168, 218, 0.2);
        }

        .stat-card.s-gold {
            border-color: rgba(212, 175, 55, 0.3);
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.08), rgba(244, 208, 63, 0.04));
        }

        .stat-card.s-gold .stat-icon {
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.2), rgba(244, 208, 63, 0.15));
            color: var(--gold-light);
            box-shadow: 0 8px 20px rgba(212, 175, 55, 0.25);
        }

        .stat-card.s-green {
            border-color: rgba(16, 185, 129, 0.3);
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.08), rgba(52, 211, 153, 0.04));
        }

        .stat-card.s-green .stat-icon {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.2), rgba(52, 211, 153, 0.15));
            color: var(--emerald-light);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.25);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin: 0 auto 1.2rem;
            transition: transform 0.3s ease;
        }

        .stat-card:hover .stat-icon {
            transform: scale(1.1) rotate(5deg);
        }

        .stat-value {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            font-size: 2.2rem;
            color: var(--white);
            line-height: 1;
            margin-bottom: 8px;
            letter-spacing: -1px;
        }

        .stat-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            letter-spacing: 1.2px;
            text-transform: uppercase;
        }

        /*  Section Heading  */
        .section-heading {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 2rem;
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

        .s-icon.blue {
            background: linear-gradient(135deg, rgba(77, 168, 218, 0.2), rgba(50, 130, 184, 0.15));
            color: var(--aqua);
        }

        .s-icon.gold {
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.2), rgba(244, 208, 63, 0.15));
            color: var(--gold-light);
        }

        .section-heading h4 {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 1.3rem;
            color: var(--white);
            margin: 0;
            letter-spacing: -0.3px;
        }

        /*  Quick Action Buttons  */
        .qa-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 12px;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.06), rgba(255, 255, 255, 0.03));
            border: 1.5px solid var(--glass-border);
            border-radius: 20px;
            padding: 1.8rem 1.2rem;
            color: rgba(254, 246, 228, 0.7);
            font-size: 0.88rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            width: 100%;
            margin-bottom: 1rem;
        }

        .qa-btn .qa-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            transition: transform 0.3s ease;
        }

        .qa-btn:hover {
            color: var(--white);
            transform: translateY(-4px);
        }

        .qa-btn:hover .qa-icon {
            transform: scale(1.1) rotate(5deg);
        }

        .qa-btn.qa-blue {
            border-color: rgba(77, 168, 218, 0.25);
        }

        .qa-btn.qa-blue .qa-icon {
            background: linear-gradient(135deg, rgba(77, 168, 218, 0.2), rgba(50, 130, 184, 0.15));
            color: var(--aqua);
        }

        .qa-btn.qa-blue:hover {
            background: rgba(77, 168, 218, 0.1);
            border-color: var(--aqua);
            box-shadow: 0 12px 35px rgba(77, 168, 218, 0.25);
        }

        .qa-btn.qa-green {
            border-color: rgba(16, 185, 129, 0.25);
        }

        .qa-btn.qa-green .qa-icon {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.2), rgba(52, 211, 153, 0.15));
            color: var(--emerald-light);
        }

        .qa-btn.qa-green:hover {
            background: rgba(16, 185, 129, 0.1);
            border-color: var(--emerald);
            box-shadow: 0 12px 35px rgba(16, 185, 129, 0.2);
        }

        .qa-btn.qa-cyan {
            border-color: rgba(6, 182, 212, 0.25);
        }

        .qa-btn.qa-cyan .qa-icon {
            background: linear-gradient(135deg, rgba(6, 182, 212, 0.2), rgba(103, 232, 249, 0.15));
            color: var(--cyan-light);
        }

        .qa-btn.qa-cyan:hover {
            background: rgba(6, 182, 212, 0.1);
            border-color: var(--cyan);
            box-shadow: 0 12px 35px rgba(6, 182, 212, 0.2);
        }

        .qa-btn.qa-gold {
            border-color: rgba(212, 175, 55, 0.25);
        }

        .qa-btn.qa-gold .qa-icon {
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.2), rgba(244, 208, 63, 0.15));
            color: var(--gold-light);
        }

        .qa-btn.qa-gold:hover {
            background: rgba(212, 175, 55, 0.1);
            border-color: var(--gold);
            box-shadow: 0 12px 35px rgba(212, 175, 55, 0.2);
        }

        /*  Table  */
        .table-responsive {
            border-radius: 18px;
            overflow: hidden;
        }

        .table {
            color: rgba(254, 246, 228, 0.75);
            font-size: 0.9rem;
            margin-bottom: 0;
        }

        .table thead th {
            background: linear-gradient(135deg, rgba(77, 168, 218, 0.15), rgba(50, 130, 184, 0.1));
            border-color: rgba(212, 175, 55, 0.15);
            color: var(--gold-light);
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            padding: 15px 18px;
            white-space: nowrap;
        }

        .table tbody tr {
            border-color: rgba(212, 175, 55, 0.1);
            transition: background 0.2s ease;
        }

        .table tbody tr:hover {
            background: rgba(255, 255, 255, 0.05);
        }

        .table tbody td {
            border-color: rgba(212, 175, 55, 0.1);
            padding: 15px 18px;
            vertical-align: middle;
        }

        .table tbody td strong {
            color: var(--white);
            font-family: 'Playfair Display', serif;
            font-weight: 700;
        }

        .badge-status {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.2), rgba(52, 211, 153, 0.15));
            border: 1.5px solid rgba(16, 185, 129, 0.35);
            color: var(--emerald-light);
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1.2px;
            padding: 5px 14px;
            border-radius: 100px;
        }

        .btn-view {
            background: transparent;
            border: 1.5px solid rgba(77, 168, 218, 0.35);
            color: var(--aqua);
            font-size: 0.8rem;
            font-weight: 600;
            padding: 6px 16px;
            border-radius: 10px;
            transition: all 0.25s ease;
            text-decoration: none;
            white-space: nowrap;
        }

        .btn-view:hover {
            background: rgba(77, 168, 218, 0.15);
            border-color: var(--aqua);
            color: var(--white);
            transform: translateY(-2px);
        }

        /* View All button */
        .btn-view-all {
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            border: none;
            border-radius: 12px !important;
            padding: 12px 32px !important;
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            font-size: 0.9rem;
            color: white !important;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: 1.5rem;
            box-shadow: 0 6px 20px rgba(50, 130, 184, 0.25);
        }

        .btn-view-all:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(50, 130, 184, 0.35);
        }

        /* Empty state */
        .empty-state {
            padding: 3.5rem 1rem;
            text-align: center;
        }

        .empty-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.06), rgba(255, 255, 255, 0.03));
            border: 1.5px solid rgba(212, 175, 55, 0.2);
            border-radius: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: rgba(254, 246, 228, 0.3);
            margin: 0 auto 1.5rem;
        }

        .empty-state h5 {
            color: rgba(254, 246, 228, 0.6);
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 1.2rem;
            margin-bottom: 8px;
            letter-spacing: -0.3px;
        }

        .empty-state p {
            color: rgba(254, 246, 228, 0.4);
            font-size: 0.95rem;
            margin-bottom: 1.8rem;
        }

        .btn-search-trains {
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            border: none;
            border-radius: 12px !important;
            padding: 13px 30px !important;
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            font-size: 0.9rem;
            color: white !important;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(50, 130, 184, 0.25);
        }

        .btn-search-trains:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(50, 130, 184, 0.35);
        }

        .section-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(212, 175, 55, 0.3), transparent);
            margin: 1.8rem 0 2.2rem;
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

        /*  Responsive  */
        @media (max-width: 768px) {
            .dashboard-card { padding: 2rem 1.8rem; }
            .container { padding-top: 2rem; }
            .welcome-text { font-size: 1.6rem; }
            .btn-book-new { width: 100%; justify-content: center; margin-top: 1rem; }
        }

        @media (max-width: 576px) {
            .dashboard-card { padding: 1.5rem 1.2rem; }
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
        <div class="navbar-nav ms-auto d-flex align-items-center gap-1">
            <a class="nav-link fw-medium me-1" href="/search">Search Trains</a>
            <a class="nav-link fw-medium me-1" href="/my-bookings">My Bookings</a>
            <a class="nav-link fw-medium me-2" href="/pnr-status">PNR Status</a>
            <div class="dropdown">
                <a class="nav-link dropdown-toggle fw-medium" href="#" role="button" data-bs-toggle="dropdown">
                    <i class="fas fa-user-circle me-1"></i>${user.firstName}
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="/profile"><i class="fas fa-user me-2"></i>Profile</a></li>
                    <li><a class="dropdown-item" href="/settings"><i class="fas fa-cog me-2"></i>Settings</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container">

    <!-- Welcome Section -->
    <div class="dashboard-card">
        <div class="row align-items-center">
            <div class="col-md-8">
                <div class="welcome-text">
                    <i class="fas fa-hand-wave me-2" style="color:var(--gold-light)"></i>Welcome back, <span class="name-accent">${user.firstName}!</span>
                </div>
                <p class="welcome-sub">Ready to plan your next journey?</p>
            </div>
            <div class="col-md-4 text-end">
                <a href="/search" class="btn-book-new">
                    <i class="fas fa-search"></i>Book New Ticket
                </a>
            </div>
        </div>
    </div>

    <!-- Stats Row -->
    <div class="row">
        <div class="col-md-4">
            <div class="stat-card s-blue">
                <div class="stat-icon"><i class="fas fa-ticket-alt"></i></div>
                <div class="stat-value">${bookingCount}</div>
                <div class="stat-label">Total Bookings</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card s-gold">
                <div class="stat-icon"><i class="fas fa-route"></i></div>
                <div class="stat-value">15+</div>
                <div class="stat-label">Routes Available</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card s-green">
                <div class="stat-icon"><i class="fas fa-train"></i></div>
                <div class="stat-value">100+</div>
                <div class="stat-label">Trains Listed</div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="dashboard-card">
        <div class="section-heading">
            <div class="s-icon gold"><i class="fas fa-bolt"></i></div>
            <h4>Quick Actions</h4>
        </div>
        <div class="section-divider"></div>
        <div class="row">
            <div class="col-md-3 text-center">
                <a href="/search" class="qa-btn qa-blue">
                    <div class="qa-icon"><i class="fas fa-search"></i></div>
                    Search Trains
                </a>
            </div>
            <div class="col-md-3 text-center">
                <a href="/my-bookings" class="qa-btn qa-green">
                    <div class="qa-icon"><i class="fas fa-list"></i></div>
                    My Bookings
                </a>
            </div>
            <div class="col-md-3 text-center">
                <a href="/pnr-status" class="qa-btn qa-cyan">
                    <div class="qa-icon"><i class="fas fa-info-circle"></i></div>
                    Check PNR
                </a>
            </div>
            <div class="col-md-3 text-center">
                <a href="/profile" class="qa-btn qa-gold">
                    <div class="qa-icon"><i class="fas fa-user"></i></div>
                    Profile
                </a>
            </div>
        </div>
    </div>

    <!-- Recent Bookings -->
    <div class="dashboard-card">
        <div class="section-heading">
            <div class="s-icon blue"><i class="fas fa-history"></i></div>
            <h4>Recent Bookings</h4>
        </div>
        <div class="section-divider"></div>
        <c:choose>
            <c:when test="${not empty bookings}">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>PNR</th>
                            <th>Train</th>
                            <th>Route</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="booking" items="${bookings}" varStatus="status">
                            <c:if test="${status.index < 5}">
                                <tr>
                                    <td><strong>${booking.pnr}</strong></td>
                                    <td>${booking.trainName}</td>
                                    <td>${booking.source}  ${booking.destination}</td>
                                    <td>${booking.journeyDate}</td>
                                    <td><span class="badge-status">${booking.status}</span></td>
                                    <td>
                                        <a href="/booking-details/${booking.pnr}" class="btn-view">
                                            View Details
                                        </a>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="text-center">
                    <a href="/my-bookings" class="btn-view-all">View All Bookings</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fas fa-ticket-alt"></i></div>
                    <h5>No bookings yet</h5>
                    <p>Start booking your first train ticket!</p>
                    <a href="/search" class="btn-search-trains">Search Trains</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
