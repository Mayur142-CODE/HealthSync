<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Registration - HealthSync</title>
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
                                <i class="fas fa-user-plus fa-3x text-primary"></i>
                            </div>
                            <h2 class="fw-bold text-primary">Patient Registration</h2>
                            <p class="text-muted">Join HealthSync for better healthcare management</p>
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
                        <form action="register" method="post" id="registerForm">
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

                            <!-- Personal Details -->
                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label for="dateOfBirth" class="form-label fw-semibold">
                                        <i class="fas fa-calendar me-2"></i>Date of Birth *
                                    </label>
                                    <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="gender" class="form-label fw-semibold">
                                        <i class="fas fa-venus-mars me-2"></i>Gender *
                                    </label>
                                    <select class="form-select" id="gender" name="gender" required>
                                        <option value="">Select Gender</option>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="bloodGroup" class="form-label fw-semibold">
                                    <i class="fas fa-tint me-2"></i>Blood Group *
                                </label>
                                <select class="form-select" id="bloodGroup" name="bloodGroup" required>
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

                            <!-- Address -->
                            <div class="mb-3">
                                <label for="address" class="form-label fw-semibold">
                                    <i class="fas fa-map-marker-alt me-2"></i>Address
                                </label>
                                <textarea class="form-control" id="address" name="address" rows="3" 
                                          placeholder="Enter your address"></textarea>
                            </div>

                            <!-- Emergency Contact -->
                            <div class="mb-4">
                                <label for="emergencyContact" class="form-label fw-semibold">
                                    <i class="fas fa-phone-alt me-2"></i>Emergency Contact
                                </label>
                                <input type="tel" class="form-control" id="emergencyContact" name="emergencyContact" 
                                       placeholder="Emergency contact number">
                            </div>

                            <!-- Terms and Conditions -->
                            <div class="mb-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="terms" required>
                                    <label class="form-check-label" for="terms">
                                        I agree to the <a href="#" class="text-primary">Terms and Conditions</a> 
                                        and <a href="#" class="text-primary">Privacy Policy</a>
                                    </label>
                                </div>
                            </div>

                            <!-- Register Button -->
                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-user-plus me-2"></i>Register
                                </button>
                            </div>
                        </form>

                        <!-- Footer Links -->
                        <div class="text-center">
                            <p class="text-muted mb-2">Already have an account?</p>
                            <a href="login.jsp" class="btn btn-outline-primary">
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
        document.getElementById('registerForm').addEventListener('submit', function(e) {
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

        // Set max date for date of birth (18 years ago)
        const today = new Date();
        const maxDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
        document.getElementById('dateOfBirth').max = maxDate.toISOString().split('T')[0];
    </script>
</body>
</html>
