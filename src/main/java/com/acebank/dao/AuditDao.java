package com.acebank.dao;

import com.acebank.db.Database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/** Writes to the immutable audit trail and login-attempt log. */
public class AuditDao {

    public void log(Integer userId, String action, String details, String ip) {
        String sql = "INSERT INTO audit_log (user_id, action, details, ip_address) VALUES (?,?,?,?)";
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (userId == null) ps.setNull(1, java.sql.Types.INTEGER); else ps.setInt(1, userId);
            ps.setString(2, action);
            ps.setString(3, details);
            ps.setString(4, ip);
            ps.executeUpdate();
        } catch (SQLException e) {
            // auditing must never break the main flow
            System.err.println("audit log failed: " + e.getMessage());
        }
    }

    public void recordLoginAttempt(String email, String ip, boolean success) {
        String sql = "INSERT INTO login_attempts (email, ip_address, success) VALUES (?,?,?)";
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, ip);
            ps.setBoolean(3, success);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("login attempt log failed: " + e.getMessage());
        }
    }

    /** Count of failed attempts from an IP in the last {@code minutes} minutes. */
    public int recentFailuresByIp(String ip, int minutes) {
        String sql = "SELECT COUNT(*) FROM login_attempts WHERE ip_address = ? AND success = FALSE " +
                     "AND created_at > (NOW() - INTERVAL ? MINUTE)";
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, ip);
            ps.setInt(2, minutes);
            try (var rs = ps.executeQuery()) { return rs.next() ? rs.getInt(1) : 0; }
        } catch (SQLException e) {
            return 0;
        }
    }
}
