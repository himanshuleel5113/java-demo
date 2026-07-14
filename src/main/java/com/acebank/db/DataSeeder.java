package com.acebank.db;

import com.acebank.security.PasswordHasher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Seeds an admin and a demo customer on first boot, with BCrypt hashes computed
 * at runtime so the documented demo credentials always work. Safe to re-run.
 *   admin@acebank.com / Admin@123   (ADMIN,    account 10000001)
 *   demo@acebank.com  / Demo@1234   (CUSTOMER, account 20000001)
 */
final class DataSeeder {

    private static final Logger log = LoggerFactory.getLogger(DataSeeder.class);

    private DataSeeder() {}

    static void seed(Connection c) {
        try {
            int adminId = ensureUser(c, "Admin", "AceBank", "admin@acebank.com",
                    "+919999999999", "Admin@123", "ADMIN");
            ensureAccount(c, 10000001L, adminId, new BigDecimal("1000000.00"));

            int demoId = ensureUser(c, "Himanshu", "Leel", "demo@acebank.com",
                    "+919876543210", "Demo@1234", "CUSTOMER");
            ensureAccount(c, 20000001L, demoId, new BigDecimal("120450.75"));

            ensureCard(c, 10000001L, "DEBIT", "VISA", "0001", "10/28", "500000.00");
            ensureCard(c, 20000001L, "DEBIT", "VISA", "0001", "08/28", "100000.00");
            ensureCard(c, 20000001L, "CREDIT", "MASTERCARD", "0002", "11/29", "200000.00");
            ensureDemoTransactions(c);
            ensureDemoLoans(c, demoId);
            ensureDemoBills(c, demoId);
            ensureDemoServiceRequests(c, demoId);
            log.info("Seed data verified");
        } catch (SQLException e) {
            log.error("Seeding failed: {}", e.getMessage(), e);
        }
    }

    private static int ensureUser(Connection c, String first, String last, String email,
                                  String phone, String plainPw, String role) throws SQLException {
        Integer id = userId(c, email);
        if (id != null) return id;
        String sql = "INSERT INTO users (first_name,last_name,email,phone,password_hash,role) VALUES (?,?,?,?,?,?)";
        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, first); ps.setString(2, last); ps.setString(3, email);
            ps.setString(4, phone); ps.setString(5, PasswordHasher.hash(plainPw)); ps.setString(6, role);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) { keys.next(); return keys.getInt(1); }
        }
    }

    private static void ensureAccount(Connection c, long accountNo, int userId, BigDecimal balance) throws SQLException {
        try (PreparedStatement chk = c.prepareStatement("SELECT 1 FROM accounts WHERE account_no = ?")) {
            chk.setLong(1, accountNo);
            try (ResultSet rs = chk.executeQuery()) { if (rs.next()) return; }
        }
        try (PreparedStatement ps = c.prepareStatement(
                "INSERT INTO accounts (account_no,user_id,balance) VALUES (?,?,?)")) {
            ps.setLong(1, accountNo); ps.setInt(2, userId); ps.setBigDecimal(3, balance);
            ps.executeUpdate();
        }
    }

    private static void ensureCard(Connection c, long accountNo, String type, String network,
                                   String last4, String expiry, String limit) throws SQLException {
        try (PreparedStatement chk = c.prepareStatement(
                "SELECT 1 FROM cards WHERE account_no = ? AND card_type = ?")) {
            chk.setLong(1, accountNo); chk.setString(2, type);
            try (ResultSet rs = chk.executeQuery()) { if (rs.next()) return; }
        }
        try (PreparedStatement ps = c.prepareStatement(
                "INSERT INTO cards (account_no,card_type,network,last4,expiry,daily_limit) VALUES (?,?,?,?,?,?)")) {
            ps.setLong(1, accountNo); ps.setString(2, type); ps.setString(3, network);
            ps.setString(4, last4); ps.setString(5, expiry); ps.setBigDecimal(6, new BigDecimal(limit));
            ps.executeUpdate();
        }
    }

    /** A handful of starter transactions for the demo account (idempotent). */
    private static void ensureDemoTransactions(Connection c) throws SQLException {
        try (PreparedStatement chk = c.prepareStatement(
                "SELECT 1 FROM transactions WHERE sender_account = 20000001 OR receiver_account = 20000001 LIMIT 1")) {
            try (ResultSet rs = chk.executeQuery()) { if (rs.next()) return; }
        }
        // type, sender, receiver, amount, remark
        insertTx(c, "DEPOSIT", null, 20000001L, "75000.00", "Salary credit");
        insertTx(c, "WITHDRAWAL", 20000001L, null, "2499.00", "Amazon purchase");
        insertTx(c, "WITHDRAWAL", 20000001L, null, "1250.00", "Electricity bill");
        insertTx(c, "TRANSFER", 20000001L, 10000001L, "5000.00", "Transfer to AceBank");
        insertTx(c, "DEPOSIT", null, 20000001L, "2500.00", "Received from friend");
    }

    private static void insertTx(Connection c, String type, Long sender, Long receiver,
                                 String amount, String remark) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(
                "INSERT INTO transactions (sender_account,receiver_account,amount,tx_type,status,remark,reference_no) " +
                "VALUES (?,?,?,?,'COMPLETED',?,?)")) {
            if (sender == null) ps.setNull(1, java.sql.Types.BIGINT); else ps.setLong(1, sender);
            if (receiver == null) ps.setNull(2, java.sql.Types.BIGINT); else ps.setLong(2, receiver);
            ps.setBigDecimal(3, new BigDecimal(amount));
            ps.setString(4, type);
            ps.setString(5, remark);
            ps.setString(6, "TXN" + Long.toHexString(System.nanoTime()).toUpperCase());
            ps.executeUpdate();
        }
    }

    /** Starter loans for the demo customer (idempotent). */
    private static void ensureDemoLoans(Connection c, int userId) throws SQLException {
        try (PreparedStatement chk = c.prepareStatement(
                "SELECT 1 FROM loans WHERE user_id = ? LIMIT 1")) {
            chk.setInt(1, userId);
            try (ResultSet rs = chk.executeQuery()) { if (rs.next()) return; }
        }
        // ref, type, principal, outstanding, rate, tenure, emi, monthsToNextDue
        insertLoan(c, userId, "HLN123456789", "HOME",      "2500000.00", "825000.00", "8.50", 240, "22360.00");
        insertLoan(c, userId, "CLN987654321", "CAR",       "525000.00",  "315000.00", "9.25", 60,  "6190.00");
        insertLoan(c, userId, "ELN567891234", "EDUCATION", "140000.00",  "105000.00", "7.50", 84,  "2000.00");
    }

    private static void insertLoan(Connection c, int userId, String ref, String type,
                                   String principal, String outstanding, String rate,
                                   int tenure, String emi) throws SQLException {
        String sql = "INSERT INTO loans (user_id, account_no, loan_ref, loan_type, principal, outstanding, " +
                "interest_rate, tenure_months, emi_amount, next_due_date) VALUES (?,20000001,?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, ref);
            ps.setString(3, type);
            ps.setBigDecimal(4, new BigDecimal(principal));
            ps.setBigDecimal(5, new BigDecimal(outstanding));
            ps.setBigDecimal(6, new BigDecimal(rate));
            ps.setInt(7, tenure);
            ps.setBigDecimal(8, new BigDecimal(emi));
            ps.setDate(9, java.sql.Date.valueOf(java.time.LocalDate.now().plusMonths(1)));
            ps.executeUpdate();
        }
    }

    /** Starter bill-payment history for the demo customer (idempotent). */
    private static void ensureDemoBills(Connection c, int userId) throws SQLException {
        try (PreparedStatement chk = c.prepareStatement(
                "SELECT 1 FROM bill_payments WHERE user_id = ? LIMIT 1")) {
            chk.setInt(1, userId);
            try (ResultSet rs = chk.executeQuery()) { if (rs.next()) return; }
        }
        insertBill(c, userId, "Electricity", "TPSPDCL", "1234567890", "1250.00");
        insertBill(c, userId, "Mobile", "Jio", "9876543210", "239.00");
        insertBill(c, userId, "DTH", "Tata Play", "1000200030", "299.00");
        insertBill(c, userId, "Water", "BWSSB", "11223344", "650.00");
    }

    private static void insertBill(Connection c, int userId, String category, String biller,
                                   String consumerNo, String amount) throws SQLException {
        String sql = "INSERT INTO bill_payments (user_id, account_no, category, biller, consumer_no, amount, " +
                "status, reference_no) VALUES (?,20000001,?,?,?,?,'SUCCESS',?)";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, category);
            ps.setString(3, biller);
            ps.setString(4, consumerNo);
            ps.setBigDecimal(5, new BigDecimal(amount));
            ps.setString(6, "BIL" + Long.toHexString(System.nanoTime()).toUpperCase());
            ps.executeUpdate();
        }
    }

    /** Starter support tickets for the demo customer (idempotent). */
    private static void ensureDemoServiceRequests(Connection c, int userId) throws SQLException {
        try (PreparedStatement chk = c.prepareStatement(
                "SELECT 1 FROM service_requests WHERE user_id = ? LIMIT 1")) {
            chk.setInt(1, userId);
            try (ResultSet rs = chk.executeQuery()) { if (rs.next()) return; }
        }
        insertRequest(c, userId, "SR-2025-0487", "Issue with Fund Transfer", "Transactions", "IN_PROGRESS");
        insertRequest(c, userId, "SR-2025-0452", "Unable to Add Beneficiary", "Accounts", "RESOLVED");
        insertRequest(c, userId, "SR-2025-0421", "Debit Card Not Received", "Cards", "IN_PROGRESS");
        insertRequest(c, userId, "SR-2025-0288", "KYC Update Assistance", "Profile", "RESOLVED");
    }

    private static void insertRequest(Connection c, int userId, String ticket, String subject,
                                      String category, String status) throws SQLException {
        String sql = "INSERT INTO service_requests (user_id, ticket_no, subject, category, status) " +
                "VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, ticket);
            ps.setString(3, subject);
            ps.setString(4, category);
            ps.setString(5, status);
            ps.executeUpdate();
        }
    }

    private static Integer userId(Connection c, String email) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement("SELECT id FROM users WHERE email = ?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getInt(1) : null; }
        }
    }
}
