package servlet;

import dao.PatientDAO;
import model.Patient;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

public class RegisterServlet extends HttpServlet {
    private PatientDAO patientDAO;
    
    @Override
    public void init() throws ServletException {
        patientDAO = new PatientDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
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
            String dateOfBirth = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            String bloodGroup = request.getParameter("bloodGroup");
            String address = request.getParameter("address");
            String emergencyContact = request.getParameter("emergencyContact");
            
            // Validation
            if (firstName == null || lastName == null || email == null || password == null ||
                phone == null || dateOfBirth == null || gender == null || bloodGroup == null ||
                firstName.trim().isEmpty() || lastName.trim().isEmpty() || email.trim().isEmpty() ||
                password.trim().isEmpty() || phone.trim().isEmpty()) {
                
                request.setAttribute("error", "Please fill in all required fields");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (password.length() < 6) {
                request.setAttribute("error", "Password must be at least 6 characters long");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Create patient object
            Patient patient = new Patient();
            patient.setFirstName(firstName.trim());
            patient.setLastName(lastName.trim());
            patient.setEmail(email.trim().toLowerCase());
            patient.setPassword(password);
            patient.setPhone(phone.trim());
            patient.setDateOfBirth(Date.valueOf(dateOfBirth));
            patient.setGender(gender);
            patient.setBloodGroup(bloodGroup);
            patient.setAddress(address != null ? address.trim() : "");
            patient.setEmergencyContact(emergencyContact != null ? emergencyContact.trim() : "");
            patient.setStatus("active");
            
            // Save patient
            if (patientDAO.addPatient(patient)) {
                request.setAttribute("success", "Registration successful! Please login with your credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Email might already be registered.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
