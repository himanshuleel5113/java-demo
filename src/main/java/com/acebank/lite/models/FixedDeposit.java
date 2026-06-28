package com.acebank.lite.models;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public record FixedDeposit(
    Integer id,
    Integer accountNo,
    BigDecimal amount,
    BigDecimal interestRate,
    Integer tenureMonths,
    LocalDate maturityDate,
    BigDecimal maturityAmount,
    String status,
    LocalDateTime createdAt
) {}
