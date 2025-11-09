package servlet;

import dao.DoctorDAO;
import model.Doctor;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DoctorRegisterServlet extends HttpServlet {
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("doctor-register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String phone = request.getParameter("phone");
            String specialization = request.getParameter("specialization");
            String qualification = request.getParameter("qualification");
            String experienceStr = request.getParameter("experience");
            String address = request.getParameter("address");
            
            // Validation
            if (firstName == null || lastName == null || email == null || password == null ||
                phone == null || specialization == null || qualification == null || experienceStr == null ||
                firstName.trim().isEmpty() || lastName.trim().isEmpty() || email.trim().isEmpty() ||
                password.trim().isEmpty() || phone.trim().isEmpty() || specialization.trim().isEmpty() ||
                qualification.trim().isEmpty() || experienceStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Please fill in all required fields");
                request.getRequestDispatcher("doctor-register.jsp").forward(request, response);
                return;
            }
            
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match");
                request.getRequestDispatcher("doctor-register.jsp").forward(request, response);
                return;
            }
            
            if (password.length() < 6) {
                request.setAttribute("error", "Password must be at least 6 characters long");
                request.getRequestDispatcher("doctor-register.jsp").forward(request, response);
                return;
            }
            
            int experience;
            try {
                experience = Integer.parseInt(experienceStr.trim());
                if (experience < 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Please enter a valid experience in years");
                request.getRequestDispatcher("doctor-register.jsp").forward(request, response);
                return;
            }
            
            // Check if email already exists
            if (doctorDAO.emailExists(email.trim().toLowerCase())) {
                request.setAttribute("error", "Email address is already registered");
                request.getRequestDispatcher("doctor-register.jsp").forward(request, response);
                return;
            }
            
            // Create doctor object
            Doctor doctor = new Doctor();
            doctor.setFirstName(firstName.trim());
            doctor.setLastName(lastName.trim());
            doctor.setEmail(email.trim().toLowerCase());
            doctor.setPassword(password);
            doctor.setPhone(phone.trim());
            doctor.setSpecialization(specialization.trim());
            doctor.setQualification(qualification.trim());
            doctor.setExperience(experience);
            doctor.setAddress(address != null ? address.trim() : "");
            doctor.setStatus("active");
            
            // Save doctor
            if (doctorDAO.addDoctor(doctor)) {
                request.setAttribute("success", "Doctor registration successful! Please login with your credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Email might already be registered.");
                request.getRequestDispatcher("doctor-register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("doctor-register.jsp").forward(request, response);
        }
    }
}
