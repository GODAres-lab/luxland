package com.luxland.model;

import java.util.ArrayList;
import java.util.List;

public class Guest extends User {
    // Atribut sesuai UML Halaman 5
    private List<Booking> bookingHistory;

    public Guest(int id, String un, String pw, String em, String fn, Integer mHid) {
        super(id, un, pw, em, fn, "Guest", mHid);
        this.bookingHistory = new ArrayList<>();
    }

    // Method sesuai UML Halaman 5
    public List<Hotel> searchHotel(String criteria) {
        System.out.println("Guest mencari hotel dengan kriteria: " + criteria);
        return Hotel.getAllHotels(); // Simulasi
    }

    public void createBooking() {
        System.out.println("Guest sedang memproses booking...");
    }

    public void writeReview(Hotel hotel, String reviewText) {
        System.out.println("Guest menulis review untuk: " + hotel.getName());
    }
}