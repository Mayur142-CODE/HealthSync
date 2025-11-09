package servlet;

import dao.AdminDAO;
import model.Admin;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class AdminProfileServlet extends HttpServlet {
    private AdminDAO adminDAO;
    
    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
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
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        Admin admin = (Admin) session.getAttribute("admin");
        String action = request.getParameter("action");
        
        // Check if request is AJAX
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        
        if ("updateProfile".equals(action)) {
            handleProfileUpdate(request, response, admin, session, isAjax);
        } else if ("changePassword".equals(action)) {
            handlePasswordChange(request, response, admin, isAjax);
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
                                     Admin admin, HttpSession session, boolean isAjax) 
            throws ServletException, IOException {
        
        try {
            // Get form parameters
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            
            // Validation
            if (fullName == null || fullName.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty()) {
                
                if (isAjax) {
                    sendJsonResponse(response, false, "All fields are required");
                } else {
                    request.setAttribute("error", "All fields are required");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
                return;
            }
            
            // Update admin object
            admin.setFullName(fullName.trim());
            admin.setPhone(phone.trim());
            
            // Update in database
            if (adminDAO.updateAdminProfile(admin)) {
                // Update session
                session.setAttribute("admin", admin);
                
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
                                      Admin admin, boolean isAjax) 
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
            if (!adminDAO.verifyPassword(admin.getAdminId(), currentPassword)) {
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
            if (adminDAO.changePassword(admin.getAdminId(), newPassword)) {
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
