<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Admin" %>
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
                        <small class="text-white-50">Admin Portal</small>
                    </div>
                    
                    <!-- Admin Info -->
                    <div class="text-center mb-4 p-3 bg-white bg-opacity-10 rounded">
                        <div class="avatar bg-white text-primary rounded-circle mx-auto mb-2 d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                            <i class="fas fa-user-shield fa-lg"></i>
                        </div>
                        <h6 class="text-white mb-1"><%= admin.getFullName() %></h6>
                        <small class="text-white-50">Administrator</small>
                    </div>
                    
                    <!-- Navigation -->
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="../admin/dashboard">
                                <i class="fas fa-tachometer-alt"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../admin/patients">
                                <i class="fas fa-users"></i>Manage Patients
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../admin/doctors">
                                <i class="fas fa-user-md"></i>Manage Doctors
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="../admin/appointments">
                                <i class="fas fa-calendar-check"></i>Appointments
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="../admin/profile">
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
                        <i class="fas fa-user-cog me-2"></i>My Profile
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="dropdown">
                            <button class="btn btn-primary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-shield me-1"></i><%= admin.getUsername() %>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="../admin/profile">
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
                                <form id="profileForm" action="../admin/profile" method="POST">
                                    <input type="hidden" name="action" value="updateProfile">
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="username" class="form-label">Username</label>
                                            <input type="text" class="form-control" id="username" 
                                                   value="<%= admin.getUsername() %>" readonly disabled>
                                            <small class="text-muted">Username cannot be changed</small>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="email" class="form-label">Email</label>
                                            <input type="email" class="form-control" id="email" 
                                                   value="<%= admin.getEmail() %>" readonly disabled>
                                            <small class="text-muted">Email cannot be changed</small>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                                   value="<%= admin.getFullName() %>" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="phone" class="form-label">Phone <span class="text-danger">*</span></label>
                                            <input type="tel" class="form-control" id="phone" name="phone" 
                                                   value="<%= admin.getPhone() %>" required>
                                        </div>
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
                                <form id="passwordForm" action="../admin/profile" method="POST">
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
                                <p class="mb-2"><strong>Admin ID:</strong> <%= admin.getAdminId() %></p>
                                <p class="mb-2"><strong>Status:</strong> 
                                    <span class="badge bg-success"><%= admin.getStatus() %></span>
                                </p>
                                <p class="mb-0"><strong>Created:</strong> <%= admin.getCreatedAt() %></p>
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
