package com.acebank.lite.dao;

import com.acebank.lite.models.Notification;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.QueryLoader;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class NotificationDaoImpl implements NotificationDao {
    private static final Logger log = Logger.getLogger(NotificationDaoImpl.class.getName());

    @Override
    public boolean createNotification(int accountNo, String message, String type, String icon, String actionLink) {
        String sql = QueryLoader.get("notification.create");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            stmt.setString(2, message);
            stmt.setString(3, type);
            stmt.setString(4, icon);
            stmt.setString(5, actionLink);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error creating notification: " + e.getMessage());
        }
        return false;
    }

    @Override
    public int getUnreadCount(int accountNo) {
        String sql = QueryLoader.get("notification.get_unread_count");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            log.severe("Error getting unread count: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public List<Notification> getLatestNotifications(int accountNo, int limit) {
        List<Notification> notifications = new ArrayList<>();
        String sql = QueryLoader.get("notification.get_latest");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setId(rs.getInt("ID"));
                    n.setAccountNo(rs.getInt("ACCOUNT_NO"));
                    n.setMessage(rs.getString("MESSAGE"));
                    n.setType(rs.getString("TYPE"));
                    n.setRead(rs.getBoolean("IS_READ"));
                    n.setIcon(rs.getString("ICON"));
                    n.setActionLink(rs.getString("ACTION_LINK"));
                    n.setCreatedAt(rs.getTimestamp("CREATED_AT") != null ? rs.getTimestamp("CREATED_AT").toLocalDateTime() : null);
                    notifications.add(n);
                }
            }
        } catch (SQLException e) {
            log.severe("Error getting latest notifications: " + e.getMessage());
        }
        return notifications;
    }

    @Override
    public boolean markAsRead(int id, int accountNo) {
        String sql = QueryLoader.get("notification.mark_read");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.setInt(2, accountNo);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error marking as read: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean markAllAsRead(int accountNo) {
        String sql = QueryLoader.get("notification.mark_all_read");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNo);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error marking all as read: " + e.getMessage());
        }
        return false;
    }
}
