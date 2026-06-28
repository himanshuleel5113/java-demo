package com.acebank.lite.service;

import com.acebank.lite.dao.CardDao;
import com.acebank.lite.dao.CardDaoImpl;
import com.acebank.lite.models.CardRequest;
import com.acebank.lite.models.ServiceResponse;

import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

public class CardServiceImpl implements CardService {
    private final CardDao cardDao;

    public CardServiceImpl() {
        this.cardDao = new CardDaoImpl();
    }

    public CardServiceImpl(CardDao cardDao) {
        this.cardDao = cardDao;
    }

    @Override
    public ServiceResponse<CardRequest> requestNewCard(int accountNo, String cardType) {
        String normalizedType = normalizeCardType(cardType);
        String maskedNumber = String.format("4532 **** **** %04d", ThreadLocalRandom.current().nextInt(10000));

        CardRequest request = new CardRequest(
            null,
            accountNo,
            normalizedType,
            "NEW",
            "PENDING",
            maskedNumber,
            false,
            null,
            null,
            LocalDateTime.now(),
            LocalDateTime.now()
        );

        boolean success = cardDao.save(request);
        if (success) {
            return ServiceResponse.success(request, "Card request submitted successfully.");
        }
        return ServiceResponse.error("Failed to submit card request.");
    }

    /** Maps a UI card label (e.g. "CREDIT_MASTERCARD") to the CARD_TYPE enum. */
    private String normalizeCardType(String cardType) {
        if (cardType == null) return "DEBIT";
        String upper = cardType.toUpperCase();
        if (upper.contains("CREDIT")) return "CREDIT";
        if (upper.contains("ATM")) return "ATM";
        return "DEBIT";
    }

    @Override
    public List<CardRequest> getCardsForAccount(int accountNo) {
        return cardDao.findByAccountNo(accountNo);
    }

    @Override
    public ServiceResponse<Void> toggleCardBlock(long cardId, int accountNo, boolean blockStatus) {
        boolean success = cardDao.updateBlockStatus(cardId, accountNo, blockStatus);
        if (success) {
            String status = blockStatus ? "blocked" : "unblocked";
            return ServiceResponse.success(null, "Card has been successfully " + status + ".");
        }
        return ServiceResponse.error("Failed to update card status.");
    }
}
