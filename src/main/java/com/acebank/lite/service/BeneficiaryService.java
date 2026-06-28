package com.acebank.lite.service;

import com.acebank.lite.models.Beneficiary;
import com.acebank.lite.models.ServiceResponse;

import java.util.List;

public interface BeneficiaryService {
    ServiceResponse<Beneficiary> addBeneficiary(int ownerAccount, String beneficiaryAccount, String beneficiaryName, String bankName, String ifscCode, String nickname);
    List<Beneficiary> getBeneficiaries(int ownerAccount);
    ServiceResponse<Void> removeBeneficiary(long id, int ownerAccount);
}
