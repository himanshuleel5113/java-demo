package com.acebank.lite.models;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record User(
    Integer userId,
    String firstName,
    String lastName,
    String aadhaarNo,
    String email,
    String passwordHash,
    String role,
    String phone,
    LocalDate dateOfBirth,
    String address,
    String panNo,
    String status,
    Integer failedLoginAttempts,
    LocalDateTime lockedUntil,
    Boolean twoFaEnabled,
    String twoFaSecret,
    String profilePhoto,
    LocalDateTime createdAt,
    LocalDateTime updatedAt
) {}