package com.acebank.lite.service;

import com.acebank.lite.dao.BeneficiaryDao;
import com.acebank.lite.dao.BeneficiaryDaoImpl;
import com.acebank.lite.models.Beneficiary;
import com.acebank.lite.models.ServiceResponse;

import java.time.LocalDateTime;
import java.util.List;

public class BeneficiaryServiceImpl implements BeneficiaryService {
    private final BeneficiaryDao beneficiaryDao;

    public BeneficiaryServiceImpl() {
        this.beneficiaryDao = new BeneficiaryDaoImpl();
    }

    public BeneficiaryServiceImpl(BeneficiaryDao beneficiaryDao) {
        this.beneficiaryDao = beneficiaryDao;
    }

    @Override
    public ServiceResponse<Beneficiary> addBeneficiary(int ownerAccount, String beneficiaryAccount, String beneficiaryName,
                                                       String bankName, String ifscCode, String nickname) {
        if (beneficiaryAccount == null || beneficiaryAccount.trim().length() < 8) {
            return ServiceResponse.error("Invalid beneficiary account number.");
        }

        int beneficiaryAccountNo;
        try {
            beneficiaryAccountNo = Integer.parseInt(beneficiaryAccount.trim());
        } catch (NumberFormatException e) {
            return ServiceResponse.error("Beneficiary account number must be numeric.");
        }

        if (ownerAccount == beneficiaryAccountNo) {
            return ServiceResponse.error("You cannot add your own account as a beneficiary.");
        }

        List<Beneficiary> existing = beneficiaryDao.findByOwnerAccount(ownerAccount);
        if (existing.stream().anyMatch(b -> b.beneficiaryAccount() == beneficiaryAccountNo)) {
            return ServiceResponse.error("Beneficiary with this account number already exists.");
        }

        Beneficiary beneficiary = new Beneficiary(
            null,
            ownerAccount,
            beneficiaryAccountNo,
            beneficiaryName,
            bankName != null ? bankName : "AceBank",
            ifscCode != null ? ifscCode : "ACEB0000001",
            nickname != null && !nickname.trim().isEmpty() ? nickname : beneficiaryName,
            true,
            LocalDateTime.now()
        );

        boolean success = beneficiaryDao.save(beneficiary);
        if (success) {
            return ServiceResponse.success(beneficiary, "Beneficiary added successfully.");
        }
        return ServiceResponse.error("Failed to add beneficiary.");
    }

    @Override
    public List<Beneficiary> getBeneficiaries(int ownerAccount) {
        return beneficiaryDao.findByOwnerAccount(ownerAccount);
    }

    @Override
    public ServiceResponse<Void> removeBeneficiary(long id, int ownerAccount) {
        boolean success = beneficiaryDao.delete(id, ownerAccount);
        if (success) {
            return ServiceResponse.success(null, "Beneficiary removed successfully.");
        }
        return ServiceResponse.error("Failed to remove beneficiary.");
    }
}
