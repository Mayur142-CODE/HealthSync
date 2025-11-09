package dao;

import model.Prescription;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PrescriptionDAO {
    
    public boolean addPrescription(Prescription prescription) {
        String sql = "INSERT INTO prescriptions (appointment_id, patient_id, doctor_id, diagnosis, medications, instructions, notes, prescription_date, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, prescription.getAppointmentId());
            stmt.setInt(2, prescription.getPatientId());
            stmt.setInt(3, prescription.getDoctorId());
            stmt.setString(4, prescription.getDiagnosis());
            stmt.setString(5, prescription.getMedications());
            stmt.setString(6, prescription.getInstructions());
            stmt.setString(7, prescription.getNotes());
            stmt.setDate(8, prescription.getPrescriptionDate());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Prescription getPrescriptionById(int prescriptionId) {
        String sql = "SELECT pr.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM prescriptions pr " +
                    "JOIN patients p ON pr.patient_id = p.patient_id " +
                    "JOIN doctors d ON pr.doctor_id = d.doctor_id " +
                    "WHERE pr.prescription_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, prescriptionId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPrescription(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updatePrescription(Prescription prescription) {
        String sql = "UPDATE prescriptions SET diagnosis = ?, medications = ?, instructions = ?, notes = ? WHERE prescription_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, prescription.getDiagnosis());
            stmt.setString(2, prescription.getMedications());
            stmt.setString(3, prescription.getInstructions());
            stmt.setString(4, prescription.getNotes());
            stmt.setInt(5, prescription.getPrescriptionId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Prescription> getAllPrescriptions() {
        List<Prescription> prescriptions = new ArrayList<>();
        String sql = "SELECT pr.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM prescriptions pr " +
                    "JOIN patients p ON pr.patient_id = p.patient_id " +
                    "JOIN doctors d ON pr.doctor_id = d.doctor_id " +
                    "ORDER BY pr.prescription_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                prescriptions.add(mapResultSetToPrescription(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prescriptions;
    }
    
    public List<Prescription> getPrescriptionsByPatient(int patientId) {
        List<Prescription> prescriptions = new ArrayList<>();
        String sql = "SELECT pr.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM prescriptions pr " +
                    "JOIN patients p ON pr.patient_id = p.patient_id " +
                    "JOIN doctors d ON pr.doctor_id = d.doctor_id " +
                    "WHERE pr.patient_id = ? " +
                    "ORDER BY pr.prescription_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                prescriptions.add(mapResultSetToPrescription(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prescriptions;
    }
    
    public List<Prescription> getPrescriptionsByDoctor(int doctorId) {
        List<Prescription> prescriptions = new ArrayList<>();
        String sql = "SELECT pr.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM prescriptions pr " +
                    "JOIN patients p ON pr.patient_id = p.patient_id " +
                    "JOIN doctors d ON pr.doctor_id = d.doctor_id " +
                    "WHERE pr.doctor_id = ? " +
                    "ORDER BY pr.prescription_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                prescriptions.add(mapResultSetToPrescription(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prescriptions;
    }
    
    public Prescription getPrescriptionByAppointment(int appointmentId) {
        String sql = "SELECT pr.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM prescriptions pr " +
                    "JOIN patients p ON pr.patient_id = p.patient_id " +
                    "JOIN doctors d ON pr.doctor_id = d.doctor_id " +
                    "WHERE pr.appointment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, appointmentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPrescription(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean deletePrescription(int prescriptionId) {
        String sql = "DELETE FROM prescriptions WHERE prescription_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, prescriptionId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getTotalPrescriptionsCount() {
        String sql = "SELECT COUNT(*) FROM prescriptions";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    private Prescription mapResultSetToPrescription(ResultSet rs) throws SQLException {
        Prescription prescription = new Prescription();
        prescription.setPrescriptionId(rs.getInt("prescription_id"));
        prescription.setAppointmentId(rs.getInt("appointment_id"));
        prescription.setPatientId(rs.getInt("patient_id"));
        prescription.setDoctorId(rs.getInt("doctor_id"));
        prescription.setDiagnosis(rs.getString("diagnosis"));
        prescription.setMedications(rs.getString("medications"));
        prescription.setInstructions(rs.getString("instructions"));
        prescription.setNotes(rs.getString("notes"));
        prescription.setPrescriptionDate(rs.getDate("prescription_date"));
        prescription.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Set display names
        prescription.setPatientName(rs.getString("patient_first_name") + " " + rs.getString("patient_last_name"));
        prescription.setDoctorName(rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));
        prescription.setPatientPhone(rs.getString("patient_phone"));
        prescription.setDoctorSpecialization(rs.getString("specialization"));
        
        return prescription;
    }
}
