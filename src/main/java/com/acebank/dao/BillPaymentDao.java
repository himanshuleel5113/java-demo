package com.acebank.dao;

import com.acebank.db.Database;
import com.acebank.model.BillPayment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Read access for bill-payment history. Writes go through
 * {@link com.acebank.service.BillPaymentService} so the debit and the bill row
 * are committed atomically.
 */
public class BillPaymentDao {

    private static final String SELECT =
            "SELECT id, user_id, account_no, category, biller, consumer_no, nickname, " +
            "amount, status, reference_no, created_at FROM bill_payments ";

    public List<BillPayment> recentForUser(int userId, int limit) {
        List<BillPayment> out = new ArrayList<>();
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     SELECT + "WHERE user_id = ? ORDER BY created_at DESC, id DESC LIMIT ?")) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("recentForUser bills failed", e);
        }
        return out;
    }

    private BillPayment map(ResultSet rs) throws SQLException {
        return new BillPayment(
                rs.getLong("id"), rs.getInt("user_id"), rs.getLong("account_no"),
                rs.getString("category"), rs.getString("biller"), rs.getString("consumer_no"),
                rs.getString("nickname"), rs.getBigDecimal("amount"), rs.getString("status"),
                rs.getString("reference_no"), rs.getTimestamp("created_at"));
    }
}
