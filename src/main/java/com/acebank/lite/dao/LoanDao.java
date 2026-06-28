package com.acebank.lite.dao;

import com.acebank.lite.models.LoanApplication;
import java.math.BigDecimal;
import java.util.List;

public interface LoanDao {
    boolean applyForLoan(int accountNo, String loanType, BigDecimal amount, int tenure, String purpose);
    List<LoanApplication> getLoansByAccount(int accountNo);
    boolean updateStatus(int loanId, String status, Integer reviewedBy, String reviewNotes);
}
