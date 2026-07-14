package com.acebank.model;

import java.math.BigDecimal;
import java.sql.Date;

/** A customer loan with EMI amortisation details. */
public record Loan(
        long id,
        int userId,
        long accountNo,
        String loanRef,
        String loanType,
        BigDecimal principal,
        BigDecimal outstanding,
        BigDecimal interestRate,
        int tenureMonths,
        BigDecimal emiAmount,
        Date nextDueDate,
        String status
) {
    /** Fraction of the principal already repaid, 0..100 (for progress bars). */
    public int progressPercent() {
        if (principal == null || principal.signum() == 0) return 0;
        BigDecimal paid = principal.subtract(outstanding == null ? BigDecimal.ZERO : outstanding);
        int pct = paid.multiply(BigDecimal.valueOf(100))
                .divide(principal, 0, java.math.RoundingMode.HALF_UP).intValue();
        return Math.max(0, Math.min(100, pct));
    }
}
