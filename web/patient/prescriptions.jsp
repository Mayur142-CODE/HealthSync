<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Patient" %>
<%@ page import="model.Prescription" %>
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
    <title>My Prescriptions - HealthSync</title>
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
                            <a class="nav-link" href="../patient/appointments">
                                <i class="fas fa-calendar-check"></i>My Appointments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="../patient/prescriptions">
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
                        <i class="fas fa-prescription-bottle-alt me-2"></i>My Prescriptions
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

                <!-- Prescriptions Grid -->
                <%
                    List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
                    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
                    
                    if (prescriptions != null && !prescriptions.isEmpty()) {
                %>
                    <div class="row">
                        <% for (Prescription prescription : prescriptions) { %>
                            <div class="col-lg-6 col-xl-4 mb-4">
                                <div class="card h-100 prescription-card">
                                    <div class="card-header bg-primary text-white">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <h6 class="mb-0">
                                                <i class="fas fa-pills me-2"></i>Prescription #<%= prescription.getPrescriptionId() %>
                                            </h6>
                                            <small><%= dateFormat.format(prescription.getPrescriptionDate()) %></small>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <div class="d-flex align-items-center mb-2">
                                                <div class="avatar bg-success text-white rounded-circle me-2 d-flex align-items-center justify-content-center" style="width: 35px; height: 35px;">
                                                    <i class="fas fa-user-md"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-semibold">Dr. <%= prescription.getDoctorName() %></div>
                                                    <small class="text-muted"><%= prescription.getDoctorSpecialization() %></small>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">DIAGNOSIS</label>
                                            <p class="mb-0"><%= prescription.getDiagnosis() %></p>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">MEDICATIONS</label>
                                            <div class="prescription-medications">
                                                <%= prescription.getMedications().replace("\n", "<br>") %>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">INSTRUCTIONS</label>
                                            <p class="mb-0 text-info"><%= prescription.getInstructions() %></p>
                                        </div>
                                        
                                        <% if (prescription.getNotes() != null && !prescription.getNotes().trim().isEmpty()) { %>
                                        <div class="mb-3">
                                            <label class="form-label text-muted small fw-bold">ADDITIONAL NOTES</label>
                                            <p class="mb-0 text-secondary"><%= prescription.getNotes() %></p>
                                        </div>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="text-center py-5">
                        <div class="mb-4">
                            <i class="fas fa-prescription-bottle-alt fa-5x text-muted"></i>
                        </div>
                        <h4 class="text-muted mb-3">No Prescriptions Yet</h4>
                        <p class="text-muted mb-4">Your prescriptions will appear here after doctor consultations.</p>
                        <a href="../patient/appointments?action=book" class="btn btn-primary">
                            <i class="fas fa-calendar-plus me-2"></i>Book an Appointment
                        </a>
                    </div>
                <% } %>
            </main>
        </div>
    </div>

    

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let currentPrescriptionId = null;

        function viewPrescription(prescriptionId) {
            currentPrescriptionId = prescriptionId;
            
            // Find the prescription card
            const prescriptionCards = document.querySelectorAll('.prescription-card');
            let prescriptionData = null;
            
            prescriptionCards.forEach(card => {
                const cardId = card.querySelector('.card-header h6').textContent.match(/\d+/)[0];
                if (cardId == prescriptionId) {
                    prescriptionData = {
                        id: prescriptionId,
                        date: card.querySelector('.card-header small').textContent,
                        doctor: card.querySelector('.fw-semibold').textContent,
                        specialization: card.querySelector('.text-muted').textContent,
                        diagnosis: card.querySelector('.prescription-medications').previousElementSibling.previousElementSibling.textContent,
                        medications: card.querySelector('.prescription-medications').innerHTML,
                        instructions: card.querySelector('.text-info').textContent,
                        notes: card.querySelector('.text-secondary') ? card.querySelector('.text-secondary').textContent : 'None'
                    };
                }
            });
            
            if (prescriptionData) {
                document.getElementById('prescriptionDetails').innerHTML = `
                    <div class="prescription-view">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6 class="text-primary">Prescription #${prescriptionData.id}</h6>
                                <p class="text-muted">Date: ${prescriptionData.date}</p>
                            </div>
                            <div class="col-md-6 text-md-end">
                                <h6 class="text-success">${prescriptionData.doctor}</h6>
                                <p class="text-muted">${prescriptionData.specialization}</p>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <h6 class="text-primary border-bottom pb-2">Diagnosis</h6>
                            <p>${prescriptionData.diagnosis}</p>
                        </div>
                        
                        <div class="mb-4">
                            <h6 class="text-primary border-bottom pb-2">Medications</h6>
                            <div class="bg-light p-3 rounded">${prescriptionData.medications}</div>
                        </div>
                        
                        <div class="mb-4">
                            <h6 class="text-primary border-bottom pb-2">Instructions</h6>
                            <div class="alert alert-info">${prescriptionData.instructions}</div>
                        </div>
                        
                        <div class="mb-4">
                            <h6 class="text-primary border-bottom pb-2">Additional Notes</h6>
                            <p class="text-muted">${prescriptionData.notes}</p>
                        </div>
                    </div>
                `;
                
                // Update download button
                document.getElementById('downloadPrescriptionBtn').onclick = function() {
                    window.location.href = '../patient/prescriptions?action=download&id=' + prescriptionId;
                };
            }
        }
    </script>

    <style>
        .prescription-card {
            transition: transform 0.2s ease-in-out;
            border: 1px solid #dee2e6;
        }
        
        .prescription-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .prescription-medications {
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            border-left: 4px solid #007bff;
            font-family: monospace;
            white-space: pre-line;
        }
        
        .prescription-view h6 {
            color: #495057;
            font-weight: 600;
        }
        
        .avatar {
            flex-shrink: 0;
        }
    </style>
</body>
</html>
