package com.acebank.lite.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record Account(
        Integer accountNo,
        Integer userId,
        String accountType,
        BigDecimal balance,
        String status,
        Integer version,
        LocalDateTime createdAt
) {}