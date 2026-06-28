package com.acebank.lite.models;

import java.time.LocalDateTime;

public record Complaint(
    Integer id,
    Integer accountNo,
    String ticketNo,
    String subject,
    String description,
    String category,
    String status,
    String priority,
    String resolution,
    Integer assignedTo,
    LocalDateTime createdAt,
    LocalDateTime updatedAt
) {}
