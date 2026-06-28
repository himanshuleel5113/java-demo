package com.acebank.lite.dao;

import com.acebank.lite.models.FixedDeposit;
import java.util.List;
import java.util.Optional;

public interface FixedDepositDao {
    boolean save(FixedDeposit fd);
    Optional<FixedDeposit> findById(long id);
    List<FixedDeposit> findByAccountNo(int accountNo);
}
