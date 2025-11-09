package servlet;

import dao.AppointmentDAO;
import dao.DoctorDAO;
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
import java.sql.Date;
import java.sql.Time;
import java.util.List;

public class PatientAppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patient") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        Patient patient = (Patient) session.getAttribute("patient");
        String action = request.getParameter("action");
        
        try {
            if ("book".equals(action)) {
                handleBookForm(request, response, patient);
            } else if ("cancel".equals(action)) {
                handleCancel(request, response, patient);
            } else {
                handleList(request, response, patient);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request");
            handleList(request, response, patient);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patient") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        Patient patient = (Patient) session.getAttribute("patient");
        String action = request.getParameter("action");
        
        try {
            if ("bookAppointment".equals(action)) {
                handleBookAppointment(request, response, patient);
            } else {
                handleList(request, response, patient);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request");
            handleList(request, response, patient);
        }
    }
    
    private void handleList(HttpServletRequest request, HttpServletResponse response, Patient patient) 
            throws ServletException, IOException {
        List<Appointment> appointments = appointmentDAO.getAppointmentsByPatient(patient.getPatientId());
        List<Doctor> doctors = doctorDAO.getActiveDoctors();
        
        request.setAttribute("appointments", appointments);
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("appointments.jsp").forward(request, response);
    }
    
    private void handleBookForm(HttpServletRequest request, HttpServletResponse response, Patient patient) 
            throws ServletException, IOException {
        List<Doctor> doctors = doctorDAO.getActiveDoctors();
        request.setAttribute("doctors", doctors);
        request.setAttribute("showBookingForm", true);
        
        handleList(request, response, patient);
    }
    
    private void handleBookAppointment(HttpServletRequest request, HttpServletResponse response, Patient patient) 
            throws ServletException, IOException {
        
        String doctorIdStr = request.getParameter("doctorId");
        String appointmentDate = request.getParameter("appointmentDate");
        String appointmentTime = request.getParameter("appointmentTime");
        String reason = request.getParameter("reason");
        
        // Validation
        if (doctorIdStr == null || appointmentDate == null || appointmentTime == null || 
            reason == null || doctorIdStr.trim().isEmpty() || appointmentDate.trim().isEmpty() ||
            appointmentTime.trim().isEmpty() || reason.trim().isEmpty()) {
            
            request.setAttribute("error", "Please fill in all required fields");
            handleBookForm(request, response, patient);
            return;
        }
        
        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            Date apptDate = Date.valueOf(appointmentDate);
            Time apptTime = Time.valueOf(appointmentTime + ":00");
            
            // Check if the date is not in the past (compare only dates, not time)
            Date today = Date.valueOf(java.time.LocalDate.now());
            if (apptDate.before(today)) {
                request.setAttribute("error", "Cannot book appointment for past dates");
                handleBookForm(request, response, patient);
                return;
            }
            
            // Check if time slot is available
            if (!appointmentDAO.isTimeSlotAvailable(doctorId, apptDate, apptTime)) {
                request.setAttribute("error", "Selected time slot is not available. Please choose another time.");
                handleBookForm(request, response, patient);
                return;
            }
            
            Appointment appointment = new Appointment();
            appointment.setPatientId(patient.getPatientId());
            appointment.setDoctorId(doctorId);
            appointment.setAppointmentDate(apptDate);
            appointment.setAppointmentTime(apptTime);
            appointment.setReason(reason.trim());
            appointment.setStatus("approved");
            
            if (appointmentDAO.addAppointment(appointment)) {
                request.setAttribute("success", "Appointment booked successfully! Your appointment is confirmed.");
            } else {
                request.setAttribute("error", "Failed to book appointment. Please try again.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid doctor selection");
            handleBookForm(request, response, patient);
            return;
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid date or time format");
            handleBookForm(request, response, patient);
            return;
        }
        
        handleList(request, response, patient);
    }
    
    private void handleCancel(HttpServletRequest request, HttpServletResponse response, Patient patient) 
            throws ServletException, IOException {
        
        String appointmentIdStr = request.getParameter("id");
        if (appointmentIdStr != null) {
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
                
                // Verify this appointment belongs to the logged-in patient
                if (appointment != null && appointment.getPatientId() == patient.getPatientId()) {
                    // Only allow cancellation if appointment is pending or approved
                    if ("pending".equals(appointment.getStatus()) || "approved".equals(appointment.getStatus())) {
                        if (appointmentDAO.updateAppointmentStatus(appointmentId, "cancelled")) {
                            request.setAttribute("success", "Appointment cancelled successfully!");
                        } else {
                            request.setAttribute("error", "Failed to cancel appointment");
                        }
                    } else {
                        request.setAttribute("error", "Cannot cancel appointment with status: " + appointment.getStatus());
                    }
                } else {
                    request.setAttribute("error", "Appointment not found or access denied");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid appointment ID");
            }
        }
        
        handleList(request, response, patient);
    }
}
