package servlet;

import dao.DoctorDAO;
import model.Doctor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class AdminDoctorServlet extends HttpServlet {
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
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
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("manage-doctors.jsp").forward(request, response);
    }
    
    private void handleSearch(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String searchTerm = request.getParameter("search");
        List<Doctor> doctors;
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            doctors = doctorDAO.searchDoctors(searchTerm.trim());
        } else {
            doctors = doctorDAO.getAllDoctors();
        }
        
        request.setAttribute("doctors", doctors);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("manage-doctors.jsp").forward(request, response);
    }
    
    private void handleAdd(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
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
            qualification.trim().isEmpty()) {
            
            request.setAttribute("error", "Please fill in all required fields");
            handleList(request, response);
            return;
        }
        
        try {
            int experience = Integer.parseInt(experienceStr);
            
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
            
            if (doctorDAO.addDoctor(doctor)) {
                request.setAttribute("success", "Doctor added successfully!");
            } else {
                request.setAttribute("error", "Failed to add doctor. Email might already exist.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid experience value");
        }
        
        handleList(request, response);
    }
    
    private void handleEdit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String doctorIdStr = request.getParameter("id");
        if (doctorIdStr != null) {
            try {
                int doctorId = Integer.parseInt(doctorIdStr);
                Doctor doctor = doctorDAO.getDoctorById(doctorId);
                request.setAttribute("editDoctor", doctor);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid doctor ID");
            }
        }
        
        handleList(request, response);
    }
    
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String doctorIdStr = request.getParameter("doctorId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String specialization = request.getParameter("specialization");
        String qualification = request.getParameter("qualification");
        String experienceStr = request.getParameter("experience");
        String address = request.getParameter("address");
        String status = request.getParameter("status");
        
        if (doctorIdStr == null || firstName == null || lastName == null || email == null ||
            phone == null || specialization == null || qualification == null || experienceStr == null) {
            
            request.setAttribute("error", "Please fill in all required fields");
            handleList(request, response);
            return;
        }
        
        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            int experience = Integer.parseInt(experienceStr);
            
            Doctor doctor = new Doctor();
            doctor.setDoctorId(doctorId);
            doctor.setFirstName(firstName.trim());
            doctor.setLastName(lastName.trim());
            doctor.setEmail(email.trim().toLowerCase());
            doctor.setPhone(phone.trim());
            doctor.setSpecialization(specialization.trim());
            doctor.setQualification(qualification.trim());
            doctor.setExperience(experience);
            doctor.setAddress(address != null ? address.trim() : "");
            doctor.setStatus(status != null ? status : "active");
            
            if (doctorDAO.updateDoctor(doctor)) {
                request.setAttribute("success", "Doctor updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update doctor");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid numeric values");
        }
        
        handleList(request, response);
    }
    
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String doctorIdStr = request.getParameter("id");
        if (doctorIdStr != null) {
            try {
                int doctorId = Integer.parseInt(doctorIdStr);
                if (doctorDAO.deleteDoctor(doctorId)) {
                    request.setAttribute("success", "Doctor deactivated successfully!");
                } else {
                    request.setAttribute("error", "Failed to deactivate doctor");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid doctor ID");
            }
        }
        
        handleList(request, response);
    }
    
    private void handlePermanentDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String doctorIdStr = request.getParameter("id");
        if (doctorIdStr != null) {
            try {
                int doctorId = Integer.parseInt(doctorIdStr);
                if (doctorDAO.permanentDeleteDoctor(doctorId)) {
                    request.setAttribute("success", "Doctor permanently deleted successfully!");
                } else {
                    request.setAttribute("error", "Failed to permanently delete doctor");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid doctor ID");
            }
        }
        
        handleList(request, response);
    }
}
