package com.acebank.lite.dao;

import com.acebank.lite.models.LoanApplication;
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

public class LoanDaoImpl implements LoanDao {
    private static final Logger log = Logger.getLogger(LoanDaoImpl.class.getName());

    @Override
    public boolean applyForLoan(int accountNo, String loanType, BigDecimal amount, int tenure, String purpose) {
        String sql = QueryLoader.get("loan.apply");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            stmt.setString(2, loanType);
            stmt.setBigDecimal(3, amount);
            stmt.setInt(4, tenure);
            stmt.setString(5, purpose);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error applying for loan: " + e.getMessage());
        }
        return false;
    }

    @Override
    public List<LoanApplication> getLoansByAccount(int accountNo) {
        List<LoanApplication> loans = new ArrayList<>();
        String sql = QueryLoader.get("loan.get_by_account");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    loans.add(new LoanApplication(
                        rs.getInt("ID"),
                        rs.getInt("ACCOUNT_NO"),
                        rs.getString("LOAN_TYPE"),
                        rs.getBigDecimal("AMOUNT"),
                        rs.getInt("TENURE"),
                        rs.getString("PURPOSE"),
                        rs.getString("STATUS"),
                        rs.getObject("REVIEWED_BY") != null ? rs.getInt("REVIEWED_BY") : null,
                        rs.getString("REVIEW_NOTES"),
                        rs.getTimestamp("APPLIED_AT") != null ? rs.getTimestamp("APPLIED_AT").toLocalDateTime() : null,
                        rs.getTimestamp("REVIEWED_AT") != null ? rs.getTimestamp("REVIEWED_AT").toLocalDateTime() : null
                    ));
                }
            }
        } catch (SQLException e) {
            log.severe("Error getting loans: " + e.getMessage());
        }
        return loans;
    }

    @Override
    public boolean updateStatus(int loanId, String status, Integer reviewedBy, String reviewNotes) {
        String sql = QueryLoader.get("loan.update_status");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            if (reviewedBy != null) {
                stmt.setInt(2, reviewedBy);
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setString(3, reviewNotes);
            stmt.setTimestamp(4, java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
            stmt.setInt(5, loanId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error updating loan status: " + e.getMessage());
        }
        return false;
    }
}
