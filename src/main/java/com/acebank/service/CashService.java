package com.acebank.service;

import com.acebank.dao.AuditDao;
import com.acebank.db.Database;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/** Deposit and withdrawal against the user's own account (transactional, locked). */
public class CashService {

    private final AuditDao audit = new AuditDao();

    public record Result(boolean success, String message) {
        static Result ok(String m)   { return new Result(true, m); }
        static Result fail(String m) { return new Result(false, m); }
    }

    public Result deposit(int userId, long accountNo, BigDecimal amount, String ip) {
        return apply(userId, accountNo, amount, true, ip);
    }

    public Result withdraw(int userId, long accountNo, BigDecimal amount, String ip) {
        return apply(userId, accountNo, amount, false, ip);
    }

    private Result apply(int userId, long accountNo, BigDecimal amount, boolean isDeposit, String ip) {
        if (amount == null || amount.signum() <= 0) return Result.fail("Enter a valid amount.");
        amount = amount.setScale(2, RoundingMode.HALF_UP);

        Connection c = null;
        try {
            c = Database.getConnection();
            c.setAutoCommit(false);

            BigDecimal bal = lockOwned(c, accountNo, userId);
            if (bal == null) return rollback(c, "Account not found or not yours.");
            if (!isDeposit && bal.compareTo(amount) < 0) return rollback(c, "Insufficient balance.");

            BigDecimal delta = isDeposit ? amount : amount.negate();
            try (PreparedStatement ps = c.prepareStatement(
                    "UPDATE accounts SET balance = balance + ?, version = version + 1 WHERE account_no = ?")) {
                ps.setBigDecimal(1, delta); ps.setLong(2, accountNo); ps.executeUpdate();
            }
            String type = isDeposit ? "DEPOSIT" : "WITHDRAWAL";
            try (PreparedStatement ps = c.prepareStatement(
                    "INSERT INTO transactions (sender_account,receiver_account,amount,tx_type,status,remark,reference_no) " +
                    "VALUES (?,?,?,?,'COMPLETED',?,?)")) {
                if (isDeposit) { ps.setNull(1, java.sql.Types.BIGINT); ps.setLong(2, accountNo); }
                else           { ps.setLong(1, accountNo); ps.setNull(2, java.sql.Types.BIGINT); }
                ps.setBigDecimal(3, amount);
                ps.setString(4, type);
                ps.setString(5, isDeposit ? "Cash deposit" : "Cash withdrawal");
                ps.setString(6, "TXN" + Long.toHexString(System.nanoTime()).toUpperCase());
                ps.executeUpdate();
            }
            c.commit();
            audit.log(userId, type, amount + " on " + accountNo, ip);
            return Result.ok((isDeposit ? "Deposited ₹" : "Withdrew ₹") + amount + " successfully.");
        } catch (SQLException e) {
            safeRollback(c);
            return Result.fail("Operation failed. Please try again.");
        } finally {
            close(c);
        }
    }

    private BigDecimal lockOwned(Connection c, long accountNo, int userId) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(
                "SELECT balance FROM accounts WHERE account_no = ? AND user_id = ? AND status='ACTIVE' FOR UPDATE")) {
            ps.setLong(1, accountNo); ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getBigDecimal(1) : null; }
        }
    }

    private Result rollback(Connection c, String m) { safeRollback(c); return Result.fail(m); }
    private void safeRollback(Connection c) { try { if (c != null) c.rollback(); } catch (SQLException ignored) {} }
    private void close(Connection c) { try { if (c != null) { c.setAutoCommit(true); c.close(); } } catch (SQLException ignored) {} }
}
