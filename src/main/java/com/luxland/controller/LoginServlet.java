package com.luxland.controller;
import com.luxland.config.DBConnection;
import com.luxland.model.*;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String userIn = req.getParameter("username");
        String passIn = req.getParameter("password");
        String portalIn = req.getParameter("loginPortal");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE username = ? AND passwordHash = ?");
            ps.setString(1, userIn);
            ps.setString(2, passIn);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String dbRole = rs.getString("role");
                if (portalIn.equals("Guest") && !dbRole.equals("Guest")) { res.sendRedirect("login.jsp?error=wrong_portal"); return; }
                if (portalIn.equals("Staff") && dbRole.equals("Guest")) { res.sendRedirect("login.jsp?error=wrong_portal"); return; }

                User user;
                int id = rs.getInt("userID");
                String un = rs.getString("username"), em = rs.getString("email"), fn = rs.getString("fullName");
                Integer mHid = (rs.getObject("managedHotelID") != null) ? rs.getInt("managedHotelID") : null;

                if (dbRole.equalsIgnoreCase("Admin")) {
                    user = new Admin(id, un, passIn, em, fn, mHid);
                } else if (dbRole.equalsIgnoreCase("HotelStaff")) {
                    user = new HotelStaff(id, un, passIn, em, fn, mHid);
                } else {
                    user = new Guest(id, un, passIn, em, fn, mHid);
                }

                req.getSession().setAttribute("currentUser", user);
                res.sendRedirect("dashboard.jsp?login=success");
            } else { res.sendRedirect("login.jsp?error=invalid"); }
        } catch (Exception e) { e.printStackTrace(); }
    }
}