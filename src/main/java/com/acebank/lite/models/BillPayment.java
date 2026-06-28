package com.acebank.lite.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record BillPayment(
    Integer id,
    Integer accountNo,
    String billerName,
    String billerCategory,
    BigDecimal amount,
    String referenceNo,
    String consumerNo,
    String status,
    LocalDateTime createdAt
) {}
