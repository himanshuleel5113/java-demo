package com.acebank.lite.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** Flattened customer + primary account row for the admin Customers page. */
public record AdminCustomerView(
        int userId,
        String firstName,
        String lastName,
        String email,
        String phone,
        String userStatus,
        LocalDateTime createdAt,
        int accountNo,
        BigDecimal balance,
        String accountStatus
) {}
