package com.luxland.controller;
import com.luxland.config.DBConnection;
import com.luxland.model.User;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");
        String bid = req.getParameter("bid");
        String total = req.getParameter("total");
        String confirmPass = req.getParameter("confirmPass");

        if (user == null || !user.getPasswordHash().equals(confirmPass)) {
            res.sendRedirect("payment.jsp?bid=" + bid + "&total=" + total + "&error=wrong_pass");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE bookings SET paymentStatus = 'Paid' WHERE bookingID = ?");
            ps.setInt(1, Integer.parseInt(bid));
            ps.executeUpdate();
            res.sendRedirect("dashboard.jsp?payment=success");
        } catch (Exception e) { res.sendRedirect("payment.jsp?bid=" + bid + "&total=" + total + "&error=system"); }
    }
}