package com.acebank.lite.dao;

import com.acebank.lite.models.Transaction;
import java.math.BigDecimal;
import java.util.List;

public interface TransactionDao {
    boolean logTransaction(Integer senderAccount, Integer receiverAccount, BigDecimal amount, String txType, String remark, String referenceNo);
    List<Transaction> getTransactions(int accountNo, int limit, int offset);
    int countTransactions(int accountNo);
    BigDecimal getDailyWithdrawalTotal(int accountNo);
}
