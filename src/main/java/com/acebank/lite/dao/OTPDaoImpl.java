package com.acebank.lite.dao;

import com.acebank.lite.models.OTP;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.QueryLoader;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.logging.Logger;

public class OTPDaoImpl implements OTPDao {
    private static final Logger log = Logger.getLogger(OTPDaoImpl.class.getName());

    @Override
    public boolean saveOTP(String email, String otpHash, Integer accountNo, String purpose, LocalDateTime expiresAt) {
        String sql = QueryLoader.get("otp.save");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, otpHash);
            if (accountNo != null) {
                stmt.setInt(3, accountNo);
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            stmt.setString(4, purpose);
            stmt.setTimestamp(5, Timestamp.valueOf(expiresAt));
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error saving OTP: " + e.getMessage());
        }
        return false;
    }

    @Override
    public OTP getLatestOTP(String email, String purpose) {
        String sql = QueryLoader.get("otp.get_latest");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, purpose);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new OTP(
                        rs.getInt("ID"),
                        rs.getString("EMAIL"),
                        rs.getString("OTP_HASH"),
                        rs.getObject("ACCOUNT_NO") != null ? rs.getInt("ACCOUNT_NO") : null,
                        rs.getString("PURPOSE"),
                        rs.getTimestamp("EXPIRES_AT") != null ? rs.getTimestamp("EXPIRES_AT").toLocalDateTime() : null,
                        rs.getBoolean("VERIFIED"),
                        rs.getInt("ATTEMPTS"),
                        rs.getTimestamp("CREATED_AT") != null ? rs.getTimestamp("CREATED_AT").toLocalDateTime() : null
                    );
                }
            }
        } catch (SQLException e) {
            log.severe("Error getting latest OTP: " + e.getMessage());
        }
        return null;
    }

    @Override
    public boolean markAsVerified(int id) {
        String sql = QueryLoader.get("otp.mark_verified");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error marking OTP as verified: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean incrementAttempts(int id) {
        String sql = QueryLoader.get("otp.increment_attempts");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error incrementing OTP attempts: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean deleteOTPByEmail(String email, String purpose) {
        String sql = QueryLoader.get("otp.delete_by_email");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, purpose);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error deleting OTP: " + e.getMessage());
        }
        return false;
    }
}
