package com.acebank.lite.service;

import com.acebank.lite.dao.ComplaintDao;
import com.acebank.lite.dao.ComplaintDaoImpl;
import com.acebank.lite.models.Complaint;
import com.acebank.lite.models.ServiceResponse;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class ComplaintServiceImpl implements ComplaintService {
    private final ComplaintDao complaintDao;

    public ComplaintServiceImpl() {
        this.complaintDao = new ComplaintDaoImpl();
    }

    @Override
    public ServiceResponse<Complaint> raiseComplaint(int accountNo, String subject, String description, String category) {
        if (subject == null || subject.trim().isEmpty() || description == null || description.trim().isEmpty()) {
            return ServiceResponse.error("Subject and Description are required.");
        }

        String ticketNo = "CMP-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String resolvedCategory = category != null ? category.toUpperCase() : "OTHER";
        LocalDateTime now = LocalDateTime.now();

        Complaint complaint = new Complaint(
            null,
            accountNo,
            ticketNo,
            subject,
            description,
            resolvedCategory,
            "OPEN",
            "MEDIUM",
            null,
            null,
            now,
            now
        );

        boolean success = complaintDao.save(complaint);
        if (success) {
            return ServiceResponse.success(complaint,
                    "Complaint raised successfully. Your ticket number is " + ticketNo + ".");
        }
        return ServiceResponse.error("Failed to raise complaint.");
    }

    @Override
    public List<Complaint> getComplaints(int accountNo) {
        return complaintDao.findByAccountNo(accountNo);
    }
}
