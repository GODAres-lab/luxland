package com.luxland.model;
public class HotelStaff extends User {
    public HotelStaff(int id, String un, String pw, String em, String fn, Integer mHid) {
        super(id, un, pw, em, fn, "HotelStaff", mHid);
    }
}