<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Doctor" %>
<%@ page import="model.Prescription" %>
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
    <title>Prescriptions - HealthSync</title>
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
                            <a class="nav-link active" href="../doctor/prescriptions">
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
                        <i class="fas fa-prescription-bottle-alt me-2"></i>Prescriptions
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createPrescriptionModal">
                            <i class="fas fa-plus me-1"></i>Create Prescription
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

                <!-- Prescriptions Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-primary">
                                    <tr>
                                        <th>Date</th>
                                        <th>Patient</th>
                                        <th>Diagnosis</th>
                                        <th>Medications</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
                                        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
                                        
                                        if (prescriptions != null && !prescriptions.isEmpty()) {
                                            for (Prescription prescription : prescriptions) {
                                    %>
                                    <tr>
                                        <td>
                                            <strong><%= dateFormat.format(prescription.getPrescriptionDate()) %></strong>
                                        </td>
                                        <td>
                                            <strong><%= prescription.getPatientName() %></strong>
                                        </td>
                                        <td>
                                            <span title="<%= prescription.getDiagnosis() %>">
                                                <%= prescription.getDiagnosis().length() > 30 ? 
                                                    prescription.getDiagnosis().substring(0, 30) + "..." : 
                                                    prescription.getDiagnosis() %>
                                            </span>
                                        </td>
                                        <td>
                                            <span title="<%= prescription.getMedications() %>">
                                                <%= prescription.getMedications().length() > 40 ? 
                                                    prescription.getMedications().substring(0, 40) + "..." : 
                                                    prescription.getMedications() %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <button type="button" class="btn btn-outline-info" title="View Details"
                                                        onclick="viewPrescription(<%= prescription.getPrescriptionId() %>)"
                                                        data-bs-toggle="modal" data-bs-target="#viewPrescriptionModal">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button type="button" class="btn btn-outline-primary" title="Edit"
                                                        onclick="editPrescription(<%= prescription.getPrescriptionId() %>, '<%= prescription.getDiagnosis().replace("'", "\\'") %>', '<%= prescription.getMedications().replace("'", "\\'") %>', '<%= prescription.getInstructions().replace("'", "\\'") %>', '<%= prescription.getNotes() != null ? prescription.getNotes().replace("'", "\\'") : "" %>')"
                                                        data-bs-toggle="modal" data-bs-target="#editPrescriptionModal">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <a href="prescriptions?action=delete&id=<%= prescription.getPrescriptionId() %>" 
                                                   class="btn btn-outline-danger" title="Delete"
                                                   onclick="return confirm('Are you sure you want to delete this prescription?')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">
                                            <i class="fas fa-prescription-bottle-alt fa-3x mb-3"></i>
                                            <br>No prescriptions found
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

    <!-- Create Prescription Modal -->
    <div class="modal fade" id="createPrescriptionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Create New Prescription</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="prescriptions" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label">Select Appointment *</label>
                                <select class="form-select" name="appointmentId" required>
                                    <option value="">Choose an appointment...</option>
                                    <%
                                        Appointment selectedAppointment = (Appointment) request.getAttribute("selectedAppointment");
                                        List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                                        if (appointments != null) {
                                            for (Appointment appointment : appointments) {
                                                if ("approved".equals(appointment.getStatus()) || "completed".equals(appointment.getStatus())) {
                                                    boolean isSelected = selectedAppointment != null && 
                                                                        selectedAppointment.getAppointmentId() == appointment.getAppointmentId();
                                    %>
                                    <option value="<%= appointment.getAppointmentId() %>" 
                                            data-patient-id="<%= appointment.getPatientId() %>"
                                            <%= isSelected ? "selected" : "" %>>
                                        <%= appointment.getPatientName() %> - <%= dateFormat.format(appointment.getAppointmentDate()) %>
                                    </option>
                                    <%
                                                }
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <input type="hidden" name="patientId" id="selectedPatientId">
                            <div class="col-12">
                                <label class="form-label">Diagnosis *</label>
                                <textarea class="form-control" name="diagnosis" rows="3" 
                                          placeholder="Enter diagnosis..." required></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Medications *</label>
                                <textarea class="form-control" name="medications" rows="4" 
                                          placeholder="Enter medications with dosage and frequency..." required></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Instructions *</label>
                                <textarea class="form-control" name="instructions" rows="3" 
                                          placeholder="Enter instructions for the patient..." required></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Additional Notes</label>
                                <textarea class="form-control" name="notes" rows="2" 
                                          placeholder="Any additional notes..."></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Create Prescription</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Prescription Modal -->
    <div class="modal fade" id="editPrescriptionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Prescription</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="prescriptions" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="prescriptionId" id="editPrescriptionId">
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label">Diagnosis *</label>
                                <textarea class="form-control" name="diagnosis" id="editDiagnosis" rows="3" 
                                          placeholder="Enter diagnosis..." required></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Medications *</label>
                                <textarea class="form-control" name="medications" id="editMedications" rows="4" 
                                          placeholder="Enter medications with dosage and frequency..." required></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Instructions *</label>
                                <textarea class="form-control" name="instructions" id="editInstructions" rows="3" 
                                          placeholder="Enter instructions for the patient..." required></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Additional Notes</label>
                                <textarea class="form-control" name="notes" id="editNotes" rows="2" 
                                          placeholder="Any additional notes..."></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Prescription</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- View Prescription Modal -->
    <div class="modal fade" id="viewPrescriptionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Prescription Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="prescriptionDetails">
                    <!-- Prescription details will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Handle appointment selection
        document.querySelector('select[name="appointmentId"]').addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            const patientId = selectedOption.getAttribute('data-patient-id');
            document.getElementById('selectedPatientId').value = patientId || '';
        });

        // Auto-open create prescription modal if appointment is pre-selected
        document.addEventListener('DOMContentLoaded', function() {
            <% if (request.getAttribute("selectedAppointment") != null) { %>
                const modal = new bootstrap.Modal(document.getElementById('createPrescriptionModal'));
                modal.show();
                
                // Set the patient ID for the pre-selected appointment
                const selectedOption = document.querySelector('select[name="appointmentId"] option[selected]');
                if (selectedOption) {
                    const patientId = selectedOption.getAttribute('data-patient-id');
                    document.getElementById('selectedPatientId').value = patientId || '';
                }
            <% } %>
        });

        function editPrescription(prescriptionId, diagnosis, medications, instructions, notes) {
            document.getElementById('editPrescriptionId').value = prescriptionId;
            document.getElementById('editDiagnosis').value = diagnosis;
            document.getElementById('editMedications').value = medications;
            document.getElementById('editInstructions').value = instructions;
            document.getElementById('editNotes').value = notes;
        }

        function viewPrescription(prescriptionId) {
            // Make AJAX request to get prescription details
            fetch('prescriptions?action=view&id=' + prescriptionId)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('prescriptionDetails').innerHTML = html;
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('prescriptionDetails').innerHTML = 
                        '<div class="alert alert-danger">Failed to load prescription details</div>';
                });
        }
    </script>
</body>
</html>
