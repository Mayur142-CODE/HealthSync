package dao;

import model.Patient;
import util.DBConnection;
import util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {
    
    public Patient authenticatePatient(String email, String password) {
        String sql = "SELECT * FROM patients WHERE email = ? AND status = 'active'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (PasswordUtil.verifyPassword(password, storedPassword)) {
                    return mapResultSetToPatient(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addPatient(Patient patient) {
        String sql = "INSERT INTO patients (first_name, last_name, email, password, phone, date_of_birth, gender, blood_group, address, emergency_contact, registration_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, patient.getFirstName());
            stmt.setString(2, patient.getLastName());
            stmt.setString(3, patient.getEmail());
            stmt.setString(4, PasswordUtil.hashPassword(patient.getPassword()));
            stmt.setString(5, patient.getPhone());
            stmt.setDate(6, patient.getDateOfBirth());
            stmt.setString(7, patient.getGender());
            stmt.setString(8, patient.getBloodGroup());
            stmt.setString(9, patient.getAddress());
            stmt.setString(10, patient.getEmergencyContact());
            stmt.setString(11, patient.getStatus());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Patient getPatientById(int patientId) {
        String sql = "SELECT * FROM patients WHERE patient_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPatient(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updatePatient(Patient patient) {
        String sql = "UPDATE patients SET first_name = ?, last_name = ?, email = ?, phone = ?, date_of_birth = ?, gender = ?, blood_group = ?, address = ?, emergency_contact = ?, medical_history = ?, status = ? WHERE patient_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, patient.getFirstName());
            stmt.setString(2, patient.getLastName());
            stmt.setString(3, patient.getEmail());
            stmt.setString(4, patient.getPhone());
            stmt.setDate(5, patient.getDateOfBirth());
            stmt.setString(6, patient.getGender());
            stmt.setString(7, patient.getBloodGroup());
            stmt.setString(8, patient.getAddress());
            stmt.setString(9, patient.getEmergencyContact());
            stmt.setString(10, patient.getMedicalHistory());
            stmt.setString(11, patient.getStatus());
            stmt.setInt(12, patient.getPatientId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updatePatientProfile(Patient patient) {
        // Profile update - don't update email and status
        String sql = "UPDATE patients SET first_name = ?, last_name = ?, phone = ?, date_of_birth = ?, gender = ?, blood_group = ?, address = ?, emergency_contact = ? WHERE patient_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, patient.getFirstName());
            stmt.setString(2, patient.getLastName());
            stmt.setString(3, patient.getPhone());
            stmt.setDate(4, patient.getDateOfBirth());
            stmt.setString(5, patient.getGender());
            stmt.setString(6, patient.getBloodGroup());
            stmt.setString(7, patient.getAddress());
            stmt.setString(8, patient.getEmergencyContact());
            stmt.setInt(9, patient.getPatientId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean verifyPassword(int patientId, String password) {
        String sql = "SELECT password FROM patients WHERE patient_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                return PasswordUtil.verifyPassword(password, storedPassword);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deletePatient(int patientId) {
        String sql = "UPDATE patients SET status = 'inactive' WHERE patient_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean permanentDeletePatient(int patientId) {
        String sql = "DELETE FROM patients WHERE patient_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM patients ORDER BY first_name, last_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                patients.add(mapResultSetToPatient(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }
    
    public List<Patient> getActivePatients() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM patients WHERE status = 'active' ORDER BY first_name, last_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                patients.add(mapResultSetToPatient(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }
    
    public List<Patient> searchPatients(String searchTerm) {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM patients WHERE (first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR phone LIKE ?) AND status = 'active' ORDER BY first_name, last_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                patients.add(mapResultSetToPatient(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }
    
    public int getTotalPatientsCount() {
        String sql = "SELECT COUNT(*) FROM patients WHERE status = 'active'";
        
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
    
    /**
     * Get monthly patient registration counts for the past N months
     * @param months Number of months to retrieve data for
     * @return Map with month name as key and registration count as value
     */
    public java.util.Map<String, Integer> getMonthlyPatientRegistrations(int months) {
        java.util.Map<String, Integer> monthlyData = new java.util.LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(registration_date, '%Y-%m') as month, " +
                    "DATE_FORMAT(registration_date, '%b') as month_name, " +
                    "COUNT(*) as count " +
                    "FROM patients " +
                    "WHERE registration_date >= DATE_SUB(CURDATE(), INTERVAL ? MONTH) " +
                    "GROUP BY DATE_FORMAT(registration_date, '%Y-%m'), DATE_FORMAT(registration_date, '%b') " +
                    "ORDER BY month ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, months);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String monthName = rs.getString("month_name");
                int count = rs.getInt("count");
                monthlyData.put(monthName, count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return monthlyData;
    }
    
    public boolean changePassword(int patientId, String newPassword) {
        String sql = "UPDATE patients SET password = ? WHERE patient_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, PasswordUtil.hashPassword(newPassword));
            stmt.setInt(2, patientId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM patients WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Patient mapResultSetToPatient(ResultSet rs) throws SQLException {
        Patient patient = new Patient();
        patient.setPatientId(rs.getInt("patient_id"));
        patient.setFirstName(rs.getString("first_name"));
        patient.setLastName(rs.getString("last_name"));
        patient.setEmail(rs.getString("email"));
        patient.setPhone(rs.getString("phone"));
        patient.setDateOfBirth(rs.getDate("date_of_birth"));
        patient.setGender(rs.getString("gender"));
        patient.setBloodGroup(rs.getString("blood_group"));
        patient.setAddress(rs.getString("address"));
        patient.setEmergencyContact(rs.getString("emergency_contact"));
        patient.setMedicalHistory(rs.getString("medical_history"));
        patient.setRegistrationDate(rs.getDate("registration_date"));
        patient.setStatus(rs.getString("status"));
        return patient;
    }
}
