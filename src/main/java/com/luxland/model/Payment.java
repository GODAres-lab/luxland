package com.luxland.model;

import java.util.Date;

public class Payment {
    private int paymentID;
    private double amount;
    private String paymentMethod;
    private Date transactionDate;

    public Payment(int paymentID, double amount, String paymentMethod) {
        this.paymentID = paymentID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.transactionDate = new Date(); // Set waktu sekarang
    }

    // Getters
    public double getAmount() { return amount; }
    public String getPaymentMethod() { return paymentMethod; }
    public Date getTransactionDate() { return transactionDate; }
}