package com.acebank.lite.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** Loan application joined with applicant identity for the admin Loans page. */
public record AdminLoanView(
        int id,
        int accountNo,
        String applicantName,
        String email,
        String loanType,
        BigDecimal amount,
        int tenure,
        String purpose,
        String status,
        LocalDateTime appliedAt
) {}
