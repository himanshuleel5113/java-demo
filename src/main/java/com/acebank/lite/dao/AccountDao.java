package com.acebank.lite.dao;

import com.acebank.lite.models.Account;
import java.math.BigDecimal;

public interface AccountDao {
    Account getAccount(int accountNo);
    BigDecimal getBalance(int accountNo);
    boolean createAccount(int accountNo, int userId);
    boolean withdraw(int accountNo, BigDecimal amount);
    boolean deposit(int accountNo, BigDecimal amount);

    /**
     * Atomically moves {@code amount} from one account to another in a single
     * database transaction. Both the debit and credit either commit together or
     * roll back together, so a failure can never leave money debited but not
     * credited. Returns {@code false} (and rolls back) on insufficient funds or
     * any SQL error.
     */
    boolean transfer(int fromAccountNo, int toAccountNo, BigDecimal amount);

    int getVersion(int accountNo);
}
