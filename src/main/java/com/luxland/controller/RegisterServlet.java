package com.luxland.controller;

import com.luxland.config.DBConnection;
import com.luxland.model.*;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String fn = req.getParameter("fullName"), un = req.getParameter("username");
        String em = req.getParameter("email"), pw = req.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {
            // PERBAIKAN: Masukkan kolom 'role' secara eksplisit sebagai 'Guest'
            String sql = "INSERT INTO users (username, passwordHash, email, fullName, role) VALUES (?, ?, ?, ?, 'Guest')";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, un);
            ps.setString(2, pw);
            ps.setString(3, em);
            ps.setString(4, fn);
            
            ps.executeUpdate();
            res.sendRedirect("login.jsp?msg=registered");
        } catch (Exception e) { 
            e.printStackTrace();
            res.sendRedirect("register.jsp?error=duplicate"); 
        }
    }
}