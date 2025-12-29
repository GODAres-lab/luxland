package com.luxland.model;

import java.util.List;

public class Admin extends User {

    public Admin(int id, String un, String pw, String em, String fn, Integer mHid) {
        super(id, un, pw, em, fn, "Admin", mHid);
    }

    // Method sesuai UML Halaman 5
    public void addHotel(Hotel hotel) {
        System.out.println("Admin menambahkan hotel baru: " + hotel.getName());
    }

    public void manageUser(User user) {
        System.out.println("Admin mengelola user: " + user.getUsername());
    }

    public boolean verifyProperty(Hotel hotel) {
        System.out.println("Admin memverifikasi hotel: " + hotel.getName());
        return true;
    }
}