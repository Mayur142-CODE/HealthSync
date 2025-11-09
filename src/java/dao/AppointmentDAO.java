package dao;

import model.Appointment;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    
    public boolean addAppointment(Appointment appointment) {
        String sql = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, reason, status, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, appointment.getPatientId());
            stmt.setInt(2, appointment.getDoctorId());
            stmt.setDate(3, appointment.getAppointmentDate());
            stmt.setTime(4, appointment.getAppointmentTime());
            stmt.setString(5, appointment.getReason());
            stmt.setString(6, appointment.getStatus());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Appointment getAppointmentById(int appointmentId) {
        String sql = "SELECT a.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM appointments a " +
                    "JOIN patients p ON a.patient_id = p.patient_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "WHERE a.appointment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, appointmentId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToAppointment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateAppointment(Appointment appointment) {
        String sql = "UPDATE appointments SET appointment_date = ?, appointment_time = ?, reason = ?, status = ?, notes = ?, updated_at = NOW() WHERE appointment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, appointment.getAppointmentDate());
            stmt.setTime(2, appointment.getAppointmentTime());
            stmt.setString(3, appointment.getReason());
            stmt.setString(4, appointment.getStatus());
            stmt.setString(5, appointment.getNotes());
            stmt.setInt(6, appointment.getAppointmentId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateAppointmentStatus(int appointmentId, String status) {
        String sql = "UPDATE appointments SET status = ?, updated_at = NOW() WHERE appointment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, appointmentId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Appointment> getAllAppointments() {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM appointments a " +
                    "JOIN patients p ON a.patient_id = p.patient_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    public List<Appointment> getAppointmentsByPatient(int patientId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM appointments a " +
                    "JOIN patients p ON a.patient_id = p.patient_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "WHERE a.patient_id = ? " +
                    "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    public List<Appointment> getAppointmentsByDoctor(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM appointments a " +
                    "JOIN patients p ON a.patient_id = p.patient_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "WHERE a.doctor_id = ? " +
                    "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    public List<Appointment> getPendingAppointments() {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM appointments a " +
                    "JOIN patients p ON a.patient_id = p.patient_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "WHERE a.status = 'pending' " +
                    "ORDER BY a.appointment_date ASC, a.appointment_time ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    public List<Appointment> getTodaysAppointmentsByDoctor(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM appointments a " +
                    "JOIN patients p ON a.patient_id = p.patient_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "WHERE a.doctor_id = ? AND a.appointment_date = CURDATE() AND a.status IN ('approved', 'completed') " +
                    "ORDER BY a.appointment_time ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    public int getTotalAppointmentsCount() {
        String sql = "SELECT COUNT(*) FROM appointments";
        
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
    
    public int getPendingAppointmentsCount() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE status = 'pending'";
        
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
    
    public boolean isTimeSlotAvailable(int doctorId, Date appointmentDate, Time appointmentTime) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND appointment_date = ? AND appointment_time = ? AND status IN ('pending', 'approved')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            stmt.setDate(2, appointmentDate);
            stmt.setTime(3, appointmentTime);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean addAppointmentNotes(int appointmentId, String notes) {
        String sql = "UPDATE appointments SET notes = ?, updated_at = NOW() WHERE appointment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, notes);
            stmt.setInt(2, appointmentId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Appointment> getCompletedAppointmentsByPatient(int patientId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM appointments a " +
                    "JOIN patients p ON a.patient_id = p.patient_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "WHERE a.patient_id = ? AND a.status = 'completed' " +
                    "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    public List<Appointment> getCompletedAppointmentsByDoctor(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, p.first_name as patient_first_name, p.last_name as patient_last_name, p.phone as patient_phone, " +
                    "d.first_name as doctor_first_name, d.last_name as doctor_last_name, d.specialization " +
                    "FROM appointments a " +
                    "JOIN patients p ON a.patient_id = p.patient_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "WHERE a.doctor_id = ? AND a.status = 'completed' " +
                    "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, doctorId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    // Analytics Methods for Dashboard
    
    /**
     * Get count of appointments by status
     * @return Map with status as key and count as value
     */
    public java.util.Map<String, Integer> getAppointmentStatusCounts() {
        java.util.Map<String, Integer> statusCounts = new java.util.LinkedHashMap<>();
        String sql = "SELECT status, COUNT(*) as count FROM appointments GROUP BY status";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("count");
                // Capitalize first letter for display
                String displayStatus = status.substring(0, 1).toUpperCase() + status.substring(1);
                statusCounts.put(displayStatus, count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Ensure all statuses are present even if count is 0
        if (!statusCounts.containsKey("Scheduled")) statusCounts.put("Scheduled", 0);
        if (!statusCounts.containsKey("Completed")) statusCounts.put("Completed", 0);
        if (!statusCounts.containsKey("Cancelled")) statusCounts.put("Cancelled", 0);
        if (!statusCounts.containsKey("Pending")) statusCounts.put("Pending", 0);
        
        return statusCounts;
    }
    
    /**
     * Get count of completed appointments
     * @return Number of completed appointments
     */
    public int getCompletedAppointmentsCount() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE status = 'completed'";
        
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
     * Get scheduled appointments count
     * @return Number of scheduled appointments
     */
    public int getScheduledAppointmentsCount() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE status = 'scheduled'";
        
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
    
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setAppointmentId(rs.getInt("appointment_id"));
        appointment.setPatientId(rs.getInt("patient_id"));
        appointment.setDoctorId(rs.getInt("doctor_id"));
        appointment.setAppointmentDate(rs.getDate("appointment_date"));
        appointment.setAppointmentTime(rs.getTime("appointment_time"));
        appointment.setReason(rs.getString("reason"));
        appointment.setStatus(rs.getString("status"));
        appointment.setNotes(rs.getString("notes"));
        appointment.setCreatedAt(rs.getTimestamp("created_at"));
        appointment.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Set display names
        appointment.setPatientName(rs.getString("patient_first_name") + " " + rs.getString("patient_last_name"));
        appointment.setDoctorName(rs.getString("doctor_first_name") + " " + rs.getString("doctor_last_name"));
        appointment.setPatientPhone(rs.getString("patient_phone"));
        appointment.setDoctorSpecialization(rs.getString("specialization"));
        
        return appointment;
    }
}
