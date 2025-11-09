package servlet;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import dao.PrescriptionDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

public class AdminDashboardServlet extends HttpServlet {
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;
    private AppointmentDAO appointmentDAO;
    private PrescriptionDAO prescriptionDAO;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
        patientDAO = new PatientDAO();
        appointmentDAO = new AppointmentDAO();
        prescriptionDAO = new PrescriptionDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        // Check if this is an AJAX request for JSON data
        String requestType = request.getParameter("type");
        if ("json".equals(requestType)) {
            handleJsonRequest(request, response);
            return;
        }
        
        try {
            // Get dashboard statistics
            int totalDoctors = doctorDAO.getTotalDoctorsCount();
            int totalPatients = patientDAO.getTotalPatientsCount();
            int totalAppointments = appointmentDAO.getTotalAppointmentsCount();
            int completedAppointments = appointmentDAO.getCompletedAppointmentsCount();
            
            // Set attributes for JSP
            request.setAttribute("totalDoctors", totalDoctors);
            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("completedAppointments", completedAppointments);
            
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load dashboard data");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle JSON request for analytics data
     */
    private void handleJsonRequest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Get appointment status counts
            Map<String, Integer> statusCounts = appointmentDAO.getAppointmentStatusCounts();
            StringBuilder appointmentStatusJson = new StringBuilder();
            appointmentStatusJson.append("{");
            int count = 0;
            for (Map.Entry<String, Integer> entry : statusCounts.entrySet()) {
                if (count > 0) appointmentStatusJson.append(",");
                appointmentStatusJson.append("\"").append(escapeJson(entry.getKey())).append("\":").append(entry.getValue());
                count++;
            }
            appointmentStatusJson.append("}");
            
            // Get monthly patient registrations (last 6 months)
            Map<String, Integer> monthlyRegistrations = patientDAO.getMonthlyPatientRegistrations(6);
            StringBuilder patientRegistrationsJson = new StringBuilder();
            patientRegistrationsJson.append("{");
            count = 0;
            for (Map.Entry<String, Integer> entry : monthlyRegistrations.entrySet()) {
                if (count > 0) patientRegistrationsJson.append(",");
                patientRegistrationsJson.append("\"").append(escapeJson(entry.getKey())).append("\":").append(entry.getValue());
                count++;
            }
            patientRegistrationsJson.append("}");
            
            // Get totals
            int totalPatients = patientDAO.getTotalPatientsCount();
            int totalDoctors = doctorDAO.getTotalDoctorsCount();
            int totalAppointments = appointmentDAO.getTotalAppointmentsCount();
            int completedAppointments = appointmentDAO.getCompletedAppointmentsCount();
            
            // Build complete JSON response
            StringBuilder jsonResponse = new StringBuilder();
            jsonResponse.append("{");
            jsonResponse.append("\"appointmentStatus\":").append(appointmentStatusJson.toString()).append(",");
            jsonResponse.append("\"patientRegistrations\":").append(patientRegistrationsJson.toString()).append(",");
            jsonResponse.append("\"totals\":{");
            jsonResponse.append("\"patients\":").append(totalPatients).append(",");
            jsonResponse.append("\"doctors\":").append(totalDoctors).append(",");
            jsonResponse.append("\"appointments\":").append(totalAppointments).append(",");
            jsonResponse.append("\"completed\":").append(completedAppointments);
            jsonResponse.append("}");
            jsonResponse.append("}");
            
            PrintWriter out = response.getWriter();
            out.print(jsonResponse.toString());
            out.flush();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"Failed to fetch analytics data: " + escapeJson(e.getMessage()) + "\"}");
            out.flush();
        }
    }
    
    /**
     * Escape special characters for JSON
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
