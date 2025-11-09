package servlet;

import dao.AppointmentDAO;
import dao.PrescriptionDAO;
import model.Appointment;
import model.Doctor;
import model.Prescription;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

public class DoctorPrescriptionServlet extends HttpServlet {
    private PrescriptionDAO prescriptionDAO;
    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        prescriptionDAO = new PrescriptionDAO();
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
            if ("create".equals(action)) {
                handleCreate(request, response, doctor);
            } else if ("edit".equals(action)) {
                handleEdit(request, response, doctor);
            } else if ("delete".equals(action)) {
                handleDelete(request, response, doctor);
            } else if ("view".equals(action)) {
                handleView(request, response, doctor);
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
            if ("add".equals(action) || "create".equals(action)) {
                handleAdd(request, response, doctor);
            } else if ("edit".equals(action)) {
                handleEdit(request, response, doctor);
            } else if ("update".equals(action)) {
                handleUpdate(request, response, doctor);
            } else if ("delete".equals(action)) {
                handleDelete(request, response, doctor);
            } else if ("view".equals(action)) {
                handleView(request, response, doctor);
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
    
    private void handleList(HttpServletRequest request, HttpServletResponse response, Doctor doctor) 
            throws ServletException, IOException {
        List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByDoctor(doctor.getDoctorId());
        List<Appointment> completedAppointments = appointmentDAO.getAppointmentsByDoctor(doctor.getDoctorId());
        
        request.setAttribute("prescriptions", prescriptions);
        request.setAttribute("appointments", completedAppointments);
        request.getRequestDispatcher("prescriptions.jsp").forward(request, response);
    }
    
    private void handleCreate(HttpServletRequest request, HttpServletResponse response, Doctor doctor) 
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("appointmentId");
        if (appointmentIdStr != null) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
                
                // Verify this appointment belongs to the logged-in doctor
                if (appointment != null && appointment.getDoctorId() == doctor.getDoctorId()) {
                    request.setAttribute("selectedAppointment", appointment);
                } else {
                    request.setAttribute("error", "Appointment not found or access denied");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid appointment ID");
            }
        }
        
        handleList(request, response, doctor);
    }
    
    private void handleAdd(HttpServletRequest request, HttpServletResponse response, Doctor doctor) 
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("appointmentId");
        String patientIdStr = request.getParameter("patientId");
        String diagnosis = request.getParameter("diagnosis");
        String medications = request.getParameter("medications");
        String instructions = request.getParameter("instructions");
        String notes = request.getParameter("notes");
        
        // Validation
        if (appointmentIdStr == null || patientIdStr == null || diagnosis == null || 
            medications == null || instructions == null ||
            diagnosis.trim().isEmpty() || medications.trim().isEmpty() || instructions.trim().isEmpty()) {
            
            request.setAttribute("error", "Please fill in all required fields");
            handleList(request, response, doctor);
            return;
        }
        
        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            int patientId = Integer.parseInt(patientIdStr);
            
            // Verify the appointment belongs to this doctor
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null || appointment.getDoctorId() != doctor.getDoctorId()) {
                request.setAttribute("error", "Invalid appointment or access denied");
                handleList(request, response, doctor);
                return;
            }
            
            // Check if prescription already exists for this appointment
            Prescription existingPrescription = prescriptionDAO.getPrescriptionByAppointment(appointmentId);
            if (existingPrescription != null) {
                request.setAttribute("error", "Prescription already exists for this appointment");
                handleList(request, response, doctor);
                return;
            }
            
            Prescription prescription = new Prescription();
            prescription.setAppointmentId(appointmentId);
            prescription.setPatientId(patientId);
            prescription.setDoctorId(doctor.getDoctorId());
            prescription.setDiagnosis(diagnosis.trim());
            prescription.setMedications(medications.trim());
            prescription.setInstructions(instructions.trim());
            prescription.setNotes(notes != null ? notes.trim() : "");
            prescription.setPrescriptionDate(new Date(System.currentTimeMillis()));
            
            if (prescriptionDAO.addPrescription(prescription)) {
                // Mark appointment as completed
                appointmentDAO.updateAppointmentStatus(appointmentId, "completed");
                request.setAttribute("success", "Prescription created successfully!");
            } else {
                request.setAttribute("error", "Failed to create prescription");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid numeric values");
        }
        
        handleList(request, response, doctor);
    }
    
    private void handleEdit(HttpServletRequest request, HttpServletResponse response, Doctor doctor) 
            throws ServletException, IOException {
        
        String prescriptionIdStr = request.getParameter("id");
        if (prescriptionIdStr != null) {
            try {
                int prescriptionId = Integer.parseInt(prescriptionIdStr);
                Prescription prescription = prescriptionDAO.getPrescriptionById(prescriptionId);
                
                // Verify this prescription belongs to the logged-in doctor
                if (prescription != null && prescription.getDoctorId() == doctor.getDoctorId()) {
                    request.setAttribute("editPrescription", prescription);
                } else {
                    request.setAttribute("error", "Prescription not found or access denied");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid prescription ID");
            }
        }
        
        handleList(request, response, doctor);
    }
    
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, Doctor doctor) 
            throws ServletException, IOException {
        
        String prescriptionIdStr = request.getParameter("prescriptionId");
        String diagnosis = request.getParameter("diagnosis");
        String medications = request.getParameter("medications");
        String instructions = request.getParameter("instructions");
        String notes = request.getParameter("notes");
        
        if (prescriptionIdStr == null || diagnosis == null || medications == null || instructions == null ||
            diagnosis.trim().isEmpty() || medications.trim().isEmpty() || instructions.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all required fields (diagnosis, medications, and instructions cannot be empty)");
            handleList(request, response, doctor);
            return;
        }
        
        try {
            int prescriptionId = Integer.parseInt(prescriptionIdStr);
            Prescription prescription = prescriptionDAO.getPrescriptionById(prescriptionId);
            
            // Verify this prescription belongs to the logged-in doctor
            if (prescription != null && prescription.getDoctorId() == doctor.getDoctorId()) {
                prescription.setDiagnosis(diagnosis.trim());
                prescription.setMedications(medications.trim());
                prescription.setInstructions(instructions.trim());
                prescription.setNotes(notes != null ? notes.trim() : "");
                
                if (prescriptionDAO.updatePrescription(prescription)) {
                    request.setAttribute("success", "Prescription updated successfully!");
                } else {
                    request.setAttribute("error", "Failed to update prescription");
                }
            } else {
                request.setAttribute("error", "Prescription not found or access denied");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid prescription ID");
        }
        
        handleList(request, response, doctor);
    }
    
    
    
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, Doctor doctor) 
            throws ServletException, IOException {
        
        String prescriptionIdStr = request.getParameter("id");
        if (prescriptionIdStr != null) {
            try {
                int prescriptionId = Integer.parseInt(prescriptionIdStr);
                Prescription prescription = prescriptionDAO.getPrescriptionById(prescriptionId);
                
                // Verify this prescription belongs to the logged-in doctor
                if (prescription != null && prescription.getDoctorId() == doctor.getDoctorId()) {
                    if (prescriptionDAO.deletePrescription(prescriptionId)) {
                        request.setAttribute("success", "Prescription deleted successfully!");
                    } else {
                        request.setAttribute("error", "Failed to delete prescription");
                    }
                } else {
                    request.setAttribute("error", "Prescription not found or access denied");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid prescription ID");
            }
        }
        
        handleList(request, response, doctor);
    }
    
    private void handleView(HttpServletRequest request, HttpServletResponse response, Doctor doctor) 
            throws ServletException, IOException {
        
        String prescriptionIdStr = request.getParameter("id");
        
        if (prescriptionIdStr != null) {
            try {
                int prescriptionId = Integer.parseInt(prescriptionIdStr);
                Prescription prescription = prescriptionDAO.getPrescriptionById(prescriptionId);
                
                // Verify this prescription belongs to the logged-in doctor
                if (prescription != null && prescription.getDoctorId() == doctor.getDoctorId()) {
                    
                    response.setContentType("text/html");
                    response.setCharacterEncoding("UTF-8");
                    
                    StringBuilder html = new StringBuilder();
                    
                    // Patient Information Section
                    html.append("<div class='row g-3'>");
                    html.append("<div class='col-md-6'>");
                    html.append("<label class='form-label'>Patient</label>");
                    html.append("<input type='text' class='form-control' value='").append(prescription.getPatientName()).append("' readonly>");
                    html.append("</div>");
                    html.append("<div class='col-md-6'>");
                    html.append("<label class='form-label'>Prescription Date</label>");
                    html.append("<input type='text' class='form-control' value='").append(prescription.getPrescriptionDate()).append("' readonly>");
                    html.append("</div>");
                    html.append("</div>");
                    
                    html.append("<div class='row g-3 mt-2'>");
                    html.append("<div class='col-12'>");
                    html.append("<label class='form-label'>Diagnosis</label>");
                    html.append("<textarea class='form-control' rows='3' readonly>").append(prescription.getDiagnosis()).append("</textarea>");
                    html.append("</div>");
                    html.append("</div>");
                    
                    html.append("<div class='row g-3 mt-2'>");
                    html.append("<div class='col-12'>");
                    html.append("<label class='form-label'>Medications</label>");
                    html.append("<textarea class='form-control' rows='4' readonly>").append(prescription.getMedications()).append("</textarea>");
                    html.append("</div>");
                    html.append("</div>");
                    
                    html.append("<div class='row g-3 mt-2'>");
                    html.append("<div class='col-12'>");
                    html.append("<label class='form-label'>Instructions</label>");
                    html.append("<textarea class='form-control' rows='3' readonly>").append(prescription.getInstructions()).append("</textarea>");
                    html.append("</div>");
                    html.append("</div>");
                    
                    if (prescription.getNotes() != null && !prescription.getNotes().trim().isEmpty()) {
                        html.append("<div class='row g-3 mt-2'>");
                        html.append("<div class='col-12'>");
                        html.append("<label class='form-label'>Additional Notes</label>");
                        html.append("<textarea class='form-control' rows='2' readonly>").append(prescription.getNotes()).append("</textarea>");
                        html.append("</div>");
                        html.append("</div>");
                    }
                    
                    response.getWriter().write(html.toString());
                } else {
                    response.setContentType("text/html");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("<div class='alert alert-danger'>Prescription not found or access denied</div>");
                }
            } catch (NumberFormatException e) {
                response.setContentType("text/html");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("<div class='alert alert-danger'>Invalid prescription ID</div>");
            }
        } else {
            response.setContentType("text/html");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("<div class='alert alert-danger'>Missing prescription ID</div>");
        }
    }
}
