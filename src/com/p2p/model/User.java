package com.p2p.model;

import java.sql.Timestamp;

/**
 * User Model class representing a user in the P2P network.
 * This is part of the MVC Model layer.
 */
public class User {
    
    private int userId;
    private String username;
    private String password;
    private String email;
    private String ipAddress;
    private int port;
    private boolean isOnline;
    private Timestamp registrationDate;
    private Timestamp lastLogin;
    
    // Constructors
    public User() {
    }
    
    public User(String username, String password, String email) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.isOnline = false;
    }
    
    public User(int userId, String username, String email, String ipAddress, int port, boolean isOnline) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.ipAddress = ipAddress;
        this.port = port;
        this.isOnline = isOnline;
    }
    
    // Getters and Setters
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getIpAddress() {
        return ipAddress;
    }
    
    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
    
    public int getPort() {
        return port;
    }
    
    public void setPort(int port) {
        this.port = port;
    }
    
    public boolean isOnline() {
        return isOnline;
    }
    
    public void setOnline(boolean online) {
        isOnline = online;
    }
    
    public Timestamp getRegistrationDate() {
        return registrationDate;
    }
    
    public void setRegistrationDate(Timestamp registrationDate) {
        this.registrationDate = registrationDate;
    }
    
    public Timestamp getLastLogin() {
        return lastLogin;
    }
    
    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }
    
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", ipAddress='" + ipAddress + '\'' +
                ", port=" + port +
                ", isOnline=" + isOnline +
                '}';
    }
}