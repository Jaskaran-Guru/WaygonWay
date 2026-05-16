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

        /*  Background Pattern  */
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
            font-size: 0.9rem; font-weight: 600;
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
            font-size: 0.9rem; font-weight: 700;
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
            font-size: 0.9rem; font-weight: 600;
            padding: 0.5rem 1.5rem;
            border-radius: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-nav-logout:hover {
            background: rgba(239, 68, 68, 0.2);
            transform: translateY(-2px);
        }

        /*  Page Container  */
        .container { position: relative; z-index: 1; padding-top: 2.5rem; padding-bottom: 3.5rem; }

        /*  Page Header  */
        .page-header {
            text-align: center;
            margin-bottom: 2.5rem;
            animation: fade-up 0.6s ease both;
        }

        .page-header .header-badge {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(135deg, rgba(212, 175, 55, 0.15), rgba(183, 110, 121, 0.15));
            border: 1px solid rgba(212, 175, 55, 0.3);
            color: var(--gold-light);
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            padding: 7px 18px;
            border-radius: 100px;
            margin-bottom: 18px;
        }

        .page-header .header-badge .dot {
            width: 7px; height: 7px;
            background: var(--gold);
            border-radius: 50%;
            animation: pulse-dot 2s ease-in-out infinite;
            box-shadow: 0 0 10px var(--gold);
        }

        @keyframes pulse-dot {
            0%, 100% { opacity: 1; transform: scale(1); }
            50%       { opacity: 0.6; transform: scale(0.8); }
        }

        .page-header h1 {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            font-size: clamp(2rem, 5vw, 2.8rem);
            color: var(--white);
            letter-spacing: -1px;
            margin-bottom: 10px;
        }

        .page-header h1 .accent {
            background: linear-gradient(135deg, var(--gold) 0%, var(--aqua) 50%, var(--gold-light) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .page-header p { color: var(--text-muted); font-size: 0.95rem; }

        @keyframes fade-up {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @keyframes fade-scale {
            from { opacity: 0; transform: translateY(20px) scale(0.97); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        /*  Glass Card Base  */
        .glass-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.08) 0%, rgba(255,255,255,0.04) 100%);
            border: 1px solid rgba(212, 175, 55, 0.2);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-radius: 28px;
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.05),
                0 28px 70px rgba(0,0,0,0.45),
                inset 0 1px 0 rgba(255,255,255,0.1);
        }

        /*  Search Card  */
        .search-card {
            padding: 2.8rem 3rem;
            animation: fade-scale 0.7s ease 0.1s both;
        }

        .search-card-header {
            text-align: center;
            margin-bottom: 2.2rem;
        }

        .search-card-header .icon-ring {
            width: 68px; height: 68px;
            border-radius: 20px;
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            display: flex; align-items: center; justify-content: center;
            font-size: 1.6rem; color: white;
            margin: 0 auto 1.2rem;
            box-shadow: 0 8px 28px rgba(50, 130, 184, 0.35);
        }

        .search-card-header h3 {
            font-family: 'Playfair Display', serif;
            font-weight: 700; font-size: 1.4rem;
            color: var(--white); margin-bottom: 6px;
        }

        .search-card-header p { color: var(--text-muted); font-size: 0.88rem; }

        /*  PNR Input  */
        .field-label {
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: var(--gold-light);
            padding-left: 6px;
            margin-bottom: 8px;
            display: block;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.08) !important;
            border: 1.5px solid rgba(212, 175, 55, 0.25) !important;
            border-radius: 16px !important;
            padding: 18px 24px !important;
            font-family: 'Inter', sans-serif !important;
            font-size: 1.5rem !important;
            font-weight: 700 !important;
            text-align: center;
            color: var(--white) !important;
            letter-spacing: 6px;
            transition: all 0.3s ease;
        }

        .form-control::placeholder {
            color: rgba(254, 246, 228, 0.3) !important;
            font-size: 1rem !important;
            letter-spacing: 1px;
            font-weight: 400 !important;
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.12) !important;
            border-color: var(--gold) !important;
            box-shadow: 0 0 0 4px rgba(212, 175, 55, 0.15) !important;
            outline: none;
        }

        .form-hint {
            color: rgba(254, 246, 228, 0.35);
            font-size: 0.78rem;
            text-align: center;
            margin-top: 8px;
        }

        /*  Search Button  */
        .btn-search {
            background: linear-gradient(135deg, var(--ocean) 0%, var(--aqua) 100%) !important;
            border: none !important;
            border-radius: 16px !important;
            padding: 18px !important;
            font-family: 'Inter', sans-serif !important;
            font-size: 1rem !important;
            font-weight: 700 !important;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: white !important;
            width: 100%;
            position: relative; overflow: hidden;
            transition: all 0.3s ease !important;
            box-shadow: 0 8px 30px rgba(50, 130, 184, 0.35);
        }

        .btn-search::before {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, transparent 60%);
            opacity: 0; transition: opacity 0.3s ease;
        }

        .btn-search:hover { transform: translateY(-3px) !important; box-shadow: 0 12px 40px rgba(50, 130, 184, 0.5) !important; }
        .btn-search:hover::before { opacity: 1; }
        .btn-search:active { transform: translateY(-1px) !important; }

        /*  Error Alert  */
        .alert-danger {
            background: rgba(239,68,68,0.1) !important;
            border: 1px solid rgba(239,68,68,0.28) !important;
            border-radius: 14px !important;
            color: #fca5a5 !important;
            font-size: 0.88rem;
            margin-top: 1.2rem;
            padding: 1rem 1.2rem;
        }

        /*  Status Card  */
        .status-card {
            padding: 2.2rem 2.5rem;
            margin-top: 1.6rem;
            animation: fade-scale 0.7s ease 0.15s both;
            position: relative;
            overflow: hidden;
        }

        .status-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
        }

        .status-confirmed::before {
            background: linear-gradient(90deg, transparent, #34d399, transparent);
        }

        .status-cancelled::before {
            background: linear-gradient(90deg, transparent, #f87171, transparent);
        }

        .status-waitlist::before {
            background: linear-gradient(90deg, transparent, var(--gold), transparent);
        }

        /*  Status Header  */
        .status-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 2rem; flex-wrap: wrap; gap: 12px;
        }

        .status-title {
            display: flex; align-items: center; gap: 14px;
        }

        .status-title .s-icon {
            width: 44px; height: 44px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem;
        }

        .s-icon.confirmed { background: rgba(52, 211, 153, 0.15); color: #6ee7b7; }
        .s-icon.cancelled { background: rgba(248, 113, 113, 0.15); color: #fca5a5; }

        .status-title h4 {
            font-family: 'Playfair Display', serif;
            font-weight: 700; font-size: 1.15rem;
            color: var(--white); margin: 0;
        }

        .status-title p {
            color: var(--text-muted); font-size: 0.82rem; margin: 0;
        }

        .badge-status {
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            font-size: 0.7rem;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            padding: 6px 18px;
            border-radius: 100px;
        }

        .badge-confirmed {
            background: rgba(52, 211, 153, 0.14);
            border: 1px solid rgba(52, 211, 153, 0.3);
            color: #6ee7b7;
        }

        .badge-cancelled {
            background: rgba(248, 113, 113, 0.14);
            border: 1px solid rgba(248, 113, 113, 0.3);
            color: #fca5a5;
        }

        /*  Detail Groups  */
        .detail-group-title {
            font-size: 0.68rem; font-weight: 700;
            letter-spacing: 1.5px; text-transform: uppercase;
            color: rgba(212, 175, 55, 0.6);
            margin-bottom: 12px;
            display: flex; align-items: center; gap: 8px;
        }

        .detail-group-title::after {
            content: '';
            flex: 1;
            height: 1px;
            background: linear-gradient(90deg, rgba(212,175,55,0.2), transparent);
        }

        .detail-item {
            display: flex; align-items: center; gap: 10px;
            font-size: 0.87rem; color: rgba(254, 246, 228, 0.65);
            margin-bottom: 10px;
        }

        .detail-item .d-dot {
            width: 26px; height: 26px; border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.65rem; flex-shrink: 0;
        }

        .d-dot.ocean  { background: rgba(50, 130, 184, 0.18);  color: var(--aqua); }
        .d-dot.gold   { background: rgba(212, 175, 55, 0.18);  color: var(--gold-light); }
        .d-dot.green  { background: rgba(52, 211, 153, 0.15);  color: #6ee7b7; }
        .d-dot.rose   { background: rgba(183, 110, 121, 0.18); color: #e8a4ae; }
        .d-dot.teal   { background: rgba(15, 76, 117, 0.35);   color: var(--aqua); }

        .detail-item strong { color: var(--white); }

        .status-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(212,175,55,0.2), transparent);
            margin: 1.5rem 0;
        }

        .meta-text { color: rgba(254, 246, 228, 0.35); font-size: 0.82rem; }

        /*  Action Buttons  */
        .btn-action-sm {
            display: inline-flex; align-items: center; gap: 7px;
            font-size: 0.8rem; font-weight: 600;
            padding: 8px 18px; border-radius: 10px;
            transition: all 0.25s ease; cursor: pointer;
            border: 1.5px solid; background: transparent;
            text-decoration: none;
        }

        .btn-action-sm.outline-ocean {
            border-color: rgba(50, 130, 184, 0.35); color: var(--aqua);
        }
        .btn-action-sm.outline-ocean:hover {
            background: rgba(50, 130, 184, 0.14); transform: translateY(-2px);
        }

        .btn-action-sm.outline-gold {
            border-color: rgba(212, 175, 55, 0.35); color: var(--gold-light);
        }
        .btn-action-sm.outline-gold:hover {
            background: rgba(212, 175, 55, 0.1); transform: translateY(-2px);
        }

        /*  Not Found  */
        .not-found-inner { text-align: center; padding: 2rem 1rem; }

        .not-found-icon {
            width: 72px; height: 72px;
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.22);
            border-radius: 20px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; color: #fca5a5;
            margin: 0 auto 1.2rem;
        }

        .not-found-inner h4 {
            font-family: 'Playfair Display', serif;
            font-weight: 700; color: #fca5a5;
            margin-bottom: 8px;
        }

        .not-found-inner p { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.4rem; }

        .alert-info-dark {
            background: rgba(50, 130, 184, 0.08);
            border: 1px solid rgba(50, 130, 184, 0.22);
            border-radius: 14px;
            padding: 1.2rem 1.4rem;
            text-align: left;
        }

        .alert-info-dark h6 {
            font-family: 'Inter', sans-serif;
            font-weight: 700; color: var(--aqua);
            font-size: 0.85rem; margin-bottom: 12px;
        }

        .check-item {
            display: flex; align-items: center; gap: 9px;
            font-size: 0.84rem; color: rgba(254, 246, 228, 0.5);
            margin-bottom: 8px;
        }

        .check-item:last-child { margin-bottom: 0; }

        .check-item .ci-dot {
            width: 20px; height: 20px; border-radius: 50%;
            background: rgba(50, 130, 184, 0.18);
            display: flex; align-items: center; justify-content: center;
            color: var(--aqua); font-size: 0.55rem; flex-shrink: 0;
        }

        /*  Help Card  */
        .help-card {
            padding: 2rem 2.5rem;
            margin-top: 1.6rem;
            animation: fade-scale 0.7s ease 0.25s both;
        }

        .help-heading {
            display: flex; align-items: center; gap: 12px;
            margin-bottom: 1.8rem;
        }

        .help-heading .h-icon {
            width: 38px; height: 38px; border-radius: 11px;
            background: linear-gradient(135deg, rgba(212,175,55,0.2), rgba(183,110,121,0.2));
            border: 1px solid rgba(212,175,55,0.2);
            display: flex; align-items: center; justify-content: center;
            color: var(--gold-light); font-size: 0.9rem;
        }

        .help-heading h5 {
            font-family: 'Playfair Display', serif;
            font-weight: 700; color: var(--white);
            font-size: 1.05rem; margin: 0;
        }

        .help-section-title {
            font-size: 0.68rem; font-weight: 700;
            letter-spacing: 1.5px; text-transform: uppercase;
            color: rgba(212, 175, 55, 0.6);
            margin-bottom: 12px;
            display: flex; align-items: center; gap: 8px;
        }

        .help-section-title::after {
            content: '';
            flex: 1; height: 1px;
            background: linear-gradient(90deg, rgba(212,175,55,0.2), transparent);
        }

        .help-item {
            display: flex; align-items: center; gap: 10px;
            font-size: 0.86rem; color: rgba(254, 246, 228, 0.55);
            margin-bottom: 10px;
        }

        .help-item .h-dot {
            width: 28px; height: 28px; border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.68rem; flex-shrink: 0;
        }

        .h-dot.ocean  { background: rgba(50, 130, 184, 0.18); color: var(--aqua); }
        .h-dot.green  { background: rgba(52, 211, 153, 0.15); color: #6ee7b7; }
        .h-dot.gold   { background: rgba(212, 175, 55, 0.18); color: var(--gold-light); }
        .h-dot.rose   { background: rgba(183, 110, 121, 0.2); color: #e8a4ae; }

        .help-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(212,175,55,0.2), transparent);
            margin: 1.4rem 0;
        }

        .btn-sample {
            background: rgba(212, 175, 55, 0.08) !important;
            border: 1.5px solid rgba(212, 175, 55, 0.25) !important;
            border-radius: 12px !important;
            padding: 12px 16px !important;
            font-family: 'Inter', sans-serif;
            font-weight: 600; font-size: 0.88rem;
            color: var(--gold-light) !important;
            transition: all 0.25s ease; width: 100%;
        }

        .btn-sample:hover {
            background: rgba(212, 175, 55, 0.15) !important;
            border-color: rgba(212, 175, 55, 0.5) !important;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(212, 175, 55, 0.15);
        }

        .help-note {
            color: rgba(254, 246, 228, 0.3);
            font-size: 0.77rem; margin-top: 8px;
        }

        /*  Responsive  */
        @media (max-width: 768px) {
            .search-card, .help-card { padding: 2rem 1.8rem; }
            .status-card { padding: 1.8rem 1.6rem; }
        }

        @media (max-width: 576px) {
            .search-card, .help-card { padding: 1.5rem 1.2rem; }
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

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <!-- Page Header -->
            <div class="page-header">
                <div class="header-badge">
                    <span class="dot"></span>
                    Live Booking Lookup
                </div>
                <h1>PNR <span class="accent">Status</span></h1>
                <p>Check your booking status instantly, anytime</p>
            </div>

            <!-- Search Card -->
            <div class="glass-card search-card">
                <div class="search-card-header">
                    <div class="icon-ring"><i class="fas fa-ticket-alt"></i></div>
                    <h3>Enter PNR Number</h3>
                    <p>Enter your 10-digit PNR number to check booking status</p>
                </div>

                <form action="/pnr-status" method="post">
                    <div class="mb-4">
                        <label class="field-label">
                            <i class="fas fa-hashtag me-1"></i>PNR Number
                        </label>
                        <input type="text" class="form-control form-control-lg" name="pnr"
                               placeholder="Enter PNR Number" maxlength="10" pattern="[0-9]{10}"
                               value="${searchedPNR}" required>
                        <div class="form-hint">
                            <i class="fas fa-info-circle me-1"></i>PNR is a 10-digit numeric code printed on your ticket
                        </div>
                    </div>

                    <button type="submit" class="btn btn-search">
                        <i class="fas fa-search me-2"></i>Check Status
                    </button>
                </form>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger mt-3">
                        <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                    </div>
                </c:if>
            </div>

            <!--  PNR Found  -->
            <c:if test="${pnrFound == true}">
                <div class="glass-card status-card status-confirmed">
                    <div class="status-header">
                        <div class="status-title">
                            <div class="s-icon confirmed"><i class="fas fa-check-circle"></i></div>
                            <div>
                                <h4>Booking Confirmed</h4>
                                <p>PNR: <strong style="color:var(--white)">${searchedPNR}</strong></p>
                            </div>
                        </div>
                        <span class="badge-status badge-confirmed">CONFIRMED</span>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-4 mb-md-0">
                            <div class="detail-group-title">Train Details</div>
                            <div class="detail-item">
                                <span class="d-dot ocean"><i class="fas fa-train"></i></span>
                                <strong>${booking.trainName}</strong>
                            </div>
                            <div class="detail-item">
                                <span class="d-dot ocean"><i class="fas fa-hashtag"></i></span>
                                Train No: ${booking.trainCode}
                            </div>
                            <div class="detail-item">
                                <span class="d-dot ocean"><i class="fas fa-route"></i></span>
                                ${booking.source}  ${booking.destination}
                            </div>

                            <div class="detail-group-title mt-3">Journey Details</div>
                            <div class="detail-item">
                                <span class="d-dot gold"><i class="fas fa-calendar"></i></span>
                                Date: ${booking.journeyDate}
                            </div>
                            <div class="detail-item">
                                <span class="d-dot gold"><i class="fas fa-clock"></i></span>
                                Departure: 08:00 AM
                            </div>
                            <div class="detail-item">
                                <span class="d-dot gold"><i class="fas fa-map-marker-alt"></i></span>
                                Platform: TBD
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="detail-group-title">Passenger Details</div>
                            <div class="detail-item">
                                <span class="d-dot green"><i class="fas fa-user"></i></span>
                                Name: <strong>${booking.passengerName}</strong>
                            </div>
                            <div class="detail-item">
                                <span class="d-dot green"><i class="fas fa-id-card"></i></span>
                                Age: ${booking.passengerAge}
                            </div>
                            <div class="detail-item">
                                <span class="d-dot green"><i class="fas fa-venus-mars"></i></span>
                                Gender: ${booking.passengerGender}
                            </div>

                            <div class="detail-group-title mt-3">Seat Details</div>
                            <div class="detail-item">
                                <span class="d-dot teal"><i class="fas fa-chair"></i></span>
                                Class: ${booking.trainClass}
                            </div>
                            <div class="detail-item">
                                <span class="d-dot teal"><i class="fas fa-credit-card"></i></span>
                                Fare: <strong style="color:#6ee7b7">${booking.totalAmount}</strong>
                            </div>
                            <div class="detail-item">
                                <span class="d-dot teal"><i class="fas fa-bed"></i></span>
                                Seat: S4/42 (Confirmed)
                            </div>
                        </div>
                    </div>

                    <div class="status-divider"></div>

                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
                        <span class="meta-text">
                            <i class="fas fa-calendar-check me-2"></i>Booked on: ${booking.bookingDate}
                        </span>
                        <div class="d-flex gap-2">
                            <button class="btn-action-sm outline-ocean" onclick="printTicket()">
                                <i class="fas fa-print"></i>Print
                            </button>
                            <button class="btn-action-sm outline-gold" onclick="downloadTicket()">
                                <i class="fas fa-download"></i>Download
                            </button>
                        </div>
                    </div>
                </div>
            </c:if>

            <!--  PNR Not Found  -->
            <c:if test="${pnrFound == false && not empty searchedPNR}">
                <div class="glass-card status-card status-cancelled">
                    <div class="not-found-inner">
                        <div class="not-found-icon"><i class="fas fa-times-circle"></i></div>
                        <h4>PNR Not Found</h4>
                        <p>No booking found with PNR: <strong style="color:var(--white)">${searchedPNR}</strong></p>

                        <div class="alert-info-dark">
                            <h6><i class="fas fa-info-circle me-2"></i>Please check the following:</h6>
                            <div class="check-item">
                                <span class="ci-dot"><i class="fas fa-circle"></i></span>
                                PNR number is entered correctly (10 digits)
                            </div>
                            <div class="check-item">
                                <span class="ci-dot"><i class="fas fa-circle"></i></span>
                                Booking was made through WaygonWay
                            </div>
                            <div class="check-item">
                                <span class="ci-dot"><i class="fas fa-circle"></i></span>
                                PNR is not older than 4 months
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Help Card -->
            <div class="glass-card help-card">
                <div class="help-heading">
                    <div class="h-icon"><i class="fas fa-question-circle"></i></div>
                    <h5>Need help finding your PNR?</h5>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-4 mb-md-0">
                        <div class="help-section-title">Where to find PNR</div>
                        <div class="help-item">
                            <span class="h-dot ocean"><i class="fas fa-envelope"></i></span>
                            Booking confirmation email
                        </div>
                        <div class="help-item">
                            <span class="h-dot green"><i class="fas fa-sms"></i></span>
                            SMS confirmation message
                        </div>
                        <div class="help-item">
                            <span class="h-dot gold"><i class="fas fa-ticket-alt"></i></span>
                            Printed or e-ticket
                        </div>
                        <div class="help-item">
                            <span class="h-dot rose"><i class="fas fa-mobile-alt"></i></span>
                            WaygonWay app booking history
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="help-section-title">Try a demo PNR</div>
                        <button class="btn btn-sample" onclick="fillSamplePNR('1234567890')">
                            <i class="fas fa-vial me-2"></i>Sample PNR: 1234567890
                        </button>
                        <p class="help-note">
                            <i class="fas fa-info-circle me-1"></i>Use this to test the PNR status lookup feature
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.querySelector('input[name="pnr"]').addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    function fillSamplePNR(pnr) {
        document.querySelector('input[name="pnr"]').value = pnr;
        document.querySelector('input[name="pnr"]').focus();
    }

    function printTicket() { window.print(); }

    function downloadTicket() {
        alert('Ticket download feature will be implemented soon!');
    }

    document.addEventListener('DOMContentLoaded', function() {
        document.querySelector('input[name="pnr"]').focus();
    });
</script>
</body>
</html>
