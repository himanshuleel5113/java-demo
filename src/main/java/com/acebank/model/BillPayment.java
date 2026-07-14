package com.acebank.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/** A single bill payment made from a customer's account. */
public record BillPayment(
        long id,
        int userId,
        long accountNo,
        String category,
        String biller,
        String consumerNo,
        String nickname,
        BigDecimal amount,
        String status,
        String referenceNo,
        Timestamp createdAt
) {}
