package com.acebank.service;

import com.acebank.dao.AuditDao;
import com.acebank.db.Database;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

/**
 * Pays a bill from the customer's own account. The account debit, the WITHDRAWAL
 * transaction and the bill_payments row are all committed in a single DB
 * transaction with the account row locked (SELECT ... FOR UPDATE), so a payment
 * can never leave money missing without a matching record.
 */
public class BillPaymentService {

    private final AuditDao audit = new AuditDao();

    public record Result(boolean success, String message, String reference) {
        static Result ok(String ref)   { return new Result(true, "Bill paid successfully.", ref); }
        static Result fail(String msg) { return new Result(false, msg, null); }
    }

    public Result pay(int userId, long accountNo, String category, String biller,
                      String consumerNo, String nickname, BigDecimal amount, String ip) {
        if (category == null || category.isBlank())        return Result.fail("Select a bill category.");
        if (biller == null || biller.isBlank())            return Result.fail("Select a biller.");
        if (consumerNo == null || consumerNo.isBlank())    return Result.fail("Enter your consumer / account number.");
        if (amount == null || amount.signum() <= 0)        return Result.fail("Enter a valid amount.");
        amount = amount.setScale(2, RoundingMode.HALF_UP);

        Connection c = null;
        try {
            c = Database.getConnection();
            c.setAutoCommit(false);

            BigDecimal bal = lockOwned(c, accountNo, userId);
            if (bal == null)                    return rollback(c, "Account not found or not yours.");
            if (bal.compareTo(amount) < 0)      return rollback(c, "Insufficient balance for this payment.");

            try (PreparedStatement ps = c.prepareStatement(
                    "UPDATE accounts SET balance = balance - ?, version = version + 1 WHERE account_no = ?")) {
                ps.setBigDecimal(1, amount); ps.setLong(2, accountNo); ps.executeUpdate();
            }

            String ref = "BIL" + UUID.randomUUID().toString().substring(0, 10).toUpperCase();

            try (PreparedStatement ps = c.prepareStatement(
                    "INSERT INTO transactions (sender_account,receiver_account,amount,tx_type,status,remark,reference_no) " +
                    "VALUES (?,NULL,?,'WITHDRAWAL','COMPLETED',?,?)")) {
                ps.setLong(1, accountNo);
                ps.setBigDecimal(2, amount);
                ps.setString(3, category + " bill - " + biller);
                ps.setString(4, ref);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = c.prepareStatement(
                    "INSERT INTO bill_payments (user_id,account_no,category,biller,consumer_no,nickname,amount,status,reference_no) " +
                    "VALUES (?,?,?,?,?,?,?,'SUCCESS',?)")) {
                ps.setInt(1, userId);
                ps.setLong(2, accountNo);
                ps.setString(3, category);
                ps.setString(4, biller);
                ps.setString(5, consumerNo.trim());
                if (nickname == null || nickname.isBlank()) ps.setNull(6, java.sql.Types.VARCHAR);
                else ps.setString(6, nickname.trim());
                ps.setBigDecimal(7, amount);
                ps.setString(8, ref);
                ps.executeUpdate();
            }

            c.commit();
            audit.log(userId, "BILL_PAYMENT", amount + " " + category + " to " + biller + " ref " + ref, ip);
            return Result.ok(ref);
        } catch (SQLException e) {
            safeRollback(c);
            return Result.fail("Payment could not be completed. Please try again.");
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
