package com.acebank.lite.service;

import com.acebank.lite.models.RecurringDeposit;
import com.acebank.lite.models.ServiceResponse;

import java.util.List;

public interface RecurringDepositService {
    ServiceResponse<RecurringDeposit> openRD(int accountNo, double monthlyAmount, int tenureMonths);
    List<RecurringDeposit> getRecurringDeposits(int accountNo);
}
