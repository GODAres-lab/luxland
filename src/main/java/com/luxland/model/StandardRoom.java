package com.luxland.model;

public class StandardRoom extends Room {
    public StandardRoom(int id, String num, double price, boolean avail) {
        super(id, num, price, avail);
    }

    @Override
    public double calculateTotalPrice(int nights) {
        return nights * pricePerNight;
    }
}