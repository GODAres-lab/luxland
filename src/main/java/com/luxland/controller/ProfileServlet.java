package com.luxland.controller;

import com.luxland.config.DBConnection;
import com.luxland.model.User;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String newPass = req.getParameter("newPassword");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE users SET passwordHash = ? WHERE userID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newPass);
            ps.setInt(2, currentUser.getUserID());
            
            ps.executeUpdate();
            res.sendRedirect("profile.jsp?msg=success");
            
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("profile.jsp?msg=error");
        }
    }
}