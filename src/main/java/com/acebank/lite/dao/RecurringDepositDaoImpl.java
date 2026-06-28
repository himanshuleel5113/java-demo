package com.acebank.lite.dao;

import com.acebank.lite.models.RecurringDeposit;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.QueryLoader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class RecurringDepositDaoImpl implements RecurringDepositDao {
    private static final Logger logger = LoggerFactory.getLogger(RecurringDepositDaoImpl.class);

    @Override
    public boolean save(RecurringDeposit rd) {
        String sql = QueryLoader.getQuery("rd.insert");
        if (sql == null) {
            sql = "INSERT INTO RECURRING_DEPOSITS (ACCOUNT_NO, MONTHLY_AMOUNT, INTEREST_RATE, TENURE_MONTHS, TOTAL_DEPOSITED, MATURITY_AMOUNT, STATUS, NEXT_DEBIT_DATE) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, rd.accountNo());
            stmt.setBigDecimal(2, rd.monthlyAmount());
            stmt.setBigDecimal(3, rd.interestRate());
            stmt.setInt(4, rd.tenureMonths());
            stmt.setBigDecimal(5, rd.totalDeposited());
            stmt.setBigDecimal(6, rd.maturityAmount());
            stmt.setString(7, rd.status());
            stmt.setDate(8, java.sql.Date.valueOf(rd.nextDebitDate()));
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Failed to save RD for account {}", rd.accountNo(), e);
            return false;
        }
    }

    @Override
    public Optional<RecurringDeposit> findById(long id) {
        String sql = QueryLoader.getQuery("rd.findById");
        if (sql == null) {
            sql = "SELECT * FROM RECURRING_DEPOSITS WHERE ID = ?";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToRecurringDeposit(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Failed to find RD by ID {}", id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<RecurringDeposit> findByAccountNo(int accountNo) {
        List<RecurringDeposit> rds = new ArrayList<>();
        String sql = QueryLoader.getQuery("rd.findByAccount");
        if (sql == null) {
            sql = "SELECT * FROM RECURRING_DEPOSITS WHERE ACCOUNT_NO = ? ORDER BY CREATED_AT DESC";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    rds.add(mapResultSetToRecurringDeposit(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Failed to find RDs for account {}", accountNo, e);
        }
        return rds;
    }

    private RecurringDeposit mapResultSetToRecurringDeposit(ResultSet rs) throws SQLException {
        return new RecurringDeposit(
            rs.getInt("ID"),
            rs.getInt("ACCOUNT_NO"),
            rs.getBigDecimal("MONTHLY_AMOUNT"),
            rs.getBigDecimal("INTEREST_RATE"),
            rs.getInt("TENURE_MONTHS"),
            rs.getBigDecimal("TOTAL_DEPOSITED"),
            rs.getBigDecimal("MATURITY_AMOUNT"),
            rs.getString("STATUS"),
            rs.getDate("NEXT_DEBIT_DATE").toLocalDate(),
            rs.getTimestamp("CREATED_AT").toLocalDateTime()
        );
    }
}
