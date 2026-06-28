package com.acebank.lite.models;

import java.math.BigDecimal;

public record LoginResult(
        boolean success,
        String message,
        int accountNumber,
        String firstName,
        String lastName,
        String email,
        String role,
        BigDecimal balance
) {}