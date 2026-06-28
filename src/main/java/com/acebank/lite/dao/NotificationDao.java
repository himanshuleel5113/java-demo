package com.acebank.lite.dao;

import com.acebank.lite.models.Notification;
import java.util.List;

public interface NotificationDao {
    boolean createNotification(int accountNo, String message, String type, String icon, String actionLink);
    int getUnreadCount(int accountNo);
    List<Notification> getLatestNotifications(int accountNo, int limit);
    boolean markAsRead(int id, int accountNo);
    boolean markAllAsRead(int accountNo);
}
