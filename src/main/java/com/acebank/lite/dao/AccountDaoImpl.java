package com.acebank.lite.dao;

import com.acebank.lite.models.Account;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.QueryLoader;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Logger;

public class AccountDaoImpl implements AccountDao {
    private static final Logger log = Logger.getLogger(AccountDaoImpl.class.getName());

    @Override
    public Account getAccount(int accountNo) {
        String sql = QueryLoader.get("account.get_account");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                        rs.getInt("ACCOUNT_NO"),
                        rs.getInt("USER_ID"),
                        rs.getString("ACCOUNT_TYPE"),
                        rs.getBigDecimal("BALANCE"),
                        rs.getString("STATUS"),
                        rs.getInt("VERSION"),
                        rs.getTimestamp("CREATED_AT") != null ? rs.getTimestamp("CREATED_AT").toLocalDateTime() : null
                    );
                }
            }
        } catch (SQLException e) {
            log.severe("Error getting account: " + e.getMessage());
        }
        return null;
    }

    @Override
    public BigDecimal getBalance(int accountNo) {
        String sql = QueryLoader.get("account.get_balance");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("BALANCE");
                }
            }
        } catch (SQLException e) {
            log.severe("Error getting balance: " + e.getMessage());
        }
        return null;
    }

    @Override
    public boolean createAccount(int accountNo, int userId) {
        String sql = QueryLoader.get("account.create");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error creating account: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean withdraw(int accountNo, BigDecimal amount) {
        String versionSql = QueryLoader.get("account.get_version");
        String withdrawSql = QueryLoader.get("account.withdraw");
        try (Connection conn = ConnectionManager.getConnection()) {
            int version = 0;
            try (PreparedStatement stmt = conn.prepareStatement(versionSql)) {
                stmt.setInt(1, accountNo);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        version = rs.getInt("VERSION");
                    } else {
                        return false;
                    }
                }
            }
            try (PreparedStatement stmt = conn.prepareStatement(withdrawSql)) {
                stmt.setBigDecimal(1, amount);
                stmt.setInt(2, accountNo);
                stmt.setBigDecimal(3, amount);
                stmt.setInt(4, version);
                return stmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            log.severe("Error withdrawing: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean deposit(int accountNo, BigDecimal amount) {
        String versionSql = QueryLoader.get("account.get_version");
        String depositSql = QueryLoader.get("account.deposit");
        try (Connection conn = ConnectionManager.getConnection()) {
            int version = 0;
            try (PreparedStatement stmt = conn.prepareStatement(versionSql)) {
                stmt.setInt(1, accountNo);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        version = rs.getInt("VERSION");
                    } else {
                        return false;
                    }
                }
            }
            try (PreparedStatement stmt = conn.prepareStatement(depositSql)) {
                stmt.setBigDecimal(1, amount);
                stmt.setInt(2, accountNo);
                stmt.setInt(3, version);
                return stmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            log.severe("Error depositing: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean transfer(int fromAccountNo, int toAccountNo, BigDecimal amount) {
        String versionSql = QueryLoader.get("account.get_version");
        String withdrawSql = QueryLoader.get("account.withdraw");
        String depositSql = QueryLoader.get("account.deposit");

        Connection conn = null;
        try {
            conn = ConnectionManager.getConnection();
            conn.setAutoCommit(false);

            int fromVersion = readVersion(conn, versionSql, fromAccountNo);
            int toVersion = readVersion(conn, versionSql, toAccountNo);
            if (fromVersion < 0 || toVersion < 0) {
                conn.rollback();
                return false;
            }

            // Debit sender (guarded by balance + optimistic version check).
            try (PreparedStatement stmt = conn.prepareStatement(withdrawSql)) {
                stmt.setBigDecimal(1, amount);
                stmt.setInt(2, fromAccountNo);
                stmt.setBigDecimal(3, amount);
                stmt.setInt(4, fromVersion);
                if (stmt.executeUpdate() != 1) {
                    conn.rollback();
                    return false;
                }
            }

            // Credit recipient.
            try (PreparedStatement stmt = conn.prepareStatement(depositSql)) {
                stmt.setBigDecimal(1, amount);
                stmt.setInt(2, toAccountNo);
                stmt.setInt(3, toVersion);
                if (stmt.executeUpdate() != 1) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            log.severe("Error during atomic transfer: " + e.getMessage());
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { log.severe("Rollback failed: " + ex.getMessage()); }
            }
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { log.severe("Close failed: " + ex.getMessage()); }
            }
        }
    }

    private int readVersion(Connection conn, String versionSql, int accountNo) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(versionSql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getInt("VERSION") : -1;
            }
        }
    }

    @Override
    public int getVersion(int accountNo) {
        String sql = QueryLoader.get("account.get_version");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("VERSION");
                }
            }
        } catch (SQLException e) {
            log.severe("Error getting version: " + e.getMessage());
        }
        return -1;
    }
}
