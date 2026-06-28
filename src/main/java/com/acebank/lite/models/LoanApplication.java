package com.acebank.lite.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record LoanApplication(
    Integer id,
    Integer accountNo,
    String loanType,
    BigDecimal amount,
    Integer tenure,
    String purpose,
    String status,
    Integer reviewedBy,
    String reviewNotes,
    LocalDateTime appliedAt,
    LocalDateTime reviewedAt
) {}
