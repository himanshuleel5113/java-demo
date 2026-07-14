package com.acebank.dao;

import com.acebank.db.Database;
import com.acebank.model.Account;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/** Data access for accounts. */
public class AccountDao {

    public Optional<Account> findPrimaryByUser(int userId) {
        String sql = "SELECT * FROM accounts WHERE user_id = ? ORDER BY account_no LIMIT 1";
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        } catch (SQLException e) {
            throw new RuntimeException("findPrimaryByUser failed", e);
        }
    }

    public List<Account> findByUser(int userId) {
        String sql = "SELECT * FROM accounts WHERE user_id = ? ORDER BY account_no";
        List<Account> out = new ArrayList<>();
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("findByUser failed", e);
        }
        return out;
    }

    public Optional<BigDecimal> balanceOf(long accountNo) {
        String sql = "SELECT balance FROM accounts WHERE account_no = ?";
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, accountNo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(rs.getBigDecimal(1)) : Optional.empty();
            }
        } catch (SQLException e) {
            throw new RuntimeException("balanceOf failed", e);
        }
    }

    /** Next account number for a new customer (simple sequential allocation). */
    public long nextAccountNo() {
        String sql = "SELECT COALESCE(MAX(account_no), 20000000) + 1 FROM accounts";
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getLong(1) : 20000001L;
        } catch (SQLException e) {
            throw new RuntimeException("nextAccountNo failed", e);
        }
    }

    public void insert(long accountNo, int userId, BigDecimal openingBalance) {
        String sql = "INSERT INTO accounts (account_no,user_id,balance) VALUES (?,?,?)";
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, accountNo);
            ps.setInt(2, userId);
            ps.setBigDecimal(3, openingBalance);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("insert account failed", e);
        }
    }

    private Account map(ResultSet rs) throws SQLException {
        return new Account(
                rs.getLong("account_no"),
                rs.getInt("user_id"),
                rs.getString("account_type"),
                rs.getBigDecimal("balance"),
                rs.getString("status"),
                rs.getInt("version"));
    }
}
