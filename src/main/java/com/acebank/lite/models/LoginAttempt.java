package com.acebank.lite.models;

import java.time.LocalDateTime;

public record LoginAttempt(
    Long id,
    Integer accountNo,
    String ipAddress,
    Boolean success,
    LocalDateTime createdAt
) {}
