package com.acebank.lite.models;

import java.time.LocalDateTime;

public record AuditEntry(
    Long id,
    Integer accountNo,
    Integer userId,
    String action,
    String details,
    String ipAddress,
    String userAgent,
    LocalDateTime createdAt
) {}
