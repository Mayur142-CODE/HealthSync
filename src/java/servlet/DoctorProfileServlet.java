package servlet;

import dao.DoctorDAO;
import model.Doctor;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class DoctorProfileServlet extends HttpServlet {
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("doctor") == null) {
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
        if (session == null || session.getAttribute("doctor") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        Doctor doctor = (Doctor) session.getAttribute("doctor");
        String action = request.getParameter("action");
        
        // Check if request is AJAX
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        
        if ("updateProfile".equals(action)) {
            handleProfileUpdate(request, response, doctor, session, isAjax);
        } else if ("changePassword".equals(action)) {
            handlePasswordChange(request, response, doctor, isAjax);
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
                                     Doctor doctor, HttpSession session, boolean isAjax) 
            throws ServletException, IOException {
        
        try {
            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String specialization = request.getParameter("specialization");
            String qualification = request.getParameter("qualification");
            String experienceStr = request.getParameter("experience");
            String address = request.getParameter("address");
            
            // Validation
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                specialization == null || specialization.trim().isEmpty() ||
                qualification == null || qualification.trim().isEmpty() ||
                experienceStr == null || experienceStr.trim().isEmpty()) {
                
                if (isAjax) {
                    sendJsonResponse(response, false, "All fields are required");
                } else {
                    request.setAttribute("error", "All fields are required");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
                return;
            }
            
            int experience;
            try {
                experience = Integer.parseInt(experienceStr);
                if (experience < 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                if (isAjax) {
                    sendJsonResponse(response, false, "Invalid experience value");
                } else {
                    request.setAttribute("error", "Invalid experience value");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
                return;
            }
            
            // Update doctor object
            doctor.setFirstName(firstName.trim());
            doctor.setLastName(lastName.trim());
            doctor.setPhone(phone.trim());
            doctor.setSpecialization(specialization.trim());
            doctor.setQualification(qualification.trim());
            doctor.setExperience(experience);
            doctor.setAddress(address != null ? address.trim() : "");
            
            // Update in database
            if (doctorDAO.updateDoctor(doctor)) {
                // Update session
                session.setAttribute("doctor", doctor);
                
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
                                      Doctor doctor, boolean isAjax) 
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
            if (!doctorDAO.verifyPassword(doctor.getDoctorId(), currentPassword)) {
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
            if (doctorDAO.changePassword(doctor.getDoctorId(), newPassword)) {
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
