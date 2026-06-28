package com.acebank.lite.dao;

import com.acebank.lite.models.FixedDeposit;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.QueryLoader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class FixedDepositDaoImpl implements FixedDepositDao {
    private static final Logger logger = LoggerFactory.getLogger(FixedDepositDaoImpl.class);

    @Override
    public boolean save(FixedDeposit fd) {
        String sql = QueryLoader.getQuery("fd.insert");
        if (sql == null) {
            sql = "INSERT INTO FIXED_DEPOSITS (ACCOUNT_NO, AMOUNT, INTEREST_RATE, TENURE_MONTHS, MATURITY_DATE, MATURITY_AMOUNT, STATUS) VALUES (?, ?, ?, ?, ?, ?, ?)";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, fd.accountNo());
            stmt.setBigDecimal(2, fd.amount());
            stmt.setBigDecimal(3, fd.interestRate());
            stmt.setInt(4, fd.tenureMonths());
            stmt.setDate(5, java.sql.Date.valueOf(fd.maturityDate()));
            stmt.setBigDecimal(6, fd.maturityAmount());
            stmt.setString(7, fd.status());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Failed to save FD for account {}", fd.accountNo(), e);
            return false;
        }
    }

    @Override
    public Optional<FixedDeposit> findById(long id) {
        String sql = QueryLoader.getQuery("fd.findById");
        if (sql == null) {
            sql = "SELECT * FROM FIXED_DEPOSITS WHERE ID = ?";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToFixedDeposit(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Failed to find FD by ID {}", id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<FixedDeposit> findByAccountNo(int accountNo) {
        List<FixedDeposit> fds = new ArrayList<>();
        String sql = QueryLoader.getQuery("fd.findByAccount");
        if (sql == null) {
            sql = "SELECT * FROM FIXED_DEPOSITS WHERE ACCOUNT_NO = ? ORDER BY CREATED_AT DESC";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    fds.add(mapResultSetToFixedDeposit(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Failed to find FDs for account {}", accountNo, e);
        }
        return fds;
    }

    private FixedDeposit mapResultSetToFixedDeposit(ResultSet rs) throws SQLException {
        return new FixedDeposit(
            rs.getInt("ID"),
            rs.getInt("ACCOUNT_NO"),
            rs.getBigDecimal("AMOUNT"),
            rs.getBigDecimal("INTEREST_RATE"),
            rs.getInt("TENURE_MONTHS"),
            rs.getDate("MATURITY_DATE").toLocalDate(),
            rs.getBigDecimal("MATURITY_AMOUNT"),
            rs.getString("STATUS"),
            rs.getTimestamp("CREATED_AT").toLocalDateTime()
        );
    }
}
