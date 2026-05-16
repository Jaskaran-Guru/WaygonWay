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
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        /*  Background Effects  */
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background:
                radial-gradient(ellipse 80% 60% at 25% 15%, rgba(212, 175, 55, 0.12) 0%, transparent 60%),
                radial-gradient(ellipse 60% 75% at 75% 80%, rgba(50, 130, 184, 0.15) 0%, transparent 55%),
                radial-gradient(ellipse 50% 50% at 50% 50%, rgba(45, 27, 78, 0.65) 0%, transparent 100%);
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
        .orb {
            position: fixed;
            border-radius: 50%;
            filter: blur(80px);
            pointer-events: none;
            z-index: 0;
            animation: orb-float 10s ease-in-out infinite;
        }

        .orb-1 {
            width: 350px; height: 350px;
            background: radial-gradient(circle, rgba(212, 175, 55, 0.15), transparent);
            top: 10%; left: 10%;
            animation-duration: 12s;
        }

        .orb-2 {
            width: 420px; height: 420px;
            background: radial-gradient(circle, rgba(50, 130, 184, 0.18), transparent);
            bottom: 10%; right: 10%;
            animation-duration: 14s;
            animation-delay: 2s;
        }

        .orb-3 {
            width: 250px; height: 250px;
            background: radial-gradient(circle, rgba(183, 110, 121, 0.12), transparent);
            top: 60%; left: 8%;
            animation-duration: 11s;
            animation-delay: 1s;
        }

        @keyframes orb-float {
            0%, 100% { transform: translate(0, 0) scale(1); }
            33% { transform: translate(30px, -35px) scale(1.08); }
            66% { transform: translate(-35px, 25px) scale(0.92); }
        }

        /*  Container  */
        .container { position: relative; z-index: 1; }

        /*  Login Card  */
        .login-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0.05) 100%);
            border: 1.5px solid rgba(212, 175, 55, 0.25);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border-radius: 32px;
            padding: 3.5rem 3.5rem 3rem;
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.05),
                0 35px 90px rgba(0, 0, 0, 0.5),
                inset 0 1px 0 rgba(255,255,255,0.12);
            animation: card-in 0.8s cubic-bezier(0.22, 1, 0.36, 1) both;
        }

        @keyframes card-in {
            from {
                opacity: 0;
                transform: translateY(40px) scale(0.96);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /*  Brand / Header  */
        .brand-wrap {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            margin-bottom: 2.8rem;
        }

        .brand-icon-lg {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, var(--gold) 0%, var(--rose-gold) 100%);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            color: var(--deep-plum);
            box-shadow: 0 10px 30px rgba(212, 175, 55, 0.4);
            animation: icon-glow 3s ease-in-out infinite;
        }

        @keyframes icon-glow {
            0%, 100% { box-shadow: 0 10px 30px rgba(212, 175, 55, 0.4); }
            50% { box-shadow: 0 10px 40px rgba(212, 175, 55, 0.6); }
        }

        .brand-title {
            font-family: 'Playfair Display', serif;
            font-weight: 800;
            font-size: 2rem;
            color: var(--white);
            letter-spacing: -0.8px;
            text-shadow: 0 2px 20px rgba(0, 0, 0, 0.3);
        }

        .brand-sub {
            color: var(--text-muted);
            font-size: 0.95rem;
            margin-top: 4px;
            text-align: center;
            max-width: 320px;
            line-height: 1.5;
        }

        /*  Alerts  */
        .alert-danger {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.15), rgba(239, 68, 68, 0.1)) !important;
            border: 1.5px solid rgba(239, 68, 68, 0.35) !important;
            border-radius: 16px !important;
            color: #fca5a5 !important;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 1.8rem;
            padding: 1rem 1.2rem;
            box-shadow: 0 4px 20px rgba(239, 68, 68, 0.15);
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.15), rgba(16, 185, 129, 0.1)) !important;
            border: 1.5px solid rgba(16, 185, 129, 0.35) !important;
            border-radius: 16px !important;
            color: #6ee7b7 !important;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 1.8rem;
            padding: 1rem 1.2rem;
            box-shadow: 0 4px 20px rgba(16, 185, 129, 0.15);
        }

        .btn-close {
            filter: invert(0.8);
            opacity: 0.7;
        }

        /*  Form Labels  */
        .form-label {
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: var(--gold-light);
            margin-bottom: 10px;
        }

        /*  Input Group  */
        .input-group {
            border-radius: 16px;
            overflow: visible;
            position: relative;
        }

        .input-group-text {
            background: rgba(255, 255, 255, 0.08);
            border: 1.5px solid rgba(212, 175, 55, 0.25);
            border-right: none;
            border-radius: 16px 0 0 16px !important;
            color: var(--gold-light);
            padding: 0 18px;
            transition: all 0.3s ease;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.08) !important;
            border: 1.5px solid rgba(212, 175, 55, 0.25) !important;
            border-left: none !important;
            border-radius: 0 16px 16px 0 !important;
            padding: 15px 20px !important;
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

        .form-control:focus {
            background: rgba(255, 255, 255, 0.12) !important;
            border-color: var(--gold) !important;
            box-shadow: none !important;
            outline: none;
        }

        /* Sync left border on focus */
        .input-group:focus-within .input-group-text {
            border-color: var(--gold);
            background: rgba(212, 175, 55, 0.15);
            color: var(--gold-light);
        }

        .input-group:focus-within {
            box-shadow: 0 0 0 4px rgba(212, 175, 55, 0.15);
            border-radius: 16px;
        }

        /*  Submit Button  */
        .btn-primary {
            background: linear-gradient(135deg, var(--ocean) 0%, var(--aqua) 100%) !important;
            border: none !important;
            border-radius: 16px !important;
            padding: 17px !important;
            font-family: 'Inter', sans-serif !important;
            font-weight: 700 !important;
            font-size: 1rem !important;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: white !important;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease !important;
            box-shadow: 0 8px 30px rgba(50, 130, 184, 0.35);
        }

        .btn-primary::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.2), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .btn-primary::after {
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

        .btn-primary:hover {
            transform: translateY(-3px) !important;
            box-shadow: 0 12px 40px rgba(50, 130, 184, 0.5) !important;
        }

        .btn-primary:hover::before { opacity: 1; }

        .btn-primary:active {
            transform: translateY(-1px) !important;
        }

        .btn-primary:active::after {
            width: 300px;
            height: 300px;
        }

        /*  Footer Links  */
        .footer-links {
            text-align: center;
            margin-top: 2rem;
        }

        .footer-links p {
            color: rgba(254, 246, 228, 0.5);
            font-size: 0.9rem;
            margin-bottom: 14px;
        }

        .footer-links a.create-link {
            color: var(--aqua);
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s ease;
            position: relative;
        }

        .footer-links a.create-link::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: linear-gradient(90deg, var(--aqua), var(--gold-light));
            transition: width 0.3s ease;
        }

        .footer-links a.create-link:hover {
            color: var(--gold-light);
        }

        .footer-links a.create-link:hover::after {
            width: 100%;
        }

        .footer-links a.back-link {
            color: rgba(254, 246, 228, 0.4);
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }

        .footer-links a.back-link:hover {
            color: rgba(254, 246, 228, 0.75);
            transform: translateX(-3px);
        }

        .divider-line {
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(212, 175, 55, 0.3), transparent);
            margin: 2rem 0;
            position: relative;
        }

        .divider-line::before {
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
        @media (max-width: 576px) {
            .login-card {
                padding: 2.5rem 2rem;
            }

            .brand-title {
                font-size: 1.7rem;
            }

            .brand-icon-lg {
                width: 56px;
                height: 56px;
                font-size: 1.4rem;
            }
        }
    </style>
</head>
<body>
<div class="orb orb-1"></div>
<div class="orb orb-2"></div>
<div class="orb orb-3"></div>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-5 col-md-7">
            <div class="login-card">

                <!-- Brand Header -->
                <div class="brand-wrap">
                    <div class="brand-icon-lg"><i class="fas fa-train"></i></div>
                    <div class="brand-title">WaygonWay</div>
                    <div class="brand-sub">Welcome back! Please sign in to your account</div>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="/login" method="post">
                    <div class="mb-4">
                        <label class="form-label">Username or Email</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-user"></i>
                            </span>
                            <input type="text" class="form-control" name="usernameOrEmail"
                                   placeholder="Enter your username or email" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-lock"></i>
                            </span>
                            <input type="password" class="form-control" name="password"
                                   placeholder="Enter your password" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 mb-4">
                        <i class="fas fa-sign-in-alt me-2"></i>Sign In
                    </button>
                </form>

                <div class="divider-line"></div>

                <div class="footer-links">
                    <p>
                        Don't have an account?&nbsp;
                        <a href="/register" class="create-link">Create Account</a>
                    </p>
                    <a href="/" class="back-link">
                        <i class="fas fa-arrow-left"></i>Back to Home
                    </a>
                </div>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
