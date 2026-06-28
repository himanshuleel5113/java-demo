package com.acebank.lite.service;

import com.acebank.lite.models.CardRequest;
import com.acebank.lite.models.ServiceResponse;

import java.util.List;

public interface CardService {
    ServiceResponse<CardRequest> requestNewCard(int accountNo, String cardType);
    List<CardRequest> getCardsForAccount(int accountNo);
    ServiceResponse<Void> toggleCardBlock(long cardId, int accountNo, boolean blockStatus);
}
