package com.acebank.lite.dao;

import com.acebank.lite.models.Transaction;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.QueryLoader;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class TransactionDaoImpl implements TransactionDao {
    private static final Logger log = Logger.getLogger(TransactionDaoImpl.class.getName());

    @Override
    public boolean logTransaction(Integer senderAccount, Integer receiverAccount, BigDecimal amount, String txType, String remark, String referenceNo) {
        String sql = QueryLoader.get("transaction.log");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            if (senderAccount != null) {
                stmt.setInt(1, senderAccount);
            } else {
                stmt.setNull(1, Types.INTEGER);
            }
            
            if (receiverAccount != null) {
                stmt.setInt(2, receiverAccount);
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            
            stmt.setBigDecimal(3, amount);
            stmt.setString(4, txType);
            stmt.setString(5, remark);
            stmt.setString(6, referenceNo);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error logging transaction: " + e.getMessage());
        }
        return false;
    }

    @Override
    public List<Transaction> getTransactions(int accountNo, int limit, int offset) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = QueryLoader.get("transaction.statement");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            stmt.setInt(2, accountNo);
            stmt.setInt(3, limit);
            stmt.setInt(4, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Integer sender = rs.getObject("SENDER_ACCOUNT") != null ? rs.getInt("SENDER_ACCOUNT") : null;
                    Integer receiver = rs.getObject("RECEIVER_ACCOUNT") != null ? rs.getInt("RECEIVER_ACCOUNT") : null;
                    transactions.add(new Transaction(
                            rs.getInt("ID"),
                            sender,
                            receiver,
                            rs.getBigDecimal("AMOUNT"),
                            rs.getString("TX_TYPE"),
                            rs.getString("REMARK"),
                            rs.getString("STATUS"),
                            rs.getString("REFERENCE_NO"),
                            rs.getTimestamp("CREATED_AT") != null ? rs.getTimestamp("CREATED_AT").toLocalDateTime() : null
                    ));
                }
            }
        } catch (SQLException e) {
            log.severe("Error getting transactions: " + e.getMessage());
        }
        return transactions;
    }

    @Override
    public int countTransactions(int accountNo) {
        String sql = QueryLoader.get("transaction.count_statement");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            stmt.setInt(2, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            log.severe("Error counting transactions: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public BigDecimal getDailyWithdrawalTotal(int accountNo) {
        String sql = QueryLoader.get("transaction.get_daily_withdrawal_total");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            log.severe("Error getting daily withdrawal: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }
}
