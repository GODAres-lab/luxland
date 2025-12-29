package com.luxland.model;
public abstract class User {
    protected int userID;
    protected String username, passwordHash, email, fullName, role;
    protected Integer managedHotelID; 

    public User(int userID, String username, String passwordHash, String email, String fullName, String role, Integer managedHotelID) {
        this.userID = userID;
        this.username = username;
        this.passwordHash = passwordHash;
        this.email = email;
        this.fullName = fullName;
        this.role = role;
        this.managedHotelID = managedHotelID;
    }
    public int getUserID() { return userID; }
    public String getUsername() { return username; }
    public String getPasswordHash() { return passwordHash; }
    public String getFullName() { return fullName; }
    public String getEmail() { return email; }
    public String getRole() { return role; }
    public Integer getManagedHotelID() { return managedHotelID; }
}