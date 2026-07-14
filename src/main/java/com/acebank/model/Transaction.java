package com.acebank.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/** A ledger transaction. */
public record Transaction(
        long id,
        Long senderAccount,
        Long receiverAccount,
        BigDecimal amount,
        String txType,
        String status,
        String remark,
        String referenceNo,
        Timestamp createdAt
) {}
