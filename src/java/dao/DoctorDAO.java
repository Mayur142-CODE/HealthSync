package dao;

import model.Doctor;
import util.DBConnection;
import util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO {
    
    public Doctor authenticateDoctor(String email, String password) {
        String sql = "SELECT * FROM doctors WHERE email = ? AND status = 'active'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (PasswordUtil.verifyPassword(password, storedPassword)) {
                    return mapResultSetToDoctor(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean addDoctor(Doctor doctor) {
        String sql = "INSERT INTO doctors (first_name, last_name, email, password, phone, specialization, qualification, experience, address, date_joined, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, doctor.getFirstName());
            stmt.setString(2, doctor.getLastName());
            stmt.setString(3, doctor.getEmail());
            stmt.setString(4, PasswordUtil.hashPassword(doctor.getPassword()));
            stmt.setString(5, doctor.getPhone());
            stmt.setString(6, doctor.getSpecialization());
            stmt.setString(7, doctor.getQualification());
            stmt.setInt(8, doctor.getExperience());
            stmt.setString(9, doctor.getAddress());
            stmt.setString(10, doctor.getStatus());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Doctor getDoctorById(int doctorId) {
        String sql = "SELECT * FROM doctors WHERE doctor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToDoctor(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateDoctor(Doctor doctor) {
        // Updated SQL - don't update email and status in profile updates
        String sql = "UPDATE doctors SET first_name = ?, last_name = ?, phone = ?, specialization = ?, qualification = ?, experience = ?, address = ? WHERE doctor_id = ?";
        
        System.out.println("=== DoctorDAO.updateDoctor called ===");
        System.out.println("Doctor ID: " + doctor.getDoctorId());
        System.out.println("First Name: " + doctor.getFirstName());
        System.out.println("Last Name: " + doctor.getLastName());
        System.out.println("Phone: " + doctor.getPhone());
        System.out.println("Specialization: " + doctor.getSpecialization());
        System.out.println("Qualification: " + doctor.getQualification());
        System.out.println("Experience: " + doctor.getExperience());
        System.out.println("Address: " + doctor.getAddress());
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, doctor.getFirstName());
            stmt.setString(2, doctor.getLastName());
            stmt.setString(3, doctor.getPhone());
            stmt.setString(4, doctor.getSpecialization());
            stmt.setString(5, doctor.getQualification());
            stmt.setInt(6, doctor.getExperience());
            stmt.setString(7, doctor.getAddress());
            stmt.setInt(8, doctor.getDoctorId());
            
            System.out.println("Executing SQL: " + sql);
            int rowsUpdated = stmt.executeUpdate();
            System.out.println("Rows updated: " + rowsUpdated);
            
            return rowsUpdated > 0;
        } catch (SQLException e) {
            System.err.println("=== SQL Exception in updateDoctor ===");
            System.err.println("Error message: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteDoctor(int doctorId) {
        String sql = "UPDATE doctors SET status = 'inactive' WHERE doctor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean permanentDeleteDoctor(int doctorId) {
        String sql = "DELETE FROM doctors WHERE doctor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Doctor> getAllDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT * FROM doctors ORDER BY first_name, last_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                doctors.add(mapResultSetToDoctor(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doctors;
    }
    
    public List<Doctor> getActiveDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT * FROM doctors WHERE status = 'active' ORDER BY first_name, last_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                doctors.add(mapResultSetToDoctor(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doctors;
    }
    
    public List<Doctor> searchDoctors(String searchTerm) {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT * FROM doctors WHERE (first_name LIKE ? OR last_name LIKE ? OR specialization LIKE ? OR email LIKE ?) AND status = 'active' ORDER BY first_name, last_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                doctors.add(mapResultSetToDoctor(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doctors;
    }
    
    public int getTotalDoctorsCount() {
        String sql = "SELECT COUNT(*) FROM doctors WHERE status = 'active'";
        
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
    
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM doctors WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email.toLowerCase());
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean verifyPassword(int doctorId, String password) {
        String sql = "SELECT password FROM doctors WHERE doctor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
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
    
    public boolean changePassword(int doctorId, String newPassword) {
        String sql = "UPDATE doctors SET password = ? WHERE doctor_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, PasswordUtil.hashPassword(newPassword));
            stmt.setInt(2, doctorId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private Doctor mapResultSetToDoctor(ResultSet rs) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setDoctorId(rs.getInt("doctor_id"));
        doctor.setFirstName(rs.getString("first_name"));
        doctor.setLastName(rs.getString("last_name"));
        doctor.setEmail(rs.getString("email"));
        doctor.setPhone(rs.getString("phone"));
        doctor.setSpecialization(rs.getString("specialization"));
        doctor.setQualification(rs.getString("qualification"));
        doctor.setExperience(rs.getInt("experience"));
        doctor.setAddress(rs.getString("address"));
        doctor.setDateJoined(rs.getDate("date_joined"));
        doctor.setStatus(rs.getString("status"));
        doctor.setProfileImage(rs.getString("profile_image"));
        return doctor;
    }
}
