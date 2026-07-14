package com.acebank.model;

import java.math.BigDecimal;

/** A bank account. Money is always BigDecimal, never double. */
public record Account(
        long accountNo,
        int userId,
        String accountType,
        BigDecimal balance,
        String status,
        int version
) {}
