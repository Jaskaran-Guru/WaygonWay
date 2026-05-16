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
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --navy: #0a0f2e;
            --azure: #2563eb;
            --sky: #3b82f6;
            --ice: #93c5fd;
            --gold: #f59e0b;
            --gold-light: #fcd34d;
            --emerald: #10b981;
            --white: #ffffff;
            --glass: rgba(255,255,255,0.05);
            --glass-border: rgba(255,255,255,0.1);
            --text-muted: rgba(255,255,255,0.45);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background-color: var(--navy);
            font-family: 'DM Sans', sans-serif;
            min-height: 100vh;
            padding-top: 76px;
        }

        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background:
                radial-gradient(ellipse 70% 55% at 10% 5%, rgba(37,99,235,0.38) 0%, transparent 60%),
                radial-gradient(ellipse 55% 65% at 90% 90%, rgba(30,58,138,0.4) 0%, transparent 55%),
                radial-gradient(ellipse 40% 40% at 50% 50%, rgba(10,15,46,0.85) 0%, transparent 100%);
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
            background-size: 60px 60px;
            z-index: 0;
            pointer-events: none;
        }

        /*  Navbar  */
        .navbar {
            background: rgba(10,15,46,0.75);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--glass-border);
            padding: 0.85rem 0;
        }

        .navbar-brand {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.5rem !important;
            color: var(--white) !important;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .navbar-brand .brand-icon {
            width: 34px; height: 34px;
            background: linear-gradient(135deg, var(--azure), var(--gold));
            border-radius: 9px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }

        .nav-link {
            color: rgba(255,255,255,0.65) !important;
            font-size: 0.88rem;
            padding: 0.4rem 0.9rem !important;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .nav-link:hover { color: var(--white) !important; background: var(--glass); }

        .btn-nav {
            background: linear-gradient(135deg, var(--azure), var(--sky));
            border: none;
            color: white !important;
            font-size: 0.85rem;
            font-weight: 600;
            padding: 0.42rem 1.1rem;
            border-radius: 8px;
            transition: all 0.25s ease;
            text-decoration: none;
        }

        .btn-nav:hover { transform: translateY(-1px); box-shadow: 0 6px 18px rgba(37,99,235,0.35); }

        /*  Container  */
        .container { position: relative; z-index: 1; padding-top: 2.5rem; padding-bottom: 3rem; }

        /*  Base Card  */
        .confirmation-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--glass-border);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 2.5rem;
            margin-bottom: 1.8rem;
            box-shadow:
                0 0 0 1px rgba(255,255,255,0.04),
                0 28px 70px rgba(0,0,0,0.35),
                inset 0 1px 0 rgba(255,255,255,0.07);
        }

        .confirmation-card:nth-child(1) { animation: fade-up 0.55s ease both; }
        .confirmation-card:nth-child(2) { animation: fade-up 0.55s ease 0.08s both; }
        .confirmation-card:nth-child(3) { animation: fade-up 0.55s ease 0.16s both; }
        .confirmation-card:nth-child(4) { animation: fade-up 0.55s ease 0.24s both; }

        @keyframes fade-up {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /*  Success Hero  */
        .success-ring {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: rgba(16,185,129,0.1);
            border: 2px solid rgba(16,185,129,0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.8rem;
            position: relative;
        }

        .success-ring::before {
            content: '';
            position: absolute;
            inset: -8px;
            border-radius: 50%;
            border: 1px solid rgba(16,185,129,0.1);
        }

        .success-icon {
            color: var(--emerald);
            font-size: 3rem;
            animation: checkmark 0.6s ease-in-out;
        }

        @keyframes checkmark {
            0%   { transform: scale(0); }
            50%  { transform: scale(1.2); }
            100% { transform: scale(1); }
        }

        .success-title {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 2rem;
            color: var(--white);
            margin-bottom: 10px;
        }

        .success-title span { color: #6ee7b7; }

        .success-subtitle {
            color: var(--text-muted);
            font-size: 0.9rem;
            max-width: 420px;
            margin: 0 auto 2rem;
            line-height: 1.7;
        }

        /*  PNR Highlight  */
        .pnr-highlight {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(59,130,246,0.3);
            border-radius: 20px;
            padding: 1.6rem 2.5rem;
            text-align: center;
            margin: 0 auto 0.5rem;
            max-width: 420px;
            position: relative;
            overflow: hidden;
        }

        .pnr-highlight::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse 80% 60% at 50% 0%, rgba(59,130,246,0.12), transparent);
        }

        .pnr-highlight h3 {
            font-size: 0.72rem;
            font-weight: 600;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.4);
            margin-bottom: 10px;
        }

        .pnr-number {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 2.8rem;
            color: var(--white);
            letter-spacing: 4px;
            line-height: 1;
            margin-bottom: 8px;
        }

        .pnr-note {
            font-size: 0.78rem;
            color: rgba(255,255,255,0.35);
        }

        /*  Section Heading  */
        .section-heading {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 1.6rem;
        }

        .section-heading .s-icon {
            width: 36px; height: 36px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.85rem; flex-shrink: 0;
        }

        .s-icon.blue   { background: rgba(59,130,246,0.15);  color: var(--ice); }
        .s-icon.gold   { background: rgba(245,158,11,0.15);  color: var(--gold-light); }
        .s-icon.green  { background: rgba(16,185,129,0.15);  color: #6ee7b7; }
        .s-icon.yellow { background: rgba(245,158,11,0.12);  color: var(--gold-light); }

        .section-heading h4, .section-heading h5 {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            color: var(--white);
            margin: 0;
        }

        .section-heading h4 { font-size: 1.1rem; }
        .section-heading h5 { font-size: 1rem; }

        /*  Ticket Details Panel  */
        .ticket-details {
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--glass-border);
            border-radius: 18px;
            padding: 2rem;
            position: relative;
            overflow: hidden;
        }

        .ticket-details::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--azure), var(--emerald), var(--gold));
        }

        .detail-group-title {
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.35);
            margin-bottom: 14px;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            font-size: 0.88rem;
            color: rgba(255,255,255,0.7);
        }

        .detail-item .d-icon {
            width: 28px; height: 28px;
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.72rem;
            flex-shrink: 0;
        }

        .d-icon.blue  { background: rgba(59,130,246,0.15); color: var(--ice); }
        .d-icon.green { background: rgba(16,185,129,0.15); color: #6ee7b7; }

        .detail-item strong { color: var(--white); }

        .ticket-divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--glass-border), transparent);
            margin: 1.6rem 0;
        }

        .meta-label {
            font-size: 0.7rem;
            font-weight: 600;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            color: rgba(255,255,255,0.3);
            margin-bottom: 5px;
        }

        .meta-value {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            color: var(--white);
            font-size: 0.95rem;
        }

        .badge-confirmed {
            background: rgba(16,185,129,0.15);
            border: 1px solid rgba(16,185,129,0.3);
            color: #6ee7b7;
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 0.78rem;
            letter-spacing: 1px;
            padding: 5px 14px;
            border-radius: 100px;
        }

        .status-note {
            font-size: 0.78rem;
            color: rgba(255,255,255,0.35);
            margin-left: 10px;
        }

        /*  Action Buttons  */
        .action-buttons .btn {
            border-radius: 12px !important;
            padding: 11px 22px !important;
            font-size: 0.85rem;
            font-weight: 600;
            margin: 0.4rem;
            transition: all 0.25s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--azure), var(--sky)) !important;
            border: none !important;
            color: white !important;
        }

        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(37,99,235,0.4) !important; }

        .btn-outline-primary {
            background: transparent !important;
            border: 1px solid rgba(59,130,246,0.35) !important;
            color: var(--ice) !important;
        }

        .btn-outline-primary:hover { background: rgba(59,130,246,0.12) !important; transform: translateY(-2px); }

        .btn-outline-info {
            background: transparent !important;
            border: 1px solid rgba(6,182,212,0.3) !important;
            color: #67e8f9 !important;
        }

        .btn-outline-info:hover { background: rgba(6,182,212,0.1) !important; transform: translateY(-2px); }

        .btn-outline-warning {
            background: transparent !important;
            border: 1px solid rgba(245,158,11,0.3) !important;
            color: var(--gold-light) !important;
        }

        .btn-outline-warning:hover { background: rgba(245,158,11,0.1) !important; transform: translateY(-2px); }

        .btn-success {
            background: linear-gradient(135deg, var(--emerald), #059669) !important;
            border: none !important;
            color: white !important;
        }

        .btn-success:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(16,185,129,0.4) !important; }

        /*  Instructions  */
        .instruction-item {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 12px;
            font-size: 0.87rem;
            color: rgba(255,255,255,0.6);
            line-height: 1.5;
        }

        .instruction-item .check-dot {
            width: 20px; height: 20px;
            background: rgba(16,185,129,0.15);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: #34d399;
            font-size: 0.6rem;
            flex-shrink: 0;
            margin-top: 2px;
        }

        .alert-support {
            background: rgba(59,130,246,0.08) !important;
            border: 1px solid rgba(59,130,246,0.2) !important;
            border-radius: 12px !important;
            color: rgba(255,255,255,0.65) !important;
            font-size: 0.87rem;
            margin-top: 1.4rem;
        }

        .alert-support strong { color: var(--ice); }
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
            <a class="nav-link" href="/my-bookings">My Bookings</a>
            <a class="btn-nav" href="/search">Book Another</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">

            <!-- Success Message -->
            <div class="confirmation-card text-center">
                <div class="success-ring">
                    <i class="fas fa-check success-icon"></i>
                </div>

                <div class="success-title">Booking <span>Confirmed!</span></div>
                <p class="success-subtitle">
                    Your train ticket has been successfully booked.
                    A confirmation email has been sent to your registered email address.
                </p>

                <!-- PNR Display -->
                <div class="pnr-highlight mx-auto">
                    <h3>Your PNR Number</h3>
                    <div class="pnr-number">${pnr}</div>
                    <div class="pnr-note">Keep this number safe for future reference</div>
                </div>
            </div>

            <!-- Ticket Details -->
            <div class="confirmation-card">
                <div class="section-heading">
                    <div class="s-icon blue"><i class="fas fa-ticket-alt"></i></div>
                    <h4>Your E-Ticket Details</h4>
                </div>

                <div class="ticket-details">
                    <div class="row">
                        <div class="col-md-6 mb-4 mb-md-0">
                            <div class="detail-group-title">Train Information</div>
                            <div class="detail-item">
                                <span class="d-icon blue"><i class="fas fa-train"></i></span>
                                <strong>${booking.trainName}</strong>
                            </div>
                            <div class="detail-item">
                                <span class="d-icon blue"><i class="fas fa-hashtag"></i></span>
                                Train No: ${booking.trainCode}
                            </div>
                            <div class="detail-item">
                                <span class="d-icon blue"><i class="fas fa-route"></i></span>
                                ${booking.source}  ${booking.destination}
                            </div>
                            <div class="detail-item">
                                <span class="d-icon blue"><i class="fas fa-calendar"></i></span>
                                Journey Date: ${booking.journeyDate}
                            </div>
                            <div class="detail-item">
                                <span class="d-icon blue"><i class="fas fa-clock"></i></span>
                                Departure: 08:00 AM
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="detail-group-title">Passenger Details</div>
                            <div class="detail-item">
                                <span class="d-icon green"><i class="fas fa-user"></i></span>
                                Name: <strong>${booking.passengerName}</strong>
                            </div>
                            <div class="detail-item">
                                <span class="d-icon green"><i class="fas fa-id-card"></i></span>
                                Age: ${booking.passengerAge} &nbsp;|&nbsp; Gender: ${booking.passengerGender}
                            </div>
                            <div class="detail-item">
                                <span class="d-icon green"><i class="fas fa-chair"></i></span>
                                Class: ${booking.trainClass}
                            </div>
                            <div class="detail-item">
                                <span class="d-icon green"><i class="fas fa-bed"></i></span>
                                Seat: S4/42 (Confirmed)
                            </div>
                            <div class="detail-item">
                                <span class="d-icon green"><i class="fas fa-credit-card"></i></span>
                                Total Fare: <strong style="color:#6ee7b7">${booking.totalAmount}</strong>
                            </div>
                        </div>
                    </div>

                    <div class="ticket-divider"></div>

                    <div class="row align-items-center">
                        <div class="col-md-6 mb-3 mb-md-0">
                            <div class="detail-group-title">Booking Information</div>
                            <div class="row g-3">
                                <div class="col-6">
                                    <div class="meta-label">PNR Number</div>
                                    <div class="meta-value">${pnr}</div>
                                </div>
                                <div class="col-6">
                                    <div class="meta-label">Booking Date</div>
                                    <div class="meta-value">${booking.bookingDate}</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="detail-group-title">Current Status</div>
                            <div class="d-flex align-items-center">
                                <span class="badge-confirmed">CONFIRMED</span>
                                <span class="status-note">Chart not prepared</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="confirmation-card">
                <div class="section-heading">
                    <div class="s-icon gold"><i class="fas fa-tools"></i></div>
                    <h5>Quick Actions</h5>
                </div>

                <div class="action-buttons text-center">
                    <button class="btn btn-primary" onclick="downloadTicket()">
                        <i class="fas fa-download me-2"></i>Download E-Ticket
                    </button>
                    <button class="btn btn-outline-primary" onclick="printTicket()">
                        <i class="fas fa-print me-2"></i>Print Ticket
                    </button>
                    <button class="btn btn-outline-info" onclick="sendSMS()">
                        <i class="fas fa-sms me-2"></i>Send SMS
                    </button>
                    <button class="btn btn-outline-warning" onclick="addCalendar()">
                        <i class="fas fa-calendar-plus me-2"></i>Add to Calendar
                    </button>
                </div>

                <div class="text-center mt-4">
                    <a href="/my-bookings" class="btn btn-success me-3">
                        <i class="fas fa-list me-2"></i>View All Bookings
                    </a>
                    <a href="/search" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Book Another Ticket
                    </a>
                </div>
            </div>

            <!-- Important Instructions -->
            <div class="confirmation-card">
                <div class="section-heading">
                    <div class="s-icon yellow"><i class="fas fa-info-circle"></i></div>
                    <h5>Important Instructions</h5>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="instruction-item">
                            <span class="check-dot"><i class="fas fa-check"></i></span>
                            Carry a valid photo ID proof while traveling
                        </div>
                        <div class="instruction-item">
                            <span class="check-dot"><i class="fas fa-check"></i></span>
                            Report at the station 30 minutes before departure
                        </div>
                        <div class="instruction-item">
                            <span class="check-dot"><i class="fas fa-check"></i></span>
                            Keep your PNR number handy for easy reference
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="instruction-item">
                            <span class="check-dot"><i class="fas fa-check"></i></span>
                            Check train running status before travel
                        </div>
                        <div class="instruction-item">
                            <span class="check-dot"><i class="fas fa-check"></i></span>
                            SMS updates will be sent to your mobile number
                        </div>
                        <div class="instruction-item">
                            <span class="check-dot"><i class="fas fa-check"></i></span>
                            Contact customer support for any assistance
                        </div>
                    </div>
                </div>

                <div class="alert-support">
                    <i class="fas fa-phone me-2" style="color:var(--ice)"></i>
                    <strong>Customer Support:</strong> 1800-123-4567 &nbsp;|&nbsp;
                    <strong>Email:</strong> support@waygonway.com
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function downloadTicket() {
        // In a real application, this would generate a PDF ticket
        alert('E-Ticket download will start shortly...');
        console.log('Downloading ticket for PNR: ${pnr}');
    }

    function printTicket() {
        window.print();
    }

    function sendSMS() {
        alert('SMS with ticket details has been sent to your mobile number!');
    }

    function addCalendar() {
        // Create calendar event
        const event = {
            title: 'Train Journey - ${booking.trainName}',
            start: '${booking.journeyDate}T08:00:00',
            description: 'PNR: ${pnr} | ${booking.source} to ${booking.destination}'
        };

        alert('Calendar event created for your journey!');
    }

    // Show success animation on page load
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(function() {
            document.querySelector('.success-icon').style.animation = 'checkmark 0.6s ease-in-out';
        }, 500);
    });
</script>
</body>
</html>
