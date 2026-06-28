package com.acebank.lite.models;

import java.util.List;

public record PaginatedResult<T>(
    List<T> data,
    int totalRecords,
    int currentPage,
    int totalPages
) {}
