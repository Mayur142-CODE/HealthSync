package model;

import java.sql.Date;

public class Doctor {
    private int doctorId;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String phone;
    private String specialization;
    private String qualification;
    private int experience;
    private String address;
    private Date dateJoined;
    private String status;
    private String profileImage;
    
    public Doctor() {}
    
    public Doctor(String firstName, String lastName, String email, String password, 
                 String phone, String specialization, String qualification, 
                 int experience, String address) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.specialization = specialization;
        this.qualification = qualification;
        this.experience = experience;
        this.address = address;
        this.status = "active";
    }
    
    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }
    
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }
    
    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }
    
    public int getExperience() { return experience; }
    public void setExperience(int experience) { this.experience = experience; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public Date getDateJoined() { return dateJoined; }
    public void setDateJoined(Date dateJoined) { this.dateJoined = dateJoined; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }
    
    public String getFullName() {
        return firstName + " " + lastName;
    }
}
