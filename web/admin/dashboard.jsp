<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Admin" %>
<%@ page import="model.Appointment" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - HealthSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../assets/css/style.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                <div class="position-sticky pt-3">
                    <!-- Brand -->
                    <div class="text-center mb-4">
                        <h4 class="text-white fw-bold">
                            <i class="fas fa-heartbeat me-2"></i>HealthSync
                        </h4>
                        <small class="text-white-50">Admin Panel</small>
                    </div>
                    
                    <!-- Navigation -->
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="../admin/dashboard">
                                <i class="fas fa-tachometer-alt"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../admin/doctors">
                                <i class="fas fa-user-md"></i>Manage Doctors
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../admin/patients">
                                <i class="fas fa-users"></i>Manage Patients
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../admin/appointments">
                                <i class="fas fa-calendar-check"></i>Appointments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../admin/profile">
                                <i class="fas fa-user-cog"></i>Profile
                            </a>
                        </li>
                        <li class="nav-item mt-3">
                            <a class="nav-link" href="../logout">
                                <i class="fas fa-sign-out-alt"></i>Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <!-- Header -->
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2 text-primary">
                        <i class="fas fa-tachometer-alt me-2"></i>Admin Dashboard
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-outline-primary" onclick="window.location.reload()">
                                <i class="fas fa-sync-alt me-1"></i>Refresh
                            </button>
                        </div>
                        <div class="dropdown">
                            <button class="btn btn-primary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-shield me-1"></i><%= admin.getFullName() %>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="../admin/profile"><i class="fas fa-user me-2"></i>Profile</a></li>
                                
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="../logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Alert Messages -->
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= request.getAttribute("error") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        <%= request.getAttribute("success") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stats-card primary">
                            <div class="stats-icon primary">
                                <i class="fas fa-users"></i>
                            </div>
                            <h3 class="fw-bold mb-1 counter" data-target="<%= request.getAttribute("totalPatients") != null ? request.getAttribute("totalPatients") : 0 %>">0</h3>
                            <p class="text-muted mb-0">Total Patients</p>
                            <small class="text-success"><i class="fas fa-arrow-up me-1"></i>Active users</small>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stats-card success">
                            <div class="stats-icon success">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <h3 class="fw-bold mb-1 counter" data-target="<%= request.getAttribute("totalDoctors") != null ? request.getAttribute("totalDoctors") : 0 %>">0</h3>
                            <p class="text-muted mb-0">Total Doctors</p>
                            <small class="text-success"><i class="fas fa-check-circle me-1"></i>Available</small>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stats-card info">
                            <div class="stats-icon info">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <h3 class="fw-bold mb-1 counter" data-target="<%= request.getAttribute("totalAppointments") != null ? request.getAttribute("totalAppointments") : 0 %>">0</h3>
                            <p class="text-muted mb-0">Total Appointments</p>
                            <small class="text-info"><i class="fas fa-calendar me-1"></i>All time</small>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stats-card warning">
                            <div class="stats-icon warning">
                                <i class="fas fa-check-double"></i>
                            </div>
                            <h3 class="fw-bold mb-1 counter" data-target="<%= request.getAttribute("completedAppointments") != null ? request.getAttribute("completedAppointments") : 0 %>">0</h3>
                            <p class="text-muted mb-0">Completed</p>
                            <small class="text-success"><i class="fas fa-thumbs-up me-1"></i>Successful</small>
                        </div>
                    </div>
                </div>

                <!-- Analytics Charts -->
                <div class="row mb-4">
                    <div class="col-lg-6 mb-4">
                        <div class="card card-modern shadow-sm">
                            <div class="card-header card-header-modern bg-white">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">
                                        <i class="fas fa-chart-pie me-2 text-primary"></i>Appointment Status Distribution
                                    </h5>
                                    <span class="badge bg-primary">Live Data</span>
                                </div>
                            </div>
                            <div class="card-body chart-container">
                                <div style="height: 320px; position: relative;">
                                    <canvas id="appointmentsChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 mb-4">
                        <div class="card card-modern shadow-sm">
                            <div class="card-header card-header-modern bg-white">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">
                                        <i class="fas fa-chart-bar me-2 text-success"></i>Patient Registration Trend
                                    </h5>
                                    <span class="badge bg-success">Last 6 Months</span>
                                </div>
                            </div>
                            <div class="card-body chart-container">
                                <div style="height: 320px; position: relative;">
                                    <canvas id="patientsChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- System Insights -->
                <div class="row">
                    <div class="col-12">
                        <div class="card card-modern shadow-sm">
                            <div class="card-header card-header-modern bg-white">
                                <h5 class="mb-0">
                                    <i class="fas fa-lightbulb me-2 text-warning"></i>System Insights
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-4">
                                    <div class="col-md-4">
                                        <div class="insight-card">
                                            <div class="d-flex align-items-center mb-3">
                                                <div class="insight-icon bg-primary-subtle text-primary me-3">
                                                    <i class="fas fa-chart-line"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0">Growth Trend</h6>
                                                    <small class="text-muted">Patient registrations</small>
                                                </div>
                                            </div>
                                            <p class="text-muted mb-0">Monitor patient registration trends over the past 6 months to identify growth patterns.</p>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="insight-card">
                                            <div class="d-flex align-items-center mb-3">
                                                <div class="insight-icon bg-success-subtle text-success me-3">
                                                    <i class="fas fa-calendar-check"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0">Appointment Status</h6>
                                                    <small class="text-muted">Real-time distribution</small>
                                                </div>
                                            </div>
                                            <p class="text-muted mb-0">Track appointment statuses to ensure efficient scheduling and patient care management.</p>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="insight-card">
                                            <div class="d-flex align-items-center mb-3">
                                                <div class="insight-icon bg-info-subtle text-info me-3">
                                                    <i class="fas fa-users-cog"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-0">Resource Management</h6>
                                                    <small class="text-muted">Doctors & Patients</small>
                                                </div>
                                            </div>
                                            <p class="text-muted mb-0">Maintain optimal doctor-to-patient ratios for quality healthcare delivery.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card card-modern shadow-sm">
                            <div class="card-header card-header-modern bg-white">
                                <h5 class="mb-0">
                                    <i class="fas fa-bolt me-2 text-warning"></i>Quick Actions
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-md-3">
                                        <a href="doctors" class="btn btn-outline-primary w-100 py-3 quick-action-btn">
                                            <i class="fas fa-user-md fa-2x d-block mb-2"></i>
                                            <span class="fw-semibold">Manage Doctors</span>
                                            <small class="d-block text-muted mt-1">View & Edit</small>
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="patients" class="btn btn-outline-success w-100 py-3 quick-action-btn">
                                            <i class="fas fa-users fa-2x d-block mb-2"></i>
                                            <span class="fw-semibold">Manage Patients</span>
                                            <small class="d-block text-muted mt-1">View & Edit</small>
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="appointments" class="btn btn-outline-info w-100 py-3 quick-action-btn">
                                            <i class="fas fa-calendar-alt fa-2x d-block mb-2"></i>
                                            <span class="fw-semibold">All Appointments</span>
                                            <small class="d-block text-muted mt-1">View & Manage</small>
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <button onclick="refreshDashboard()" class="btn btn-outline-warning w-100 py-3 quick-action-btn">
                                            <i class="fas fa-sync-alt fa-2x d-block mb-2"></i>
                                            <span class="fw-semibold">Refresh Data</span>
                                            <small class="d-block text-muted mt-1">Update Charts</small>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../assets/js/main.js"></script>
    <script src="../assets/js/dashboard-analytics.js"></script>
    
    <style>
        .stats-card {
            border-radius: 12px;
            padding: 1.5rem;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
        }
        
        .stats-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        
        .stats-icon.primary { background: rgba(13, 110, 253, 0.1); color: #0d6efd; }
        .stats-icon.success { background: rgba(25, 135, 84, 0.1); color: #198754; }
        .stats-icon.info { background: rgba(13, 202, 240, 0.1); color: #0dcaf0; }
        .stats-icon.warning { background: rgba(255, 193, 7, 0.1); color: #ffc107; }
        
        .insight-card {
            padding: 1.25rem;
            border-radius: 10px;
            background: #f8f9fa;
            height: 100%;
            transition: all 0.3s ease;
        }
        
        .insight-card:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }
        
        .insight-icon {
            width: 45px;
            height: 45px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
        }
        
        .quick-action-btn {
            transition: all 0.3s ease;
            border-width: 2px;
        }
        
        .quick-action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .card-modern {
            border: none;
            border-radius: 12px;
        }
        
        .card-header-modern {
            border-bottom: 1px solid #e9ecef;
            padding: 1.25rem 1.5rem;
            background: #f8f9fa;
            border-radius: 12px 12px 0 0 !important;
        }
        
        .chart-container {
            position: relative;
        }
    </style>
</body>
</html>
