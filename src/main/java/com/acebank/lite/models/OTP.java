package com.acebank.lite.models;

import java.time.LocalDateTime;

public record OTP(
    Integer id,
    String email,
    String otpHash,
    Integer accountNo,
    String purpose,
    LocalDateTime expiresAt,
    Boolean verified,
    Integer attempts,
    LocalDateTime createdAt
) {}
