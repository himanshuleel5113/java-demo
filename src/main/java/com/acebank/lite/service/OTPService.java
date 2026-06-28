package com.acebank.lite.service;

import com.acebank.lite.dao.OTPDao;
import com.acebank.lite.dao.OTPDaoImpl;
import com.acebank.lite.models.OTP;
import com.acebank.lite.util.PasswordUtil;
import lombok.extern.java.Log;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.logging.Logger;

public class OTPService {

    private static final Logger log = Logger.getLogger(OTPService.class.getName());
    
    private static final OTPDao otpDao = new OTPDaoImpl();
    private static final SecureRandom random = new SecureRandom();
    private static final int OTP_EXPIRY_MINUTES = 10;
    
    public static class OTPData {
        private final String otp;
        private final long expiryTime;
        private final Integer accountNo;
        private final String email;
        private boolean verified;
        
        public OTPData(String otp, Integer accountNo, String email) {
            this.otp = otp;
            this.accountNo = accountNo;
            this.email = email;
            this.expiryTime = System.currentTimeMillis() + (OTP_EXPIRY_MINUTES * 60 * 1000);
            this.verified = false;
        }
        
        public String getOtp() { return otp; }
        public long getExpiryTime() { return expiryTime; }
        public Integer getAccountNo() { return accountNo; }
        public String getEmail() { return email; }
        public boolean isVerified() { return verified; }
        public void setVerified(boolean verified) { this.verified = verified; }
        public boolean isExpired() { return System.currentTimeMillis() > expiryTime; }
    }
    
    // Kept primitive int for backward compatibility with existing servlets
    public static String generateOTP(int accountNo, String email) {
        return generateOTP((Integer) accountNo, email);
    }
    
    public static String generateOTP(Integer accountNo, String email) {
        int otpNumber = 100000 + random.nextInt(900000);
        String otp = String.valueOf(otpNumber);
        
        String otpHash = PasswordUtil.hashPassword(otp);
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES);
        
        boolean saved = otpDao.saveOTP(email, otpHash, accountNo, "PASSWORD_RESET", expiresAt);
        
        if (saved) {
            log.info("DB OTP generated for email: " + email + " (valid for " + OTP_EXPIRY_MINUTES + " minutes)");
            return otp;
        } else {
            log.severe("Failed to save OTP to database for: " + email);
            return null;
        }
    }
    
    public static boolean validateOTP(String email, String otp) {
        OTP otpRecord = otpDao.getLatestOTP(email, "PASSWORD_RESET");
        
        if (otpRecord == null) {
            log.warning("No OTP found for email: " + email);
            return false;
        }
        
        if (otpRecord.expiresAt().isBefore(LocalDateTime.now())) {
            log.warning("OTP expired for email: " + email);
            return false;
        }
        
        if (otpRecord.attempts() >= 3) {
            log.warning("OTP maximum attempts reached for email: " + email);
            return false;
        }
        
        if (!PasswordUtil.checkPassword(otp, otpRecord.otpHash())) {
            log.warning("Invalid OTP for email: " + email);
            otpDao.incrementAttempts(otpRecord.id());
            return false;
        }
        
        otpDao.markAsVerified(otpRecord.id());
        log.info("OTP verified successfully for email: " + email);
        return true;
    }
    
    public static boolean isVerified(String email) {
        OTP otpRecord = otpDao.getLatestOTP(email, "PASSWORD_RESET");
        return otpRecord != null && Boolean.TRUE.equals(otpRecord.verified()) && otpRecord.expiresAt().isAfter(LocalDateTime.now());
    }
    
    public static OTPData getOTPData(String email) {
        OTP otpRecord = otpDao.getLatestOTP(email, "PASSWORD_RESET");
        if (otpRecord != null) {
            OTPData data = new OTPData("", otpRecord.accountNo(), email);
            data.setVerified(Boolean.TRUE.equals(otpRecord.verified()));
            return data;
        }
        return null;
    }
    
    public static void clearOTP(String email) {
        otpDao.deleteOTPByEmail(email, "PASSWORD_RESET");
        log.info("OTP cleared for email: " + email);
    }
}