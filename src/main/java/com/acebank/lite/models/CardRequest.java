package com.acebank.lite.models;

import java.time.LocalDateTime;

public record CardRequest(
    Integer id,
    Integer accountNo,
    String cardType,
    String requestType,
    String status,
    String cardNumberMasked,
    Boolean isBlocked,
    String reason,
    Integer reviewedBy,
    LocalDateTime createdAt,
    LocalDateTime updatedAt
) {}
