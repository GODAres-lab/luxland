package com.luxland.model;

import com.luxland.config.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Hotel {
    private int hotelID;
    private String name;
    private String address;
    private double rating;
    private List<Room> rooms; // List untuk menyimpan objek kamar (Polymorphism)

    public Hotel(int hotelID, String name, String address, double rating) {
        this.hotelID = hotelID;
        this.name = name;
        this.address = address;
        this.rating = rating;
        this.rooms = new ArrayList<>();
    }

    // Method untuk menambah kamar ke dalam hotel
    public void addRoom(Room room) {
        this.rooms.add(room);
    }

    // Getters
    public List<Room> getRooms() { return rooms; }
    public String getName() { return name; }
    public String getAddress() { return address; }
    public double getRating() { return rating; }
    public int getHotelID() { return hotelID; }

    // --- STATIC METHOD: Mengambil Data dari Database ---
    // Method ini digunakan oleh dashboard.jsp untuk menampilkan daftar hotel dan kamar
    public static List<Hotel> getAllHotels() {
        List<Hotel> listHotel = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            // 1. Ambil Semua Data Hotel
            String sqlHotel = "SELECT * FROM hotels";
            PreparedStatement ps = con.prepareStatement(sqlHotel);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // Buat Objek Hotel berdasarkan baris database
                Hotel h = new Hotel(
                    rs.getInt("hotelID"),
                    rs.getString("name"),
                    rs.getString("address"),
                    rs.getDouble("rating")
                );

                // 2. Ambil Data Kamar khusus untuk Hotel ini
                String sqlRoom = "SELECT * FROM rooms WHERE hotelID = ?";
                PreparedStatement psRoom = con.prepareStatement(sqlRoom);
                psRoom.setInt(1, h.getHotelID());
                ResultSet rsRoom = psRoom.executeQuery();

                while (rsRoom.next()) {
                    // INTI POLYMORPHISM:
                    // Cek kolom 'type' di DB. Jika 'Standard' buat StandardRoom, jika 'Deluxe' buat DeluxeRoom.
                    String type = rsRoom.getString("type");
                    Room r = null;

                    int rId = rsRoom.getInt("roomID");
                    String rNum = rsRoom.getString("roomNumber");
                    double rPrice = rsRoom.getDouble("pricePerNight");
                    boolean rAvail = rsRoom.getInt("isAvailable") == 1; // 1 = true, 0 = false

                    if (type.equalsIgnoreCase("Standard")) {
                        r = new StandardRoom(rId, rNum, rPrice, rAvail);
                    } else if (type.equalsIgnoreCase("Deluxe")) {
                        r = new DeluxeRoom(rId, rNum, rPrice, rAvail);
                    }
                    // SuiteRoom dihapus dari sini agar sesuai UML

                    // Masukkan objek kamar ke dalam list rooms milik objek Hotel h
                    if (r != null) {
                        h.addRoom(r);
                    }
                }
                
                // Masukkan objek hotel yang sudah berisi kamar ke dalam list utama
                listHotel.add(h);
            }
        } catch (Exception e) {
            System.out.println("Error di Hotel.java: " + e.getMessage());
            e.printStackTrace();
        }
        return listHotel;
    }
}