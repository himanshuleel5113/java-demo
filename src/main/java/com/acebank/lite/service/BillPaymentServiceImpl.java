package com.acebank.lite.service;

import com.acebank.lite.dao.AccountDao;
import com.acebank.lite.dao.AccountDaoImpl;
import com.acebank.lite.dao.BillPaymentDao;
import com.acebank.lite.dao.BillPaymentDaoImpl;
import com.acebank.lite.dao.TransactionDao;
import com.acebank.lite.dao.TransactionDaoImpl;
import com.acebank.lite.models.Account;
import com.acebank.lite.models.BillPayment;
import com.acebank.lite.models.ServiceResponse;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class BillPaymentServiceImpl implements BillPaymentService {

    private final BillPaymentDao billPaymentDao;
    private final AccountDao accountDao;
    private final TransactionDao transactionDao;

    public BillPaymentServiceImpl() {
        this.billPaymentDao = new BillPaymentDaoImpl();
        this.accountDao = new AccountDaoImpl();
        this.transactionDao = new TransactionDaoImpl();
    }

    @Override
    public ServiceResponse<BillPayment> payBill(int accountNo, String billerName, String billerCategory,
                                                double amount, String consumerNo) {
        BigDecimal billAmount = BigDecimal.valueOf(amount).setScale(2, RoundingMode.HALF_UP);
        if (billAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return ServiceResponse.error("Invalid bill amount.");
        }

        Account account = accountDao.getAccount(accountNo);
        if (account == null) {
            return ServiceResponse.error("Account not found.");
        }
        if (account.balance().compareTo(billAmount) < 0) {
            return ServiceResponse.error("Insufficient balance to pay this bill.");
        }

        boolean debited = accountDao.withdraw(accountNo, billAmount);
        if (!debited) {
            return ServiceResponse.error("Failed to process payment.");
        }

        String receiptNo = "BP-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String category = billerCategory != null ? billerCategory.toUpperCase() : "OTHER";

        transactionDao.logTransaction(accountNo, null, billAmount, "WITHDRAWAL",
                "Bill payment to " + billerName, receiptNo);

        BillPayment payment = new BillPayment(
            null,
            accountNo,
            billerName,
            category,
            billAmount,
            receiptNo,
            consumerNo,
            "COMPLETED",
            LocalDateTime.now()
        );

        boolean saved = billPaymentDao.save(payment);
        if (saved) {
            NotificationService.addNotification(accountNo,
                    String.format("₹ %,.2f paid to %s. Receipt %s.", billAmount, billerName, receiptNo),
                    "WITHDRAWAL");
            return ServiceResponse.success(payment, "Bill paid successfully. Receipt: " + receiptNo);
        }
        // Receipt persistence failed — refund the debited amount.
        accountDao.deposit(accountNo, billAmount);
        return ServiceResponse.error("Payment could not be completed. Amount refunded.");
    }

    @Override
    public List<BillPayment> getBillPayments(int accountNo) {
        return billPaymentDao.findByAccountNo(accountNo);
    }
}
