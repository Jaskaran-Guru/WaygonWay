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

        /*  Elegant Background Pattern  */
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
        }

        .navbar-brand .brand-icon {
            width: 40px;
            height: 40px;
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
            bottom: 0;
            left: 50%;
            width: 0;
            height: 2px;
            background: linear-gradient(90deg, var(--gold), var(--gold-light));
            transform: translateX(-50%);
            transition: width 0.3s ease;
        }

        .nav-link:hover {
            color: var(--gold-light) !important;
        }

        .nav-link:hover::before {
            width: 70%;
        }

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

        /*  Hero Section  */
        .hero-section {
            position: relative;
            z-index: 1;
            padding: 180px 0 90px;
            text-align: center;
        }

        .hero-badge {
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
            margin-bottom: 32px;
            box-shadow: 0 4px 20px rgba(212, 175, 55, 0.15);
        }

        .hero-badge .dot {
            width: 8px;
            height: 8px;
            background: var(--gold);
            border-radius: 50%;
            animation: pulse-dot 2s ease-in-out infinite;
            box-shadow: 0 0 10px var(--gold);
        }

        @keyframes pulse-dot {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.6; transform: scale(0.8); }
        }

        .hero-title {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            font-size: clamp(3rem, 7vw, 5.5rem);
            color: var(--white);
            line-height: 1.1;
            letter-spacing: -1.5px;
            margin-bottom: 28px;
            text-shadow: 0 4px 30px rgba(0, 0, 0, 0.4);
        }

        .hero-title .accent {
            background: linear-gradient(135deg, var(--gold) 0%, var(--aqua) 50%, var(--gold-light) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            position: relative;
            display: inline-block;
        }

        .hero-subtitle {
            color: rgba(254, 246, 228, 0.7);
            font-size: 1.15rem;
            font-weight: 400;
            max-width: 580px;
            margin: 0 auto 60px;
            line-height: 1.8;
            letter-spacing: 0.3px;
        }

        /*  Search Card  */
        .search-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.08) 0%, rgba(255, 255, 255, 0.04) 100%);
            border: 1px solid rgba(212, 175, 55, 0.2);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-radius: 32px;
            padding: 3rem 3.5rem;
            margin-top: 0;
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.05),
                0 30px 90px rgba(0, 0, 0, 0.5),
                inset 0 1px 0 rgba(255,255,255,0.1);
        }

        .search-card-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 2.5rem;
        }

        .search-card-header .icon-box {
            width: 52px;
            height: 52px;
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
            letter-spacing: 0.3px;
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
            background: rgba(255, 255, 255, 0.08) !important;
            border: 1.5px solid rgba(212, 175, 55, 0.25) !important;
            border-radius: 16px !important;
            padding: 16px 20px !important;
            color: var(--white) !important;
            font-family: 'Inter', sans-serif;
            font-size: 1rem !important;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .form-control::placeholder { 
            color: rgba(254, 246, 228, 0.4) !important; 
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

        .divider-arrow {
            display: flex;
            align-items: flex-end;
            justify-content: center;
            padding-bottom: 16px;
        }

        .divider-arrow .arrow-btn {
            width: 44px;
            height: 44px;
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

        .divider-arrow .arrow-btn:hover {
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            border-color: var(--aqua);
            color: white;
            transform: rotate(180deg) scale(1.1);
            box-shadow: 0 4px 20px rgba(50, 130, 184, 0.4);
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

        .btn-search::after {
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

        .btn-search:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 40px rgba(50, 130, 184, 0.5);
        }

        .btn-search:hover::before { opacity: 1; }
        
        .btn-search:active { 
            transform: translateY(-1px); 
        }

        .btn-search:active::after {
            width: 300px;
            height: 300px;
        }

        /*  Elegant Floating Orbs  */
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

        /*  Entry Animations  */
        .hero-badge { animation: fade-up 0.8s ease both; }
        .hero-title { animation: fade-up 0.8s ease 0.15s both; }
        .hero-subtitle { animation: fade-up 0.8s ease 0.25s both; }
        .search-card { animation: fade-scale 0.9s ease 0.35s both; }

        @keyframes fade-up {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @keyframes fade-scale {
            from { opacity: 0; transform: translateY(30px) scale(0.95); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        /*  Responsive  */
        @media (max-width: 768px) {
            .search-card { padding: 2rem 1.8rem; }
            .hero-section { padding: 140px 0 70px; }
            .divider-arrow { display: none; }
            .hero-title { font-size: 2.5rem; }
        }

        @media (max-width: 576px) {
            .search-card { padding: 1.5rem 1.2rem; }
            .navbar-brand { font-size: 1.4rem !important; }
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
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/search">Search Trains</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/pnr-status">PNR Status</a>
                </li>
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

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">

        <div class="hero-badge">
            <span class="dot"></span>
            India's Trusted Rail Booking Platform
        </div>

        <h1 class="hero-title">
            Book Your Journey<br>
            <span class="accent">with Confidence</span>
        </h1>

        <p class="hero-subtitle">
            Experience seamless railway booking with India's most trusted platform. Fast, secure, and reliable  your perfect travel companion.
        </p>

        <!-- Search Form -->
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="search-card">
                    <div class="search-card-header">
                        <div class="icon-box">
                            <i class="fas fa-search"></i>
                        </div>
                        <div>
                            <h3>Find Your Perfect Train</h3>
                            <p>Search across all routes and classes</p>
                        </div>
                    </div>
                    <form action="/search" method="post">
                        <div class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <div class="field-group">
                                    <span class="field-label"><i class="fas fa-map-marker-alt me-1"></i>From</span>
                                    <input type="text" class="form-control" id="source" name="source" placeholder="Departure station" required>
                                </div>
                            </div>

                            <div class="col-md-auto divider-arrow d-none d-md-flex">
                                <div class="arrow-btn">
                                    <i class="fas fa-arrows-alt-h"></i>
                                </div>
                            </div>

                            <div class="col-md-3">
                                <div class="field-group">
                                    <span class="field-label"><i class="fas fa-map-marker me-1"></i>To</span>
                                    <input type="text" class="form-control" id="destination" name="destination" placeholder="Arrival station" required>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="field-group">
                                    <span class="field-label"><i class="fas fa-calendar me-1"></i>Date</span>
                                    <input type="date" class="form-control" id="travelDate" name="travelDate" required>
                                </div>
                            </div>
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
                            <div class="col-12 mt-4">
                                <button type="submit" class="btn btn-search">
                                    <i class="fas fa-search me-2"></i>SEARCH TRAINS
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Set minimum date to today
    document.getElementById('travelDate').min = new Date().toISOString().split('T')[0];
</script>
</body>
</html>
