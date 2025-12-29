package com.luxland.model;

import com.luxland.config.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Booking implements IPayable {
    private int bookingID;
    private User guest;
    private Room room;
    private LocalDate checkIn, checkOut;
    private double totalPrice; // Pastikan ini double
    private String paymentStatus;

    public Booking(User guest, Room room, LocalDate checkIn, LocalDate checkOut) {
        this.guest = guest;
        this.room = room;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.paymentStatus = "Pending";
        
        long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
        if (nights < 1) nights = 1;
        
        // Menghitung harga total
        this.totalPrice = room.calculateTotalPrice((int) nights);
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    // Perbaikan method ini:
    @Override
    public boolean processPayment(double amount) {
        if (amount >= this.totalPrice) {
            this.paymentStatus = "Paid";
            return true; 
        }
        return false;
    }

    @Override
    public String getPaymentStatus() {
        return paymentStatus;
    }

    public boolean saveToDatabase() {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO bookings (userID, roomID, checkInDate, checkOutDate, totalPrice, paymentStatus) VALUES (?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, guest.getUserID());
            ps.setInt(2, room.getRoomID());
            ps.setDate(3, Date.valueOf(checkIn));
            ps.setDate(4, Date.valueOf(checkOut));
            ps.setDouble(5, totalPrice);
            ps.setString(6, paymentStatus);
            
            if (ps.executeUpdate() > 0) {
                // Update status kamar jadi tidak tersedia (isAvailable = 0)
                PreparedStatement up = con.prepareStatement("UPDATE rooms SET isAvailable = 0 WHERE roomID = ?");
                up.setInt(1, room.getRoomID());
                up.executeUpdate();
                return true;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}