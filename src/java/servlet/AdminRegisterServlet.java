package servlet;

import dao.AdminDAO;
import model.Admin;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminRegisterServlet extends HttpServlet {
    private AdminDAO adminDAO;
    
    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("admin-register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String username = request.getParameter("username");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String phone = request.getParameter("phone");
            
            // Validation
            if (username == null || fullName == null || email == null || password == null ||
                phone == null || username.trim().isEmpty() || fullName.trim().isEmpty() || 
                email.trim().isEmpty() || password.trim().isEmpty() || phone.trim().isEmpty()) {
                
                request.setAttribute("error", "Please fill in all required fields");
                request.getRequestDispatcher("admin-register.jsp").forward(request, response);
                return;
            }
            
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match");
                request.getRequestDispatcher("admin-register.jsp").forward(request, response);
                return;
            }
            
            if (password.length() < 6) {
                request.setAttribute("error", "Password must be at least 6 characters long");
                request.getRequestDispatcher("admin-register.jsp").forward(request, response);
                return;
            }
            
            if (username.trim().length() < 3) {
                request.setAttribute("error", "Username must be at least 3 characters long");
                request.getRequestDispatcher("admin-register.jsp").forward(request, response);
                return;
            }
            
            // Check if username already exists
            if (adminDAO.usernameExists(username.trim().toLowerCase())) {
                request.setAttribute("error", "Username is already taken");
                request.getRequestDispatcher("admin-register.jsp").forward(request, response);
                return;
            }
            
            // Check if email already exists
            if (adminDAO.emailExists(email.trim().toLowerCase())) {
                request.setAttribute("error", "Email address is already registered");
                request.getRequestDispatcher("admin-register.jsp").forward(request, response);
                return;
            }
            
            // Create admin object
            Admin admin = new Admin();
            admin.setUsername(username.trim().toLowerCase());
            admin.setFullName(fullName.trim());
            admin.setEmail(email.trim().toLowerCase());
            admin.setPassword(password);
            admin.setPhone(phone.trim());
            admin.setStatus("active");
            
            // Save admin
            if (adminDAO.addAdmin(admin)) {
                request.setAttribute("success", "Admin registration successful! Please login with your credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Username or email might already be registered.");
                request.getRequestDispatcher("admin-register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("admin-register.jsp").forward(request, response);
        }
    }
}
