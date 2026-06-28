package com.acebank.lite.dao;

import com.acebank.lite.models.BillPayment;
import java.util.List;
import java.util.Optional;

public interface BillPaymentDao {
    boolean save(BillPayment billPayment);
    Optional<BillPayment> findById(long id);
    List<BillPayment> findByAccountNo(int accountNo);
}
