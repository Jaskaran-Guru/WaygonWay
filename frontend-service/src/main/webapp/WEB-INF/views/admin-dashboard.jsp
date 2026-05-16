<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - WaygonWay</title>
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
            --violet: #8b5cf6;
            --violet-light: #a78bfa;
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
            padding-top: 85px;
            position: relative;
        }

        /*  Background Effects  */
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background:
                radial-gradient(circle at 25% 15%, rgba(212, 175, 55, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 75% 75%, rgba(50, 130, 184, 0.15) 0%, transparent 50%),
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

        /*  Cards  */
        .admin-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.08) 0%, rgba(255, 255, 255, 0.04) 100%);
            border: 1px solid rgba(212, 175, 55, 0.2);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-radius: 28px;
            padding: 2.8rem 3rem;
            margin-bottom: 2rem;
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.05),
                0 30px 90px rgba(0, 0, 0, 0.5),
                inset 0 1px 0 rgba(255,255,255,0.1);
            animation: fade-up 0.7s ease both;
        }

        .admin-card:nth-child(2) { animation-delay: 0.15s; }
        .admin-card:nth-child(3) { animation-delay: 0.25s; }

        @keyframes fade-up {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /*  Card Heading  */
        .card-heading {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 1.7rem;
            color: var(--white);
            margin-bottom: 2.2rem;
            display: flex;
            align-items: center;
            gap: 16px;
            letter-spacing: -0.5px;
        }

        .card-heading .heading-icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--deep-plum);
            font-size: 1.2rem;
            flex-shrink: 0;
            box-shadow: 0 8px 25px rgba(212, 175, 55, 0.3);
        }

        .card-heading .heading-icon.blue {
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            color: white;
            box-shadow: 0 8px 25px rgba(50, 130, 184, 0.3);
        }

        .card-heading-subtitle {
            font-family: 'Inter', sans-serif;
            font-size: 0.85rem;
            font-weight: 400;
            color: rgba(254, 246, 228, 0.55);
            margin-top: 4px;
            letter-spacing: 0.3px;
        }

        /*  Stat Cards  */
        .stat-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.06), rgba(255, 255, 255, 0.03));
            border: 1.5px solid var(--glass-border);
            border-radius: 20px;
            padding: 2rem 1.8rem;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
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

        /* Individual stat colors */
        .stat-card.stat-users {
            border-color: rgba(77, 168, 218, 0.3);
            background: linear-gradient(135deg, rgba(77, 168, 218, 0.08), rgba(50, 130, 184, 0.04));
        }
        .stat-card.stat-users .stat-icon-wrap {
            background: linear-gradient(135deg, rgba(77, 168, 218, 0.2), rgba(50, 130, 184, 0.15));
            color: var(--aqua);
            box-shadow: 0 8px 20px rgba(77, 168, 218, 0.2);
        }

        .stat-card.stat-trains {
            border-color: rgba(212, 175, 55, 0.3);
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.08), rgba(244, 208, 63, 0.04));
        }
        .stat-card.stat-trains .stat-icon-wrap {
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.2), rgba(244, 208, 63, 0.15));
            color: var(--gold-light);
            box-shadow: 0 8px 20px rgba(212, 175, 55, 0.25);
        }

        .stat-card.stat-bookings {
            border-color: rgba(16, 185, 129, 0.3);
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.08), rgba(52, 211, 153, 0.04));
        }
        .stat-card.stat-bookings .stat-icon-wrap {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.2), rgba(52, 211, 153, 0.15));
            color: var(--emerald-light);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.25);
        }

        .stat-card.stat-revenue {
            border-color: rgba(139, 92, 246, 0.3);
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.08), rgba(167, 139, 250, 0.04));
        }
        .stat-card.stat-revenue .stat-icon-wrap {
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.2), rgba(167, 139, 250, 0.15));
            color: var(--violet-light);
            box-shadow: 0 8px 20px rgba(139, 92, 246, 0.25);
        }

        .stat-icon-wrap {
            width: 64px;
            height: 64px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            margin: 0 auto 1.2rem;
            transition: transform 0.3s ease;
        }

        .stat-card:hover .stat-icon-wrap {
            transform: scale(1.1) rotate(5deg);
        }

        .stat-value {
            font-family: 'Playfair Display', serif;
            font-size: 2.4rem;
            font-weight: 800;
            color: var(--white);
            line-height: 1;
            margin-bottom: 8px;
            letter-spacing: -1px;
        }

        .stat-label {
            font-size: 0.8rem;
            color: rgba(254, 246, 228, 0.6);
            font-weight: 500;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        /*  Action Buttons  */
        .btn-admin {
            background: linear-gradient(135deg, var(--ocean) 0%, var(--aqua) 100%);
            border: none;
            border-radius: 14px !important;
            padding: 15px 24px !important;
            font-family: 'Inter', sans-serif;
            font-weight: 600;
            font-size: 0.95rem;
            color: white !important;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(50, 130, 184, 0.3);
        }

        .btn-admin::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.2), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .btn-admin::after {
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

        .btn-admin:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(50, 130, 184, 0.45);
        }

        .btn-admin:hover::before { opacity: 1; }

        .btn-admin:active::after {
            width: 300px;
            height: 300px;
        }

        .btn-outline-primary {
            background: transparent !important;
            border: 1.5px solid rgba(77, 168, 218, 0.4) !important;
            border-radius: 14px !important;
            padding: 15px 24px !important;
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--aqua) !important;
            transition: all 0.3s ease;
        }

        .btn-outline-primary:hover {
            background: rgba(77, 168, 218, 0.15) !important;
            border-color: var(--aqua) !important;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(77, 168, 218, 0.25);
        }

        .btn-outline-success {
            background: transparent !important;
            border: 1.5px solid rgba(16, 185, 129, 0.4) !important;
            border-radius: 14px !important;
            padding: 15px 24px !important;
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--emerald-light) !important;
            transition: all 0.3s ease;
        }

        .btn-outline-success:hover {
            background: rgba(16, 185, 129, 0.15) !important;
            border-color: var(--emerald) !important;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.25);
        }

        /*  Section Divider  */
        .section-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(212, 175, 55, 0.3), transparent);
            margin: 2rem 0 2.5rem;
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
            width: 350px; height: 350px;
            background: radial-gradient(circle, rgba(212, 175, 55, 0.12), transparent);
            top: 15%; left: 15%;
            animation-duration: 13s;
        }

        .shape:nth-child(2) {
            width: 450px; height: 450px;
            background: radial-gradient(circle, rgba(50, 130, 184, 0.15), transparent);
            top: 55%; left: 65%;
            animation-duration: 15s;
            animation-delay: 3s;
        }

        @keyframes float-orb {
            0%, 100% { transform: translate(0, 0) scale(1); }
            33% { transform: translate(30px, -40px) scale(1.1); }
            66% { transform: translate(-40px, 20px) scale(0.9); }
        }

        /*  Responsive  */
        @media (max-width: 768px) {
            .admin-card { padding: 2rem 1.8rem; }
            .container { padding-top: 2rem; }
            .card-heading { font-size: 1.4rem; }
            .stat-value { font-size: 2rem; }
        }

        @media (max-width: 576px) {
            .admin-card { padding: 1.5rem 1.2rem; }
        }
    </style>
</head>
<body>
<div class="floating-shapes">
    <div class="shape"></div>
    <div class="shape"></div>
</div>

<nav class="navbar navbar-expand-lg fixed-top">
    <div class="container">
        <a class="navbar-brand" href="/">
            <span class="brand-icon"><i class="fas fa-train"></i></span>
            WaygonWay
        </a>
        <div class="navbar-nav ms-auto d-flex align-items-center gap-2">
            <a class="nav-link" href="/admin/create-demo-data">Demo Data</a>
            <a class="btn-logout" href="/logout">Logout</a>
        </div>
    </div>
</nav>

<div class="container">

    <!-- Stats Section -->
    <div class="admin-card">
        <div class="card-heading">
            <div class="heading-icon">
                <i class="fas fa-crown"></i>
            </div>
            <div>
                <div>Admin Dashboard</div>
                <div class="card-heading-subtitle">Overview &amp; Statistics</div>
            </div>
        </div>
        <div class="row g-4">
            <div class="col-md-3">
                <div class="stat-card stat-users">
                    <div class="stat-icon-wrap"><i class="fas fa-users"></i></div>
                    <div class="stat-value">150</div>
                    <div class="stat-label">Total Users</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-trains">
                    <div class="stat-icon-wrap"><i class="fas fa-train"></i></div>
                    <div class="stat-value">25</div>
                    <div class="stat-label">Total Trains</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-bookings">
                    <div class="stat-icon-wrap"><i class="fas fa-ticket-alt"></i></div>
                    <div class="stat-value">89</div>
                    <div class="stat-label">Bookings Today</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-revenue">
                    <div class="stat-icon-wrap"><i class="fas fa-rupee-sign"></i></div>
                    <div class="stat-value">45,000</div>
                    <div class="stat-label">Revenue Today</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="admin-card">
        <div class="card-heading">
            <div class="heading-icon blue">
                <i class="fas fa-tools"></i>
            </div>
            <div>
                <div>Quick Actions</div>
                <div class="card-heading-subtitle">Manage your platform</div>
            </div>
        </div>
        <div class="section-divider"></div>
        <div class="row g-4">
            <div class="col-md-4">
                <a href="/admin/create-demo-data" class="btn btn-admin w-100">
                    <i class="fas fa-plus me-2"></i>Create Demo Data
                </a>
            </div>
            <div class="col-md-4">
                <button class="btn btn-outline-primary w-100" onclick="exportData()">
                    <i class="fas fa-download me-2"></i>Export Data
                </button>
            </div>
            <div class="col-md-4">
                <button class="btn btn-outline-success w-100" onclick="viewReports()">
                    <i class="fas fa-chart-bar me-2"></i>View Reports
                </button>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function exportData() { alert('Data export started!'); }
    function viewReports() { window.location.href = '/admin/reports'; }
</script>
</body>
</html>
