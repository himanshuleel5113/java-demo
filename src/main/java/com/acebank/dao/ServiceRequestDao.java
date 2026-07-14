package com.acebank.dao;

import com.acebank.db.Database;
import com.acebank.model.ServiceRequest;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Data access for customer support tickets, scoped by user. */
public class ServiceRequestDao {

    private static final String SELECT =
            "SELECT id, user_id, ticket_no, subject, category, message, status, created_at, updated_at " +
            "FROM service_requests ";

    public List<ServiceRequest> findByUser(int userId) {
        List<ServiceRequest> out = new ArrayList<>();
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     SELECT + "WHERE user_id = ? ORDER BY updated_at DESC, id DESC")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("findByUser service requests failed", e);
        }
        return out;
    }

    public void insert(int userId, String ticketNo, String subject, String category, String message) {
        String sql = "INSERT INTO service_requests (user_id, ticket_no, subject, category, message) " +
                "VALUES (?,?,?,?,?)";
        try (Connection c = Database.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, ticketNo);
            ps.setString(3, subject);
            ps.setString(4, category);
            ps.setString(5, message);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("insert service request failed", e);
        }
    }

    private ServiceRequest map(ResultSet rs) throws SQLException {
        return new ServiceRequest(
                rs.getLong("id"), rs.getInt("user_id"), rs.getString("ticket_no"),
                rs.getString("subject"), rs.getString("category"), rs.getString("message"),
                rs.getString("status"), rs.getTimestamp("created_at"), rs.getTimestamp("updated_at"));
    }
}
