package servlet;

import dao.PatientDAO;
import model.Patient;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

public class AdminPatientServlet extends HttpServlet {
    private PatientDAO patientDAO;
    
    @Override
    public void init() throws ServletException {
        patientDAO = new PatientDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("search".equals(action)) {
                handleSearch(request, response);
            } else if ("edit".equals(action)) {
                handleEdit(request, response);
            } else if ("delete".equals(action)) {
                handleDelete(request, response);
            } else if ("permanentDelete".equals(action)) {
                handlePermanentDelete(request, response);
            } else {
                handleList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request");
            handleList(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                handleAdd(request, response);
            } else if ("update".equals(action)) {
                handleUpdate(request, response);
            } else {
                handleList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request");
            handleList(request, response);
        }
    }
    
    private void handleList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Patient> patients = patientDAO.getAllPatients();
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("manage-patients.jsp").forward(request, response);
    }
    
    private void handleSearch(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String searchTerm = request.getParameter("search");
        List<Patient> patients;
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            patients = patientDAO.searchPatients(searchTerm.trim());
        } else {
            patients = patientDAO.getAllPatients();
        }
        
        request.setAttribute("patients", patients);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("manage-patients.jsp").forward(request, response);
    }
    
    private void handleAdd(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String dateOfBirth = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String bloodGroup = request.getParameter("bloodGroup");
        String address = request.getParameter("address");
        String emergencyContact = request.getParameter("emergencyContact");
        String medicalHistory = request.getParameter("medicalHistory");
        
        // Validation
        if (firstName == null || lastName == null || email == null || password == null ||
            phone == null || dateOfBirth == null || gender == null || bloodGroup == null ||
            firstName.trim().isEmpty() || lastName.trim().isEmpty() || email.trim().isEmpty() ||
            password.trim().isEmpty() || phone.trim().isEmpty()) {
            
            request.setAttribute("error", "Please fill in all required fields");
            handleList(request, response);
            return;
        }
        
        try {
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
            patient.setMedicalHistory(medicalHistory != null ? medicalHistory.trim() : "");
            patient.setStatus("active");
            
            if (patientDAO.addPatient(patient)) {
                request.setAttribute("success", "Patient added successfully!");
            } else {
                request.setAttribute("error", "Failed to add patient. Email might already exist.");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Invalid date format or other data error");
        }
        
        handleList(request, response);
    }
    
    private void handleEdit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String patientIdStr = request.getParameter("id");
        if (patientIdStr != null) {
            try {
                int patientId = Integer.parseInt(patientIdStr);
                Patient patient = patientDAO.getPatientById(patientId);
                request.setAttribute("editPatient", patient);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid patient ID");
            }
        }
        
        handleList(request, response);
    }
    
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String patientIdStr = request.getParameter("patientId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dateOfBirth = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String bloodGroup = request.getParameter("bloodGroup");
        String address = request.getParameter("address");
        String emergencyContact = request.getParameter("emergencyContact");
        String medicalHistory = request.getParameter("medicalHistory");
        String status = request.getParameter("status");
        
        if (patientIdStr == null || firstName == null || lastName == null || email == null ||
            phone == null || dateOfBirth == null || gender == null || bloodGroup == null) {
            
            request.setAttribute("error", "Please fill in all required fields");
            handleList(request, response);
            return;
        }
        
        try {
            int patientId = Integer.parseInt(patientIdStr);
            
            Patient patient = new Patient();
            patient.setPatientId(patientId);
            patient.setFirstName(firstName.trim());
            patient.setLastName(lastName.trim());
            patient.setEmail(email.trim().toLowerCase());
            patient.setPhone(phone.trim());
            patient.setDateOfBirth(Date.valueOf(dateOfBirth));
            patient.setGender(gender);
            patient.setBloodGroup(bloodGroup);
            patient.setAddress(address != null ? address.trim() : "");
            patient.setEmergencyContact(emergencyContact != null ? emergencyContact.trim() : "");
            patient.setMedicalHistory(medicalHistory != null ? medicalHistory.trim() : "");
            patient.setStatus(status != null ? status : "active");
            
            if (patientDAO.updatePatient(patient)) {
                request.setAttribute("success", "Patient updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update patient");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Invalid data format");
        }
        
        handleList(request, response);
    }
    
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String patientIdStr = request.getParameter("id");
        if (patientIdStr != null) {
            try {
                int patientId = Integer.parseInt(patientIdStr);
                if (patientDAO.deletePatient(patientId)) {
                    request.setAttribute("success", "Patient deactivated successfully!");
                } else {
                    request.setAttribute("error", "Failed to deactivate patient");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid patient ID");
            }
        }
        
        handleList(request, response);
    }
    
    private void handlePermanentDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String patientIdStr = request.getParameter("id");
        if (patientIdStr != null) {
            try {
                int patientId = Integer.parseInt(patientIdStr);
                if (patientDAO.permanentDeletePatient(patientId)) {
                    request.setAttribute("success", "Patient permanently deleted successfully!");
                } else {
                    request.setAttribute("error", "Failed to permanently delete patient");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid patient ID");
            }
        }
        
        handleList(request, response);
    }
}
