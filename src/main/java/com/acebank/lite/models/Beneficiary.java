package com.acebank.lite.models;

import java.time.LocalDateTime;

public record Beneficiary(
    Integer id,
    Integer ownerAccount,
    Integer beneficiaryAccount,
    String beneficiaryName,
    String bankName,
    String ifscCode,
    String nickname,
    Boolean isActive,
    LocalDateTime createdAt
) {}
