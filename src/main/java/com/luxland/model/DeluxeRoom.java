package com.luxland.model;

public class DeluxeRoom extends Room {
    private boolean miniBarIncluded = true; // Default untuk Deluxe sesuai UML

    public DeluxeRoom(int id, String num, double price, boolean avail) {
        super(id, num, price, avail);
    }

    public boolean isMiniBarIncluded() { return miniBarIncluded; }

    @Override
    public double calculateTotalPrice(int nights) {
        return nights * pricePerNight;
    }
}