package servlet;

import dao.PatientDAO;
import model.Patient;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;

public class PatientProfileServlet extends HttpServlet {
    private PatientDAO patientDAO;
    
    @Override
    public void init() throws ServletException {
        patientDAO = new PatientDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patient") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        // Forward to profile page
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patient") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        Patient patient = (Patient) session.getAttribute("patient");
        String action = request.getParameter("action");
        
        // Check if request is AJAX
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        
        if ("updateProfile".equals(action)) {
            handleProfileUpdate(request, response, patient, session, isAjax);
        } else if ("changePassword".equals(action)) {
            handlePasswordChange(request, response, patient, isAjax);
        } else {
            if (isAjax) {
                sendJsonResponse(response, false, "Invalid action");
            } else {
                request.setAttribute("error", "Invalid action");
                request.getRequestDispatcher("profile.jsp").forward(request, response);
            }
        }
    }
    
    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, 
                                     Patient patient, HttpSession session, boolean isAjax) 
            throws ServletException, IOException {
        
        try {
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            String bloodGroup = request.getParameter("bloodGroup");
            String address = request.getParameter("address");
            String emergencyContact = request.getParameter("emergencyContact");
            
            // Validation
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                gender == null || gender.trim().isEmpty()) {
                
                if (isAjax) {
                    sendJsonResponse(response, false, "Required fields are missing");
                } else {
                    request.setAttribute("error", "Required fields are missing");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
                return;
            }
            
            // Parse date of birth
            Date dateOfBirth = null;
            if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
                try {
                    dateOfBirth = Date.valueOf(dateOfBirthStr);
                } catch (IllegalArgumentException e) {
                    if (isAjax) {
                        sendJsonResponse(response, false, "Invalid date format");
                    } else {
                        request.setAttribute("error", "Invalid date format");
                        request.getRequestDispatcher("profile.jsp").forward(request, response);
                    }
                    return;
                }
            }
            
            // Update patient object
            patient.setFirstName(firstName.trim());
            patient.setLastName(lastName.trim());
            patient.setPhone(phone.trim());
            patient.setDateOfBirth(dateOfBirth);
            patient.setGender(gender.trim());
            patient.setBloodGroup(bloodGroup != null ? bloodGroup.trim() : "");
            patient.setAddress(address != null ? address.trim() : "");
            patient.setEmergencyContact(emergencyContact != null ? emergencyContact.trim() : "");
            
            // Update in database
            if (patientDAO.updatePatientProfile(patient)) {
                // Update session
                session.setAttribute("patient", patient);
                
                if (isAjax) {
                    sendJsonResponse(response, true, "Profile updated successfully");
                } else {
                    request.setAttribute("success", "Profile updated successfully");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
            } else {
                if (isAjax) {
                    sendJsonResponse(response, false, "Failed to update profile");
                } else {
                    request.setAttribute("error", "Failed to update profile");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                sendJsonResponse(response, false, "An error occurred: " + e.getMessage());
            } else {
                request.setAttribute("error", "An error occurred: " + e.getMessage());
                request.getRequestDispatcher("profile.jsp").forward(request, response);
            }
        }
    }
    
    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response, 
                                      Patient patient, boolean isAjax) 
            throws ServletException, IOException {
        
        try {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Validation
            if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
                
                if (isAjax) {
                    sendJsonResponse(response, false, "All password fields are required");
                } else {
                    request.setAttribute("error", "All password fields are required");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
                return;
            }
            
            // Verify current password
            if (!patientDAO.verifyPassword(patient.getPatientId(), currentPassword)) {
                if (isAjax) {
                    sendJsonResponse(response, false, "Current password is incorrect");
                } else {
                    request.setAttribute("error", "Current password is incorrect");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
                return;
            }
            
            // Check new password length
            if (newPassword.length() < 6) {
                if (isAjax) {
                    sendJsonResponse(response, false, "New password must be at least 6 characters");
                } else {
                    request.setAttribute("error", "New password must be at least 6 characters");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
                return;
            }
            
            // Check if passwords match
            if (!newPassword.equals(confirmPassword)) {
                if (isAjax) {
                    sendJsonResponse(response, false, "New passwords do not match");
                } else {
                    request.setAttribute("error", "New passwords do not match");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
                return;
            }
            
            // Change password
            if (patientDAO.changePassword(patient.getPatientId(), newPassword)) {
                if (isAjax) {
                    sendJsonResponse(response, true, "Password changed successfully");
                } else {
                    request.setAttribute("success", "Password changed successfully");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
            } else {
                if (isAjax) {
                    sendJsonResponse(response, false, "Failed to change password");
                } else {
                    request.setAttribute("error", "Failed to change password");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                sendJsonResponse(response, false, "An error occurred: " + e.getMessage());
            } else {
                request.setAttribute("error", "An error occurred: " + e.getMessage());
                request.getRequestDispatcher("profile.jsp").forward(request, response);
            }
        }
    }
    
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
        out.flush();
    }
}
