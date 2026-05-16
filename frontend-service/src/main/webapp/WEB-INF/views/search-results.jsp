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
            --text-muted: rgba(254, 246, 228, 0.55);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background: linear-gradient(135deg, var(--deep-plum) 0%, var(--midnight) 50%, var(--teal) 100%);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
            padding-top: 80px;
        }

        body::before {
            content: '';
            position: fixed; inset: 0;
            background:
                radial-gradient(circle at 15% 15%, rgba(212,175,55,0.08) 0%, transparent 50%),
                radial-gradient(circle at 85% 80%, rgba(50,130,184,0.12) 0%, transparent 50%),
                radial-gradient(circle at 50% 50%, rgba(45,27,78,0.6) 0%, transparent 100%);
            z-index: 0; pointer-events: none;
        }

        body::after {
            content: '';
            position: fixed; inset: 0;
            background-image:
                linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
            background-size: 50px 50px;
            z-index: 0; pointer-events: none; opacity: 0.4;
        }

        /*  Floating Orbs  */
        .floating-shapes { position: fixed; inset: 0; pointer-events: none; overflow: hidden; z-index: 0; }

        .shape { position: absolute; border-radius: 50%; filter: blur(80px); animation: float-orb 12s ease-in-out infinite; }
        .shape:nth-child(1) { width: 380px; height: 380px; background: radial-gradient(circle, rgba(212,175,55,0.14), transparent); top: 5%; left: 5%; animation-duration: 14s; }
        .shape:nth-child(2) { width: 480px; height: 480px; background: radial-gradient(circle, rgba(50,130,184,0.18), transparent); top: 55%; left: 65%; animation-duration: 16s; animation-delay: 3s; }
        .shape:nth-child(3) { width: 280px; height: 280px; background: radial-gradient(circle, rgba(183,110,121,0.12), transparent); top: 70%; left: 10%; animation-duration: 13s; animation-delay: 2s; }

        @keyframes float-orb {
            0%, 100% { transform: translate(0,0) scale(1); }
            33%       { transform: translate(30px,-40px) scale(1.1); }
            66%       { transform: translate(-40px,20px) scale(0.9); }
        }

        /*  Navbar  */
        .navbar {
            background: rgba(26,11,46,0.85);
            backdrop-filter: blur(30px); -webkit-backdrop-filter: blur(30px);
            border-bottom: 1px solid rgba(212,175,55,0.2);
            padding: 1rem 0; position: fixed; top: 0; left: 0; right: 0;
            z-index: 1000; box-shadow: 0 4px 30px rgba(0,0,0,0.3);
        }

        .navbar-brand {
            font-family: 'Playfair Display', serif; font-weight: 800; font-size: 1.7rem !important;
            color: var(--white) !important; letter-spacing: -0.5px;
            display: flex; align-items: center; gap: 10px;
        }

        .navbar-brand .brand-icon {
            width: 40px; height: 40px;
            background: linear-gradient(135deg, var(--gold) 0%, var(--rose-gold) 100%);
            border-radius: 12px; display: inline-flex; align-items: center; justify-content: center;
            color: var(--deep-plum); font-size: 1.1rem; box-shadow: 0 4px 15px rgba(212,175,55,0.3);
        }

        .nav-link {
            color: rgba(255,255,255,0.75) !important; font-weight: 500; font-size: 0.95rem;
            padding: 0.5rem 1rem !important; border-radius: 10px; transition: all 0.3s ease; position: relative;
        }

        .nav-link::before {
            content: ''; position: absolute; bottom: 0; left: 50%; width: 0; height: 2px;
            background: linear-gradient(90deg, var(--gold), var(--gold-light));
            transform: translateX(-50%); transition: width 0.3s ease;
        }

        .nav-link:hover { color: var(--gold-light) !important; }
        .nav-link:hover::before { width: 70%; }

        .btn-nav-new-search {
            background: linear-gradient(135deg, var(--gold) 0%, var(--gold-light) 100%);
            border: none; color: var(--deep-plum) !important;
            font-size: 0.9rem; font-weight: 700; padding: 0.5rem 1.5rem;
            border-radius: 10px; transition: all 0.3s ease; text-decoration: none;
            box-shadow: 0 4px 15px rgba(212,175,55,0.25);
        }

        .btn-nav-new-search:hover { transform: translateY(-2px); box-shadow: 0 6px 25px rgba(212,175,55,0.4); }

        .btn-nav-logout {
            background: rgba(239,68,68,0.12); border: 1.5px solid rgba(239,68,68,0.3);
            color: #fca5a5 !important; font-size: 0.9rem; font-weight: 600;
            padding: 0.5rem 1.5rem; border-radius: 10px; transition: all 0.3s ease; text-decoration: none;
        }

        .btn-nav-logout:hover { background: rgba(239,68,68,0.2); transform: translateY(-2px); }

        /*  Container  */
        .container { position: relative; z-index: 1; padding-top: 2rem; padding-bottom: 3.5rem; }

        /*  Animations  */
        @keyframes fade-up   { from { opacity:0; transform:translateY(20px); } to { opacity:1; transform:translateY(0); } }
        @keyframes fade-scale{ from { opacity:0; transform:translateY(20px) scale(0.97); } to { opacity:1; transform:translateY(0) scale(1); } }

        /*  Search Summary Header  */
        .search-summary {
            background: linear-gradient(135deg, rgba(255,255,255,0.08) 0%, rgba(255,255,255,0.04) 100%);
            border: 1px solid rgba(212,175,55,0.2);
            backdrop-filter: blur(30px); -webkit-backdrop-filter: blur(30px);
            border-radius: 24px; padding: 1.8rem 2.2rem;
            margin-bottom: 2rem;
            box-shadow: 0 0 0 1px rgba(255,255,255,0.05), 0 20px 60px rgba(0,0,0,0.35);
            animation: fade-scale 0.7s ease both;
        }

        .route-display {
            display: flex; align-items: center; gap: 14px; flex-wrap: wrap;
        }

        .route-station {
            display: flex; flex-direction: column;
        }

        .route-station .station-label {
            font-size: 0.62rem; font-weight: 700; letter-spacing: 1.5px;
            text-transform: uppercase; color: var(--gold-light); margin-bottom: 2px;
        }

        .route-station .station-name {
            font-family: 'Playfair Display', serif; font-weight: 700; font-size: 1.4rem;
            color: var(--white); letter-spacing: -0.5px;
        }

        .route-arrow {
            display: flex; flex-direction: column; align-items: center; gap: 3px;
            padding: 0 6px;
        }

        .route-arrow .arrow-line {
            width: 50px; height: 1px;
            background: linear-gradient(90deg, rgba(212,175,55,0.5), rgba(77,168,218,0.5));
        }

        .route-arrow .arrow-icon { color: var(--aqua); font-size: 0.75rem; }
        .route-arrow .arrow-duration { font-size: 0.68rem; color: var(--text-muted); letter-spacing: 0.5px; white-space: nowrap; }

        .summary-meta {
            display: flex; align-items: center; gap: 20px; flex-wrap: wrap; margin-top: 10px;
        }

        .meta-chip {
            display: inline-flex; align-items: center; gap: 7px;
            font-size: 0.8rem; color: var(--text-muted);
        }

        .meta-chip .chip-icon {
            width: 22px; height: 22px; border-radius: 6px;
            background: rgba(212,175,55,0.12);
            display: flex; align-items: center; justify-content: center;
            color: var(--gold-light); font-size: 0.6rem;
        }

        .result-count {
            font-weight: 600;
        }

        .result-count.found { color: #6ee7b7; }
        .result-count.none  { color: var(--gold-light); }

        .btn-modify {
            background: transparent;
            border: 1.5px solid rgba(212,175,55,0.3);
            color: var(--gold-light) !important; font-size: 0.85rem; font-weight: 600;
            padding: 0.5rem 1.2rem; border-radius: 10px;
            transition: all 0.3s ease; text-decoration: none;
            white-space: nowrap;
        }

        .btn-modify:hover { background: rgba(212,175,55,0.1); border-color: var(--gold); transform: translateY(-2px); }

        /*  Train Card  */
        .train-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.07) 0%, rgba(255,255,255,0.03) 100%);
            border: 1px solid rgba(212,175,55,0.18);
            backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border-radius: 22px; padding: 1.8rem 2rem;
            margin-bottom: 1.2rem;
            box-shadow: 0 0 0 1px rgba(255,255,255,0.04), 0 16px 50px rgba(0,0,0,0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
            animation: fade-scale 0.6s ease both;
            position: relative; overflow: hidden;
        }

        .train-card::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0; height: 2px;
            background: linear-gradient(90deg, transparent, rgba(212,175,55,0.3), transparent);
            transition: opacity 0.3s ease; opacity: 0;
        }

        .train-card:hover { transform: translateY(-4px); box-shadow: 0 24px 70px rgba(0,0,0,0.45); border-color: rgba(212,175,55,0.35); }
        .train-card:hover::before { opacity: 1; }

        /* stagger animations */
        .train-card:nth-child(1) { animation-delay: 0.05s; }
        .train-card:nth-child(2) { animation-delay: 0.12s; }
        .train-card:nth-child(3) { animation-delay: 0.19s; }
        .train-card:nth-child(4) { animation-delay: 0.26s; }
        .train-card:nth-child(5) { animation-delay: 0.33s; }

        /*  Train Name / Number  */
        .train-name {
            font-family: 'Playfair Display', serif; font-weight: 700; font-size: 1.05rem;
            color: var(--white); margin-bottom: 3px; line-height: 1.3;
        }

        .train-number {
            font-size: 0.75rem; color: var(--text-muted); margin-bottom: 6px;
        }

        .train-type-badge {
            display: inline-flex; align-items: center; gap: 5px;
            background: rgba(212,175,55,0.12); border: 1px solid rgba(212,175,55,0.22);
            color: var(--gold-light); font-size: 0.65rem; font-weight: 700;
            letter-spacing: 1px; text-transform: uppercase;
            padding: 3px 10px; border-radius: 100px;
        }

        /*  Time Block  */
        .time-block { text-align: center; }

        .time-block .time {
            font-family: 'Playfair Display', serif; font-weight: 700;
            font-size: 1.3rem; color: var(--white); line-height: 1;
            margin-bottom: 3px;
        }

        .time-block .station-code {
            font-size: 0.72rem; font-weight: 700; letter-spacing: 1px;
            text-transform: uppercase; color: var(--aqua);
        }

        /*  Journey Arrow  */
        .journey-arrow {
            display: flex; flex-direction: column; align-items: center; gap: 4px;
        }

        .journey-arrow .j-line {
            width: 100%; height: 1px; max-width: 70px;
            background: linear-gradient(90deg, rgba(212,175,55,0.4), rgba(77,168,218,0.4));
        }

        .journey-arrow .j-icon { color: var(--aqua); font-size: 0.8rem; }
        .journey-arrow .j-dur { font-size: 0.7rem; color: var(--text-muted); white-space: nowrap; }

        /*  Price Badge  */
        .price-badge {
            background: linear-gradient(135deg, rgba(52,211,153,0.18), rgba(16,185,129,0.12));
            border: 1px solid rgba(52,211,153,0.28);
            color: #6ee7b7; font-family: 'Playfair Display', serif;
            font-weight: 700; font-size: 1.1rem;
            padding: 7px 16px; border-radius: 12px;
            display: inline-block; margin-bottom: 5px;
        }

        .seats-available {
            font-size: 0.72rem; color: #6ee7b7;
            display: flex; align-items: center; justify-content: center; gap: 4px;
        }

        /*  Book Button  */
        .btn-book {
            background: linear-gradient(135deg, var(--ocean) 0%, var(--aqua) 100%);
            border: none; border-radius: 12px !important;
            padding: 10px 20px !important;
            font-family: 'Inter', sans-serif; font-weight: 700;
            font-size: 0.88rem !important; color: white !important;
            position: relative; overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(50,130,184,0.3);
            white-space: nowrap;
        }

        .btn-book::before {
            content: ''; position: absolute; inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, transparent 60%);
            opacity: 0; transition: opacity 0.3s ease;
        }

        .btn-book:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(50,130,184,0.5); }
        .btn-book:hover::before { opacity: 1; }

        .btn-book-login {
            background: transparent;
            border: 1.5px solid rgba(212,175,55,0.35) !important;
            color: var(--gold-light) !important;
            font-size: 0.82rem; font-weight: 600;
            padding: 10px 16px; border-radius: 12px;
            text-decoration: none; transition: all 0.3s ease;
            white-space: nowrap; display: inline-block;
        }

        .btn-book-login:hover { background: rgba(212,175,55,0.1); transform: translateY(-2px); }

        /*  Train Description  */
        .train-desc-row {
            margin-top: 1.2rem; padding-top: 1.2rem;
            border-top: 1px solid rgba(255,255,255,0.07);
        }

        .train-desc {
            font-size: 0.82rem; color: rgba(254,246,228,0.4);
            display: flex; align-items: flex-start; gap: 8px;
        }

        .train-desc i { color: rgba(212,175,55,0.4); margin-top: 2px; flex-shrink: 0; }

        /*  Empty State  */
        .empty-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.06) 0%, rgba(255,255,255,0.03) 100%);
            border: 1px solid rgba(212,175,55,0.18);
            backdrop-filter: blur(20px); border-radius: 24px;
            padding: 4rem 2rem; text-align: center;
            animation: fade-scale 0.7s ease 0.1s both;
        }

        .empty-icon-ring {
            width: 80px; height: 80px; border-radius: 50%;
            background: rgba(212,175,55,0.1); border: 1px solid rgba(212,175,55,0.2);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; color: var(--gold-light);
            margin: 0 auto 1.5rem;
        }

        .empty-card h4 {
            font-family: 'Playfair Display', serif; font-weight: 700;
            color: var(--white); margin-bottom: 8px;
        }

        .empty-card p { color: var(--text-muted); font-size: 0.92rem; margin-bottom: 1.5rem; }

        .suggestions-box {
            background: rgba(50,130,184,0.08);
            border: 1px solid rgba(50,130,184,0.2);
            border-radius: 16px; padding: 1.2rem 1.5rem;
            text-align: left; margin-bottom: 1.8rem;
        }

        .suggestions-box h6 {
            font-family: 'Inter', sans-serif; font-weight: 700;
            color: var(--aqua); font-size: 0.85rem; margin-bottom: 10px;
        }

        .suggestion-item {
            display: flex; align-items: center; gap: 9px;
            font-size: 0.84rem; color: rgba(254,246,228,0.5); margin-bottom: 7px;
        }

        .suggestion-item:last-child { margin-bottom: 0; }

        .suggestion-item .s-dot {
            width: 20px; height: 20px; border-radius: 50%;
            background: rgba(50,130,184,0.18);
            display: flex; align-items: center; justify-content: center;
            color: var(--aqua); font-size: 0.5rem; flex-shrink: 0;
        }

        .btn-search-again {
            background: linear-gradient(135deg, var(--ocean) 0%, var(--aqua) 100%);
            border: none; border-radius: 12px; padding: 12px 28px;
            font-family: 'Inter', sans-serif; font-weight: 700;
            font-size: 0.9rem; color: white; text-decoration: none;
            transition: all 0.3s ease; box-shadow: 0 6px 20px rgba(50,130,184,0.3);
            display: inline-flex; align-items: center; gap: 8px;
        }

        .btn-search-again:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(50,130,184,0.5); color: white; }

        /*  Modal  */
        .modal-content {
            background: linear-gradient(135deg, #1e0f38 0%, var(--midnight) 100%);
            border: 1px solid rgba(212,175,55,0.25);
            border-radius: 24px;
            box-shadow: 0 30px 80px rgba(0,0,0,0.6);
        }

        .modal-header {
            border-bottom: 1px solid rgba(212,175,55,0.15);
            padding: 1.5rem 1.8rem;
        }

        .modal-title {
            font-family: 'Playfair Display', serif; font-weight: 700;
            color: var(--white); font-size: 1.15rem;
        }

        .modal-body { padding: 1.8rem; }

        .btn-close { filter: invert(1) opacity(0.5); }
        .btn-close:hover { filter: invert(1) opacity(0.9); }

        .modal-section-title {
            font-size: 0.65rem; font-weight: 700; letter-spacing: 1.5px;
            text-transform: uppercase; color: rgba(212,175,55,0.6);
            margin-bottom: 1rem; display: flex; align-items: center; gap: 8px;
        }

        .modal-section-title::after {
            content: ''; flex: 1; height: 1px;
            background: linear-gradient(90deg, rgba(212,175,55,0.2), transparent);
        }

        .modal-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(212,175,55,0.15), transparent);
            margin: 1.2rem 0;
        }

        .field-label {
            font-size: 0.68rem; font-weight: 700; letter-spacing: 1.5px;
            text-transform: uppercase; color: var(--gold-light); padding-left: 2px;
            display: block; margin-bottom: 6px;
        }

        .form-control, .form-select {
            background: rgba(255,255,255,0.07) !important;
            border: 1.5px solid rgba(212,175,55,0.22) !important;
            border-radius: 12px !important;
            padding: 12px 16px !important;
            color: var(--white) !important;
            font-family: 'Inter', sans-serif;
            font-size: 0.92rem !important; font-weight: 500;
            transition: all 0.3s ease;
        }

        .form-control::placeholder { color: rgba(254,246,228,0.28) !important; font-weight: 400; }

        .form-control:focus, .form-select:focus {
            background: rgba(255,255,255,0.11) !important;
            border-color: var(--gold) !important;
            box-shadow: 0 0 0 4px rgba(212,175,55,0.14) !important; outline: none;
        }

        .form-select option { background: var(--deep-plum); color: var(--white); }

        input[type="date"]::-webkit-calendar-picker-indicator {
            filter: invert(0.7) sepia(1) saturate(5) hue-rotate(10deg); cursor: pointer;
        }

        .btn-proceed {
            background: linear-gradient(135deg, var(--ocean) 0%, var(--aqua) 100%);
            border: none; border-radius: 14px !important; padding: 16px !important;
            font-family: 'Inter', sans-serif; font-weight: 700;
            font-size: 0.95rem !important; letter-spacing: 1px; text-transform: uppercase;
            color: white !important; width: 100%;
            position: relative; overflow: hidden; transition: all 0.3s ease;
            box-shadow: 0 8px 28px rgba(50,130,184,0.35);
        }

        .btn-proceed::before {
            content: ''; position: absolute; inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, transparent 60%);
            opacity: 0; transition: opacity 0.3s ease;
        }

        .btn-proceed:hover { transform: translateY(-2px); box-shadow: 0 12px 40px rgba(50,130,184,0.5); }
        .btn-proceed:hover::before { opacity: 1; }

        /*  Responsive  */
        @media (max-width: 768px) {
            .train-card { padding: 1.4rem 1.2rem; }
            .search-summary { padding: 1.4rem 1.5rem; }
            .route-arrow .arrow-line { width: 24px; }
            .journey-arrow .j-line { max-width: 30px; }
            .time-block .time { font-size: 1.1rem; }
        }

        @media (max-width: 576px) {
            .navbar-brand { font-size: 1.4rem !important; }
            .empty-card { padding: 2.5rem 1.2rem; }
        }
    </style>
</head>
<body>

<div class="floating-shapes">
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
                        <a class="btn-nav-new-search" href="/search">New Search</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<div class="container">

    <!-- Search Summary -->
    <div class="search-summary">
        <div class="row align-items-center g-3">
            <div class="col-md-8">
                <div class="route-display mb-2">
                    <div class="route-station">
                        <span class="station-label">From</span>
                        <span class="station-name">${searchQuery.source}</span>
                    </div>
                    <div class="route-arrow">
                        <div class="arrow-line"></div>
                        <i class="arrow-icon fas fa-arrow-right"></i>
                    </div>
                    <div class="route-station">
                        <span class="station-label">To</span>
                        <span class="station-name">${searchQuery.destination}</span>
                    </div>
                </div>
                <div class="summary-meta">
                    <div class="meta-chip">
                        <span class="chip-icon"><i class="fas fa-calendar"></i></span>
                        ${searchQuery.travelDate}
                    </div>
                    <div class="meta-chip">
                        <c:choose>
                            <c:when test="${not empty trains}">
                                <span class="chip-icon"><i class="fas fa-train"></i></span>
                                <span class="result-count found">${trains.size()} trains found</span>
                            </c:when>
                            <c:otherwise>
                                <span class="chip-icon"><i class="fas fa-exclamation"></i></span>
                                <span class="result-count none">No trains found</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            <div class="col-md-4 text-md-end">
                <a href="/search" class="btn-modify">
                    <i class="fas fa-edit me-2"></i>Modify Search
                </a>
            </div>
        </div>
    </div>

    <!-- Train Results -->
    <c:choose>
        <c:when test="${not empty trains}">
            <c:forEach var="train" items="${trains}">
                <div class="train-card">
                    <div class="row align-items-center g-3">

                        <!-- Train Info -->
                        <div class="col-md-3">
                            <div class="train-name">${train.eventName}</div>
                            <div class="train-number"><i class="fas fa-hashtag me-1" style="color:rgba(212,175,55,0.4)"></i>${train.eventCode}</div>
                            <span class="train-type-badge"><i class="fas fa-tag"></i>${train.eventType}</span>
                        </div>

                        <!-- Departure -->
                        <div class="col-md-2">
                            <div class="time-block">
                                <div class="time">08:00</div>
                                <div class="station-code">${train.source}</div>
                            </div>
                        </div>

                        <!-- Journey Arrow -->
                        <div class="col-md-2">
                            <div class="journey-arrow">
                                <div class="j-line"></div>
                                <i class="j-icon fas fa-long-arrow-alt-right"></i>
                                <span class="j-dur">16h 30m</span>
                            </div>
                        </div>

                        <!-- Arrival -->
                        <div class="col-md-2">
                            <div class="time-block">
                                <div class="time">00:30</div>
                                <div class="station-code">${train.destination}</div>
                            </div>
                        </div>

                        <!-- Price & Seats -->
                        <div class="col-md-2 text-center">
                            <div class="price-badge">${train.price}</div>
                            <div class="seats-available">
                                <i class="fas fa-check-circle"></i>${train.availableSeats} seats left
                            </div>
                        </div>

                        <!-- Book Button -->
                        <div class="col-md-1 text-center">
                            <c:choose>
                                <c:when test="${isLoggedIn}">
                                    <button class="btn btn-book"
                                            onclick="bookTrain('${train.id}', '${train.eventName}')">
                                        <i class="fas fa-ticket-alt me-1"></i>Book
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="/login" class="btn-book-login">
                                        <i class="fas fa-lock me-1"></i>Login to Book
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Description -->
                    <c:if test="${not empty train.description}">
                        <div class="train-desc-row">
                            <div class="train-desc">
                                <i class="fas fa-info-circle"></i>
                                ${train.description}
                            </div>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </c:when>

        <!-- Empty State -->
        <c:otherwise>
            <div class="empty-card">
                <div class="empty-icon-ring">
                    <i class="fas fa-train"></i>
                </div>
                <h4>No Trains Found</h4>
                <p>
                    No trains available from <strong style="color:var(--white)">${searchQuery.source}</strong>
                    to <strong style="color:var(--white)">${searchQuery.destination}</strong>
                    on <strong style="color:var(--white)">${searchQuery.travelDate}</strong>.
                </p>
                <div class="suggestions-box">
                    <h6><i class="fas fa-lightbulb me-2"></i>Try the following:</h6>
                    <div class="suggestion-item">
                        <span class="s-dot"><i class="fas fa-circle"></i></span>
                        Double-check the spelling of station names
                    </div>
                    <div class="suggestion-item">
                        <span class="s-dot"><i class="fas fa-circle"></i></span>
                        Try a different travel date
                    </div>
                    <div class="suggestion-item">
                        <span class="s-dot"><i class="fas fa-circle"></i></span>
                        Search for nearby or alternate stations
                    </div>
                </div>
                <a href="/search" class="btn-search-again">
                    <i class="fas fa-search"></i>Search Again
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<!--  Booking Modal  -->
<div class="modal fade" id="bookingModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">
                    <i class="fas fa-ticket-alt me-2" style="color:var(--aqua)"></i>Book Ticket
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="bookingForm" action="/book-ticket" method="post">
                    <input type="hidden" id="eventId" name="eventId">

                    <!-- Passenger -->
                    <div class="modal-section-title">
                        <i class="fas fa-user" style="color:var(--gold-light);font-size:0.65rem"></i>
                        Passenger Details
                    </div>
                    <div class="mb-3">
                        <label class="field-label">Passenger Name <span style="color:var(--rose-gold)">*</span></label>
                        <input type="text" class="form-control" name="passengerName" placeholder="Full name" required>
                    </div>
                    <div class="row g-3 mb-2">
                        <div class="col-6">
                            <label class="field-label">Age <span style="color:var(--rose-gold)">*</span></label>
                            <input type="number" class="form-control" name="passengerAge"
                                   min="1" max="120" placeholder="e.g. 28" required>
                        </div>
                        <div class="col-6">
                            <label class="field-label">Gender <span style="color:var(--rose-gold)">*</span></label>
                            <select class="form-select" name="passengerGender" required>
                                <option value="">Select</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                    </div>

                    <div class="modal-divider"></div>

                    <!-- Journey -->
                    <div class="modal-section-title">
                        <i class="fas fa-train" style="color:var(--aqua);font-size:0.65rem"></i>
                        Journey Details
                    </div>
                    <div class="row g-3 mb-4">
                        <div class="col-6">
                            <label class="field-label">Train Class <span style="color:var(--rose-gold)">*</span></label>
                            <select class="form-select" name="trainClass" required>
                                <option value="SL">Sleeper (SL)</option>
                                <option value="3A">AC 3 Tier (3A)</option>
                                <option value="2A">AC 2 Tier (2A)</option>
                                <option value="1A">AC First Class (1A)</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="field-label">Journey Date <span style="color:var(--rose-gold)">*</span></label>
                            <input type="date" class="form-control" name="journeyDate"
                                   value="${searchQuery.travelDate}" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-proceed">
                        <i class="fas fa-credit-card me-2"></i>Proceed to Book
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function bookTrain(eventId, trainName) {
        document.getElementById('eventId').value = eventId;
        document.getElementById('modalTitle').innerHTML =
            '<i class="fas fa-ticket-alt me-2" style="color:var(--aqua)"></i>Book  ' + trainName;
        new bootstrap.Modal(document.getElementById('bookingModal')).show();
    }
</script>
</body>
</html>
