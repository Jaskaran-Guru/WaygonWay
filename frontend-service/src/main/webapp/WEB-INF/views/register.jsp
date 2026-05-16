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
            padding: 2.5rem 0;
        }

        /*  Background Pattern  */
        body::before {
            content: '';
            position: fixed; inset: 0;
            background:
                radial-gradient(circle at 15% 15%, rgba(212, 175, 55, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 85% 80%, rgba(50, 130, 184, 0.12) 0%, transparent 50%),
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
            width: 380px; height: 380px;
            background: radial-gradient(circle, rgba(212, 175, 55, 0.15), transparent);
            top: 5%; left: 5%; animation-duration: 14s;
        }

        .shape:nth-child(2) {
            width: 480px; height: 480px;
            background: radial-gradient(circle, rgba(50, 130, 184, 0.18), transparent);
            top: 55%; left: 65%; animation-duration: 16s; animation-delay: 3s;
        }

        .shape:nth-child(3) {
            width: 300px; height: 300px;
            background: radial-gradient(circle, rgba(183, 110, 121, 0.13), transparent);
            top: 70%; left: 10%; animation-duration: 13s; animation-delay: 2s;
        }

        @keyframes float-orb {
            0%, 100% { transform: translate(0, 0) scale(1); }
            33%       { transform: translate(30px, -40px) scale(1.1); }
            66%       { transform: translate(-40px, 20px) scale(0.9); }
        }

        /*  Page Container  */
        .container { position: relative; z-index: 1; }

        /*  Animations  */
        @keyframes fade-up {
            from { opacity: 0; transform: translateY(24px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        @keyframes fade-scale {
            from { opacity: 0; transform: translateY(28px) scale(0.97); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        /*  Brand Header  */
        .brand-header {
            text-align: center;
            margin-bottom: 2rem;
            animation: fade-up 0.6s ease both;
        }

        .brand-header .brand-logo {
            display: inline-flex; align-items: center; gap: 12px;
            text-decoration: none; margin-bottom: 1rem;
        }

        .brand-header .brand-icon {
            width: 48px; height: 48px;
            background: linear-gradient(135deg, var(--gold) 0%, var(--rose-gold) 100%);
            border-radius: 14px;
            display: inline-flex; align-items: center; justify-content: center;
            color: var(--deep-plum); font-size: 1.2rem;
            box-shadow: 0 6px 20px rgba(212, 175, 55, 0.35);
        }

        .brand-header .brand-name {
            font-family: 'Playfair Display', serif;
            font-weight: 800; font-size: 2rem;
            color: var(--white); letter-spacing: -0.5px;
        }

        .brand-header .header-badge {
            display: inline-flex; align-items: center; gap: 9px;
            background: linear-gradient(135deg, rgba(212,175,55,0.15), rgba(183,110,121,0.15));
            border: 1px solid rgba(212,175,55,0.3);
            color: var(--gold-light); font-size: 0.72rem; font-weight: 700;
            letter-spacing: 2px; text-transform: uppercase;
            padding: 6px 16px; border-radius: 100px; margin-bottom: 12px;
        }

        .brand-header .header-badge .dot {
            width: 7px; height: 7px; background: var(--gold); border-radius: 50%;
            animation: pulse-dot 2s ease-in-out infinite;
            box-shadow: 0 0 8px var(--gold);
        }

        @keyframes pulse-dot {
            0%, 100% { opacity: 1; transform: scale(1); }
            50%       { opacity: 0.6; transform: scale(0.8); }
        }

        .brand-header h2 {
            font-family: 'Playfair Display', serif;
            font-weight: 800; font-size: clamp(1.7rem, 4vw, 2.2rem);
            color: var(--white); letter-spacing: -0.8px; margin-bottom: 8px;
        }

        .brand-header h2 .accent {
            background: linear-gradient(135deg, var(--gold) 0%, var(--aqua) 50%, var(--gold-light) 100%);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
        }

        .brand-header p { color: var(--text-muted); font-size: 0.95rem; }

        /*  Register Card  */
        .register-card {
            background: linear-gradient(135deg, rgba(255,255,255,0.08) 0%, rgba(255,255,255,0.04) 100%);
            border: 1px solid rgba(212, 175, 55, 0.2);
            backdrop-filter: blur(30px); -webkit-backdrop-filter: blur(30px);
            border-radius: 28px; padding: 2.8rem 3rem;
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.05),
                0 30px 80px rgba(0,0,0,0.45),
                inset 0 1px 0 rgba(255,255,255,0.1);
            animation: fade-scale 0.8s ease 0.1s both;
            margin-bottom: 1.5rem;
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

        .field-label .req { color: var(--rose-gold); margin-left: 3px; }

        .input-icon-wrap { position: relative; }

        .input-icon-wrap .i-icon {
            position: absolute; left: 16px; top: 50%; transform: translateY(-50%);
            color: rgba(212, 175, 55, 0.5); font-size: 0.75rem; pointer-events: none;
            z-index: 2;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.07) !important;
            border: 1.5px solid rgba(212, 175, 55, 0.22) !important;
            border-radius: 14px !important;
            padding: 14px 18px 14px 42px !important;
            color: var(--white) !important;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem !important; font-weight: 500;
            transition: all 0.3s ease;
        }

        .form-control::placeholder { color: rgba(254, 246, 228, 0.28) !important; font-weight: 400; }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.11) !important;
            border-color: var(--gold) !important;
            box-shadow: 0 0 0 4px rgba(212, 175, 55, 0.14) !important;
            outline: none;
        }

        /* password eye toggle */
        .pw-toggle {
            position: absolute; right: 14px; top: 50%; transform: translateY(-50%);
            color: rgba(254,246,228,0.3); cursor: pointer; font-size: 0.8rem;
            transition: color 0.2s ease; z-index: 2; background: none; border: none;
            padding: 4px;
        }

        .pw-toggle:hover { color: var(--gold-light); }

        /*  Form Divider  */
        .form-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(212,175,55,0.2), transparent);
            margin: 1.8rem 0;
        }

        /*  Submit Button  */
        .btn-register {
            background: linear-gradient(135deg, var(--ocean) 0%, var(--aqua) 100%);
            border: none; border-radius: 16px !important;
            padding: 18px !important;
            font-family: 'Inter', sans-serif;
            font-size: 1rem !important; font-weight: 700;
            letter-spacing: 1.5px; text-transform: uppercase;
            color: white !important; width: 100%;
            position: relative; overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 8px 28px rgba(50, 130, 184, 0.35);
        }

        .btn-register::before {
            content: ''; position: absolute; inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, transparent 60%);
            opacity: 0; transition: opacity 0.3s ease;
        }

        .btn-register:hover { transform: translateY(-3px); box-shadow: 0 12px 40px rgba(50, 130, 184, 0.5); }
        .btn-register:hover::before { opacity: 1; }
        .btn-register:active { transform: translateY(-1px); }

        /*  Error Alert  */
        .alert-danger {
            background: rgba(239,68,68,0.1) !important;
            border: 1px solid rgba(239,68,68,0.28) !important;
            border-radius: 14px !important; color: #fca5a5 !important;
            font-size: 0.88rem; padding: 1rem 1.2rem;
        }

        .btn-close { filter: invert(1) opacity(0.5); }
        .btn-close:hover { filter: invert(1) opacity(0.9); }

        /*  Footer Links  */
        .card-footer-links {
            text-align: center; margin-top: 1.8rem;
            animation: fade-up 0.7s ease 0.3s both;
        }

        .card-footer-links p {
            color: var(--text-muted); font-size: 0.88rem; margin-bottom: 10px;
        }

        .card-footer-links a.link-primary {
            color: var(--gold-light) !important;
            font-weight: 700; text-decoration: none;
            transition: color 0.2s ease;
        }

        .card-footer-links a.link-primary:hover { color: var(--gold) !important; }

        .card-footer-links a.link-back {
            display: inline-flex; align-items: center; gap: 6px;
            color: rgba(254,246,228,0.35) !important;
            font-size: 0.82rem; text-decoration: none;
            transition: color 0.2s ease;
        }

        .card-footer-links a.link-back:hover { color: var(--text-muted) !important; }

        /*  Step Progress  */
        .step-pills {
            display: flex; align-items: center; justify-content: center;
            gap: 0; margin-bottom: 2.5rem;
        }

        .step-pill {
            display: flex; flex-direction: column; align-items: center; gap: 5px;
        }

        .step-circle {
            width: 32px; height: 32px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.75rem; font-weight: 700;
            border: 1.5px solid;
        }

        .step-circle.active {
            background: linear-gradient(135deg, var(--ocean), var(--aqua));
            border-color: var(--aqua); color: white;
            box-shadow: 0 4px 14px rgba(50,130,184,0.35);
        }

        .step-circle.done {
            background: rgba(52,211,153,0.15); border-color: rgba(52,211,153,0.4);
            color: #6ee7b7;
        }

        .step-circle.pending {
            background: rgba(255,255,255,0.05); border-color: rgba(255,255,255,0.15);
            color: rgba(255,255,255,0.3);
        }

        .step-label {
            font-size: 0.62rem; font-weight: 600; letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .step-label.active { color: var(--aqua); }
        .step-label.done   { color: #6ee7b7; }
        .step-label.pending{ color: rgba(255,255,255,0.25); }

        .step-line {
            width: 48px; height: 1px; margin-bottom: 18px;
            background: linear-gradient(90deg, rgba(50,130,184,0.4), rgba(255,255,255,0.1));
        }

        /*  Responsive  */
        @media (max-width: 768px) {
            .register-card { padding: 2rem 1.8rem; }
            .step-line { width: 30px; }
        }

        @media (max-width: 576px) {
            .register-card { padding: 1.5rem 1.2rem; }
            .step-pills { display: none; }
        }
    </style>
</head>
<body>

<div class="floating-shapes">
    <div class="shape"></div>
    <div class="shape"></div>
    <div class="shape"></div>
</div>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">

            <!-- Brand Header -->
            <div class="brand-header">
                <a class="brand-logo" href="/">
                    <span class="brand-icon"><i class="fas fa-train"></i></span>
                    <span class="brand-name">WaygonWay</span>
                </a>
                <br>
                <div class="header-badge">
                    <span class="dot"></span>
                    New Account
                </div>
                <h2>Create Your <span class="accent">Account</span></h2>
                <p>Join thousands of travellers booking smarter every day</p>
            </div>

            <!-- Step Pills -->
            <div class="step-pills">
                <div class="step-pill">
                    <div class="step-circle active"><i class="fas fa-user"></i></div>
                    <span class="step-label active">Details</span>
                </div>
                <div class="step-line"></div>
                <div class="step-pill">
                    <div class="step-circle pending"><i class="fas fa-lock"></i></div>
                    <span class="step-label pending">Security</span>
                </div>
                <div class="step-line"></div>
                <div class="step-pill">
                    <div class="step-circle pending"><i class="fas fa-check"></i></div>
                    <span class="step-label pending">Done</span>
                </div>
            </div>

            <!-- Register Card -->
            <div class="register-card">

                <!-- Error -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show mb-4">
                        <i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="/register" method="post">

                    <!-- Personal Info -->
                    <div class="section-title">
                        <span class="st-icon"><i class="fas fa-user"></i></span>
                        Personal Information
                    </div>
                    <div class="row g-3 mb-2">
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">First Name <span class="req">*</span></span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-user"></i>
                                    <input type="text" class="form-control" name="firstName"
                                           placeholder="Your first name" required>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">Last Name <span class="req">*</span></span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-user"></i>
                                    <input type="text" class="form-control" name="lastName"
                                           placeholder="Your last name" required>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-divider"></div>

                    <!-- Contact -->
                    <div class="section-title">
                        <span class="st-icon"><i class="fas fa-envelope"></i></span>
                        Contact Details
                    </div>
                    <div class="row g-3 mb-2">
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">Email Address <span class="req">*</span></span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-envelope"></i>
                                    <input type="email" class="form-control" name="email"
                                           placeholder="your@email.com" required>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">Phone Number</span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-phone"></i>
                                    <input type="tel" class="form-control" name="phone"
                                           placeholder="+91 00000 00000">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-divider"></div>

                    <!-- Credentials -->
                    <div class="section-title">
                        <span class="st-icon"><i class="fas fa-lock"></i></span>
                        Login Credentials
                    </div>
                    <div class="row g-3 mb-2">
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">Username <span class="req">*</span></span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-at"></i>
                                    <input type="text" class="form-control" name="username"
                                           placeholder="Choose a username" required>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">Password <span class="req">*</span></span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-lock"></i>
                                    <input type="password" class="form-control" name="password"
                                           id="passwordInput" placeholder="Create a strong password" required>
                                    <button type="button" class="pw-toggle" onclick="togglePassword()">
                                        <i class="fas fa-eye" id="pwIcon"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-divider"></div>

                    <!-- Location -->
                    <div class="section-title">
                        <span class="st-icon"><i class="fas fa-map-marker-alt"></i></span>
                        Location <span style="color:rgba(254,246,228,0.3);font-size:0.65rem;font-weight:400;letter-spacing:0;text-transform:none;margin-left:4px;">(optional)</span>
                    </div>
                    <div class="row g-3 mb-2">
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">City</span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-city"></i>
                                    <input type="text" class="form-control" name="city"
                                           placeholder="Your city">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="field-group">
                                <span class="field-label">State</span>
                                <div class="input-icon-wrap">
                                    <i class="i-icon fas fa-map"></i>
                                    <input type="text" class="form-control" name="state"
                                           placeholder="Your state">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Submit -->
                    <div class="mt-4 pt-1">
                        <button type="submit" class="btn btn-register">
                            <i class="fas fa-user-plus me-2"></i>Create Account
                        </button>
                    </div>

                </form>
            </div>

            <!-- Footer Links -->
            <div class="card-footer-links">
                <p>
                    Already have an account?
                    <a href="/login" class="link-primary ms-1">Sign In</a>
                </p>
                <a href="/" class="link-back">
                    <i class="fas fa-arrow-left"></i>Back to Home
                </a>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function togglePassword() {
        const input = document.getElementById('passwordInput');
        const icon  = document.getElementById('pwIcon');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    }
</script>
</body>
</html>
