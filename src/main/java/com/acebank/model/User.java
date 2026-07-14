package com.acebank.model;

import java.sql.Timestamp;

/** A user/customer record. */
public record User(
        int id,
        String firstName,
        String lastName,
        String email,
        String phone,
        String passwordHash,
        String role,
        String status,
        int failedLoginAttempts,
        Timestamp lockedUntil
) {
    public String fullName() { return (firstName + " " + lastName).trim(); }
    public boolean isAdmin()  { return "ADMIN".equals(role); }
}
