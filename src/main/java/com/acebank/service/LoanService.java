package com.acebank.service;

import com.acebank.dao.AuditDao;
import com.acebank.dao.LoanDao;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.Set;
import java.util.UUID;

/**
 * Loan origination. Applying for a loan computes the reducing-balance EMI and
 * records the loan; no cash is disbursed to the account in this build (the loan
 * is booked as an obligation the customer then repays via EMIs).
 */
public class LoanService {

    private final LoanDao loans = new LoanDao();
    private final AuditDao audit = new AuditDao();

    private static final Set<String> TYPES = Set.of("HOME", "CAR", "PERSONAL", "EDUCATION");

    public record Result(boolean success, String message, String reference) {
        static Result ok(String ref)   { return new Result(true, "Loan application approved.", ref); }
        static Result fail(String msg) { return new Result(false, msg, null); }
    }

    public Result apply(int userId, long accountNo, String type, BigDecimal principal,
                        BigDecimal annualRate, int tenureMonths, String ip) {
        if (type == null || !TYPES.contains(type))                 return Result.fail("Choose a valid loan type.");
        if (principal == null || principal.signum() <= 0)          return Result.fail("Enter a valid loan amount.");
        if (annualRate == null || annualRate.signum() <= 0)        return Result.fail("Enter a valid interest rate.");
        if (tenureMonths <= 0 || tenureMonths > 600)               return Result.fail("Enter a valid tenure (1-600 months).");

        principal = principal.setScale(2, RoundingMode.HALF_UP);
        BigDecimal emi = emi(principal, annualRate, tenureMonths);
        String ref = "LN" + UUID.randomUUID().toString().substring(0, 10).toUpperCase();
        java.sql.Date nextDue = java.sql.Date.valueOf(LocalDate.now().plusMonths(1));

        loans.insert(userId, accountNo, ref, type, principal, annualRate, tenureMonths, emi, nextDue);
        audit.log(userId, "LOAN_APPLY",
                type + " loan " + principal + " @" + annualRate + "% x " + tenureMonths + "m ref " + ref, ip);
        return Result.ok(ref);
    }

    /**
     * Reducing-balance EMI: P·r·(1+r)^n / ((1+r)^n − 1), where r is the monthly
     * rate. Returned scaled to 2 decimals.
     */
    public static BigDecimal emi(BigDecimal principal, BigDecimal annualRatePercent, int months) {
        double p = principal.doubleValue();
        double r = annualRatePercent.doubleValue() / 12.0 / 100.0;
        double emi;
        if (r == 0) {
            emi = p / months;
        } else {
            double pow = Math.pow(1 + r, months);
            emi = p * r * pow / (pow - 1);
        }
        return BigDecimal.valueOf(emi).setScale(2, RoundingMode.HALF_UP);
    }
}
