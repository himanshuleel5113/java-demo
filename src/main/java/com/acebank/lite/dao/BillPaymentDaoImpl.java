package com.acebank.lite.dao;

import com.acebank.lite.models.BillPayment;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.QueryLoader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class BillPaymentDaoImpl implements BillPaymentDao {
    private static final Logger logger = LoggerFactory.getLogger(BillPaymentDaoImpl.class);

    @Override
    public boolean save(BillPayment billPayment) {
        String sql = QueryLoader.getQuery("bill.insert");
        if (sql == null) {
            sql = "INSERT INTO BILL_PAYMENTS (ACCOUNT_NO, BILLER_NAME, BILLER_CATEGORY, AMOUNT, REFERENCE_NO, CONSUMER_NO, STATUS) VALUES (?, ?, ?, ?, ?, ?, ?)";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, billPayment.accountNo());
            stmt.setString(2, billPayment.billerName());
            stmt.setString(3, billPayment.billerCategory());
            stmt.setBigDecimal(4, billPayment.amount());
            stmt.setString(5, billPayment.referenceNo());
            stmt.setString(6, billPayment.consumerNo());
            stmt.setString(7, billPayment.status());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Failed to save Bill Payment for account {}", billPayment.accountNo(), e);
            return false;
        }
    }

    @Override
    public Optional<BillPayment> findById(long id) {
        String sql = QueryLoader.getQuery("bill.findById");
        if (sql == null) {
            sql = "SELECT * FROM BILL_PAYMENTS WHERE ID = ?";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToBillPayment(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Failed to find Bill Payment by ID {}", id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<BillPayment> findByAccountNo(int accountNo) {
        List<BillPayment> payments = new ArrayList<>();
        String sql = QueryLoader.getQuery("bill.findByAccount");
        if (sql == null) {
            sql = "SELECT * FROM BILL_PAYMENTS WHERE ACCOUNT_NO = ? ORDER BY CREATED_AT DESC";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToBillPayment(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Failed to find Bill Payments for account {}", accountNo, e);
        }
        return payments;
    }

    private BillPayment mapResultSetToBillPayment(ResultSet rs) throws SQLException {
        return new BillPayment(
            rs.getInt("ID"),
            rs.getInt("ACCOUNT_NO"),
            rs.getString("BILLER_NAME"),
            rs.getString("BILLER_CATEGORY"),
            rs.getBigDecimal("AMOUNT"),
            rs.getString("REFERENCE_NO"),
            rs.getString("CONSUMER_NO"),
            rs.getString("STATUS"),
            rs.getTimestamp("CREATED_AT").toLocalDateTime()
        );
    }
}
