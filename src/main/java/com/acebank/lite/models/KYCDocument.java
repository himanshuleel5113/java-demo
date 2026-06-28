package com.acebank.lite.models;

import java.time.LocalDateTime;

public record KYCDocument(
    Integer id,
    Integer accountNo,
    String documentType,
    String fileName,
    String filePath,
    Long fileSize,
    String mimeType,
    String status,
    Integer verifiedBy,
    String rejectionReason,
    LocalDateTime verifiedAt,
    LocalDateTime createdAt
) {}
