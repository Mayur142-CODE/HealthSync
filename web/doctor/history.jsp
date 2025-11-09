<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Doctor" %>
<%@ page import="model.Appointment" %>
<%@ page import="model.Prescription" %>
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
    <title>History - HealthSync</title>
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
                            <a class="nav-link active" href="../doctor/history">
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
                        <i class="fas fa-history me-2"></i>Medical History
                    </h1>
                </div>

                <!-- Alert Messages -->
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= request.getAttribute("error") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="row">
                    <!-- Completed Appointments -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-calendar-check me-2"></i>Completed Appointments
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-sm">
                                        <thead>
                                            <tr>
                                                <th>Date</th>
                                                <th>Patient</th>
                                                <th>Reason</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                List<Appointment> completedAppointments = (List<Appointment>) request.getAttribute("completedAppointments");
                                                SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
                                                
                                                if (completedAppointments != null && !completedAppointments.isEmpty()) {
                                                    for (Appointment appointment : completedAppointments) {
                                            %>
                                            <tr>
                                                <td><%= dateFormat.format(appointment.getAppointmentDate()) %></td>
                                                <td><%= appointment.getPatientName() %></td>
                                                <td>
                                                    <span title="<%= appointment.getReason() %>">
                                                        <%= appointment.getReason().length() > 30 ? 
                                                            appointment.getReason().substring(0, 30) + "..." : 
                                                            appointment.getReason() %>
                                                    </span>
                                                </td>
                                            </tr>
                                            <%
                                                    }
                                                } else {
                                            %>
                                            <tr>
                                                <td colspan="3" class="text-center text-muted">No completed appointments</td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Prescriptions -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-prescription me-2"></i>Prescriptions Issued
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-sm">
                                        <thead>
                                            <tr>
                                                <th>Date</th>
                                                <th>Patient</th>
                                                <th>Diagnosis</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
                                                
                                                if (prescriptions != null && !prescriptions.isEmpty()) {
                                                    for (Prescription prescription : prescriptions) {
                                            %>
                                            <tr>
                                                <td><%= dateFormat.format(prescription.getPrescriptionDate()) %></td>
                                                <td><%= prescription.getPatientName() %></td>
                                                <td>
                                                    <span title="<%= prescription.getDiagnosis() %>">
                                                        <%= prescription.getDiagnosis().length() > 25 ? 
                                                            prescription.getDiagnosis().substring(0, 25) + "..." : 
                                                            prescription.getDiagnosis() %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <button type="button" class="btn btn-outline-info btn-sm" 
                                                            onclick="viewPrescriptionDetails(<%= prescription.getPrescriptionId() %>)"
                                                            data-bs-toggle="modal" data-bs-target="#prescriptionDetailsModal">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                            <%
                                                    }
                                                } else {
                                            %>
                                            <tr>
                                                <td colspan="4" class="text-center text-muted">No prescriptions issued</td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Prescription Details Modal -->
    <div class="modal fade" id="prescriptionDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Prescription Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="prescriptionDetailsContent">
                    <!-- Details will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function viewPrescriptionDetails(prescriptionId) {
            // Find prescription details from the page data
            const prescriptions = [
                <%
                    if (prescriptions != null) {
                        for (int i = 0; i < prescriptions.size(); i++) {
                            Prescription p = prescriptions.get(i);
                %>
                {
                    id: <%= p.getPrescriptionId() %>,
                    patient: '<%= p.getPatientName() %>',
                    date: '<%= dateFormat.format(p.getPrescriptionDate()) %>',
                    diagnosis: '<%= p.getDiagnosis().replace("'", "\\'") %>',
                    medications: '<%= p.getMedications().replace("'", "\\'") %>',
                    instructions: '<%= p.getInstructions().replace("'", "\\'") %>',
                    notes: '<%= p.getNotes() != null ? p.getNotes().replace("'", "\\'") : "" %>'
                }<%= i < prescriptions.size() - 1 ? "," : "" %>
                <%
                        }
                    }
                %>
            ];
            
            const prescription = prescriptions.find(p => p.id === prescriptionId);
            if (prescription) {
                var html = '<div class="row">' +
                    '<div class="col-md-6">' +
                    '<strong>Patient:</strong> ' + prescription.patient + '<br>' +
                    '<strong>Date:</strong> ' + prescription.date +
                    '</div>' +
                    '</div>' +
                    '<hr>' +
                    '<div class="mb-3">' +
                    '<strong>Diagnosis:</strong><br>' +
                    '<p class="text-muted">' + prescription.diagnosis + '</p>' +
                    '</div>' +
                    '<div class="mb-3">' +
                    '<strong>Medications:</strong><br>' +
                    '<p class="text-muted">' + prescription.medications + '</p>' +
                    '</div>' +
                    '<div class="mb-3">' +
                    '<strong>Instructions:</strong><br>' +
                    '<p class="text-muted">' + prescription.instructions + '</p>' +
                    '</div>';
                
                if (prescription.notes && prescription.notes.trim() !== '') {
                    html += '<div class="mb-3">' +
                        '<strong>Notes:</strong><br>' +
                        '<p class="text-muted">' + prescription.notes + '</p>' +
                        '</div>';
                }
                
                document.getElementById('prescriptionDetailsContent').innerHTML = html;
            }
        }
    </script>
</body>
</html>
