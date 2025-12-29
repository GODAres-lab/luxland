package com.luxland.model;

public interface IPayable {
    // Pastikan di sini tertulis 'boolean', bukan 'double'
    boolean processPayment(double amount);
    String getPaymentStatus();
}