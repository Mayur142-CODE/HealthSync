<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Patient" %>
<%@ page import="model.Appointment" %>
<%@ page import="model.Prescription" %>
<%@ page import="java.util.List" %>
<%
    Patient patient = (Patient) session.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - HealthSync</title>
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
                        <small class="text-white-50">Patient Portal</small>
                    </div>
                    
                    <!-- Patient Info -->
                    <div class="text-center mb-4 p-3 bg-white bg-opacity-10 rounded">
                        <div class="avatar bg-white text-primary rounded-circle mx-auto mb-2 d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                            <i class="fas fa-user fa-lg"></i>
                        </div>
                        <h6 class="text-white mb-1"><%= patient.getFullName() %></h6>
                        <small class="text-white-50">Patient ID: #<%= patient.getPatientId() %></small>
                    </div>
                    
                    <!-- Navigation -->
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="../patient/dashboard">
                                <i class="fas fa-tachometer-alt"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../patient/appointments?action=book">
                                <i class="fas fa-calendar-plus"></i>Book Appointment
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../patient/appointments">
                                <i class="fas fa-calendar-check"></i>My Appointments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../patient/prescriptions">
                                <i class="fas fa-prescription-bottle-alt"></i>My Prescriptions
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../patient/history">
                                <i class="fas fa-history"></i>My History
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../patient/profile">
                                <i class="fas fa-user-cog"></i>My Profile
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
                        <i class="fas fa-tachometer-alt me-2"></i>Patient Dashboard
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <a href="../patient/appointments?action=book" class="btn btn-primary">
                                <i class="fas fa-calendar-plus me-1"></i>Book Appointment
                            </a>
                        </div>
                        <div class="dropdown">
                            <button class="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user me-1"></i><%= patient.getFirstName() %>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="../patient/profile">
                                    <i class="fas fa-user me-2"></i>Profile</a></li>
                                
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

                <% if (session.getAttribute("profileSuccess") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        <%= session.getAttribute("profileSuccess") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("profileSuccess"); %>
                <% } %>

                <% if (session.getAttribute("profileError") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= session.getAttribute("profileError") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("profileError"); %>
                <% } %>

                <!-- Welcome Card -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card bg-gradient-primary text-white">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h4 class="mb-2">Welcome, <%= patient.getFirstName() %>!</h4>
                                        <p class="mb-0 opacity-75">
                                            <i class="fas fa-tint me-2"></i>Blood Group: <%= patient.getBloodGroup() %>
                                            <span class="ms-3"><i class="fas fa-birthday-cake me-2"></i>DOB: <%= patient.getDateOfBirth() %></span>
                                            <span class="ms-3"><i class="fas fa-phone me-2"></i><%= patient.getPhone() %></span>
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-md-end">
                                        <i class="fas fa-user-injured fa-4x opacity-50"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Stats -->
                <div class="row mb-4">
                    <% 
                        List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                        List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
                        
                        int totalAppointments = appointments != null ? appointments.size() : 0;
                        int pendingAppointments = 0;
                        int completedAppointments = 0;
                        
                        if (appointments != null) {
                            for (Appointment apt : appointments) {
                                if ("pending".equals(apt.getStatus()) || "approved".equals(apt.getStatus())) {
                                    pendingAppointments++;
                                } else if ("completed".equals(apt.getStatus())) {
                                    completedAppointments++;
                                }
                            }
                        }
                    %>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stats-card primary">
                            <div class="stats-icon primary">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <h3 class="fw-bold mb-1"><%= totalAppointments %></h3>
                            <p class="text-muted mb-0">Total Appointments</p>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stats-card warning">
                            <div class="stats-icon warning">
                                <i class="fas fa-clock"></i>
                            </div>
                            <h3 class="fw-bold mb-1"><%= pendingAppointments %></h3>
                            <p class="text-muted mb-0">Pending Appointments</p>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stats-card success">
                            <div class="stats-icon success">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <h3 class="fw-bold mb-1"><%= completedAppointments %></h3>
                            <p class="text-muted mb-0">Completed Visits</p>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stats-card info">
                            <div class="stats-icon info">
                                <i class="fas fa-prescription"></i>
                            </div>
                            <h3 class="fw-bold mb-1"><%= prescriptions != null ? prescriptions.size() : 0 %></h3>
                            <p class="text-muted mb-0">Prescriptions</p>
                        </div>
                    </div>
                </div>

                <!-- Recent Appointments -->
                <div class="row mb-4">
                    <div class="col-lg-8">
                        <div class="card card-modern">
                            <div class="card-header card-header-modern d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">
                                    <i class="fas fa-calendar-alt me-2"></i>Recent Appointments
                                </h5>
                                <a href="../patient/appointments" class="btn btn-light btn-sm">
                                    <i class="fas fa-eye me-1"></i>View All
                                </a>
                            </div>
                            <div class="card-body p-0">
                                <% if (appointments != null && !appointments.isEmpty()) { %>
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Date & Time</th>
                                                    <th>Doctor</th>
                                                    <th>Reason</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% 
                                                    int count = 0;
                                                    for (Appointment appointment : appointments) { 
                                                        if (count >= 5) break; // Show only 5 recent appointments
                                                %>
                                                    <tr>
                                                        <td>
                                                            <div>
                                                                <div class="fw-semibold"><%= appointment.getAppointmentDate() %></div>
                                                                <small class="text-muted"><%= appointment.getAppointmentTime() %></small>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <div class="avatar bg-primary text-white rounded-circle me-2 d-flex align-items-center justify-content-center" style="width: 35px; height: 35px;">
                                                                    <i class="fas fa-user-md"></i>
                                                                </div>
                                                                <div>
                                                                    <div class="fw-semibold">Dr. <%= appointment.getDoctorName() %></div>
                                                                    <small class="text-muted"><%= appointment.getDoctorSpecialization() %></small>
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
                                                            <% if ("pending".equals(appointment.getStatus()) || "approved".equals(appointment.getStatus())) { %>
                                                                <button class="btn btn-outline-danger btn-sm cancel-appointment-btn" 
                                                                        data-appointment-id="<%= appointment.getAppointmentId() %>">
                                                                    <i class="fas fa-times"></i> Cancel
                                                                </button>
                                                            <% } else { %>
                                                                <span class="text-muted">-</span>
                                                            <% } %>
                                                        </td>
                                                    </tr>
                                                <%
                                                        count++;
                                                    }
                                                %>
                                            </tbody>
                                        </table>
                                    </div>
                                <% } else { %>
                                    <div class="text-center py-5">
                                        <i class="fas fa-calendar-plus fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No appointments yet</h5>
                                        <p class="text-muted">Book your first appointment to get started.</p>
                                        <a href="../patient/appointments?action=book" class="btn btn-primary">
                                            <i class="fas fa-calendar-plus me-1"></i>Book Appointment
                                        </a>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <!-- Medical Info -->
                    <div class="col-lg-4">
                        <div class="card card-modern">
                            <div class="card-header card-header-modern">
                                <h5 class="mb-0">
                                    <i class="fas fa-user-injured me-2"></i>Medical Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label text-muted small">Blood Group</label>
                                    <div class="fw-semibold text-danger fs-5">
                                        <i class="fas fa-tint me-2"></i><%= patient.getBloodGroup() %>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted small">Gender</label>
                                    <div class="fw-semibold">
                                        <i class="fas fa-<%= "Male".equals(patient.getGender()) ? "mars" : "Female".equals(patient.getGender()) ? "venus" : "genderless" %> me-2"></i>
                                        <%= patient.getGender() %>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted small">Emergency Contact</label>
                                    <div class="fw-semibold">
                                        <i class="fas fa-phone me-2"></i>
                                        <%= patient.getEmergencyContact() != null && !patient.getEmergencyContact().isEmpty() ? patient.getEmergencyContact() : "Not provided" %>
                                    </div>
                                </div>
                                <div class="mb-0">
                                    <label class="form-label text-muted small">Registration Date</label>
                                    <div class="fw-semibold">
                                        <i class="fas fa-calendar me-2"></i><%= patient.getRegistrationDate() %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Prescriptions -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card card-modern">
                            <div class="card-header card-header-modern d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">
                                    <i class="fas fa-prescription-bottle-alt me-2"></i>Recent Prescriptions
                                </h5>
                                <a href="../patient/prescriptions" class="btn btn-light btn-sm">
                                    <i class="fas fa-eye me-1"></i>View All
                                </a>
                            </div>
                            <div class="card-body p-0">
                                <% if (prescriptions != null && !prescriptions.isEmpty()) { %>
                                    <div class="row g-0">
                                        <% 
                                            int prescCount = 0;
                                            for (Prescription prescription : prescriptions) { 
                                                if (prescCount >= 3) break; // Show only 3 recent prescriptions
                                        %>
                                            <div class="col-md-4">
                                                <div class="p-4 border-end">
                                                    <div class="d-flex align-items-center mb-2">
                                                        <div class="avatar bg-success text-white rounded-circle me-3 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                                            <i class="fas fa-pills"></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-semibold">Dr. <%= prescription.getDoctorName() %></div>
                                                            <small class="text-muted"><%= prescription.getPrescriptionDate() %></small>
                                                        </div>
                                                    </div>
                                                    <p class="mb-2"><strong>Diagnosis:</strong> <%= prescription.getDiagnosis() %></p>
                                                    <a href="../patient/prescriptions?action=download&id=<%= prescription.getPrescriptionId() %>" 
                                                       class="btn btn-outline-primary btn-sm">
                                                        <i class="fas fa-download me-1"></i>Download PDF
                                                    </a>
                                                </div>
                                            </div>
                                        <%
                                                prescCount++;
                                            }
                                        %>
                                    </div>
                                <% } else { %>
                                    <div class="text-center py-4">
                                        <i class="fas fa-prescription-bottle-alt fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No prescriptions yet</h5>
                                        <p class="text-muted">Your prescriptions will appear here after doctor visits.</p>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row">
                    <div class="col-12">
                        <div class="card card-modern">
                            <div class="card-header card-header-modern">
                                <h5 class="mb-0">
                                    <i class="fas fa-bolt me-2"></i>Quick Actions
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-md-3">
                                        <a href="../patient/appointments?action=book" class="btn btn-outline-primary w-100 py-3">
                                            <i class="fas fa-calendar-plus fa-2x d-block mb-2"></i>
                                            Book New Appointment
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="../patient/appointments" class="btn btn-outline-success w-100 py-3">
                                            <i class="fas fa-calendar-check fa-2x d-block mb-2"></i>
                                            View Appointments
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="../patient/prescriptions" class="btn btn-outline-info w-100 py-3">
                                            <i class="fas fa-prescription fa-2x d-block mb-2"></i>
                                            View Prescriptions
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="../patient/profile" class="btn btn-outline-warning w-100 py-3">
                                            <i class="fas fa-user-edit fa-2x d-block mb-2"></i>
                                            Update Profile
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
    <script>
        // Cancel appointment functionality
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.cancel-appointment-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const appointmentId = this.getAttribute('data-appointment-id');
                    if (confirm('Are you sure you want to cancel this appointment?')) {
                        window.location.href = '../patient/appointments?action=cancel&id=' + appointmentId;
                    }
                });
            });
        });
    </script>
</body>
</html>
