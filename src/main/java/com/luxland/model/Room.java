package com.luxland.model;

public abstract class Room {
    protected int roomID;
    protected String roomNumber;
    protected double pricePerNight;
    protected boolean isAvailable;

    public Room(int roomID, String roomNumber, double pricePerNight, boolean isAvailable) {
        this.roomID = roomID;
        this.roomNumber = roomNumber;
        this.pricePerNight = pricePerNight;
        this.isAvailable = isAvailable;
    }

    public abstract double calculateTotalPrice(int nights);

    public int getRoomID() { return roomID; }
    public String getRoomNumber() { return roomNumber; }
    public double getPricePerNight() { return pricePerNight; }
    public boolean isAvailable() { return isAvailable; }
}