package com.luxland.controller;

import com.luxland.config.DBConnection;
import com.luxland.model.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");
        
        if(user == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int roomId = Integer.parseInt(req.getParameter("room_id"));
        LocalDate checkIn = LocalDate.parse(req.getParameter("check_in"));
        LocalDate checkOut = LocalDate.parse(req.getParameter("check_out"));

        // VALIDASI TANGGAL DI SERVER
        LocalDate today = LocalDate.now();
        if (checkIn.isBefore(today) || checkOut.isBefore(checkIn) || checkOut.isEqual(checkIn)) {
            res.sendRedirect("dashboard.jsp?error=invalid_date");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            // 1. Ambil data kamar dari DB
            PreparedStatement psr = con.prepareStatement("SELECT * FROM rooms WHERE roomID = ?");
            psr.setInt(1, roomId);
            ResultSet rsr = psr.executeQuery();
            
            if(rsr.next()) {
                // 2. Terapkan POLIMORFISME Room
                Room room;
                if(rsr.getString("type").equalsIgnoreCase("Deluxe")) {
                    room = new DeluxeRoom(roomId, rsr.getString("roomNumber"), rsr.getDouble("pricePerNight"), true);
                } else {
                    room = new StandardRoom(roomId, rsr.getString("roomNumber"), rsr.getDouble("pricePerNight"), true);
                }
                
                // 3. Buat Objek Booking
                Booking b = new Booking(user, room, checkIn, checkOut);
                
                if(b.saveToDatabase()) {
                    // 4. Ambil ID Booking yang barusan disimpan untuk halaman pembayaran
                    PreparedStatement psid = con.prepareStatement("SELECT MAX(bookingID) FROM bookings WHERE userID = ?");
                    psid.setInt(1, user.getUserID());
                    ResultSet rsid = psid.executeQuery();
                    
                    int bid = 0;
                    if(rsid.next()) bid = rsid.getInt(1);

                    // 5. REDIRECT OTOMATIS KE PORTAL PEMBAYARAN
                    res.sendRedirect("payment.jsp?bid=" + bid + "&total=" + b.getTotalPrice());
                } else {
                    res.sendRedirect("dashboard.jsp?msg=failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("dashboard.jsp?msg=error");
        }
    }
}