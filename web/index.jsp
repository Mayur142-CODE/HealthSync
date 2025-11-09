<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HealthSync - Hospital Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                <i class="fas fa-heartbeat me-2"></i>HealthSync
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#features">Features</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">About</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link btn btn-primary ms-2 px-3" href="login.jsp">Login</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link btn btn-light text-primary ms-2 px-3 dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Register
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="register.jsp"><i class="fas fa-user me-2"></i>As Patient</a></li>
                            <li><a class="dropdown-item" href="doctor-register.jsp"><i class="fas fa-user-md me-2"></i>As Doctor</a></li>
                            <li><a class="dropdown-item" href="admin-register.jsp"><i class="fas fa-user-shield me-2"></i>As Admin</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center min-vh-100">
                <div class="col-lg-6">
                    <div class="hero-content">
                        <h1 class="display-4 fw-bold text-primary mb-4">
                            <i class="fas fa-heartbeat text-danger"></i> HealthSync
                        </h1>
                        <p class="lead text-muted mb-4">
                            "Where Doctors, Patients & Data Sync Together"
                        </p>
                        <p class="fs-5 mb-5">
                            A comprehensive hospital management system that streamlines healthcare operations, 
                            enhances patient care, and improves medical workflow efficiency.
                        </p>
                        <div class="d-flex gap-3 flex-wrap">
                            <div class="dropdown">
                                <button class="btn btn-primary btn-lg px-4 dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user-plus me-2"></i>Get Started
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="register.jsp"><i class="fas fa-user me-2"></i>Register as Patient</a></li>
                                    <li><a class="dropdown-item" href="doctor-register.jsp"><i class="fas fa-user-md me-2"></i>Register as Doctor</a></li>
                                    <li><a class="dropdown-item" href="admin-register.jsp"><i class="fas fa-user-shield me-2"></i>Register as Admin</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="login.jsp"><i class="fas fa-sign-in-alt me-2"></i>Already have an account?</a></li>
                                </ul>
                            </div>
                            <a href="login.jsp" class="btn btn-outline-primary btn-lg px-4">
                                <i class="fas fa-sign-in-alt me-2"></i>Login
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="hero-image text-center">
                        <i class="fas fa-hospital display-1 text-primary opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="py-5 bg-light">
        <div class="container">
            <div class="row">
                <div class="col-12 text-center mb-5">
                    <h2 class="display-5 fw-bold text-primary">Key Features</h2>
                    <p class="lead text-muted">Comprehensive healthcare management solutions</p>
                </div>
            </div>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-card card h-100 border-0 shadow-sm">
                        <div class="card-body text-center p-4">
                            <div class="feature-icon mb-3">
                                <i class="fas fa-user-md fa-3x text-primary"></i>
                            </div>
                            <h5 class="card-title fw-bold">Doctor Management</h5>
                            <p class="card-text text-muted">
                                Comprehensive doctor profiles, specializations, schedules, and appointment management.
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card card h-100 border-0 shadow-sm">
                        <div class="card-body text-center p-4">
                            <div class="feature-icon mb-3">
                                <i class="fas fa-users fa-3x text-success"></i>
                            </div>
                            <h5 class="card-title fw-bold">Patient Portal</h5>
                            <p class="card-text text-muted">
                                Easy appointment booking, medical history tracking, and prescription management.
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card card h-100 border-0 shadow-sm">
                        <div class="card-body text-center p-4">
                            <div class="feature-icon mb-3">
                                <i class="fas fa-calendar-check fa-3x text-warning"></i>
                            </div>
                            <h5 class="card-title fw-bold">Appointment System</h5>
                            <p class="card-text text-muted">
                                Intelligent scheduling system with real-time availability and automated notifications.
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card card h-100 border-0 shadow-sm">
                        <div class="card-body text-center p-4">
                            <div class="feature-icon mb-3">
                                <i class="fas fa-prescription-bottle-alt fa-3x text-info"></i>
                            </div>
                            <h5 class="card-title fw-bold">Digital Prescriptions</h5>
                            <p class="card-text text-muted">
                                Generate, manage, and download digital prescriptions with PDF export functionality.
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card card h-100 border-0 shadow-sm">
                        <div class="card-body text-center p-4">
                            <div class="feature-icon mb-3">
                                <i class="fas fa-chart-line fa-3x text-danger"></i>
                            </div>
                            <h5 class="card-title fw-bold">Analytics Dashboard</h5>
                            <p class="card-text text-muted">
                                Real-time statistics, reports, and insights for better healthcare management.
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card card h-100 border-0 shadow-sm">
                        <div class="card-body text-center p-4">
                            <div class="feature-icon mb-3">
                                <i class="fas fa-shield-alt fa-3x text-secondary"></i>
                            </div>
                            <h5 class="card-title fw-bold">Secure & Reliable</h5>
                            <p class="card-text text-muted">
                                Advanced security measures to protect sensitive medical data and patient privacy.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section id="about" class="py-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h2 class="display-5 fw-bold text-primary mb-4">About HealthSync</h2>
                    <p class="lead mb-4">
                        HealthSync is a modern, web-based hospital management system designed to streamline 
                        healthcare operations and improve patient care quality.
                    </p>
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check-circle text-success me-3"></i>
                                <span>User-Friendly Interface</span>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check-circle text-success me-3"></i>
                                <span>Real-time Updates</span>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check-circle text-success me-3"></i>
                                <span>Mobile Responsive</span>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-check-circle text-success me-3"></i>
                                <span>Secure Data Management</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="text-center">
                        <i class="fas fa-laptop-medical display-1 text-primary opacity-75"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5 class="fw-bold">
                        <i class="fas fa-heartbeat me-2"></i>HealthSync
                    </h5>
                    <p class="text-muted">Where Doctors, Patients & Data Sync Together</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p class="text-muted mb-0">
                        &copy; 2024 HealthSync. Advanced Java Web Application.
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Success/Error Messages -->
    <% if (request.getParameter("message") != null) { %>
        <div class="toast-container position-fixed top-0 end-0 p-3">
            <div class="toast show" role="alert">
                <div class="toast-header">
                    <i class="fas fa-info-circle text-primary me-2"></i>
                    <strong class="me-auto">HealthSync</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast"></button>
                </div>
                <div class="toast-body">
                    <%= request.getParameter("message") %>
                </div>
            </div>
        </div>
    <% } %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/main.js"></script>
</body>
</html>
