package com.acebank.lite.dao;

import com.acebank.lite.models.AccountRecoveryDTO;
import com.acebank.lite.models.LoginResult;
import com.acebank.lite.models.User;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.PasswordUtil;
import com.acebank.lite.util.QueryLoader;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.logging.Logger;

public class UserDaoImpl implements UserDao {
    private static final Logger log = Logger.getLogger(UserDaoImpl.class.getName());

    @Override
    public LoginResult login(int accountNo, String password) {
        String sql = QueryLoader.get("user.login_details");
        // We will do a different approach: since login_details looks for email = ?,
        // the old query was WHERE a.ACCOUNT_NO = ? AND u.PASSWORD_HASH = ?
        // We will need a specific query for accountNo based login if it is supported.
        // For now, let's just get the user by accountNo and verify password.
        return null;
    }

    @Override
    public LoginResult loginByEmail(String email, String password) {
        String sql = QueryLoader.get("user.login_details");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // Password verification must happen here, but we need the hash.
                    String hashQuery = QueryLoader.get("user.get_password_by_email");
                    try (PreparedStatement hStmt = conn.prepareStatement(hashQuery)) {
                        hStmt.setString(1, email);
                        try (ResultSet hrs = hStmt.executeQuery()) {
                            if (hrs.next()) {
                                String hash = hrs.getString("PASSWORD_HASH");
                                if (PasswordUtil.checkPassword(password, hash)) {
                                    return new LoginResult(true, "Login successful", rs.getInt("ACCOUNT_NO"), rs.getString("FIRST_NAME"), rs.getString("LAST_NAME"), rs.getString("EMAIL"), rs.getString("ROLE"), rs.getBigDecimal("BALANCE"));
                                }
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            log.severe("Error logging in: " + e.getMessage());
        }
        return new LoginResult(false, "Invalid credentials", -1, null, null, null, null, null);
    }

    @Override
    public boolean changePassword(int accountNo, String oldPassword, String newPassword) {
        String getPwSql = QueryLoader.get("user.get_password_by_acc");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(getPwSql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String hash = rs.getString("PASSWORD_HASH");
                    if (PasswordUtil.checkPassword(oldPassword, hash)) {
                        return updatePasswordByAccountNo(accountNo, newPassword);
                    }
                }
            }
        } catch (SQLException e) {
            log.severe("Error changing password: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean updatePasswordByAccountNo(int accountNo, String newPassword) {
        String sql = QueryLoader.get("user.update_password_by_account");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, PasswordUtil.hashPassword(newPassword));
            stmt.setInt(2, accountNo);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error updating password: " + e.getMessage());
        }
        return false;
    }

    @Override
    public User getDetails(int accountNo) {
        String sql = "SELECT u.* FROM USERS u JOIN ACCOUNTS a ON u.USER_ID = a.USER_ID WHERE a.ACCOUNT_NO = ?";
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            log.severe("Error getting details: " + e.getMessage());
        }
        return null;
    }

    @Override
    public AccountRecoveryDTO getRecoveryDetails(String email) {
        String sql = QueryLoader.get("user.recover_details");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new AccountRecoveryDTO(rs.getString("FIRST_NAME"), rs.getString("LAST_NAME"), rs.getInt("ACCOUNT_NO"));
                }
            }
        } catch (SQLException e) {
            log.severe("Error getting recovery details: " + e.getMessage());
        }
        return null;
    }

    @Override
    public boolean registerUser(User user, int accountNo) {
        String sql = QueryLoader.get("user.signup");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.firstName());
            stmt.setString(2, user.lastName());
            stmt.setString(3, user.aadhaarNo());
            stmt.setString(4, user.email());
            stmt.setString(5, user.passwordHash());
            stmt.setString(6, user.phone());
            stmt.setObject(7, user.dateOfBirth());
            stmt.setString(8, user.address());
            stmt.setString(9, user.panNo());
            stmt.setString(10, user.role() != null ? user.role() : "CUSTOMER");
            
            if (stmt.executeUpdate() > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int userId = rs.getInt(1);
                        String createAccSql = QueryLoader.get("account.create");
                        try (PreparedStatement accStmt = conn.prepareStatement(createAccSql)) {
                            accStmt.setInt(1, accountNo);
                            accStmt.setInt(2, userId);
                            return accStmt.executeUpdate() > 0;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            log.severe("Error registering user: " + e.getMessage());
        }
        return false;
    }

    @Override
    public User getUserByEmail(String email) {
        String sql = QueryLoader.get("user.get_user_by_email");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            log.severe("Error getting user by email: " + e.getMessage());
        }
        return null;
    }

    @Override
    public boolean checkEmailExists(String email) {
        String sql = QueryLoader.get("user.check_email_exists");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            log.severe("Error checking email: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean checkAadhaarExists(String aadhaar) {
        String sql = QueryLoader.get("user.check_aadhaar_exists");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, aadhaar);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            log.severe("Error checking aadhaar: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean updateFailedLogins(String email, int attempts, LocalDateTime lockedUntil, String status) {
        String sql = QueryLoader.get("user.update_failed_logins");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, attempts);
            if (lockedUntil != null) {
                stmt.setTimestamp(2, Timestamp.valueOf(lockedUntil));
            } else {
                stmt.setNull(2, java.sql.Types.TIMESTAMP);
            }
            stmt.setString(3, status);
            stmt.setString(4, email);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error updating failed logins: " + e.getMessage());
        }
        return false;
    }
    
    private User mapUser(ResultSet rs) throws SQLException {
        return new User(
            rs.getInt("USER_ID"),
            rs.getString("FIRST_NAME"),
            rs.getString("LAST_NAME"),
            rs.getString("AADHAAR_NO"),
            rs.getString("EMAIL"),
            rs.getString("PASSWORD_HASH"),
            rs.getString("ROLE"),
            rs.getString("PHONE"),
            rs.getDate("DATE_OF_BIRTH") != null ? rs.getDate("DATE_OF_BIRTH").toLocalDate() : null,
            rs.getString("ADDRESS"),
            rs.getString("PAN_NO"),
            rs.getString("STATUS"),
            rs.getInt("FAILED_LOGIN_ATTEMPTS"),
            rs.getTimestamp("LOCKED_UNTIL") != null ? rs.getTimestamp("LOCKED_UNTIL").toLocalDateTime() : null,
            rs.getBoolean("TWO_FA_ENABLED"),
            rs.getString("TWO_FA_SECRET"),
            rs.getString("PROFILE_PHOTO"),
            rs.getTimestamp("CREATED_AT") != null ? rs.getTimestamp("CREATED_AT").toLocalDateTime() : null,
            rs.getTimestamp("UPDATED_AT") != null ? rs.getTimestamp("UPDATED_AT").toLocalDateTime() : null
        );
    }
}
