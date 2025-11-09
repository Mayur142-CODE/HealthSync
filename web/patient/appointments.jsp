<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Patient" %>
<%@ page import="model.Appointment" %>
<%@ page import="model.Doctor" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    <title>My Appointments - HealthSync</title>
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
                            <a class="nav-link" href="../patient/dashboard">
                                <i class="fas fa-tachometer-alt"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../patient/appointments?action=book">
                                <i class="fas fa-calendar-plus"></i>Book Appointment
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="../patient/appointments">
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
                        <i class="fas fa-calendar-check me-2"></i>My Appointments
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#bookAppointmentModal">
                            <i class="fas fa-calendar-plus me-1"></i>Book New Appointment
                        </button>
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

                <!-- Appointments Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-primary">
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
                                        List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                                        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
                                        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                                        
                                        if (appointments != null && !appointments.isEmpty()) {
                                            for (Appointment appointment : appointments) {
                                    %>
                                    <tr>
                                        <td>
                                            <strong><%= dateFormat.format(appointment.getAppointmentDate()) %></strong>
                                            <br><small class="text-muted"><%= timeFormat.format(appointment.getAppointmentTime()) %></small>
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
                                        <td>
                                            <span title="<%= appointment.getReason() %>">
                                                <%= appointment.getReason().length() > 50 ? 
                                                    appointment.getReason().substring(0, 50) + "..." : 
                                                    appointment.getReason() %>
                                            </span>
                                        </td>
                                        <td>
                                            <% 
                                                String status = appointment.getStatus();
                                                String badgeClass = "";
                                                if ("pending".equals(status)) {
                                                    badgeClass = "bg-warning";
                                                } else if ("approved".equals(status)) {
                                                    badgeClass = "bg-success";
                                                } else if ("completed".equals(status)) {
                                                    badgeClass = "bg-info";
                                                } else if ("cancelled".equals(status)) {
                                                    badgeClass = "bg-secondary";
                                                } else if ("rejected".equals(status)) {
                                                    badgeClass = "bg-danger";
                                                }
                                            %>
                                            <span class="badge <%= badgeClass %>">
                                                <%= status.substring(0, 1).toUpperCase() + status.substring(1) %>
                                            </span>
                                        </td>
                                        <td>
                                            <% if ("pending".equals(status) || "approved".equals(status)) { %>
                                                <a href="../patient/appointments?action=cancel&id=<%= appointment.getAppointmentId() %>" 
                                                   class="btn btn-outline-danger btn-sm"
                                                   onclick="return confirm('Are you sure you want to cancel this appointment?')">
                                                    <i class="fas fa-times"></i> Cancel
                                                </a>
                                            <% } else { %>
                                                <span class="text-muted">-</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">
                                            <i class="fas fa-calendar-times fa-3x mb-3"></i>
                                            <br>No appointments found
                                            <br><small>Book your first appointment to get started.</small>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Book Appointment Modal -->
    <div class="modal fade" id="bookAppointmentModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-calendar-plus me-2"></i>Book New Appointment
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="../patient/appointments" method="post">
                    <input type="hidden" name="action" value="bookAppointment">
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label">Select Doctor *</label>
                                <select class="form-select" name="doctorId" required>
                                    <option value="">Choose a doctor...</option>
                                    <%
                                        List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
                                        if (doctors != null) {
                                            for (Doctor doctor : doctors) {
                                    %>
                                    <option value="<%= doctor.getDoctorId() %>">
                                        Dr. <%= doctor.getFullName() %> - <%= doctor.getSpecialization() %>
                                    </option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Appointment Date *</label>
                                <input type="date" class="form-control" name="appointmentDate" 
                                       min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Appointment Time *</label>
                                <select class="form-select" name="appointmentTime" required>
                                    <option value="">Select time...</option>
                                    <option value="09:00">09:00 AM</option>
                                    <option value="09:30">09:30 AM</option>
                                    <option value="10:00">10:00 AM</option>
                                    <option value="10:30">10:30 AM</option>
                                    <option value="11:00">11:00 AM</option>
                                    <option value="11:30">11:30 AM</option>
                                    <option value="14:00">02:00 PM</option>
                                    <option value="14:30">02:30 PM</option>
                                    <option value="15:00">03:00 PM</option>
                                    <option value="15:30">03:30 PM</option>
                                    <option value="16:00">04:00 PM</option>
                                    <option value="16:30">04:30 PM</option>
                                    <option value="17:00">05:00 PM</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Reason for Visit *</label>
                                <textarea class="form-control" name="reason" rows="3" 
                                          placeholder="Please describe your symptoms or reason for the appointment..." required></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-calendar-plus me-1"></i>Book Appointment
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-open booking modal if requested
        document.addEventListener('DOMContentLoaded', function() {
            <% if (request.getAttribute("showBookingForm") != null) { %>
                const modal = new bootstrap.Modal(document.getElementById('bookAppointmentModal'));
                modal.show();
            <% } %>
        });
    </script>
</body>
</html>
