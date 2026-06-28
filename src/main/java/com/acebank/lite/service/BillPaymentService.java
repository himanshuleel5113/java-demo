package com.acebank.lite.service;

import com.acebank.lite.models.BillPayment;
import com.acebank.lite.models.ServiceResponse;

import java.util.List;

public interface BillPaymentService {
    ServiceResponse<BillPayment> payBill(int accountNo, String billerName, String billerCategory, double amount, String referenceNo);
    List<BillPayment> getBillPayments(int accountNo);
}
