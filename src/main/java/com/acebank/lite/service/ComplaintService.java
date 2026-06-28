package com.acebank.lite.service;

import com.acebank.lite.models.Complaint;
import com.acebank.lite.models.ServiceResponse;

import java.util.List;

public interface ComplaintService {
    ServiceResponse<Complaint> raiseComplaint(int accountNo, String subject, String description, String category);
    List<Complaint> getComplaints(int accountNo);
}
