package servlet;

import dao.AppointmentDAO;
import dao.PrescriptionDAO;
import model.Doctor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class DoctorDashboardServlet extends HttpServlet {
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
            // Get today's appointments
            request.setAttribute("todaysAppointments", 
                appointmentDAO.getTodaysAppointmentsByDoctor(doctor.getDoctorId()));
            
            // Get all appointments for this doctor
            request.setAttribute("allAppointments", 
                appointmentDAO.getAppointmentsByDoctor(doctor.getDoctorId()));
            
            // Get prescriptions created by this doctor
            request.setAttribute("prescriptions", 
                prescriptionDAO.getPrescriptionsByDoctor(doctor.getDoctorId()));
            
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load dashboard data");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }
}
