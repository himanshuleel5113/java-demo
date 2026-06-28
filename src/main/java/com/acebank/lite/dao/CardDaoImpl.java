package com.acebank.lite.dao;

import com.acebank.lite.models.CardRequest;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.QueryLoader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CardDaoImpl implements CardDao {
    private static final Logger logger = LoggerFactory.getLogger(CardDaoImpl.class);

    @Override
    public boolean save(CardRequest card) {
        String sql = QueryLoader.getQuery("card.insert");
        if (sql == null) {
            sql = "INSERT INTO CARD_REQUESTS (ACCOUNT_NO, CARD_TYPE, REQUEST_TYPE, STATUS, CARD_NUMBER_MASKED, IS_BLOCKED) VALUES (?, ?, ?, ?, ?, ?)";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, card.accountNo());
            stmt.setString(2, card.cardType());
            stmt.setString(3, card.requestType());
            stmt.setString(4, card.status());
            stmt.setString(5, card.cardNumberMasked());
            stmt.setBoolean(6, card.isBlocked());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Failed to save card request for account {}", card.accountNo(), e);
            return false;
        }
    }

    @Override
    public Optional<CardRequest> findById(long id) {
        String sql = QueryLoader.getQuery("card.findById");
        if (sql == null) {
            sql = "SELECT * FROM CARD_REQUESTS WHERE ID = ?";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToCardRequest(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Failed to find card request by ID {}", id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<CardRequest> findByAccountNo(int accountNo) {
        List<CardRequest> cards = new ArrayList<>();
        String sql = QueryLoader.getQuery("card.findByAccount");
        if (sql == null) {
            sql = "SELECT * FROM CARD_REQUESTS WHERE ACCOUNT_NO = ? ORDER BY CREATED_AT DESC";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    cards.add(mapResultSetToCardRequest(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Failed to find cards for account {}", accountNo, e);
        }
        return cards;
    }

    @Override
    public boolean updateStatus(long id, int accountNo, String status) {
        String sql = QueryLoader.getQuery("card.updateStatus");
        if (sql == null) {
            sql = "UPDATE CARD_REQUESTS SET STATUS = ? WHERE ID = ? AND ACCOUNT_NO = ?";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setLong(2, id);
            stmt.setInt(3, accountNo);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Failed to update status for card request {}", id, e);
            return false;
        }
    }

    @Override
    public boolean updateBlockStatus(long id, int accountNo, boolean isBlocked) {
        String sql = QueryLoader.getQuery("card.updateBlockStatus");
        if (sql == null) {
            sql = "UPDATE CARD_REQUESTS SET IS_BLOCKED = ? WHERE ID = ? AND ACCOUNT_NO = ?";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, isBlocked);
            stmt.setLong(2, id);
            stmt.setInt(3, accountNo);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Failed to block/unblock card {}", id, e);
            return false;
        }
    }

    private CardRequest mapResultSetToCardRequest(ResultSet rs) throws SQLException {
        return new CardRequest(
            rs.getInt("ID"),
            rs.getInt("ACCOUNT_NO"),
            rs.getString("CARD_TYPE"),
            rs.getString("REQUEST_TYPE"),
            rs.getString("STATUS"),
            rs.getString("CARD_NUMBER_MASKED"),
            rs.getBoolean("IS_BLOCKED"),
            rs.getString("REASON"),
            (Integer) rs.getObject("REVIEWED_BY"),
            rs.getTimestamp("CREATED_AT").toLocalDateTime(),
            rs.getTimestamp("UPDATED_AT") != null ? rs.getTimestamp("UPDATED_AT").toLocalDateTime() : null
        );
    }
}
