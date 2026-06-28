package com.acebank.lite.dao;

import com.acebank.lite.models.Beneficiary;
import java.util.List;
import java.util.Optional;

public interface BeneficiaryDao {
    boolean save(Beneficiary beneficiary);
    Optional<Beneficiary> findById(long id);
    List<Beneficiary> findByOwnerAccount(int ownerAccount);
    boolean update(Beneficiary beneficiary);
    boolean delete(long id, int ownerAccount);
}
