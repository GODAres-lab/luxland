package com.luxland.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    
    // Pengaturan koneksi ke XAMPP
    private static final String URL = "jdbc:mysql://localhost:3306/luxland_db";
    private static final String USER = "root";
    private static final String PASSWORD = ""; 

    public static Connection getConnection() {
        Connection con = null;
        try {
            // Memanggil driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Menghubungi database
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Koneksi Gagal: " + e.getMessage());
        }
        return con; // HARUS ADA BARIS INI AGAR TIDAK MERAH
    }
}