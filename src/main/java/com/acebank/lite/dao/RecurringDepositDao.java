package com.acebank.lite.dao;

import com.acebank.lite.models.RecurringDeposit;
import java.util.List;
import java.util.Optional;

public interface RecurringDepositDao {
    boolean save(RecurringDeposit rd);
    Optional<RecurringDeposit> findById(long id);
    List<RecurringDeposit> findByAccountNo(int accountNo);
}
