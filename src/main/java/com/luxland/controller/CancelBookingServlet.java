package com.luxland.controller;
import com.luxland.config.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        int bid = Integer.parseInt(req.getParameter("bid"));
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps1 = con.prepareStatement("SELECT roomID FROM bookings WHERE bookingID = ?");
            ps1.setInt(1, bid);
            ResultSet rs = ps1.executeQuery();
            if(rs.next()) {
                int rid = rs.getInt(1);
                con.prepareStatement("UPDATE bookings SET paymentStatus = 'Cancelled' WHERE bookingID = " + bid).executeUpdate();
                con.prepareStatement("UPDATE rooms SET isAvailable = 1 WHERE roomID = " + rid).executeUpdate();
            }
            res.sendRedirect("dashboard.jsp?cancel=success");
        } catch (Exception e) { e.printStackTrace(); }
    }
}