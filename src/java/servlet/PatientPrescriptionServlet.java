package servlet;

import dao.PrescriptionDAO;
import model.Patient;
import model.Prescription;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class PatientPrescriptionServlet extends HttpServlet {
    private PrescriptionDAO prescriptionDAO;
    
    @Override
    public void init() throws ServletException {
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
        String action = request.getParameter("action");
        
        try {
            if ("download".equals(action)) {
                
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
        List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByPatient(patient.getPatientId());
        request.setAttribute("prescriptions", prescriptions);
        request.getRequestDispatcher("prescriptions.jsp").forward(request, response);
    }
    
   
}
