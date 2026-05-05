package com.p2p.model;

import java.sql.Timestamp;

/**
 * User Model class — represents a Study Material Hub user (student or faculty).
 */
public class User {

    public static final String ROLE_STUDENT = "student";
    public static final String ROLE_FACULTY = "faculty";

    private int userId;
    private String username;
    private String password;
    private String email;
    private String role;
    private String branch;
    private int semester;
    private String ipAddress;
    private int port;
    private boolean isOnline;
    private Timestamp registrationDate;
    private Timestamp lastLogin;

    public User() {
        this.role = ROLE_STUDENT;
    }

    public User(String username, String password, String email) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = ROLE_STUDENT;
        this.isOnline = false;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isFaculty() { return ROLE_FACULTY.equalsIgnoreCase(role); }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public int getPort() { return port; }
    public void setPort(int port) { this.port = port; }

    public boolean isOnline() { return isOnline; }
    public void setOnline(boolean online) { isOnline = online; }

    public Timestamp getRegistrationDate() { return registrationDate; }
    public void setRegistrationDate(Timestamp registrationDate) { this.registrationDate = registrationDate; }

    public Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(Timestamp lastLogin) { this.lastLogin = lastLogin; }

    @Override
    public String toString() {
        return "User{id=" + userId + ", username=" + username + ", role=" + role +
               ", branch=" + branch + ", sem=" + semester + "}";
    }
}
