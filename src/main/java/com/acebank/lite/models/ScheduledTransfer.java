package com.acebank.lite.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record ScheduledTransfer(
    Integer id,
    Integer fromAccount,
    Integer toAccount,
    BigDecimal amount,
    String scheduleType,
    LocalDateTime nextExecution,
    LocalDateTime lastExecuted,
    String status,
    String remark,
    LocalDateTime createdAt
) {}
