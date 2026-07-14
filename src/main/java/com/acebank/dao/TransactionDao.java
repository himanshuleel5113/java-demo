package com.acebank.dao;

import com.acebank.db.Database;
import com.acebank.model.Transaction;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Data access for transactions. */
public class TransactionDao {

    /** Recent transactions involving an account (either side), newest first. */
    public List<Transaction> recentForAccount(long accountNo, int limit) {
        String sql = "SELECT * FROM transactions WHERE sender_account = ? OR receiver_account = ? " +
                     "ORDER BY created_at DESC, id DESC LIMIT ?";
        List<Transaction> out = new ArrayList<>();
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, accountNo);
            ps.setLong(2, accountNo);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("recentForAccount failed", e);
        }
        return out;
    }

    private Transaction map(ResultSet rs) throws SQLException {
        long sender = rs.getLong("sender_account");
        Long senderVal = rs.wasNull() ? null : sender;
        long receiver = rs.getLong("receiver_account");
        Long receiverVal = rs.wasNull() ? null : receiver;
        return new Transaction(
                rs.getLong("id"),
                senderVal,
                receiverVal,
                rs.getBigDecimal("amount"),
                rs.getString("tx_type"),
                rs.getString("status"),
                rs.getString("remark"),
                rs.getString("reference_no"),
                rs.getTimestamp("created_at"));
    }
}
