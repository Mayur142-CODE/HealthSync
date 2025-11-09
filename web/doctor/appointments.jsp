<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Doctor" %>
<%@ page import="model.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
                            <a class="nav-link" href="../doctor/dashboard">
                                <i class="fas fa-tachometer-alt"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="../doctor/appointments">
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
                        <i class="fas fa-calendar-check me-2"></i>My Appointments
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-outline-primary" onclick="window.location.reload()">
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
                                        <th>Date & Time</th>
                                        <th>Patient</th>
                                        <th>Contact</th>
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
                                                <div>
                                                    <strong><%= appointment.getPatientName() %></strong>
                                                    <br>
                                                    <button type="button" class="btn btn-link btn-sm p-0 text-info" 
                                                            onclick="viewPatientHistory(<%= appointment.getPatientId() %>, '<%= appointment.getPatientName() %>')"
                                                            data-bs-toggle="modal" data-bs-target="#patientHistoryModal">
                                                        <i class="fas fa-history me-1"></i>View History
                                                    </button>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <small class="text-muted"><%= appointment.getPatientPhone() %></small>
                                        </td>
                                        <td>
                                            <span title="<%= appointment.getReason() %>">
                                                <%= appointment.getReason().length() > 40 ? 
                                                    appointment.getReason().substring(0, 40) + "..." : 
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
                                            <div class="btn-group btn-group-sm">
                                                <% if ("approved".equals(status) || "completed".equals(status)) { %>
                                                    <button type="button" class="btn btn-outline-success" title="Create/View Prescription"
                                                            onclick="managePrescription(<%= appointment.getAppointmentId() %>, <%= appointment.getPatientId() %>, '<%= appointment.getPatientName() %>')"
                                                            data-bs-toggle="modal" data-bs-target="#prescriptionModal">
                                                        <i class="fas fa-prescription"></i>
                                                    </button>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-4">
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


    <!-- Patient History Modal -->
    <div class="modal fade" id="patientHistoryModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-history me-2"></i>Patient Medical History
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="patientHistoryContent">
                        <div class="text-center">
                            <div class="spinner-border" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Prescription Management Modal -->
    <div class="modal fade" id="prescriptionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-prescription me-2"></i>Prescription Management
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="../doctor/prescriptions" method="post">
                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="appointmentId" id="prescriptionAppointmentId">
                    <input type="hidden" name="patientId" id="prescriptionPatientId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Patient</label>
                            <input type="text" class="form-control" id="prescriptionPatientName" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Diagnosis *</label>
                            <textarea class="form-control" name="diagnosis" rows="2" required 
                                      placeholder="Enter diagnosis..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Medications *</label>
                            <textarea class="form-control" name="medications" rows="4" required 
                                      placeholder="Enter medications with dosage and frequency..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Instructions *</label>
                            <textarea class="form-control" name="instructions" rows="3" required 
                                      placeholder="Enter instructions for the patient..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Additional Notes</label>
                            <textarea class="form-control" name="notes" rows="2" 
                                      placeholder="Any additional notes..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Create Prescription
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>

        function viewPatientHistory(patientId, patientName) {
            document.querySelector('#patientHistoryModal .modal-title').innerHTML = 
                '<i class="fas fa-history me-2"></i>Medical History - ' + patientName;
            
            // Load patient history via AJAX
            fetch('../doctor/appointments?action=getPatientHistory&patientId=' + patientId)
                .then(response => response.text())
                .then(data => {
                    document.getElementById('patientHistoryContent').innerHTML = data;
                })
                .catch(error => {
                    document.getElementById('patientHistoryContent').innerHTML = 
                        '<div class="alert alert-danger">Error loading patient history</div>';
                });
        }

        function managePrescription(appointmentId, patientId, patientName) {
            document.getElementById('prescriptionAppointmentId').value = appointmentId;
            document.getElementById('prescriptionPatientId').value = patientId;
            document.getElementById('prescriptionPatientName').value = patientName;
        }
    </script>
</body>
</html>
