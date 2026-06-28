package com.acebank.lite.models;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Notification {
    private int id;
    private int accountNo;
    private String message;
    private String type;
    private boolean isRead;
    private String icon;
    private String actionLink;
    private LocalDateTime createdAt;

    public Notification() {}

    public Notification(int accountNo, String message, String type) {
        this.accountNo = accountNo;
        this.message = message;
        this.type = type;
        this.isRead = false;
        this.createdAt = LocalDateTime.now();
        setIconAndLink();
    }

    private void setIconAndLink() {
        if (type == null) type = "INFO";
        switch (type) {
            case "DEPOSIT":
                this.icon = "fa-arrow-down text-green-500";
                this.actionLink = "Statement.jsp";
                break;
            case "WITHDRAWAL":
                this.icon = "fa-arrow-up text-red-500";
                this.actionLink = "Statement.jsp";
                break;
            case "TRANSFER":
                this.icon = "fa-exchange-alt text-blue-500";
                this.actionLink = "Statement.jsp";
                break;
            case "LOAN":
                this.icon = "fa-hand-holding-usd text-yellow-500";
                this.actionLink = "Loan.jsp";
                break;
            case "SECURITY":
                this.icon = "fa-shield-alt text-purple-500";
                this.actionLink = "ChangePassword.jsp";
                break;
            default:
                this.icon = "fa-info-circle text-gray-500";
                this.actionLink = "#";
        }
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getAccountNo() { return accountNo; }
    public void setAccountNo(int accountNo) { this.accountNo = accountNo; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; setIconAndLink(); }
    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }
    public String getActionLink() { return actionLink; }
    public void setActionLink(String actionLink) { this.actionLink = actionLink; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public String getFormattedTime() {
        if (createdAt == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM, hh:mm a");
        return createdAt.format(formatter);
    }
}