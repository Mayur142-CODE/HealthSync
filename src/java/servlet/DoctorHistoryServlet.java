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
import java.util.List;

public class DoctorHistoryServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private PrescriptionDAO prescriptionDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        prescriptionDAO = new PrescriptionDAO();
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
        
        try {
            // Get completed appointments for this doctor
            List<Appointment> completedAppointments = appointmentDAO.getCompletedAppointmentsByDoctor(doctor.getDoctorId());
            
            // Get all prescriptions for this doctor
            List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByDoctor(doctor.getDoctorId());
            
            request.setAttribute("completedAppointments", completedAppointments);
            request.setAttribute("prescriptions", prescriptions);
            request.getRequestDispatcher("history.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load history data");
            request.getRequestDispatcher("history.jsp").forward(request, response);
        }
    }
}
