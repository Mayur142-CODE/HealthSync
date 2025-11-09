<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - HealthSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-lg border-0 rounded-4">
                    <div class="card-body p-5">
                        <!-- Header -->
                        <div class="text-center mb-4">
                            <div class="mb-3">
                                <i class="fas fa-heartbeat fa-3x text-primary"></i>
                            </div>
                            <h2 class="fw-bold text-primary">HealthSync</h2>
                            <p class="text-muted">Where Doctors, Patients & Data Sync Together</p>
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

                        <!-- Login Form -->
                        <form action="login" method="post" id="loginForm">
                            <!-- User Type Selection -->
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Login As</label>
                                <div class="row g-2">
                                    <div class="col-4">
                                        <input type="radio" class="btn-check" name="userType" id="admin" value="admin" autocomplete="off">
                                        <label class="btn btn-outline-primary w-100" for="admin">
                                            <i class="fas fa-user-shield d-block mb-1"></i>
                                            <small>Admin</small>
                                        </label>
                                    </div>
                                    <div class="col-4">
                                        <input type="radio" class="btn-check" name="userType" id="doctor" value="doctor" autocomplete="off" checked>
                                        <label class="btn btn-outline-primary w-100" for="doctor">
                                            <i class="fas fa-user-md d-block mb-1"></i>
                                            <small>Doctor</small>
                                        </label>
                                    </div>
                                    <div class="col-4">
                                        <input type="radio" class="btn-check" name="userType" id="patient" value="patient" autocomplete="off">
                                        <label class="btn btn-outline-primary w-100" for="patient">
                                            <i class="fas fa-user d-block mb-1"></i>
                                            <small>Patient</small>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Email Field -->
                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold">
                                    <i class="fas fa-envelope me-2"></i>Email Address
                                </label>
                                <input type="email" class="form-control form-control-lg" id="email" name="email" 
                                       placeholder="Enter your email" required>
                            </div>

                            <!-- Password Field -->
                            <div class="mb-4">
                                <label for="password" class="form-label fw-semibold">
                                    <i class="fas fa-lock me-2"></i>Password
                                </label>
                                <div class="input-group">
                                    <input type="password" class="form-control form-control-lg" id="password" 
                                           name="password" placeholder="Enter your password" required>
                                    <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- Login Button -->
                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-sign-in-alt me-2"></i>Login
                                </button>
                            </div>
                        </form>

                        

                        <!-- Footer Links -->
                        <div class="text-center mt-4">
                            <p class="text-muted mb-2">Don't have an account?</p>
                            <div class="row g-2">
                                <div class="col-md-4">
                                    <a href="register.jsp" class="btn btn-outline-primary btn-sm w-100">
                                        <i class="fas fa-user me-1"></i>Patient
                                    </a>
                                </div>
                                <div class="col-md-4">
                                    <a href="doctor-register.jsp" class="btn btn-outline-success btn-sm w-100">
                                        <i class="fas fa-user-md me-1"></i>Doctor
                                    </a>
                                </div>
                                <div class="col-md-4">
                                    <a href="admin-register.jsp" class="btn btn-outline-warning btn-sm w-100">
                                        <i class="fas fa-user-shield me-1"></i>Admin
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div class="text-center mt-3">
                            <a href="index.jsp" class="text-decoration-none text-muted">
                                <i class="fas fa-arrow-left me-2"></i>Back to Home
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle password visibility
        document.getElementById('togglePassword').addEventListener('click', function() {
            const password = document.getElementById('password');
            const icon = this.querySelector('i');
            
            if (password.type === 'password') {
                password.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                password.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });

        // Update email placeholder based on user type
        document.querySelectorAll('input[name="userType"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const emailInput = document.getElementById('email');
                const userType = this.value;
                
                switch(userType) {
                    case 'admin':
                        emailInput.placeholder = 'admin@healthsync.com';
                        break;
                    case 'doctor':
                        emailInput.placeholder = 'doctor@healthsync.com';
                        break;
                    case 'patient':
                        emailInput.placeholder = 'patient@email.com';
                        break;
                }
            });
        });

        // Form validation
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const userType = document.querySelector('input[name="userType"]:checked');
            if (!userType) {
                e.preventDefault();
                alert('Please select a user type');
                return false;
            }
        });
    </script>
</body>
</html>
