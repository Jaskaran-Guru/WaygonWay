<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - WaygonWay</title>
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

        /*  Background Pattern  */
        body::before {
            content: '';
            position: fixed; inset: 0;
            background:
                radial-gradient(circle at 20% 20%, rgba(212, 175, 55, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(50, 130, 184, 0.12) 0%, transparent 50%),
                radial-gradient(circle at 50% 50%, rgba(45, 27, 78, 0.6) 0%, transparent 100%);
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

        .shape {
            position: absolute; border-radius: 50%;
            filter: blur(80px);
            animation: float-orb 12s ease-in-out infinite;
        }

        .shape:nth-child(1) {
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(212, 175, 55, 0.15), transparent);
            top: 5%; left: 5%; animation-duration: 14s;
        }

        .shape:nth-child(2) {
            width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(50, 130, 184, 0.18), transparent);
            top: 55%; left: 65%; animation-duration: 16s; animation-delay: 3s;
        }

        .shape:nth-child(3) {
            width: 280px; height: 280px;
            background: radial-gradient(circle, rgba(183, 110, 121, 0.12), transparent);
            top: 70%; left: 15%; animation-duration: 13s; animation-delay: 2s;
        }

        @keyframes float-orb {
            0%, 100% { transform: translate(0, 0) scale(1); }
            33%       { transform: translate(30px, -40px) scale(1.1); }
            66%       { transform: translate(-40px, 20px) scale(0.9); }
        }

        /*  Navbar  */
        .navbar {
            background: rgba(26, 11, 46, 0.85);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-bottom: 1px solid rgba(212, 175, 55, 0.2);
            padding: 1rem 0;
            position: fixed; top: 0; left: 0; right: 0;
            z-index: 1000;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-family: 'Playfair Display', serif;
            font-weight: 800; font-size: 1.7rem !important;
            color: var(--white) !important; letter-spacing: -0.5px;
            display: flex; align-items: center; gap: 10px;
        }

        .navbar-brand .brand-icon {
            width: 40px; height: 40px;
            background: linear-gradient(135deg, var(--gold) 0%, var(--rose-gold) 100%);
            border-radius: 12px;
            display: inline-flex; align-items: center; justify-content: center;
            color: var(--deep-plum); font-size: 1.1rem;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
        }

        .nav-link {
            color: rgba(255,255,255,0.75) !important;
            font-weight: 500; font-size: 0.95rem; letter-spacing: 0.3px;
            padding: 0.5rem 1rem !important; border-radius: 10px;
            transition: all 0.3s ease; position: relative;
        }

        .nav-link::before {
            content: ''; position: absolute;
            bottom: 0; left: 50%; width: 0; height: 2px;
            background: linear-gradient(90deg, var(--gold), var(--gold-light));
            transform: translateX(-50%); transition: width 0.3s ease;
        }

        .nav-link:hover { color: var(--gold-light) !important; }
        .nav-link:hover::before { width: 70%; }

        .btn-nav-logout {
            background: rgba(239, 68, 68, 0.12);
            border: 1.5px solid rgba(239, 68, 68, 0.3);
            color: #fca5a5 !important; font-size: 0.9rem; font-weight: 600;
            padding: 0.5rem 1.5rem; border-radius: 10px;
            transition: all 0.3s ease; text-decoration: none;
        }

        .btn-nav-logout:hover { background: rgba(239, 68, 68, 0.2); transform: translateY(-2px); }

        /*  Page Container  */
        .container { position: relative; z-index: 1; padding-top: 2.5rem; padding-bottom: 3.5rem; }

        /*  Animations  */
        @keyframes fade-up {
            from { opacity: 0; transform: translateY(24px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @keyframes fade-scale {
            from { opacity: 0; transform: translateY(24px) scale(0.97); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        /*  Page Header  */
        .page-header {
            text-align: center; margin-bottom: 2.5rem;
            animation: fade-up 0.6s ease both;
        }

        .page-header .header-badge {
            display: inline-flex; align-items: center; gap: 10px;
            background: linear-gradient(135deg, rgba(212,175,55,0.15), rgba(183,110,121,0.15));
            border: 1px solid rgba(212,175,55,0.3);
            color: var(--gold-light); font-size: 0.72rem; font-weight: 700;
            letter-spacing: 2px; text-transform: uppercase;
            padding: 7px 18px; border-radius: 100px; margin-bottom: 18px;
        }

        .page-header .header-badge .dot {
            width: 7px; height: 7px; background: var(--gold); border-radius: 50%;
            animation: pulse-dot 2s ease-in-out infinite;
            box-shadow: 0 0 10px var(--gold);
        }

        @keyframes pulse-dot {
            0%, 100% { opacity: 1; transform: scale(1); }
            50%       { opacity: 0.6; transform: scale(0.8); }
        }

        .page-header h1 {
            font-family: 'Playfair Display', serif;
            font-weight: 800; font-size: clamp(2rem, 5vw, 2.8rem);
            color: var(--white); letter-spacing: -1px; margin-bottom: 10px;
        }

        .page-header h1 .accent {
            background: linear-gradient(135deg, var(--gold) 0%, var(--aqua) 50%, var(--gold-light) 100%);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
        }

        .page-header p { color: var(--text-muted); font-size: 0.95rem; }

        /*  Avatar Block  */
        .avatar-block {
            display: flex; flex-direction: column; align-items: center;
            margin-bottom: 2.5rem;
            animation: fade-scale 0.7s ease 0.05s both;
        }

        .avatar-ring {
            width: 88px; height: 88px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            display: flex; align-items: center; justify-content: center;
            font-size: 2.2rem; color: white;
            box-shadow:
                0 0 0 4px rgba(50, 130, 184, 0.2),
                0 0 0 8px rgba(50, 130, 184, 0.08),
                0 12px 35px rgba(50, 130, 184, 0.35);
            margin-bottom: 1rem;
            position: relative;
        }

        .avatar-ring::after {
            content: '';
            position: absolute; inset: -4px;
            border-radius: 50%;
            background: conic-gradient(var(--gold), var(--aqua), var(--rose-gold), var(--gold));
            z-index: -1; opacity: 0.5;
            animation: spin-ring 8s linear infinite;
        }

        @keyframes spin-ring {
            from { transform: rotate(0deg); }
            to   { transform: rotate(360deg); }
        }

        .avatar-name {
            font-family: 'Playfair Display', serif;
            font-weight: 700; font-size: 1.2rem;
            color: var(--white); margin-bottom: 4px;
        }

        .avatar-username {
            font-size: 0.82rem; color: var(--text-muted);
            background: rgba(212, 175, 55, 0.1);
            border: 1px solid rgba(212, 175, 55, 0.2);
            padding: 3px 14px; border-radius: 100px;
        }

        /*  Profile Card  */
        .profile-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.08) 0%, rgba(255,255,255,0.04) 100%);
            border: 1px solid rgba(212, 175, 55, 0.2);
            backdrop-filter: blur(30px); -webkit-backdrop-filter: blur(30px);
            border-radius: 28px; padding: 2.8rem 3rem;
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.05),
                0 30px 80px rgba(0,0,0,0.45),
                inset 0 1px 0 rgba(255,255,255,0.1);
            animation: fade-scale 0.8s ease 0.1s both;
        }

        /*  Section Title  */
        .section-title {
            font-size: 0.68rem; font-weight: 700;
            letter-spacing: 1.5px; text-transform: uppercase;
            color: rgba(212, 175, 55, 0.7);
            margin-bottom: 1.2rem;
            display: flex; align-items: center; gap: 10px;
        }

        .section-title::after {
            content: ''; flex: 1; height: 1px;
            background: linear-gradient(90deg, rgba(212,175,55,0.25), transparent);
        }

        .section-title .st-icon {
            width: 24px; height: 24px; border-radius: 7px;
            background: rgba(212,175,55,0.15);
            display: flex; align-items: center; justify-content: center;
            color: var(--gold-light); font-size: 0.6rem;
        }

        /*  Form Fields  */
        .field-group { display: flex; flex-direction: column; gap: 7px; }

        .field-label {
            font-size: 0.7rem; font-weight: 700;
            letter-spacing: 1.5px; text-transform: uppercase;
            color: var(--gold-light); padding-left: 4px;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.07) !important;
            border: 1.5px solid rgba(212, 175, 55, 0.22) !important;
            border-radius: 14px !important;
            padding: 14px 18px !important;
            color: var(--white) !important;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem !important;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .form-control::placeholder { color: rgba(254, 246, 228, 0.3) !important; font-weight: 400; }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.11) !important;
            border-color: var(--gold) !important;
            box-shadow: 0 0 0 4px rgba(212, 175, 55, 0.14) !important;
            outline: none;
        }

        .form-control[readonly] {
            background: rgba(255, 255, 255, 0.04) !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
            color: rgba(254, 246, 228, 0.4) !important;
            cursor: not-allowed;
        }

        .readonly-hint {
            font-size: 0.72rem; color: rgba(254,246,228,0.3);
            padding-left: 4px; margin-top: 2px;
        }

        /*  Divider  */
        .form-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(212,175,55,0.2), transparent);
            margin: 2rem 0;
        }

        /*  Submit Button  */
        .btn-update {
            background: linear-gradient(135deg, var(--ocean) 0%, var(--aqua) 100%);
            border: none; border-radius: 14px !important;
            padding: 16px 48px !important;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem !important; font-weight: 700;
            letter-spacing: 1.5px; text-transform: uppercase;
            color: white !important;
            position: relative; overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 8px 28px rgba(50, 130, 184, 0.35);
        }

        .btn-update::before {
            content: ''; position: absolute; inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, transparent 60%);
            opacity: 0; transition: opacity 0.3s ease;
        }

        .btn-update:hover { transform: translateY(-3px); box-shadow: 0 12px 40px rgba(50, 130, 184, 0.5); }
        .btn-update:hover::before { opacity: 1; }
        .btn-update:active { transform: translateY(-1px); }

        /*  Success / Error Alerts  */
        .alert-success-dark {
            background: rgba(52, 211, 153, 0.1);
            border: 1px solid rgba(52, 211, 153, 0.28);
            border-radius: 14px; color: #6ee7b7;
            font-size: 0.88rem; padding: 1rem 1.2rem;
            margin-bottom: 1.5rem;
        }

        .alert-danger-dark {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.28);
            border-radius: 14px; color: #fca5a5;
            font-size: 0.88rem; padding: 1rem 1.2rem;
            margin-bottom: 1.5rem;
        }

        /*  Input Icon Wrapper  */
        .input-icon-wrap { position: relative; }

        .input-icon-wrap .i-icon {
            position: absolute; left: 16px; top: 50%; transform: translateY(-50%);
            color: rgba(212, 175, 55, 0.5); font-size: 0.75rem; pointer-events: none;
        }

        .input-icon-wrap .form-control { padding-left: 40px !important; }

        /*  Responsive  */
        @media (max-width: 768px) {
            .profile-card { padding: 2rem 1.8rem; }
        }

        @media (max-width: 576px) {
            .profile-card { padding: 1.5rem 1.2rem; }
            .navbar-brand { font-size: 1.4rem !important; }
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
                <a class="nav-link" href="/dashboard">Dashboard</a>
                <a class="nav-link" href="/my-bookings">My Bookings</a>
                <a class="btn-nav-logout" href="/logout">Logout</a>
            </div>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <!-- Page Header -->
            <div class="page-header">
                <div class="header-badge">
                    <span class="dot"></span>
                    Account Settings
                </div>
                <h1>My <span class="accent">Profile</span></h1>
                <p>Manage your personal information and account details</p>
            </div>

            <!-- Avatar Block -->
            <div class="avatar-block">
                <div class="avatar-ring">
                    <i class="fas fa-user"></i>
                </div>
                <div class="avatar-name">${user.firstName} ${user.lastName}</div>
                <div class="avatar-username">@${user.username}</div>
            </div>

            <!-- Success / Error Messages -->
            <c:if test="${not empty successMessage}">
                <div class="alert-success-dark mb-4">
                    <i class="fas fa-check-circle me-2"></i>${successMessage}
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert-danger-dark mb-4">
                    <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                </div>
            </c:if>

            <!-- Profile Card -->
            <div class="profile-card">
                <form action="/profile/update" method="post">

                    <!-- Personal Info -->
                    <div class="section-title">
                        <span class="st-icon"><i class="fas fa-user"></i></span>
                        Personal Information
                    </div>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">First Name</span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-user"></i>
                                    <input type="text" class="form-control" name="firstName"
                                           value="${user.firstName}" placeholder="Your first name" required>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">Last Name</span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-user"></i>
                                    <input type="text" class="form-control" name="lastName"
                                           value="${user.lastName}" placeholder="Your last name" required>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-divider"></div>

                    <!-- Contact Info -->
                    <div class="section-title">
                        <span class="st-icon"><i class="fas fa-envelope"></i></span>
                        Contact Details
                    </div>
                    <div class="row g-3 mb-4">
                        <div class="col-12">
                            <div class="field-group">
                                <span class="field-label">Email Address</span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-envelope"></i>
                                    <input type="email" class="form-control" name="email"
                                           value="${user.email}" placeholder="your@email.com" required>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">Phone Number</span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-phone"></i>
                                    <input type="tel" class="form-control" name="phone"
                                           value="${user.phone}" placeholder="+91 00000 00000">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">Username</span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-at"></i>
                                    <input type="text" class="form-control" name="username"
                                           value="${user.username}" readonly>
                                </div>
                                <span class="readonly-hint"><i class="fas fa-lock me-1"></i>Username cannot be changed</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-divider"></div>

                    <!-- Location -->
                    <div class="section-title">
                        <span class="st-icon"><i class="fas fa-map-marker-alt"></i></span>
                        Location
                    </div>
                    <div class="row g-3 mb-2">
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">City</span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-city"></i>
                                    <input type="text" class="form-control" name="city"
                                           value="${user.city}" placeholder="Your city">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">State</span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-map"></i>
                                    <input type="text" class="form-control" name="state"
                                           value="${user.state}" placeholder="Your state">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Submit -->
                    <div class="text-center mt-4 pt-2">
                        <button type="submit" class="btn btn-update">
                            <i class="fas fa-save me-2"></i>Save Changes
                        </button>
                    </div>

                </form>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
