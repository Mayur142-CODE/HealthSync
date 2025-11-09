<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Admin" %>
<%@ page import="model.Doctor" %>
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
    <title>Manage Doctors - HealthSync</title>
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
                            <a class="nav-link" href="../admin/dashboard">
                                <i class="fas fa-tachometer-alt"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="../admin/doctors">
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
                        <i class="fas fa-user-md me-2"></i>Manage Doctors
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addDoctorModal">
                            <i class="fas fa-plus me-1"></i>Add New Doctor
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

                <!-- Search and Filter -->
                <div class="card card-modern mb-4">
                    <div class="card-body">
                        <form method="get" action="doctors">
                            <input type="hidden" name="action" value="search">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-8">
                                    <label for="search" class="form-label">Search Doctors</label>
                                    <input type="text" class="form-control" id="search" name="search" 
                                           placeholder="Search by name, email, or specialization..."
                                           value="<%= request.getAttribute("searchTerm") != null ? request.getAttribute("searchTerm") : "" %>">
                                </div>
                                <div class="col-md-4">
                                    <div class="d-grid gap-2 d-md-flex">
                                        <button type="submit" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Search
                                        </button>
                                        <a href="doctors" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Clear
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Doctors Table -->
                <div class="card card-modern">
                    <div class="card-header card-header-modern">
                        <h5 class="mb-0">
                            <i class="fas fa-list me-2"></i>Doctors List
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <% 
                            List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
                            if (doctors != null && !doctors.isEmpty()) {
                        %>
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Doctor</th>
                                            <th>Specialization</th>
                                            <th>Qualification</th>
                                            <th>Experience</th>
                                            <th>Contact</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Doctor doctor : doctors) { %>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar bg-primary text-white rounded-circle me-3 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                                            <i class="fas fa-user-md"></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-semibold">Dr. <%= doctor.getFullName() %></div>
                                                            <small class="text-muted"><%= doctor.getEmail() %></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge bg-info"><%= doctor.getSpecialization() %></span>
                                                </td>
                                                <td><%= doctor.getQualification() %></td>
                                                <td><%= doctor.getExperience() %> years</td>
                                                <td>
                                                    <div>
                                                        <small class="text-muted d-block">
                                                            <i class="fas fa-phone me-1"></i><%= doctor.getPhone() %>
                                                        </small>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge bg-<%= "active".equals(doctor.getStatus()) ? "success" : "secondary" %>">
                                                        <%= doctor.getStatus().toUpperCase() %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="btn-group btn-group-sm">
                                                        <button type="button" class="btn btn-outline-primary edit-doctor-btn" 
                                                                data-doctor-id="<%= doctor.getDoctorId() %>"
                                                                data-doctor-firstname="<%= doctor.getFirstName() %>"
                                                                data-doctor-lastname="<%= doctor.getLastName() %>"
                                                                data-doctor-email="<%= doctor.getEmail() %>"
                                                                data-doctor-phone="<%= doctor.getPhone() %>"
                                                                data-doctor-specialization="<%= doctor.getSpecialization() %>"
                                                                data-doctor-qualification="<%= doctor.getQualification() %>"
                                                                data-doctor-experience="<%= doctor.getExperience() %>"
                                                                data-doctor-address="<%= doctor.getAddress() != null ? doctor.getAddress() : "" %>"
                                                                data-doctor-status="<%= doctor.getStatus() %>"
                                                                data-bs-toggle="modal" data-bs-target="#editDoctorModal">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <div class="btn-group">
                                                            <button type="button" class="btn btn-outline-warning btn-sm dropdown-toggle" data-bs-toggle="dropdown">
                                                                <i class="fas fa-ellipsis-v"></i>
                                                            </button>
                                                            <ul class="dropdown-menu">
                                                                <li>
                                                                    <a class="dropdown-item" href="doctors?action=delete&id=<%= doctor.getDoctorId() %>"
                                                                       onclick="return confirm('Are you sure you want to deactivate Dr. <%= doctor.getFullName() %>?')">
                                                                        <i class="fas fa-ban me-2 text-warning"></i>Deactivate
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="dropdown-item text-danger" href="doctors?action=permanentDelete&id=<%= doctor.getDoctorId() %>"
                                                                       onclick="return confirm('⚠️ WARNING: This will permanently delete Dr. <%= doctor.getFullName() %> and cannot be undone! Are you absolutely sure?')">
                                                                        <i class="fas fa-trash me-2"></i>Delete Permanently
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="text-center py-5">
                                <i class="fas fa-user-md fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No doctors found</h5>
                                <p class="text-muted">Add new doctors to get started.</p>
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addDoctorModal">
                                    <i class="fas fa-plus me-1"></i>Add First Doctor
                                </button>
                            </div>
                        <% } %>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Add Doctor Modal -->
    <div class="modal fade" id="addDoctorModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-user-plus me-2"></i>Add New Doctor
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="doctors" class="needs-validation" novalidate>
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="firstName" class="form-label">First Name *</label>
                                <input type="text" class="form-control" id="firstName" name="firstName" required>
                            </div>
                            <div class="col-md-6">
                                <label for="lastName" class="form-label">Last Name *</label>
                                <input type="text" class="form-control" id="lastName" name="lastName" required>
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email *</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Phone *</label>
                                <input type="tel" class="form-control" id="phone" name="phone" required>
                            </div>
                            <div class="col-md-6">
                                <label for="specialization" class="form-label">Specialization *</label>
                                <select class="form-select" id="specialization" name="specialization" required>
                                    <option value="">Select Specialization</option>
                                    <option value="Cardiology">Cardiology</option>
                                    <option value="Pediatrics">Pediatrics</option>
                                    <option value="Orthopedics">Orthopedics</option>
                                    <option value="Gynecology">Gynecology</option>
                                    <option value="Neurology">Neurology</option>
                                    <option value="Dermatology">Dermatology</option>
                                    <option value="General Medicine">General Medicine</option>
                                    <option value="Surgery">Surgery</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="experience" class="form-label">Experience (Years) *</label>
                                <input type="number" class="form-control" id="experience" name="experience" min="0" max="50" required>
                            </div>
                            <div class="col-12">
                                <label for="qualification" class="form-label">Qualification *</label>
                                <input type="text" class="form-control" id="qualification" name="qualification" 
                                       placeholder="e.g., MBBS, MD Cardiology" required>
                            </div>
                            <div class="col-12">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3"></textarea>
                            </div>
                            <div class="col-md-6">
                                <label for="password" class="form-label">Password *</label>
                                <input type="password" class="form-control" id="password" name="password" minlength="6" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Add Doctor
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Doctor Modal -->
    <div class="modal fade" id="editDoctorModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>Edit Doctor
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="doctors" id="editDoctorForm">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="doctorId" id="editDoctorId">
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="editFirstName" class="form-label">First Name *</label>
                                <input type="text" class="form-control" id="editFirstName" name="firstName" required>
                            </div>
                            <div class="col-md-6">
                                <label for="editLastName" class="form-label">Last Name *</label>
                                <input type="text" class="form-control" id="editLastName" name="lastName" required>
                            </div>
                            <div class="col-md-6">
                                <label for="editEmail" class="form-label">Email *</label>
                                <input type="email" class="form-control" id="editEmail" name="email" required>
                            </div>
                            <div class="col-md-6">
                                <label for="editPhone" class="form-label">Phone *</label>
                                <input type="tel" class="form-control" id="editPhone" name="phone" required>
                            </div>
                            <div class="col-md-6">
                                <label for="editSpecialization" class="form-label">Specialization *</label>
                                <select class="form-select" id="editSpecialization" name="specialization" required>
                                    <option value="Cardiology">Cardiology</option>
                                    <option value="Pediatrics">Pediatrics</option>
                                    <option value="Orthopedics">Orthopedics</option>
                                    <option value="Gynecology">Gynecology</option>
                                    <option value="Neurology">Neurology</option>
                                    <option value="Dermatology">Dermatology</option>
                                    <option value="General Medicine">General Medicine</option>
                                    <option value="Surgery">Surgery</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="editExperience" class="form-label">Experience (Years) *</label>
                                <input type="number" class="form-control" id="editExperience" name="experience" min="0" max="50" required>
                            </div>
                            <div class="col-12">
                                <label for="editQualification" class="form-label">Qualification *</label>
                                <input type="text" class="form-control" id="editQualification" name="qualification" required>
                            </div>
                            <div class="col-12">
                                <label for="editAddress" class="form-label">Address</label>
                                <textarea class="form-control" id="editAddress" name="address" rows="3"></textarea>
                            </div>
                            <div class="col-md-6">
                                <label for="editStatus" class="form-label">Status</label>
                                <select class="form-select" id="editStatus" name="status">
                                    <option value="active">Active</option>
                                    <option value="inactive">Inactive</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Update Doctor
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../assets/js/main.js"></script>
    <script>
        // Event listeners for edit buttons
        document.addEventListener('DOMContentLoaded', function() {
            // Edit doctor buttons
            document.querySelectorAll('.edit-doctor-btn').forEach(button => {
                button.addEventListener('click', function() {
                    // Get doctor data from button attributes
                    const doctorId = this.getAttribute('data-doctor-id');
                    const firstName = this.getAttribute('data-doctor-firstname');
                    const lastName = this.getAttribute('data-doctor-lastname');
                    const email = this.getAttribute('data-doctor-email');
                    const phone = this.getAttribute('data-doctor-phone');
                    const specialization = this.getAttribute('data-doctor-specialization');
                    const qualification = this.getAttribute('data-doctor-qualification');
                    const experience = this.getAttribute('data-doctor-experience');
                    const address = this.getAttribute('data-doctor-address');
                    const status = this.getAttribute('data-doctor-status');

                    // Populate edit modal fields
                    document.getElementById('editDoctorId').value = doctorId;
                    document.getElementById('editFirstName').value = firstName;
                    document.getElementById('editLastName').value = lastName;
                    document.getElementById('editEmail').value = email;
                    document.getElementById('editPhone').value = phone;
                    document.getElementById('editSpecialization').value = specialization;
                    document.getElementById('editQualification').value = qualification;
                    document.getElementById('editExperience').value = experience;
                    document.getElementById('editAddress').value = address;
                    document.getElementById('editStatus').value = status;
                });
            });
        });

        // Form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();

        // Auto-hide alerts
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>
