<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Registration - HealthSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-lg border-0 rounded-4">
                    <div class="card-body p-5">
                        <!-- Header -->
                        <div class="text-center mb-4">
                            <div class="mb-3">
                                <i class="fas fa-user-md fa-3x text-success"></i>
                            </div>
                            <h2 class="fw-bold text-success">Doctor Registration</h2>
                            <p class="text-muted">Join HealthSync as a healthcare provider</p>
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

                        <!-- Registration Form -->
                        <form action="doctor-register" method="post" id="doctorRegisterForm">
                            <!-- Personal Information -->
                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label for="firstName" class="form-label fw-semibold">
                                        <i class="fas fa-user me-2"></i>First Name *
                                    </label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" 
                                           placeholder="Enter first name" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="lastName" class="form-label fw-semibold">Last Name *</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" 
                                           placeholder="Enter last name" required>
                                </div>
                            </div>

                            <!-- Contact Information -->
                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold">
                                    <i class="fas fa-envelope me-2"></i>Email Address *
                                </label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       placeholder="Enter email address" required>
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="form-label fw-semibold">
                                    <i class="fas fa-phone me-2"></i>Phone Number *
                                </label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       placeholder="Enter phone number" required>
                            </div>

                            <!-- Password Fields -->
                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label for="password" class="form-label fw-semibold">
                                        <i class="fas fa-lock me-2"></i>Password *
                                    </label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="password" name="password" 
                                               placeholder="Enter password" required minlength="6">
                                        <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="form-text">Minimum 6 characters</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="confirmPassword" class="form-label fw-semibold">Confirm Password *</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                           placeholder="Confirm password" required>
                                </div>
                            </div>

                            <!-- Professional Information -->
                            <div class="mb-3">
                                <label for="specialization" class="form-label fw-semibold">
                                    <i class="fas fa-stethoscope me-2"></i>Specialization *
                                </label>
                                <select class="form-select" id="specialization" name="specialization" required>
                                    <option value="">Select Specialization</option>
                                    <option value="General Medicine">General Medicine</option>
                                    <option value="Cardiology">Cardiology</option>
                                    <option value="Dermatology">Dermatology</option>
                                    <option value="Endocrinology">Endocrinology</option>
                                    <option value="Gastroenterology">Gastroenterology</option>
                                    <option value="Neurology">Neurology</option>
                                    <option value="Oncology">Oncology</option>
                                    <option value="Orthopedics">Orthopedics</option>
                                    <option value="Pediatrics">Pediatrics</option>
                                    <option value="Psychiatry">Psychiatry</option>
                                    <option value="Pulmonology">Pulmonology</option>
                                    <option value="Radiology">Radiology</option>
                                    <option value="Surgery">Surgery</option>
                                    <option value="Urology">Urology</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="qualification" class="form-label fw-semibold">
                                    <i class="fas fa-graduation-cap me-2"></i>Qualification *
                                </label>
                                <input type="text" class="form-control" id="qualification" name="qualification" 
                                       placeholder="e.g., MBBS, MD, MS" required>
                            </div>

                            <div class="mb-3">
                                <label for="experience" class="form-label fw-semibold">
                                    <i class="fas fa-calendar-alt me-2"></i>Experience (Years) *
                                </label>
                                <input type="number" class="form-control" id="experience" name="experience" 
                                       placeholder="Years of experience" min="0" max="50" required>
                            </div>

                            <!-- Address -->
                            <div class="mb-4">
                                <label for="address" class="form-label fw-semibold">
                                    <i class="fas fa-map-marker-alt me-2"></i>Clinic/Hospital Address
                                </label>
                                <textarea class="form-control" id="address" name="address" rows="3" 
                                          placeholder="Enter your clinic or hospital address"></textarea>
                            </div>

                            <!-- Terms and Conditions -->
                            <div class="mb-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="terms" required>
                                    <label class="form-check-label" for="terms">
                                        I agree to the <a href="#" class="text-success">Terms and Conditions</a> 
                                        and <a href="#" class="text-success">Privacy Policy</a>
                                    </label>
                                </div>
                            </div>

                            <!-- Register Button -->
                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-success btn-lg">
                                    <i class="fas fa-user-md me-2"></i>Register as Doctor
                                </button>
                            </div>
                        </form>

                        <!-- Footer Links -->
                        <div class="text-center">
                            <p class="text-muted mb-2">Already have an account?</p>
                            <a href="login.jsp" class="btn btn-outline-success">
                                <i class="fas fa-sign-in-alt me-2"></i>Login Here
                            </a>
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

        // Form validation
        document.getElementById('doctorRegisterForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long!');
                return false;
            }
        });

        // Real-time password confirmation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (confirmPassword && password !== confirmPassword) {
                this.setCustomValidity('Passwords do not match');
                this.classList.add('is-invalid');
            } else {
                this.setCustomValidity('');
                this.classList.remove('is-invalid');
            }
        });
    </script>
</body>
</html>
