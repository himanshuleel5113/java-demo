package com.acebank.lite.service;

import com.acebank.lite.dao.AccountDao;
import com.acebank.lite.dao.AccountDaoImpl;
import com.acebank.lite.dao.FixedDepositDao;
import com.acebank.lite.dao.FixedDepositDaoImpl;
import com.acebank.lite.dao.TransactionDao;
import com.acebank.lite.dao.TransactionDaoImpl;
import com.acebank.lite.models.Account;
import com.acebank.lite.models.FixedDeposit;
import com.acebank.lite.models.ServiceResponse;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class FixedDepositServiceImpl implements FixedDepositService {

    private static final BigDecimal MIN_DEPOSIT = new BigDecimal("1000");

    private final FixedDepositDao fdDao;
    private final AccountDao accountDao;
    private final TransactionDao transactionDao;

    public FixedDepositServiceImpl() {
        this.fdDao = new FixedDepositDaoImpl();
        this.accountDao = new AccountDaoImpl();
        this.transactionDao = new TransactionDaoImpl();
    }

    @Override
    public ServiceResponse<FixedDeposit> openFD(int accountNo, double amount, int tenureMonths) {
        BigDecimal principal = BigDecimal.valueOf(amount).setScale(2, RoundingMode.HALF_UP);

        if (principal.compareTo(MIN_DEPOSIT) < 0) {
            return ServiceResponse.error("Minimum deposit amount is ₹1,000.");
        }
        if (tenureMonths < 6) {
            return ServiceResponse.error("Minimum tenure is 6 months.");
        }

        Account account = accountDao.getAccount(accountNo);
        if (account == null) {
            return ServiceResponse.error("Account not found.");
        }
        if (account.balance().compareTo(principal) < 0) {
            return ServiceResponse.error("Insufficient balance to open Fixed Deposit.");
        }

        // Deduct principal atomically (optimistic-locked withdraw).
        boolean debited = accountDao.withdraw(accountNo, principal);
        if (!debited) {
            return ServiceResponse.error("Failed to deduct amount from account.");
        }

        transactionDao.logTransaction(accountNo, null, principal, "WITHDRAWAL",
                "Fixed Deposit opened for " + tenureMonths + " months",
                UUID.randomUUID().toString());

        // Tiered interest rate based on tenure.
        double rate = 7.10;
        if (tenureMonths >= 12 && tenureMonths < 36) rate = 7.30;
        else if (tenureMonths >= 36) rate = 7.50;
        BigDecimal interestRate = BigDecimal.valueOf(rate);

        // Quarterly compounding maturity value.
        double ratePerQuarter = (rate / 100) / 4;
        double quarters = tenureMonths / 3.0;
        BigDecimal maturityAmount = principal
                .multiply(BigDecimal.valueOf(Math.pow(1 + ratePerQuarter, quarters)))
                .setScale(2, RoundingMode.HALF_UP);

        LocalDate maturityDate = LocalDate.now().plusMonths(tenureMonths);

        FixedDeposit fd = new FixedDeposit(
            null,
            accountNo,
            principal,
            interestRate,
            tenureMonths,
            maturityDate,
            maturityAmount,
            "ACTIVE",
            LocalDateTime.now()
        );

        boolean saved = fdDao.save(fd);
        if (saved) {
            NotificationService.addNotification(accountNo,
                    String.format("Fixed Deposit of ₹ %,.2f created. Maturity value ₹ %,.2f.",
                            principal, maturityAmount), "DEPOSIT");
            return ServiceResponse.success(fd, "Fixed Deposit opened successfully.");
        }
        // Saving the FD record failed — refund the debited principal.
        accountDao.deposit(accountNo, principal);
        return ServiceResponse.error("Failed to create FD record. Amount refunded.");
    }

    @Override
    public List<FixedDeposit> getFixedDeposits(int accountNo) {
        return fdDao.findByAccountNo(accountNo);
    }
}
