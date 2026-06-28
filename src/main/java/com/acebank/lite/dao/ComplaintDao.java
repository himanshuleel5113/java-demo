package com.acebank.lite.dao;

import com.acebank.lite.models.Complaint;
import java.util.List;
import java.util.Optional;

public interface ComplaintDao {
    boolean save(Complaint complaint);
    Optional<Complaint> findById(long id);
    List<Complaint> findByAccountNo(int accountNo);
    boolean updateStatus(long id, String status, String resolution);
}
