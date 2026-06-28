package com.acebank.lite.service;

import com.acebank.lite.dao.NotificationDao;
import com.acebank.lite.dao.NotificationDaoImpl;
import com.acebank.lite.models.Notification;
import lombok.extern.java.Log;

import java.util.List;
import java.util.logging.Logger;

public class NotificationService {

    private static final Logger log = Logger.getLogger(NotificationService.class.getName());

    private static final NotificationDao notificationDao = new NotificationDaoImpl();

    public static void addNotification(int accountNo, String message, String type) {
        // Simple logic for icon/link
        String icon = "fa-info-circle text-gray-500";
        String actionLink = "#";
        if (type == null) type = "INFO";
        switch (type) {
            case "DEPOSIT":
                icon = "fa-arrow-down text-green-500";
                actionLink = "Statement.jsp";
                break;
            case "WITHDRAWAL":
                icon = "fa-arrow-up text-red-500";
                actionLink = "Statement.jsp";
                break;
            case "TRANSFER":
                icon = "fa-exchange-alt text-blue-500";
                actionLink = "Statement.jsp";
                break;
            case "LOAN":
                icon = "fa-hand-holding-usd text-yellow-500";
                actionLink = "Loan.jsp";
                break;
            case "SECURITY":
                icon = "fa-shield-alt text-purple-500";
                actionLink = "ChangePassword.jsp";
                break;
        }

        try {
            boolean success = notificationDao.createNotification(accountNo, message, type, icon, actionLink);
            if (success) {
                log.info("✅ NOTIFICATION ADDED for account " + accountNo + ": " + message + " (Type: " + type + ")");
            } else {
                log.warning("Failed to add notification for account " + accountNo);
            }
        } catch (Exception e) {
            log.severe("Error adding notification: " + e.getMessage());
        }
    }

    public static List<Notification> getNotifications(int accountNo) {
        return notificationDao.getLatestNotifications(accountNo, 50); // Get latest 50
    }

    public static List<Notification> getUnreadNotifications(int accountNo) {
        List<Notification> unread = new java.util.ArrayList<>();
        List<Notification> all = getNotifications(accountNo);
        for (Notification n : all) {
            if (!n.isRead()) {
                unread.add(n);
            }
        }
        return unread;
    }

    public static int getUnreadCount(int accountNo) {
        return notificationDao.getUnreadCount(accountNo);
    }

    public static void markAsRead(int accountNo, int notificationId) {
        notificationDao.markAsRead(notificationId, accountNo);
    }

    public static void markAllAsRead(int accountNo) {
        notificationDao.markAllAsRead(accountNo);
    }
}