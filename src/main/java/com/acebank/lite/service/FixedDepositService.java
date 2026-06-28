package com.acebank.lite.service;

import com.acebank.lite.models.FixedDeposit;
import com.acebank.lite.models.ServiceResponse;

import java.util.List;

public interface FixedDepositService {
    ServiceResponse<FixedDeposit> openFD(int accountNo, double amount, int tenureMonths);
    List<FixedDeposit> getFixedDeposits(int accountNo);
}
