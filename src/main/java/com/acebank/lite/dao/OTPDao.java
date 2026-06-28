package com.acebank.lite.dao;

import com.acebank.lite.models.OTP;
import java.time.LocalDateTime;

public interface OTPDao {
    boolean saveOTP(String email, String otpHash, Integer accountNo, String purpose, LocalDateTime expiresAt);
    OTP getLatestOTP(String email, String purpose);
    boolean markAsVerified(int id);
    boolean incrementAttempts(int id);
    boolean deleteOTPByEmail(String email, String purpose);
}
