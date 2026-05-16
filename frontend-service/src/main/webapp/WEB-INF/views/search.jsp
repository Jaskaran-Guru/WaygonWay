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
            --cream: #fef6e4;
            --white: #ffffff;
            --glass: rgba(255, 255, 255, 0.05);
            --glass-border: rgba(255, 255, 255, 0.15);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background: linear-gradient(135deg, var(--deep-plum) 0%, var(--midnight) 50%, var(--teal) 100%);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background:
                radial-gradient(circle at 20% 20%, rgba(212, 175, 55, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(50, 130, 184, 0.12) 0%, transparent 50%),
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

        /*  Floating Orbs  */
        .floating-shapes {
            position: fixed;
            inset: 0;
            pointer-events: none;
            overflow: hidden;
            z-index: 0;
        }

        .shape {
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            animation: float-orb 12s ease-in-out infinite;
        }

        .shape:nth-child(1) {
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(212, 175, 55, 0.15), transparent);
            top: 10%; left: 10%;
            animation-duration: 14s;
        }

        .shape:nth-child(2) {
            width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(50, 130, 184, 0.18), transparent);
            top: 60%; left: 70%;
            animation-duration: 16s;
            animation-delay: 3s;
        }

        .shape:nth-child(3) {
            width: 300px; height: 300px;
            background: radial-gradient(circle, rgba(183, 110, 121, 0.12), transparent);
            top: 75%; left: 20%;
            animation-duration: 13s;
            animation-delay: 2s;
        }

        .shape:nth-child(4) {
            width: 350px; height: 350px;
            background: radial-gradient(circle, rgba(77, 168, 218, 0.14), transparent);
            top: 30%; left: 65%;
            animation-duration: 15s;
            animation-delay: 5s;
        }

        @keyframes float-orb {
            0%, 100% { transform: translate(0, 0) scale(1); }
            33% { transform: translate(30px, -40px) scale(1.1); }
            66% { transform: translate(-40px, 20px) scale(0.9); }
        }

        /*  Navbar  */
        .navbar {
            background: rgba(26, 11, 46, 0.85);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-bottom: 1px solid rgba(212, 175, 55, 0.2);
            padding: 1rem 0;
            position: fixed;
            top: 0; left: 0; right: 0;
            z-index: 1000;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            font-size: 1.7rem !important;
            color: var(--white) !important;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }

        .navbar-brand .brand-icon {
            width: 40px; height: 40px;
            background: linear-gradient(135deg, var(--gold) 0%, var(--rose-gold) 100%);
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: var(--deep-plum);
            font-size: 1.1rem;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
        }

        .nav-link {
            color: rgba(255,255,255,0.75) !important;
            font-weight: 500;
            font-size: 0.95rem;
            letter-spacing: 0.3px;
            padding: 0.5rem 1rem !important;
            border-radius: 10px;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-link::before {
            content: '';
            position: absolute;
            bottom: 0; left: 50%;
            width: 0; height: 2px;
            background: linear-gradient(90deg, var(--gold), var(--gold-light));
            transform: translateX(-50%);
            transition: width 0.3s ease;
        }

        .nav-link:hover { color: var(--gold-light) !important; }
        .nav-link:hover::before { width: 70%; }

        .btn-nav-login {
            background: transparent;
            border: 1.5px solid rgba(212, 175, 55, 0.4);
            color: var(--gold-light) !important;
            font-size: 0.9rem;
            font-weight: 600;
            padding: 0.5rem 1.5rem;
            border-radius: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-nav-login:hover {
            background: rgba(212, 175, 55, 0.15);
            border-color: var(--gold);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.2);
        }

        .btn-nav-register {
            background: linear-gradient(135deg, var(--gold) 0%, var(--gold-light) 100%);
            border: none;
            color: var(--deep-plum) !important;
            font-size: 0.9rem;
            font-weight: 700;
            padding: 0.5rem 1.5rem;
            border-radius: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.25);
        }

        .btn-nav-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 25px rgba(212, 175, 55, 0.4);
        }

        .btn-nav-logout {
            background: rgba(239, 68, 68, 0.12);
            border: 1.5px solid rgba(239, 68, 68, 0.3);
            color: #fca5a5 !important;
            font-size: 0.9rem;
            font-weight: 600;
            padding: 0.5rem 1.5rem;
            border-radius: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-nav-logout:hover {
            background: rgba(239, 68, 68, 0.2);
            transform: translateY(-2px);
        }

        /*  Page Wrapper  */
        .page-wrapper {
            position: relative;
            z-index: 1;
            padding: 120px 0 60px;
        }

        /*  Page Header  */
        .page-header {
            text-align: center;
            margin-bottom: 2.5rem;
            animation: fade-up 0.8s ease both;
        }

        .page-badge {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.15), rgba(183, 110, 121, 0.15));
            border: 1px solid rgba(212, 175, 55, 0.3);
            color: var(--gold-light);
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            padding: 8px 20px;
            border-radius: 100px;
            margin-bottom: 20px;
            box-shadow: 0 4px 20px rgba(212, 175, 55, 0.15);
        }

        .page-badge .dot {
            width: 8px; height: 8px;
            background: var(--gold);
            border-radius: 50%;
            animation: pulse-dot 2s ease-in-out infinite;
            box-shadow: 0 0 10px var(--gold);
        }

        @keyframes pulse-dot {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.6; transform: scale(0.8); }
        }

        .page-title {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            font-size: clamp(2.2rem, 5vw, 3.5rem);
            color: var(--white);
            line-height: 1.15;
            letter-spacing: -1px;
            margin-bottom: 14px;
            text-shadow: 0 4px 30px rgba(0, 0, 0, 0.4);
        }

        .page-title .accent {
            background: linear-gradient(135deg, var(--gold) 0%, var(--aqua) 50%, var(--gold-light) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .page-subtitle {
            color: rgba(254, 246, 228, 0.6);
            font-size: 1.05rem;
            font-weight: 400;
            letter-spacing: 0.3px;
        }

        /*  Main Search Card  */
        .search-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.08) 0%, rgba(255,255,255,0.04) 100%);
            border: 1px solid rgba(212, 175, 55, 0.2);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-radius: 32px;
            padding: 3rem 3.5rem;
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.05),
                0 30px 90px rgba(0,0,0,0.5),
                inset 0 1px 0 rgba(255,255,255,0.1);
            animation: fade-scale 0.9s ease 0.2s both;
        }

        .search-card-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 2.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid rgba(212, 175, 55, 0.15);
        }

        .search-card-header .icon-box {
            width: 52px; height: 52px;
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            flex-shrink: 0;
            box-shadow: 0 8px 25px rgba(50, 130, 184, 0.3);
        }

        .search-card-header h3 {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 1.5rem;
            color: var(--white);
            margin: 0;
            letter-spacing: -0.5px;
        }

        .search-card-header p {
            font-size: 0.85rem;
            color: rgba(254, 246, 228, 0.55);
            margin: 0;
        }

        /*  Form Fields  */
        .field-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .field-label {
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: var(--gold-light);
            padding-left: 6px;
        }

        .form-control, .form-select {
            background: rgba(255,255,255,0.08) !important;
            border: 1.5px solid rgba(212, 175, 55, 0.25) !important;
            border-radius: 16px !important;
            padding: 16px 20px !important;
            color: var(--white) !important;
            font-family: 'Inter', sans-serif;
            font-size: 1rem !important;
            font-weight: 500;
            transition: all 0.3s ease;
            height: auto !important;
        }

        .form-control::placeholder {
            color: rgba(254, 246, 228, 0.4) !important;
            font-weight: 400;
        }

        .form-control:focus, .form-select:focus {
            background: rgba(255,255,255,0.12) !important;
            border-color: var(--gold) !important;
            box-shadow: 0 0 0 4px rgba(212, 175, 55, 0.15) !important;
            outline: none;
        }

        .form-select option {
            background: var(--deep-plum);
            color: var(--white);
        }

        input[type="date"]::-webkit-calendar-picker-indicator {
            filter: invert(0.7) sepia(1) saturate(5) hue-rotate(10deg);
            cursor: pointer;
        }

        /*  Swap Button  */
        .swap-wrapper {
            display: flex;
            align-items: flex-end;
            justify-content: center;
            padding-bottom: 16px;
        }

        .swap-btn {
            width: 44px; height: 44px;
            background: rgba(212, 175, 55, 0.12);
            border: 1.5px solid rgba(212, 175, 55, 0.3);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--gold-light);
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.4s ease;
        }

        .swap-btn:hover {
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            border-color: var(--aqua);
            color: white;
            transform: rotate(180deg) scale(1.1);
            box-shadow: 0 4px 20px rgba(50, 130, 184, 0.4);
        }

        /*  Toggle Switches  */
        .toggle-row {
            padding: 14px 20px;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 14px;
            transition: border-color 0.3s;
        }

        .toggle-row:hover { border-color: rgba(212, 175, 55, 0.2); }

        .form-check-input {
            background-color: rgba(255,255,255,0.1) !important;
            border: 1.5px solid rgba(212, 175, 55, 0.3) !important;
            width: 2.5em !important;
            height: 1.3em !important;
        }

        .form-check-input:checked {
            background-color: var(--ocean) !important;
            border-color: var(--aqua) !important;
        }

        .form-check-input:focus {
            box-shadow: 0 0 0 3px rgba(50, 130, 184, 0.2) !important;
        }

        .form-check-label {
            color: rgba(254, 246, 228, 0.75);
            font-size: 0.9rem;
            font-weight: 500;
            padding-left: 6px;
            cursor: pointer;
        }

        /*  Search Button  */
        .btn-search {
            background: linear-gradient(135deg, var(--ocean) 0%, var(--aqua) 100%);
            border: none;
            border-radius: 16px !important;
            padding: 18px 36px !important;
            font-family: 'Inter', sans-serif;
            font-size: 1.05rem !important;
            font-weight: 700;
            letter-spacing: 1.5px;
            color: white !important;
            width: 100%;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 8px 30px rgba(50, 130, 184, 0.35);
        }

        .btn-search::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, transparent 60%);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .btn-search:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 40px rgba(50, 130, 184, 0.5);
        }

        .btn-search:hover::before { opacity: 1; }
        .btn-search:active { transform: translateY(-1px); }

        /*  Info Cards  */
        .info-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.07) 0%, rgba(255,255,255,0.03) 100%);
            border: 1px solid rgba(212, 175, 55, 0.15);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 2rem 2.5rem;
            margin-top: 1.5rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        }

        .info-card:nth-child(2) { animation: fade-up 0.8s ease 0.45s both; }
        .info-card:nth-child(3) { animation: fade-up 0.8s ease 0.6s both; }

        .info-card-title {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--white);
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .info-card-title .title-icon {
            width: 32px; height: 32px;
            background: rgba(212, 175, 55, 0.15);
            border: 1px solid rgba(212, 175, 55, 0.3);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--gold-light);
            font-size: 0.8rem;
        }

        /*  Route Buttons  */
        .route-btn {
            background: rgba(255,255,255,0.06);
            border: 1.5px solid rgba(212, 175, 55, 0.25);
            border-radius: 12px;
            padding: 9px 18px;
            margin: 4px;
            color: rgba(254, 246, 228, 0.8);
            font-family: 'Inter', sans-serif;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .route-btn:hover {
            background: linear-gradient(135deg, rgba(50,130,184,0.25), rgba(77,168,218,0.2));
            border-color: var(--aqua);
            color: var(--gold-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(50, 130, 184, 0.25);
        }

        /*  Tips  */
        .tip-item {
            display: flex;
            align-items: center;
            gap: 10px;
            color: rgba(254, 246, 228, 0.7);
            font-size: 0.88rem;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }

        .tip-item:last-child { border-bottom: none; }

        .tip-icon {
            width: 22px; height: 22px;
            background: rgba(50, 130, 184, 0.2);
            border: 1px solid rgba(50, 130, 184, 0.3);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--aqua);
            font-size: 0.6rem;
            flex-shrink: 0;
        }

        /*  Animations  */
        @keyframes fade-up {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @keyframes fade-scale {
            from { opacity: 0; transform: translateY(30px) scale(0.95); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        .page-header { animation: fade-up 0.8s ease both; }

        /*  Responsive  */
        @media (max-width: 768px) {
            .search-card { padding: 2rem 1.8rem; }
            .page-wrapper { padding: 100px 0 40px; }
            .swap-wrapper { display: none; }
        }

        @media (max-width: 576px) {
            .search-card { padding: 1.5rem 1.2rem; }
            .navbar-brand { font-size: 1.4rem !important; }
            .info-card { padding: 1.5rem; }
        }
    </style>
</head>
<body>
<div class="floating-shapes">
    <div class="shape"></div>
    <div class="shape"></div>
    <div class="shape"></div>
    <div class="shape"></div>
</div>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg fixed-top">
    <div class="container">
        <a class="navbar-brand" href="/">
            <span class="brand-icon"><i class="fas fa-train"></i></span>
            WaygonWay
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                style="border-color: rgba(212,175,55,0.3);">
            <span class="navbar-toggler-icon" style="filter: invert(1);"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="/">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="/search">Search Trains</a></li>
                <li class="nav-item"><a class="nav-link" href="/pnr-status">PNR Status</a></li>
            </ul>
            <div class="d-flex align-items-center gap-2">
                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <a class="nav-link" href="/dashboard">Dashboard</a>
                        <a class="nav-link" href="/my-bookings">My Bookings</a>
                        <a class="btn-nav-logout" href="/logout">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a class="btn-nav-login" href="/login">Login</a>
                        <a class="btn-nav-register" href="/register">Register</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<!-- Page Content -->
<div class="page-wrapper">
    <div class="container">

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-badge">
                <span class="dot"></span>
                All Routes  All Classes
            </div>
            <h1 class="page-title">
                Find Your <span class="accent">Perfect Train</span>
            </h1>
            <p class="page-subtitle">Search across all routes, classes, and schedules in seconds</p>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-10">

                <!-- Main Search Card -->
                <div class="search-card">
                    <div class="search-card-header">
                        <div class="icon-box">
                            <i class="fas fa-route"></i>
                        </div>
                        <div>
                            <h3>Search Trains</h3>
                            <p>Enter your journey details below</p>
                        </div>
                    </div>

                    <form action="/search" method="post">
                        <div class="row g-3 align-items-end">

                            <!-- From -->
                            <div class="col-md-5">
                                <div class="field-group">
                                    <span class="field-label"><i class="fas fa-map-marker-alt me-1"></i>From</span>
                                    <input type="text" class="form-control" id="source" name="source"
                                           placeholder="Departure station" list="sourceList" required>
                                    <datalist id="sourceList">
                                        <option value="Bangalore">
                                        <option value="Delhi">
                                        <option value="Mumbai">
                                        <option value="Chennai">
                                        <option value="Kolkata">
                                        <option value="Hyderabad">
                                        <option value="Pune">
                                        <option value="Jaipur">
                                        <option value="Chandigarh">
                                    </datalist>
                                </div>
                            </div>

                            <!-- Swap -->
                            <div class="col-auto swap-wrapper d-none d-md-flex">
                                <button type="button" class="swap-btn" onclick="swapStations()" title="Swap stations">
                                    <i class="fas fa-arrows-alt-h"></i>
                                </button>
                            </div>

                            <!-- To -->
                            <div class="col-md-5">
                                <div class="field-group">
                                    <span class="field-label"><i class="fas fa-map-marker me-1"></i>To</span>
                                    <input type="text" class="form-control" id="destination" name="destination"
                                           placeholder="Arrival station" list="destinationList" required>
                                    <datalist id="destinationList">
                                        <option value="Bangalore">
                                        <option value="Delhi">
                                        <option value="Mumbai">
                                        <option value="Chennai">
                                        <option value="Kolkata">
                                        <option value="Hyderabad">
                                        <option value="Pune">
                                        <option value="Jaipur">
                                        <option value="Chandigarh">
                                    </datalist>
                                </div>
                            </div>

                            <!-- Date -->
                            <div class="col-md-3">
                                <div class="field-group">
                                    <span class="field-label"><i class="fas fa-calendar me-1"></i>Date</span>
                                    <input type="date" class="form-control" id="travelDate" name="travelDate" required>
                                </div>
                            </div>

                            <!-- Class -->
                            <div class="col-md-3">
                                <div class="field-group">
                                    <span class="field-label"><i class="fas fa-train me-1"></i>Class</span>
                                    <select class="form-select" id="trainClass" name="trainClass">
                                        <option value="">All Classes</option>
                                        <option value="SL">Sleeper (SL)</option>
                                        <option value="3A">AC 3 Tier (3A)</option>
                                        <option value="2A">AC 2 Tier (2A)</option>
                                        <option value="1A">AC First Class (1A)</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Passengers -->
                            <div class="col-md-3">
                                <div class="field-group">
                                    <span class="field-label"><i class="fas fa-users me-1"></i>Passengers</span>
                                    <select class="form-select" id="passengerCount" name="passengerCount">
                                        <option value="1">1 Passenger</option>
                                        <option value="2">2 Passengers</option>
                                        <option value="3">3 Passengers</option>
                                        <option value="4">4 Passengers</option>
                                        <option value="5">5 Passengers</option>
                                        <option value="6">6 Passengers</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Toggles -->
                            <div class="col-md-6 col-12">
                                <div class="toggle-row d-flex align-items-center gap-3">
                                    <input class="form-check-input flex-shrink-0" type="checkbox"
                                           id="flexibleDates" name="flexibleDates" role="switch">
                                    <label class="form-check-label" for="flexibleDates">
                                        <i class="fas fa-calendar-week me-2" style="color: var(--gold-light);"></i>
                                        Flexible dates
                                        <span style="color: rgba(254,246,228,0.4); font-size: 0.8rem;">(3 days)</span>
                                    </label>
                                </div>
                            </div>

                            <div class="col-md-6 col-12">
                                <div class="toggle-row d-flex align-items-center gap-3">
                                    <input class="form-check-input flex-shrink-0" type="checkbox"
                                           id="availableOnly" name="availableOnly" checked role="switch">
                                    <label class="form-check-label" for="availableOnly">
                                        <i class="fas fa-check-circle me-2" style="color: var(--aqua);"></i>
                                        Available trains only
                                    </label>
                                </div>
                            </div>

                            <!-- Submit -->
                            <div class="col-12 mt-4">
                                <button type="submit" class="btn btn-search">
                                    <i class="fas fa-search me-2"></i>SEARCH TRAINS
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Popular Routes -->
                <div class="info-card">
                    <div class="info-card-title">
                        <span class="title-icon"><i class="fas fa-bolt"></i></span>
                        Popular Routes
                    </div>
                    <div class="text-center">
                        <button class="btn route-btn" onclick="fillRoute('Delhi','Mumbai')">Delhi  Mumbai</button>
                        <button class="btn route-btn" onclick="fillRoute('Bangalore','Chennai')">Bangalore  Chennai</button>
                        <button class="btn route-btn" onclick="fillRoute('Delhi','Kolkata')">Delhi  Kolkata</button>
                        <button class="btn route-btn" onclick="fillRoute('Mumbai','Pune')">Mumbai  Pune</button>
                        <button class="btn route-btn" onclick="fillRoute('Delhi','Jaipur')">Delhi  Jaipur</button>
                        <button class="btn route-btn" onclick="fillRoute('Bangalore','Hyderabad')">Bangalore  Hyderabad</button>
                    </div>
                </div>

                <!-- Search Tips -->
                <div class="info-card">
                    <div class="info-card-title">
                        <span class="title-icon"><i class="fas fa-lightbulb"></i></span>
                        Search Tips
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="tip-item">
                                <span class="tip-icon"><i class="fas fa-check"></i></span>
                                Book in advance for better availability
                            </div>
                            <div class="tip-item">
                                <span class="tip-icon"><i class="fas fa-check"></i></span>
                                Try flexible dates for more options
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="tip-item">
                                <span class="tip-icon"><i class="fas fa-check"></i></span>
                                Check different train classes
                            </div>
                            <div class="tip-item">
                                <span class="tip-icon"><i class="fas fa-check"></i></span>
                                Consider nearby stations
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const today = new Date();
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    document.getElementById('travelDate').min = today.toISOString().split('T')[0];
    document.getElementById('travelDate').value = tomorrow.toISOString().split('T')[0];

    function fillRoute(from, to) {
        document.getElementById('source').value = from;
        document.getElementById('destination').value = to;
        [document.getElementById('source'), document.getElementById('destination')].forEach(el => {
            el.style.borderColor = 'var(--gold)';
            el.style.boxShadow = '0 0 0 4px rgba(212, 175, 55, 0.15)';
            setTimeout(() => { el.style.borderColor = ''; el.style.boxShadow = ''; }, 1200);
        });
    }

    function swapStations() {
        const source = document.getElementById('source');
        const dest = document.getElementById('destination');
        const temp = source.value;
        source.value = dest.value;
        dest.value = temp;
    }
</script>
</body>
</html>
