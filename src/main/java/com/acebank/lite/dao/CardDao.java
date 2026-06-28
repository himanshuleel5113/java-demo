package com.acebank.lite.dao;

import com.acebank.lite.models.CardRequest;
import java.util.List;
import java.util.Optional;

public interface CardDao {
    boolean save(CardRequest card);
    Optional<CardRequest> findById(long id);
    List<CardRequest> findByAccountNo(int accountNo);
    boolean updateStatus(long id, int accountNo, String status);
    boolean updateBlockStatus(long id, int accountNo, boolean isBlocked);
}
