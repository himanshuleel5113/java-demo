package com.acebank.lite.service;

import com.acebank.lite.dao.AccountDao;
import com.acebank.lite.dao.AccountDaoImpl;
import com.acebank.lite.dao.RecurringDepositDao;
import com.acebank.lite.dao.RecurringDepositDaoImpl;
import com.acebank.lite.dao.TransactionDao;
import com.acebank.lite.dao.TransactionDaoImpl;
import com.acebank.lite.models.Account;
import com.acebank.lite.models.RecurringDeposit;
import com.acebank.lite.models.ServiceResponse;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class RecurringDepositServiceImpl implements RecurringDepositService {

    private static final BigDecimal MIN_MONTHLY = new BigDecimal("500");
    private static final BigDecimal BASE_RATE = new BigDecimal("7.00");

    private final RecurringDepositDao rdDao;
    private final AccountDao accountDao;
    private final TransactionDao transactionDao;

    public RecurringDepositServiceImpl() {
        this.rdDao = new RecurringDepositDaoImpl();
        this.accountDao = new AccountDaoImpl();
        this.transactionDao = new TransactionDaoImpl();
    }

    @Override
    public ServiceResponse<RecurringDeposit> openRD(int accountNo, double monthlyAmount, int tenureMonths) {
        BigDecimal monthly = BigDecimal.valueOf(monthlyAmount).setScale(2, RoundingMode.HALF_UP);

        if (monthly.compareTo(MIN_MONTHLY) < 0) {
            return ServiceResponse.error("Minimum monthly deposit is ₹500.");
        }
        if (tenureMonths < 6) {
            return ServiceResponse.error("Minimum tenure is 6 months.");
        }

        Account account = accountDao.getAccount(accountNo);
        if (account == null) {
            return ServiceResponse.error("Account not found.");
        }
        if (account.balance().compareTo(monthly) < 0) {
            return ServiceResponse.error("Insufficient balance for the first RD installment.");
        }

        // Debit the first installment atomically.
        boolean debited = accountDao.withdraw(accountNo, monthly);
        if (!debited) {
            return ServiceResponse.error("Failed to deduct first installment.");
        }

        transactionDao.logTransaction(accountNo, null, monthly, "WITHDRAWAL",
                "RD installment 1 of " + tenureMonths,
                UUID.randomUUID().toString());

        // Simplified RD maturity approximation (simple interest on average balance).
        BigDecimal totalDeposited = monthly.multiply(BigDecimal.valueOf(tenureMonths));
        BigDecimal interest = totalDeposited
                .multiply(BASE_RATE).divide(BigDecimal.valueOf(100), 6, RoundingMode.HALF_UP)
                .multiply(BigDecimal.valueOf(tenureMonths)).divide(BigDecimal.valueOf(24), 2, RoundingMode.HALF_UP);
        BigDecimal maturityAmount = totalDeposited.add(interest).setScale(2, RoundingMode.HALF_UP);

        LocalDate nextDebitDate = LocalDate.now().plusMonths(1);

        RecurringDeposit rd = new RecurringDeposit(
            null,
            accountNo,
            monthly,
            BASE_RATE,
            tenureMonths,
            monthly, // first installment already deposited
            maturityAmount,
            "ACTIVE",
            nextDebitDate,
            LocalDateTime.now()
        );

        boolean saved = rdDao.save(rd);
        if (saved) {
            NotificationService.addNotification(accountNo,
                    String.format("Recurring Deposit of ₹ %,.2f/month started. Maturity value ₹ %,.2f.",
                            monthly, maturityAmount), "DEPOSIT");
            return ServiceResponse.success(rd, "Recurring Deposit opened successfully.");
        }
        // Saving the RD record failed — refund the debited installment.
        accountDao.deposit(accountNo, monthly);
        return ServiceResponse.error("Failed to create RD record. Amount refunded.");
    }

    @Override
    public List<RecurringDeposit> getRecurringDeposits(int accountNo) {
        return rdDao.findByAccountNo(accountNo);
    }
}
