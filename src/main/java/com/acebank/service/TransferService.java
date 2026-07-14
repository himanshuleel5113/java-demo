package com.acebank.service;

import com.acebank.dao.AuditDao;
import com.acebank.db.Database;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

/**
 * Money movement. A transfer runs in a single DB transaction with the two
 * accounts locked (SELECT ... FOR UPDATE) so concurrent transfers can't
 * double-spend, and always ordered by account number to avoid deadlocks.
 * Amounts are BigDecimal throughout.
 */
public class TransferService {

    private final AuditDao audit = new AuditDao();

    public record Result(boolean success, String message, String reference) {
        static Result ok(String ref)     { return new Result(true, "Transfer completed.", ref); }
        static Result fail(String msg)   { return new Result(false, msg, null); }
    }

    /**
     * @param ownerUserId the logged-in user's id (authorization: the source
     *                    account must belong to them — prevents IDOR)
     */
    public Result transfer(int ownerUserId, long fromAccount, long toAccount,
                           BigDecimal amount, String remark, String ip) {
        if (amount == null || amount.signum() <= 0)      return Result.fail("Enter a valid amount.");
        amount = amount.setScale(2, java.math.RoundingMode.HALF_UP);
        if (fromAccount == toAccount)                    return Result.fail("Cannot transfer to the same account.");

        Connection c = null;
        try {
            c = Database.getConnection();
            c.setAutoCommit(false);

            if (!ownsAccount(c, ownerUserId, fromAccount))
                return rollback(c, "You are not authorized to use this account.");

            // Lock both rows in a deterministic order to avoid deadlocks.
            long first = Math.min(fromAccount, toAccount);
            long second = Math.max(fromAccount, toAccount);
            BigDecimal firstBal  = lockBalance(c, first);
            BigDecimal secondBal = lockBalance(c, second);
            if (firstBal == null || secondBal == null)
                return rollback(c, "Beneficiary account not found.");

            BigDecimal fromBal = (first == fromAccount) ? firstBal : secondBal;
            if (fromBal.compareTo(amount) < 0)
                return rollback(c, "Insufficient balance.");

            adjust(c, fromAccount, amount.negate());
            adjust(c, toAccount,   amount);
            String ref = "TXN" + UUID.randomUUID().toString().substring(0, 10).toUpperCase();
            recordTx(c, fromAccount, toAccount, amount, remark, ref);

            c.commit();
            audit.log(ownerUserId, "TRANSFER",
                    amount + " from " + fromAccount + " to " + toAccount + " ref " + ref, ip);
            return Result.ok(ref);
        } catch (SQLException e) {
            safeRollback(c);
            return Result.fail("Transfer could not be completed. Please try again.");
        } finally {
            close(c);
        }
    }

    private boolean ownsAccount(Connection c, int userId, long accountNo) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(
                "SELECT 1 FROM accounts WHERE account_no = ? AND user_id = ? AND status = 'ACTIVE'")) {
            ps.setLong(1, accountNo); ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    private BigDecimal lockBalance(Connection c, long accountNo) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(
                "SELECT balance FROM accounts WHERE account_no = ? FOR UPDATE")) {
            ps.setLong(1, accountNo);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getBigDecimal(1) : null; }
        }
    }

    private void adjust(Connection c, long accountNo, BigDecimal delta) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(
                "UPDATE accounts SET balance = balance + ?, version = version + 1 WHERE account_no = ?")) {
            ps.setBigDecimal(1, delta); ps.setLong(2, accountNo);
            ps.executeUpdate();
        }
    }

    private void recordTx(Connection c, long from, long to, BigDecimal amount,
                          String remark, String ref) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(
                "INSERT INTO transactions (sender_account,receiver_account,amount,tx_type,status,remark,reference_no) " +
                "VALUES (?,?,?,'TRANSFER','COMPLETED',?,?)")) {
            ps.setLong(1, from); ps.setLong(2, to); ps.setBigDecimal(3, amount);
            ps.setString(4, remark == null ? null : remark.trim());
            ps.setString(5, ref);
            ps.executeUpdate();
        }
    }

    private Result rollback(Connection c, String msg) { safeRollback(c); return Result.fail(msg); }
    private void safeRollback(Connection c) { try { if (c != null) c.rollback(); } catch (SQLException ignored) {} }
    private void close(Connection c) { try { if (c != null) { c.setAutoCommit(true); c.close(); } } catch (SQLException ignored) {} }
}
