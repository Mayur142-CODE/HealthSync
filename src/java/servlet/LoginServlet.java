package servlet;

import dao.AdminDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import model.Admin;
import model.Doctor;
import model.Patient;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private AdminDAO adminDAO;
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;
    
    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
        doctorDAO = new DoctorDAO();
        patientDAO = new PatientDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null) {
            if (session.getAttribute("admin") != null) {
                response.sendRedirect("admin/dashboard.jsp");
                return;
            } else if (session.getAttribute("doctor") != null) {
                response.sendRedirect("doctor/dashboard.jsp");
                return;
            } else if (session.getAttribute("patient") != null) {
                response.sendRedirect("patient/dashboard.jsp");
                return;
            }
        }
        
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");
        
        if (email == null || password == null || userType == null || 
            email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all fields");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        HttpSession session = request.getSession();
        
        try {
            switch (userType) {
                case "admin":
                    Admin admin = adminDAO.authenticateAdmin(email, password);
                    if (admin != null) {
                        session.setAttribute("admin", admin);
                        session.setAttribute("userType", "admin");
                        response.sendRedirect("admin/dashboard");
                    } else {
                        request.setAttribute("error", "Invalid admin credentials");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    }
                    break;
                    
                case "doctor":
                    Doctor doctor = doctorDAO.authenticateDoctor(email, password);
                    if (doctor != null) {
                        session.setAttribute("doctor", doctor);
                        session.setAttribute("userType", "doctor");
                        response.sendRedirect("doctor/dashboard.jsp");
                    } else {
                        request.setAttribute("error", "Invalid doctor credentials");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    }
                    break;
                    
                case "patient":
                    Patient patient = patientDAO.authenticatePatient(email, password);
                    if (patient != null) {
                        session.setAttribute("patient", patient);
                        session.setAttribute("userType", "patient");
                        response.sendRedirect("patient/dashboard.jsp");
                    } else {
                        request.setAttribute("error", "Invalid patient credentials");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    }
                    break;
                    
                default:
                    request.setAttribute("error", "Invalid user type");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Login failed. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
