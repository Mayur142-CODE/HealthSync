package servlet;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import model.Appointment;
import model.Doctor;
import model.Patient;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class AdminAppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorDAO();
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
            if ("cancel".equals(action)) {
                handleCancel(request, response);
            } else if ("complete".equals(action)) {
                handleComplete(request, response);
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
            if ("updateStatus".equals(action)) {
                handleUpdateStatus(request, response);
            } else if ("addNotes".equals(action)) {
                handleAddNotes(request, response);
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
        List<Appointment> appointments = appointmentDAO.getAllAppointments();
        List<Doctor> doctors = doctorDAO.getActiveDoctors();
        List<Patient> patients = patientDAO.getActivePatients();
        
        request.setAttribute("appointments", appointments);
        request.setAttribute("doctors", doctors);
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("manage-appointments.jsp").forward(request, response);
    }
    
    
    
    private void handleCancel(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr != null) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                if (appointmentDAO.updateAppointmentStatus(appointmentId, "cancelled")) {
                    request.setAttribute("success", "Appointment cancelled successfully!");
                } else {
                    request.setAttribute("error", "Failed to cancel appointment");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid appointment ID");
            }
        }
        
        handleList(request, response);
    }
    
    private void handleComplete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr != null) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                if (appointmentDAO.updateAppointmentStatus(appointmentId, "completed")) {
                    request.setAttribute("success", "Appointment marked as completed!");
                } else {
                    request.setAttribute("error", "Failed to complete appointment");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid appointment ID");
            }
        }
        
        handleList(request, response);
    }
    
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("appointmentId");
        String status = request.getParameter("status");
        
        if (appointmentIdStr != null && status != null) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                if (appointmentDAO.updateAppointmentStatus(appointmentId, status)) {
                    request.setAttribute("success", "Appointment status updated successfully!");
                } else {
                    request.setAttribute("error", "Failed to update appointment status");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid appointment ID");
            }
        } else {
            request.setAttribute("error", "Missing required parameters");
        }
        
        handleList(request, response);
    }
    
    private void handleAddNotes(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("appointmentId");
        String notes = request.getParameter("notes");
        
        if (appointmentIdStr != null && notes != null) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
                
                if (appointment != null) {
                    if (appointmentDAO.addAppointmentNotes(appointmentId, notes.trim())) {
                        request.setAttribute("success", "Notes added successfully!");
                    } else {
                        request.setAttribute("error", "Failed to add notes");
                    }
                } else {
                    request.setAttribute("error", "Appointment not found");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid appointment ID");
            }
        } else {
            request.setAttribute("error", "Missing required parameters");
        }
        
        handleList(request, response);
    }
}
