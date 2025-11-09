package servlet;

import dao.AppointmentDAO;
import dao.PrescriptionDAO;
import model.Appointment;
import model.Doctor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Prescription;

public class DoctorAppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("doctor") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        Doctor doctor = (Doctor) session.getAttribute("doctor");
        String action = request.getParameter("action");
        
        try {
            if ("complete".equals(action)) {
                handleComplete(request, response, doctor);
            } else if ("getPatientHistory".equals(action)) {
                handleGetPatientHistory(request, response, doctor);
                return; // Don't forward to JSP for AJAX response
            } else {
                handleList(request, response, doctor);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request");
            handleList(request, response, doctor);
        }
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
        
        try {
            if ("updateNotes".equals(action)) {
                handleUpdateNotes(request, response, doctor);
            } else if ("updateStatus".equals(action)) {
                handleUpdateStatus(request, response, doctor);
            } else {
                handleList(request, response, doctor);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request");
            handleList(request, response, doctor);
        }
    }
    
    private void handleList(HttpServletRequest request, HttpServletResponse response, Doctor doctor) 
            throws ServletException, IOException {
        List<Appointment> appointments = appointmentDAO.getAppointmentsByDoctor(doctor.getDoctorId());
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("appointments.jsp").forward(request, response);
    }
    
    private void handleComplete(HttpServletRequest request, HttpServletResponse response, Doctor doctor) 
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
        
        handleList(request, response, doctor);
    }
    
    
    private void handleUpdateNotes(HttpServletRequest request, HttpServletResponse response, Doctor doctor) 
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("appointmentId");
        String notes = request.getParameter("notes");
        
        if (appointmentIdStr != null && notes != null) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
                
                // Verify this appointment belongs to the logged-in doctor
                if (appointment != null && appointment.getDoctorId() == doctor.getDoctorId()) {
                    appointment.setNotes(notes.trim());
                    if (appointmentDAO.updateAppointment(appointment)) {
                        request.setAttribute("success", "Treatment notes updated successfully!");
                    } else {
                        request.setAttribute("error", "Failed to update notes");
                    }
                } else {
                    request.setAttribute("error", "Appointment not found or access denied");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid appointment ID");
            }
        } else {
            request.setAttribute("error", "Missing required parameters");
        }
        
        handleList(request, response, doctor);
    }
    
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response, Doctor doctor) 
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("appointmentId");
        String status = request.getParameter("status");
        
        if (appointmentIdStr != null && status != null) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
                
                // Verify this appointment belongs to the logged-in doctor
                if (appointment != null && appointment.getDoctorId() == doctor.getDoctorId()) {
                    if (appointmentDAO.updateAppointmentStatus(appointmentId, status)) {
                        request.setAttribute("success", "Appointment status updated successfully!");
                    } else {
                        request.setAttribute("error", "Failed to update appointment status");
                    }
                } else {
                    request.setAttribute("error", "Appointment not found or access denied");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid appointment ID");
            }
        } else {
            request.setAttribute("error", "Missing required parameters");
        }
        
        handleList(request, response, doctor);
    }
    
    
    private void handleGetPatientHistory(HttpServletRequest request, HttpServletResponse response, Doctor doctor) 
            throws ServletException, IOException {
        String patientIdStr = request.getParameter("patientId");
        
        if (patientIdStr != null) {
            try {
                int patientId = Integer.parseInt(patientIdStr);
                
                // Get patient's prescription history
                PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
                List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByPatient(patientId);
                
                // Get patient's appointment history
                List<Appointment> appointments = appointmentDAO.getAppointmentsByPatient(patientId);
                
                response.setContentType("text/html");
                response.setCharacterEncoding("UTF-8");
                
                StringBuilder html = new StringBuilder();
                html.append("<div class='row'>");
                
                // Prescription History
                html.append("<div class='col-md-6'>");
                html.append("<h6 class='text-primary'><i class='fas fa-prescription me-2'></i>Prescription History</h6>");
                if (prescriptions != null && !prescriptions.isEmpty()) {
                    for (Prescription prescription : prescriptions) {
                        html.append("<div class='card mb-2'>");
                        html.append("<div class='card-body p-2'>");
                        html.append("<small class='text-muted'>").append(prescription.getPrescriptionDate()).append("</small>");
                        html.append("<br><strong>").append(prescription.getDiagnosis()).append("</strong>");
                        html.append("<br><small>").append(prescription.getMedications()).append("</small>");
                        html.append("</div></div>");
                    }
                } else {
                    html.append("<p class='text-muted'>No previous prescriptions</p>");
                }
                html.append("</div>");
                
                // Appointment History
                html.append("<div class='col-md-6'>");
                html.append("<h6 class='text-primary'><i class='fas fa-calendar me-2'></i>Appointment History</h6>");
                if (appointments != null && !appointments.isEmpty()) {
                    for (Appointment appointment : appointments) {
                        html.append("<div class='card mb-2'>");
                        html.append("<div class='card-body p-2'>");
                        html.append("<small class='text-muted'>").append(appointment.getAppointmentDate()).append("</small>");
                        html.append("<br><strong>").append(appointment.getReason()).append("</strong>");
                        html.append("<br><span class='badge bg-").append(getStatusBadgeClass(appointment.getStatus())).append("'>")
                               .append(appointment.getStatus()).append("</span>");
                        if (appointment.getNotes() != null && !appointment.getNotes().isEmpty()) {
                            html.append("<br><small><strong>Notes:</strong> ").append(appointment.getNotes()).append("</small>");
                        }
                        html.append("</div></div>");
                    }
                } else {
                    html.append("<p class='text-muted'>No previous appointments</p>");
                }
                html.append("</div>");
                html.append("</div>");
                
                response.getWriter().write(html.toString());
                
            } catch (NumberFormatException e) {
                response.getWriter().write("<div class='alert alert-danger'>Invalid patient ID</div>");
            }
        } else {
            response.getWriter().write("<div class='alert alert-danger'>Missing patient ID</div>");
        }
    }
    
    private String getStatusBadgeClass(String status) {
        switch (status.toLowerCase()) {
            case "pending": return "warning";
            case "approved": return "success";
            case "completed": return "info";
            case "cancelled": return "secondary";
            case "rejected": return "danger";
            default: return "secondary";
        }
    }
}
