package com.acebank.model;

import java.math.BigDecimal;

/** A card, with the holder name joined from the owning account's user. */
public record Card(
        long id,
        long accountNo,
        String cardType,
        String network,
        String last4,
        String expiry,
        String status,
        BigDecimal dailyLimit,
        String holder
) {}
