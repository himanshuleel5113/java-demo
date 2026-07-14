package com.acebank.dao;

import com.acebank.db.Database;
import com.acebank.model.Card;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Data access for cards. Holder name is joined from the owning user. */
public class CardDao {

    private static final String SELECT =
            "SELECT c.id, c.account_no, c.card_type, c.network, c.last4, c.expiry, c.status, c.daily_limit, " +
            "CONCAT(u.first_name,' ',u.last_name) AS holder " +
            "FROM cards c JOIN accounts a ON c.account_no = a.account_no JOIN users u ON a.user_id = u.id ";

    public List<Card> listByUser(int userId) {
        List<Card> out = new ArrayList<>();
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(SELECT + "WHERE u.id = ? ORDER BY c.id")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("listByUser cards failed", e);
        }
        return out;
    }

    public boolean existsForAccount(long accountNo) {
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT 1 FROM cards WHERE account_no = ? LIMIT 1")) {
            ps.setLong(1, accountNo);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) {
            throw new RuntimeException("existsForAccount failed", e);
        }
    }

    public void insert(long accountNo, String type, String network, String last4,
                       String expiry, BigDecimal limit) {
        String sql = "INSERT INTO cards (account_no, card_type, network, last4, expiry, daily_limit) VALUES (?,?,?,?,?,?)";
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, accountNo);
            ps.setString(2, type);
            ps.setString(3, network);
            ps.setString(4, last4);
            ps.setString(5, expiry);
            ps.setBigDecimal(6, limit);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("insert card failed", e);
        }
    }

    /** Toggle block/unblock for a card the user owns (authorization enforced in SQL). */
    public boolean setStatus(long cardId, int userId, String status) {
        String sql = "UPDATE cards c JOIN accounts a ON c.account_no = a.account_no " +
                     "SET c.status = ? WHERE c.id = ? AND a.user_id = ?";
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, cardId);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("setStatus card failed", e);
        }
    }

    private Card map(ResultSet rs) throws SQLException {
        return new Card(
                rs.getLong("id"), rs.getLong("account_no"), rs.getString("card_type"),
                rs.getString("network"), rs.getString("last4"), rs.getString("expiry"),
                rs.getString("status"), rs.getBigDecimal("daily_limit"), rs.getString("holder"));
    }
}
