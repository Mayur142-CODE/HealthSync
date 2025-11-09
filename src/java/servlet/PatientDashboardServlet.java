package servlet;

import dao.AppointmentDAO;
import dao.PrescriptionDAO;
import model.Patient;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class PatientDashboardServlet extends HttpServlet {
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
        if (session == null || session.getAttribute("patient") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        Patient patient = (Patient) session.getAttribute("patient");
        
        try {
            // Get patient's appointments
            request.setAttribute("appointments", 
                appointmentDAO.getAppointmentsByPatient(patient.getPatientId()));
            
            // Get patient's prescriptions
            request.setAttribute("prescriptions", 
                prescriptionDAO.getPrescriptionsByPatient(patient.getPatientId()));
            
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load dashboard data");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }
}
