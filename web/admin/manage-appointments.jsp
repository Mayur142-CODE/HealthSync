<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Admin" %>
<%@ page import="model.Appointment" %>
<%@ page import="model.Doctor" %>
<%@ page import="model.Patient" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    <title>Manage Appointments - HealthSync</title>
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
                    <div class="text-center mb-4">
                        <h4 class="text-white fw-bold">
                            <i class="fas fa-heartbeat me-2"></i>HealthSync
                        </h4>
                        <small class="text-white-50">Admin Panel</small>
                    </div>
                    
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="dashboard">
                                <i class="fas fa-tachometer-alt"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="doctors">
                                <i class="fas fa-user-md"></i>Manage Doctors
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="patients">
                                <i class="fas fa-users"></i>Manage Patients
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="appointments">
                                <i class="fas fa-calendar-check"></i>Appointments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="profile">
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
                        <i class="fas fa-calendar-check me-2"></i>
                        <%= request.getAttribute("showPendingOnly") != null ? "Pending Appointments" : "Manage Appointments" %>
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <% if (request.getAttribute("showPendingOnly") != null) { %>
                            <a href="appointments" class="btn btn-outline-primary me-2">
                                <i class="fas fa-list me-1"></i>View All
                            </a>
                        <% } else { %>
                            <a href="appointments?action=pending" class="btn btn-outline-warning me-2">
                                <i class="fas fa-clock me-1"></i>Pending Only
                            </a>
                        <% } %>
                        <button type="button" class="btn btn-primary" onclick="window.location.reload()">
                            <i class="fas fa-sync-alt me-1"></i>Refresh
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
                                        <th>ID</th>
                                        <th>Patient</th>
                                        <th>Doctor</th>
                                        <th>Date & Time</th>
                                        <th>Reason</th>
                                        <th>Status</th>
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
                                        <td><%= appointment.getAppointmentId() %></td>
                                        <td>
                                            <strong><%= appointment.getPatientName() %></strong>
                                            <br><small class="text-muted"><%= appointment.getPatientPhone() %></small>
                                        </td>
                                        <td>
                                            <strong><%= appointment.getDoctorName() %></strong>
                                            <br><small class="text-muted"><%= appointment.getDoctorSpecialization() %></small>
                                        </td>
                                        <td>
                                            <%= dateFormat.format(appointment.getAppointmentDate()) %>
                                            <br><small class="text-muted"><%= timeFormat.format(appointment.getAppointmentTime()) %></small>
                                        </td>
                                        <td>
                                            <span title="<%= appointment.getReason() %>">
                                                <%= appointment.getReason().length() > 30 ? 
                                                    appointment.getReason().substring(0, 30) + "..." : 
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
                                                } else if ("rejected".equals(status)) {
                                                    badgeClass = "bg-danger";
                                                } else if ("completed".equals(status)) {
                                                    badgeClass = "bg-info";
                                                } else if ("cancelled".equals(status)) {
                                                    badgeClass = "bg-secondary";
                                                }
                                            %>
                                            <span class="badge <%= badgeClass %>">
                                                <%= status.substring(0, 1).toUpperCase() + status.substring(1) %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <% if ("pending".equals(status)) { %>
                                                    <a href="appointments?action=approve&id=<%= appointment.getAppointmentId() %>" 
                                                       class="btn btn-outline-success" title="Approve">
                                                        <i class="fas fa-check"></i>
                                                    </a>
                                                    <a href="appointments?action=reject&id=<%= appointment.getAppointmentId() %>" 
                                                       class="btn btn-outline-danger" title="Reject"
                                                       onclick="return confirm('Are you sure you want to reject this appointment?')">
                                                        <i class="fas fa-times"></i>
                                                    </a>
                                                <% } %>
                                                <% if ("approved".equals(status)) { %>
                                                    <a href="appointments?action=complete&id=<%= appointment.getAppointmentId() %>" 
                                                       class="btn btn-outline-info" title="Mark Complete">
                                                        <i class="fas fa-check-double"></i>
                                                    </a>
                                                <% } %>
                                                <% if (!"cancelled".equals(status) && !"completed".equals(status)) { %>
                                                    <a href="appointments?action=cancel&id=<%= appointment.getAppointmentId() %>" 
                                                       class="btn btn-outline-warning" title="Cancel"
                                                       onclick="return confirm('Are you sure you want to cancel this appointment?')">
                                                        <i class="fas fa-ban"></i>
                                                    </a>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="7" class="text-center text-muted py-4">
                                            <i class="fas fa-calendar-times fa-3x mb-3"></i>
                                            <br>No appointments found
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

    <!-- Add Notes Modal -->
    <div class="modal fade" id="notesModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add Notes</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="appointments" method="post">
                    <input type="hidden" name="action" value="addNotes">
                    <input type="hidden" name="appointmentId" id="notesAppointmentId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Notes</label>
                            <textarea class="form-control" name="notes" rows="4" 
                                      placeholder="Enter appointment notes..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Notes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function addNotes(appointmentId) {
            document.getElementById('notesAppointmentId').value = appointmentId;
        }
    </script>
</body>
</html>
