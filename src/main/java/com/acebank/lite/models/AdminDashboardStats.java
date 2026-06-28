package com.acebank.lite.models;

import java.math.BigDecimal;

public record AdminDashboardStats(
    int totalUsers,
    int totalAccounts,
    BigDecimal totalDeposits,
    BigDecimal totalLoans,
    int pendingComplaints,
    int pendingKYC
) {}
