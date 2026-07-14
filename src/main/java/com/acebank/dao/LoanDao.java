package com.acebank.dao;

import com.acebank.db.Database;
import com.acebank.model.Loan;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Data access for loans. Every query is parameterised and scoped by user. */
public class LoanDao {

    private static final String SELECT =
            "SELECT id, user_id, account_no, loan_ref, loan_type, principal, outstanding, " +
            "interest_rate, tenure_months, emi_amount, next_due_date, status FROM loans ";

    public List<Loan> findByUser(int userId) {
        List<Loan> out = new ArrayList<>();
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     SELECT + "WHERE user_id = ? ORDER BY status = 'ACTIVE' DESC, id")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("findByUser loans failed", e);
        }
        return out;
    }

    /** Aggregate figures for the loan overview cards. */
    public Summary summaryForUser(int userId) {
        String sql = "SELECT COUNT(*) AS cnt, " +
                "COALESCE(SUM(outstanding),0) AS outstanding, " +
                "COALESCE(SUM(emi_amount),0) AS emi, " +
                "COALESCE(SUM(principal - outstanding),0) AS paid " +
                "FROM loans WHERE user_id = ? AND status = 'ACTIVE'";
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Summary(rs.getInt("cnt"), rs.getBigDecimal("outstanding"),
                            rs.getBigDecimal("emi"), rs.getBigDecimal("paid"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("summaryForUser loans failed", e);
        }
        return new Summary(0, BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO);
    }

    public void insert(int userId, long accountNo, String loanRef, String type,
                       BigDecimal principal, BigDecimal rate, int tenureMonths,
                       BigDecimal emi, Date nextDue) {
        String sql = "INSERT INTO loans (user_id, account_no, loan_ref, loan_type, principal, " +
                "outstanding, interest_rate, tenure_months, emi_amount, next_due_date) " +
                "VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setLong(2, accountNo);
            ps.setString(3, loanRef);
            ps.setString(4, type);
            ps.setBigDecimal(5, principal);
            ps.setBigDecimal(6, principal);          // outstanding starts at full principal
            ps.setBigDecimal(7, rate);
            ps.setInt(8, tenureMonths);
            ps.setBigDecimal(9, emi);
            ps.setDate(10, nextDue);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("insert loan failed", e);
        }
    }

    private Loan map(ResultSet rs) throws SQLException {
        return new Loan(
                rs.getLong("id"), rs.getInt("user_id"), rs.getLong("account_no"),
                rs.getString("loan_ref"), rs.getString("loan_type"),
                rs.getBigDecimal("principal"), rs.getBigDecimal("outstanding"),
                rs.getBigDecimal("interest_rate"), rs.getInt("tenure_months"),
                rs.getBigDecimal("emi_amount"), rs.getDate("next_due_date"),
                rs.getString("status"));
    }

    /** Loan overview totals for one customer. */
    public record Summary(int count, BigDecimal outstanding, BigDecimal totalEmi, BigDecimal totalPaid) {}
}
