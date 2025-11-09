<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Admin" %>
<%@ page import="model.Patient" %>
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
    <title>Manage Patients - HealthSync</title>
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
                            <a class="nav-link active" href="patients">
                                <i class="fas fa-users"></i>Manage Patients
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="appointments">
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
                        <i class="fas fa-users me-2"></i>Manage Patients
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPatientModal">
                            <i class="fas fa-plus me-1"></i>Add New Patient
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

                <!-- Search Bar -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <form action="patients" method="get" class="d-flex">
                            <input type="hidden" name="action" value="search">
                            <input type="text" class="form-control me-2" name="search" placeholder="Search patients..." 
                                   value="<%= request.getAttribute("searchTerm") != null ? request.getAttribute("searchTerm") : "" %>">
                            <button class="btn btn-outline-primary" type="submit">
                                <i class="fas fa-search"></i>
                            </button>
                        </form>
                    </div>
                    <div class="col-md-6 text-end">
                        <a href="patients" class="btn btn-outline-secondary">
                            <i class="fas fa-refresh me-1"></i>Show All
                        </a>
                    </div>
                </div>

                <!-- Patients Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-primary">
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Phone</th>
                                        <th>Gender</th>
                                        <th>Blood Group</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<Patient> patients = (List<Patient>) request.getAttribute("patients");
                                        if (patients != null && !patients.isEmpty()) {
                                            for (Patient patient : patients) {
                                    %>
                                    <tr>
                                        <td><%= patient.getPatientId() %></td>
                                        <td>
                                            <strong><%= patient.getFullName() %></strong>
                                        </td>
                                        <td><%= patient.getEmail() %></td>
                                        <td><%= patient.getPhone() %></td>
                                        <td><%= patient.getGender() %></td>
                                        <td>
                                            <span class="badge bg-info"><%= patient.getBloodGroup() %></span>
                                        </td>
                                        <td>
                                            <% if ("active".equals(patient.getStatus())) { %>
                                                <span class="badge bg-success">Active</span>
                                            <% } else { %>
                                                <span class="badge bg-secondary">Inactive</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <button type="button" class="btn btn-outline-primary edit-patient-btn" 
                                                        data-patient-id="<%= patient.getPatientId() %>"
                                                        data-patient-firstname="<%= patient.getFirstName() %>"
                                                        data-patient-lastname="<%= patient.getLastName() %>"
                                                        data-patient-email="<%= patient.getEmail() %>"
                                                        data-patient-phone="<%= patient.getPhone() %>"
                                                        data-patient-dob="<%= patient.getDateOfBirth() %>"
                                                        data-patient-gender="<%= patient.getGender() %>"
                                                        data-patient-bloodgroup="<%= patient.getBloodGroup() %>"
                                                        data-patient-address="<%= patient.getAddress() != null ? patient.getAddress() : "" %>"
                                                        data-patient-emergency="<%= patient.getEmergencyContact() != null ? patient.getEmergencyContact() : "" %>"
                                                        data-patient-history="<%= patient.getMedicalHistory() != null ? patient.getMedicalHistory() : "" %>"
                                                        data-patient-status="<%= patient.getStatus() %>"
                                                        data-bs-toggle="modal" data-bs-target="#editPatientModal">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <div class="btn-group">
                                                    <button type="button" class="btn btn-outline-warning btn-sm dropdown-toggle" data-bs-toggle="dropdown">
                                                        <i class="fas fa-ellipsis-v"></i>
                                                    </button>
                                                    <ul class="dropdown-menu">
                                                        <% if ("active".equals(patient.getStatus())) { %>
                                                        <li>
                                                            <a class="dropdown-item" href="patients?action=delete&id=<%= patient.getPatientId() %>"
                                                               onclick="return confirm('Are you sure you want to deactivate this patient?')">
                                                                <i class="fas fa-ban me-2 text-warning"></i>Deactivate
                                                            </a>
                                                        </li>
                                                        <% } %>
                                                        <li>
                                                            <a class="dropdown-item text-danger" href="patients?action=permanentDelete&id=<%= patient.getPatientId() %>"
                                                               onclick="return confirm('⚠️ WARNING: This will permanently delete this patient and cannot be undone! Are you absolutely sure?')">
                                                                <i class="fas fa-trash me-2"></i>Delete Permanently
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="8" class="text-center text-muted py-4">
                                            <i class="fas fa-users fa-3x mb-3"></i>
                                            <br>No patients found
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

    <!-- Add Patient Modal -->
    <div class="modal fade" id="addPatientModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Patient</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="patients" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">First Name *</label>
                                <input type="text" class="form-control" name="firstName" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Last Name *</label>
                                <input type="text" class="form-control" name="lastName" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email *</label>
                                <input type="email" class="form-control" name="email" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phone *</label>
                                <input type="tel" class="form-control" name="phone" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Password *</label>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Date of Birth *</label>
                                <input type="date" class="form-control" name="dateOfBirth" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Gender *</label>
                                <select class="form-select" name="gender" required>
                                    <option value="">Select Gender</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Blood Group *</label>
                                <select class="form-select" name="bloodGroup" required>
                                    <option value="">Select Blood Group</option>
                                    <option value="A+">A+</option>
                                    <option value="A-">A-</option>
                                    <option value="B+">B+</option>
                                    <option value="B-">B-</option>
                                    <option value="AB+">AB+</option>
                                    <option value="AB-">AB-</option>
                                    <option value="O+">O+</option>
                                    <option value="O-">O-</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Address</label>
                                <textarea class="form-control" name="address" rows="2"></textarea>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Emergency Contact</label>
                                <input type="tel" class="form-control" name="emergencyContact">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Medical History</label>
                                <textarea class="form-control" name="medicalHistory" rows="2"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Patient</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Patient Modal -->
    <div class="modal fade" id="editPatientModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>Edit Patient
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="patients" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="patientId" id="editPatientId">
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">First Name *</label>
                                <input type="text" class="form-control" name="firstName" id="editFirstName" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Last Name *</label>
                                <input type="text" class="form-control" name="lastName" id="editLastName" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email *</label>
                                <input type="email" class="form-control" name="email" id="editEmail" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Phone *</label>
                                <input type="tel" class="form-control" name="phone" id="editPhone" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Date of Birth *</label>
                                <input type="date" class="form-control" name="dateOfBirth" id="editDateOfBirth" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Gender *</label>
                                <select class="form-select" name="gender" id="editGender" required>
                                    <option value="">Select Gender</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Blood Group *</label>
                                <select class="form-select" name="bloodGroup" id="editBloodGroup" required>
                                    <option value="">Select Blood Group</option>
                                    <option value="A+">A+</option>
                                    <option value="A-">A-</option>
                                    <option value="B+">B+</option>
                                    <option value="B-">B-</option>
                                    <option value="AB+">AB+</option>
                                    <option value="AB-">AB-</option>
                                    <option value="O+">O+</option>
                                    <option value="O-">O-</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Status</label>
                                <select class="form-select" name="status" id="editStatus">
                                    <option value="active">Active</option>
                                    <option value="inactive">Inactive</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Address</label>
                                <textarea class="form-control" name="address" id="editAddress" rows="2"></textarea>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Emergency Contact</label>
                                <input type="tel" class="form-control" name="emergencyContact" id="editEmergencyContact">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Medical History</label>
                                <textarea class="form-control" name="medicalHistory" id="editMedicalHistory" rows="2"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Update Patient
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Event listeners for edit buttons
        document.addEventListener('DOMContentLoaded', function() {
            // Edit patient buttons
            document.querySelectorAll('.edit-patient-btn').forEach(button => {
                button.addEventListener('click', function() {
                    // Get patient data from button attributes
                    const patientId = this.getAttribute('data-patient-id');
                    const firstName = this.getAttribute('data-patient-firstname');
                    const lastName = this.getAttribute('data-patient-lastname');
                    const email = this.getAttribute('data-patient-email');
                    const phone = this.getAttribute('data-patient-phone');
                    const dob = this.getAttribute('data-patient-dob');
                    const gender = this.getAttribute('data-patient-gender');
                    const bloodGroup = this.getAttribute('data-patient-bloodgroup');
                    const address = this.getAttribute('data-patient-address');
                    const emergency = this.getAttribute('data-patient-emergency');
                    const history = this.getAttribute('data-patient-history');
                    const status = this.getAttribute('data-patient-status');

                    // Populate edit modal fields
                    document.getElementById('editPatientId').value = patientId;
                    document.getElementById('editFirstName').value = firstName;
                    document.getElementById('editLastName').value = lastName;
                    document.getElementById('editEmail').value = email;
                    document.getElementById('editPhone').value = phone;
                    document.getElementById('editDateOfBirth').value = dob;
                    document.getElementById('editGender').value = gender;
                    document.getElementById('editBloodGroup').value = bloodGroup;
                    document.getElementById('editAddress').value = address;
                    document.getElementById('editEmergencyContact').value = emergency;
                    document.getElementById('editMedicalHistory').value = history;
                    document.getElementById('editStatus').value = status;
                });
            });
        });
    </script>
</body>
</html>
