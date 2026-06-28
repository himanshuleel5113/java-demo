package com.acebank.lite.models;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public record RecurringDeposit(
    Integer id,
    Integer accountNo,
    BigDecimal monthlyAmount,
    BigDecimal interestRate,
    Integer tenureMonths,
    BigDecimal totalDeposited,
    BigDecimal maturityAmount,
    String status,
    LocalDate nextDebitDate,
    LocalDateTime createdAt
) {}
