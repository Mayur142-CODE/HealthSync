<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Doctor" %>
<%@ page import="model.Appointment" %>
<%@ page import="model.Prescription" %>
<%@ page import="java.util.List" %>
<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");
    if (doctor == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - HealthSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../assets/css/style.css" rel="stylesheet">
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
                        <small class="text-white-50">Doctor Portal</small>
                    </div>
                    
                    <!-- Doctor Info -->
                    <div class="text-center mb-4 p-3 bg-white bg-opacity-10 rounded">
                        <div class="avatar bg-white text-primary rounded-circle mx-auto mb-2 d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                            <i class="fas fa-user-md fa-lg"></i>
                        </div>
                        <h6 class="text-white mb-1">Dr. <%= doctor.getFullName() %></h6>
                        <small class="text-white-50"><%= doctor.getSpecialization() %></small>
                    </div>
                    
                    <!-- Navigation -->
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="../doctor/dashboard">
                                <i class="fas fa-tachometer-alt"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../doctor/appointments">
                                <i class="fas fa-calendar-check"></i>My Appointments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../doctor/prescriptions">
                                <i class="fas fa-prescription-bottle-alt"></i>Prescriptions
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../doctor/history">
                                <i class="fas fa-history"></i>History
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../doctor/profile">
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
                        <i class="fas fa-tachometer-alt me-2"></i>Doctor Dashboard
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-outline-primary" onclick="window.location.reload()">
                                <i class="fas fa-sync-alt me-1"></i>Refresh
                            </button>
                        </div>
                        <div class="dropdown">
                            <button class="btn btn-primary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-md me-1"></i>Dr. <%= doctor.getLastName() %>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="../doctor/profile">
                                    <i class="fas fa-user me-2"></i>Profile</a></li
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

                <!-- Welcome Card -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card bg-gradient-primary text-white">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h4 class="mb-2">Welcome back, Dr. <%= doctor.getFirstName() %>!</h4>
                                        <p class="mb-0 opacity-75">
                                            <i class="fas fa-stethoscope me-2"></i><%= doctor.getSpecialization() %> Specialist
                                            <span class="ms-3"><i class="fas fa-graduation-cap me-2"></i><%= doctor.getQualification() %></span>
                                            <span class="ms-3"><i class="fas fa-clock me-2"></i><%= doctor.getExperience() %> years experience</span>
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-md-end">
                                        <i class="fas fa-user-md fa-4x opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Today's Appointments -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card card-modern">
                            <div class="card-header card-header-modern d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">
                                    <i class="fas fa-calendar-day me-2"></i>Today's Appointments
                                </h5>
                                <a href="../doctor/appointments" class="btn btn-light btn-sm">
                                    <i class="fas fa-eye me-1"></i>View All
                                </a>
                            </div>
                            <div class="card-body p-0">
                                <% 
                                    List<Appointment> todaysAppointments = (List<Appointment>) request.getAttribute("todaysAppointments");
                                    if (todaysAppointments != null && !todaysAppointments.isEmpty()) {
                                %>
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Time</th>
                                                    <th>Patient</th>
                                                    <th>Reason</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for (Appointment appointment : todaysAppointments) { %>
                                                    <tr>
                                                        <td>
                                                            <div class="fw-semibold text-primary">
                                                                <%= appointment.getAppointmentTime() %>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <div class="avatar bg-success text-white rounded-circle me-2 d-flex align-items-center justify-content-center" style="width: 35px; height: 35px;">
                                                                    <i class="fas fa-user"></i>
                                                                </div>
                                                                <div>
                                                                    <div class="fw-semibold"><%= appointment.getPatientName() %></div>
                                                                    <small class="text-muted"><%= appointment.getPatientPhone() %></small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td><%= appointment.getReason() %></td>
                                                        <td>
                                                            <span class="badge bg-<%= appointment.getStatus() %>">
                                                                <%= appointment.getStatus().toUpperCase() %>
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group btn-group-sm">
                                                                <a href="../doctor/appointments?action=addNotes&id=<%= appointment.getAppointmentId() %>" 
                                                                   class="btn btn-outline-primary btn-sm" title="Add Notes">
                                                                    <i class="fas fa-notes-medical"></i>
                                                                </a>
                                                                <a href="../doctor/prescriptions?action=create&appointmentId=<%= appointment.getAppointmentId() %>" 
                                                                   class="btn btn-outline-success btn-sm" title="Create Prescription">
                                                                    <i class="fas fa-prescription"></i>
                                                                </a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                <% } else { %>
                                    <div class="text-center py-5">
                                        <i class="fas fa-calendar-day fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No appointments today</h5>
                                        <p class="text-muted">You have a free schedule for today!</p>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Statistics and Recent Activity -->
                <div class="row">
                    <!-- Recent Prescriptions -->
                    <div class="col-lg-8">
                        <div class="card card-modern">
                            <div class="card-header card-header-modern d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">
                                    <i class="fas fa-prescription-bottle-alt me-2"></i>Recent Prescriptions
                                </h5>
                                <a href="prescriptions" class="btn btn-light btn-sm">
                                    <i class="fas fa-eye me-1"></i>View All
                                </a>
                            </div>
                            <div class="card-body p-0">
                                <% 
                                    List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
                                    if (prescriptions != null && !prescriptions.isEmpty()) {
                                        int count = 0;
                                        for (Prescription prescription : prescriptions) {
                                            if (count >= 5) break; // Show only 5 recent prescriptions
                                %>
                                    <div class="d-flex align-items-center p-3 border-bottom">
                                        <div class="avatar bg-info text-white rounded-circle me-3 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                            <i class="fas fa-pills"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="fw-semibold"><%= prescription.getPatientName() %></div>
                                            <small class="text-muted">
                                                <%= prescription.getDiagnosis() %> • <%= prescription.getPrescriptionDate() %>
                                            </small>
                                        </div>
                                        <div>
                                            <a href="prescriptions?action=download&id=<%= prescription.getPrescriptionId() %>" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-download"></i>
                                            </a>
                                        </div>
                                    </div>
                                <%
                                            count++;
                                        }
                                    } else {
                                %>
                                    <div class="text-center py-4">
                                        <i class="fas fa-prescription-bottle-alt fa-2x text-muted mb-2"></i>
                                        <p class="text-muted mb-0">No prescriptions created yet</p>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Stats -->
                    <div class="col-lg-4">
                        <div class="row g-3">
                            <div class="col-12">
                                <div class="stats-card info">
                                    <div class="stats-icon info">
                                        <i class="fas fa-calendar-check"></i>
                                    </div>
                                    <h4 class="fw-bold mb-1">
                                        <%= todaysAppointments != null ? todaysAppointments.size() : 0 %>
                                    </h4>
                                    <p class="text-muted mb-0">Today's Appointments</p>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="stats-card success">
                                    <div class="stats-icon success">
                                        <i class="fas fa-prescription"></i>
                                    </div>
                                    <h4 class="fw-bold mb-1">
                                        <%= prescriptions != null ? prescriptions.size() : 0 %>
                                    </h4>
                                    <p class="text-muted mb-0">Total Prescriptions</p>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="stats-card warning">
                                    <div class="stats-icon warning">
                                        <i class="fas fa-users"></i>
                                    </div>
                                    <h4 class="fw-bold mb-1">
                                        <% 
                                            List<Appointment> allAppointments = (List<Appointment>) request.getAttribute("allAppointments");
                                        %>
                                        <%= allAppointments != null ? allAppointments.size() : 0 %>
                                    </h4>
                                    <p class="text-muted mb-0">Total Patients</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card card-modern">
                            <div class="card-header card-header-modern">
                                <h5 class="mb-0">
                                    <i class="fas fa-bolt me-2"></i>Quick Actions
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <a href="appointments" class="btn btn-outline-primary w-100 py-3">
                                            <i class="fas fa-calendar-check fa-2x d-block mb-2"></i>
                                            View All Appointments
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="prescriptions?action=create" class="btn btn-outline-success w-100 py-3">
                                            <i class="fas fa-prescription fa-2x d-block mb-2"></i>
                                            Create Prescription
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="prescriptions" class="btn btn-outline-info w-100 py-3">
                                            <i class="fas fa-file-medical fa-2x d-block mb-2"></i>
                                            Manage Prescriptions
                                        </a>
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
</body>
</html>
