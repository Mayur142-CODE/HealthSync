<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Patient" %>
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
    <title>My Profile - HealthSync</title>
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
                        <small class="text-white-50">Patient</small>
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
                            <a class="nav-link active" href="../patient/profile">
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
                        <i class="fas fa-user-cog me-2"></i>My Profile
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="dropdown">
                            <button class="btn btn-primary dropdown-toggle" type="button" data-bs-toggle="dropdown">
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

                <!-- Profile Information -->
                <div class="row">
                    <div class="col-lg-8">
                        <div class="card card-modern mb-4">
                            <div class="card-header card-header-modern">
                                <h5 class="mb-0">
                                    <i class="fas fa-user-edit me-2"></i>Profile Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <form id="profileForm" action="../patient/profile" method="POST">
                                    <input type="hidden" name="action" value="updateProfile">
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="firstName" class="form-label">First Name <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="firstName" name="firstName" 
                                                   value="<%= patient.getFirstName() %>" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="lastName" class="form-label">Last Name <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="lastName" name="lastName" 
                                                   value="<%= patient.getLastName() %>" required>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="email" class="form-label">Email</label>
                                            <input type="email" class="form-control" id="email" 
                                                   value="<%= patient.getEmail() %>" readonly disabled>
                                            <small class="text-muted">Email cannot be changed</small>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="phone" class="form-label">Phone <span class="text-danger">*</span></label>
                                            <input type="tel" class="form-control" id="phone" name="phone" 
                                                   value="<%= patient.getPhone() %>" required>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="dateOfBirth" class="form-label">Date of Birth</label>
                                            <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" 
                                                   value="<%= patient.getDateOfBirth() != null ? patient.getDateOfBirth() : "" %>">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="gender" class="form-label">Gender <span class="text-danger">*</span></label>
                                            <select class="form-select" id="gender" name="gender" required>
                                                <option value="">Select Gender</option>
                                                <option value="Male" <%= "Male".equals(patient.getGender()) ? "selected" : "" %>>Male</option>
                                                <option value="Female" <%= "Female".equals(patient.getGender()) ? "selected" : "" %>>Female</option>
                                                <option value="Other" <%= "Other".equals(patient.getGender()) ? "selected" : "" %>>Other</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="bloodGroup" class="form-label">Blood Group</label>
                                            <select class="form-select" id="bloodGroup" name="bloodGroup">
                                                <option value="">Select Blood Group</option>
                                                <option value="A+" <%= "A+".equals(patient.getBloodGroup()) ? "selected" : "" %>>A+</option>
                                                <option value="A-" <%= "A-".equals(patient.getBloodGroup()) ? "selected" : "" %>>A-</option>
                                                <option value="B+" <%= "B+".equals(patient.getBloodGroup()) ? "selected" : "" %>>B+</option>
                                                <option value="B-" <%= "B-".equals(patient.getBloodGroup()) ? "selected" : "" %>>B-</option>
                                                <option value="AB+" <%= "AB+".equals(patient.getBloodGroup()) ? "selected" : "" %>>AB+</option>
                                                <option value="AB-" <%= "AB-".equals(patient.getBloodGroup()) ? "selected" : "" %>>AB-</option>
                                                <option value="O+" <%= "O+".equals(patient.getBloodGroup()) ? "selected" : "" %>>O+</option>
                                                <option value="O-" <%= "O-".equals(patient.getBloodGroup()) ? "selected" : "" %>>O-</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="emergencyContact" class="form-label">Emergency Contact</label>
                                            <input type="tel" class="form-control" id="emergencyContact" name="emergencyContact" 
                                                   value="<%= patient.getEmergencyContact() != null ? patient.getEmergencyContact() : "" %>">
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="address" class="form-label">Address</label>
                                        <textarea class="form-control" id="address" name="address" rows="3"><%= patient.getAddress() != null ? patient.getAddress() : "" %></textarea>
                                    </div>

                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <button type="reset" class="btn btn-secondary">
                                            <i class="fas fa-undo me-1"></i>Reset
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-1"></i>Update Profile
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Change Password -->
                    <div class="col-lg-4">
                        <div class="card card-modern mb-4">
                            <div class="card-header card-header-modern">
                                <h5 class="mb-0">
                                    <i class="fas fa-lock me-2"></i>Change Password
                                </h5>
                            </div>
                            <div class="card-body">
                                <form id="passwordForm" action="../patient/profile" method="POST">
                                    <input type="hidden" name="action" value="changePassword">
                                    
                                    <div class="mb-3">
                                        <label for="currentPassword" class="form-label">Current Password <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="newPassword" class="form-label">New Password <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                               minlength="6" required>
                                        <small class="text-muted">Minimum 6 characters</small>
                                    </div>

                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">Confirm Password <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                               minlength="6" required>
                                    </div>

                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-warning">
                                            <i class="fas fa-key me-1"></i>Change Password
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Account Info -->
                        <div class="card card-modern">
                            <div class="card-header card-header-modern">
                                <h5 class="mb-0">
                                    <i class="fas fa-info-circle me-2"></i>Account Info
                                </h5>
                            </div>
                            <div class="card-body">
                                <p class="mb-2"><strong>Patient ID:</strong> <%= patient.getPatientId() %></p>
                                <p class="mb-2"><strong>Status:</strong> 
                                    <span class="badge bg-success"><%= patient.getStatus() %></span>
                                </p>
                                <p class="mb-0"><strong>Registered:</strong> <%= patient.getRegistrationDate() %></p>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Password confirmation validation
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('New passwords do not match!');
                return false;
            }
        });

        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>
