<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - HealthSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-lg border-0 rounded-4">
                    <div class="card-body p-5 text-center">
                        <!-- Error Icon -->
                        <div class="mb-4">
                            <i class="fas fa-exclamation-triangle fa-4x text-warning"></i>
                        </div>

                        <!-- Error Message -->
                        <h2 class="fw-bold text-danger mb-3">Oops! Something went wrong</h2>
                        
                        <% 
                            String errorCode = request.getParameter("code");
                            if (errorCode == null) {
                                errorCode = String.valueOf(response.getStatus());
                            }
                            
                            String errorMessage = "";
                            String errorDescription = "";
                            
                            switch(errorCode) {
                                case "404":
                                    errorMessage = "Page Not Found";
                                    errorDescription = "The page you're looking for doesn't exist or has been moved.";
                                    break;
                                case "500":
                                    errorMessage = "Internal Server Error";
                                    errorDescription = "We're experiencing some technical difficulties. Please try again later.";
                                    break;
                                case "403":
                                    errorMessage = "Access Forbidden";
                                    errorDescription = "You don't have permission to access this resource.";
                                    break;
                                default:
                                    errorMessage = "Unexpected Error";
                                    errorDescription = "An unexpected error occurred. Please contact support if the problem persists.";
                            }
                        %>
                        
                        <div class="alert alert-danger" role="alert">
                            <h5 class="alert-heading">
                                <i class="fas fa-times-circle me-2"></i>Error <%= errorCode %>: <%= errorMessage %>
                            </h5>
                            <p class="mb-0"><%= errorDescription %></p>
                        </div>

                        <!-- Exception Details (for development) -->
                        <% if (exception != null) { %>
                            <div class="alert alert-warning mt-3" role="alert">
                                <h6 class="alert-heading">
                                    <i class="fas fa-bug me-2"></i>Technical Details
                                </h6>
                                <small class="text-muted">
                                    <%= exception.getClass().getSimpleName() %>: <%= exception.getMessage() %>
                                </small>
                            </div>
                        <% } %>

                        <!-- Action Buttons -->
                        <div class="mt-4">
                            <button onclick="history.back()" class="btn btn-outline-primary me-2">
                                <i class="fas fa-arrow-left me-1"></i>Go Back
                            </button>
                            <a href="index.jsp" class="btn btn-primary">
                                <i class="fas fa-home me-1"></i>Home Page
                            </a>
                        </div>

                        <!-- Contact Support -->
                        <div class="mt-4 pt-3 border-top">
                            <p class="text-muted mb-2">Need help?</p>
                            <small class="text-muted">
                                If this problem persists, please contact our support team.
                            </small>
                        </div>

                        <!-- HealthSync Branding -->
                        <div class="mt-4">
                            <h5 class="text-primary mb-1">
                                <i class="fas fa-heartbeat me-2"></i>HealthSync
                            </h5>
                            <small class="text-muted">Where Doctors, Patients & Data Sync Together</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Auto-refresh for 500 errors -->
    <% if ("500".equals(errorCode)) { %>
        <script>
            // Auto-refresh after 30 seconds for server errors
            setTimeout(function() {
                if (confirm('Would you like to try refreshing the page?')) {
                    window.location.reload();
                }
            }, 30000);
        </script>
    <% } %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
