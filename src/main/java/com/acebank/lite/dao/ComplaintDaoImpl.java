package com.acebank.lite.dao;

import com.acebank.lite.models.Complaint;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.QueryLoader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ComplaintDaoImpl implements ComplaintDao {
    private static final Logger logger = LoggerFactory.getLogger(ComplaintDaoImpl.class);

    @Override
    public boolean save(Complaint complaint) {
        String sql = QueryLoader.getQuery("complaint.insert");
        if (sql == null) {
            sql = "INSERT INTO COMPLAINTS (ACCOUNT_NO, TICKET_NO, SUBJECT, DESCRIPTION, CATEGORY, STATUS, PRIORITY, RESOLUTION) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, complaint.accountNo());
            stmt.setString(2, complaint.ticketNo());
            stmt.setString(3, complaint.subject());
            stmt.setString(4, complaint.description());
            stmt.setString(5, complaint.category());
            stmt.setString(6, complaint.status());
            stmt.setString(7, complaint.priority());
            stmt.setString(8, complaint.resolution());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Failed to save Complaint for account {}", complaint.accountNo(), e);
            return false;
        }
    }

    @Override
    public Optional<Complaint> findById(long id) {
        String sql = QueryLoader.getQuery("complaint.findById");
        if (sql == null) {
            sql = "SELECT * FROM COMPLAINTS WHERE ID = ?";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToComplaint(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Failed to find Complaint by ID {}", id, e);
        }
        return Optional.empty();
    }

    @Override
    public List<Complaint> findByAccountNo(int accountNo) {
        List<Complaint> complaints = new ArrayList<>();
        String sql = QueryLoader.getQuery("complaint.findByAccount");
        if (sql == null) {
            sql = "SELECT * FROM COMPLAINTS WHERE ACCOUNT_NO = ? ORDER BY CREATED_AT DESC";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapResultSetToComplaint(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Failed to find Complaints for account {}", accountNo, e);
        }
        return complaints;
    }

    @Override
    public boolean updateStatus(long id, String status, String resolution) {
        String sql = QueryLoader.getQuery("complaint.updateStatus");
        if (sql == null) {
            sql = "UPDATE COMPLAINTS SET STATUS = ?, RESOLUTION = ?, UPDATED_AT = ? WHERE ID = ?";
        }
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, resolution);
            stmt.setTimestamp(3, Timestamp.valueOf(java.time.LocalDateTime.now()));
            stmt.setLong(4, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Failed to update Complaint status for ID {}", id, e);
            return false;
        }
    }

    private Complaint mapResultSetToComplaint(ResultSet rs) throws SQLException {
        return new Complaint(
            rs.getInt("ID"),
            rs.getInt("ACCOUNT_NO"),
            rs.getString("TICKET_NO"),
            rs.getString("SUBJECT"),
            rs.getString("DESCRIPTION"),
            rs.getString("CATEGORY"),
            rs.getString("STATUS"),
            rs.getString("PRIORITY"),
            rs.getString("RESOLUTION"),
            (Integer) rs.getObject("ASSIGNED_TO"),
            rs.getTimestamp("CREATED_AT").toLocalDateTime(),
            rs.getTimestamp("UPDATED_AT").toLocalDateTime()
        );
    }
}
