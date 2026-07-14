package com.acebank.model;

import java.sql.Timestamp;

/** A customer support ticket raised from Help & Support. */
public record ServiceRequest(
        long id,
        int userId,
        String ticketNo,
        String subject,
        String category,
        String message,
        String status,
        Timestamp createdAt,
        Timestamp updatedAt
) {}
