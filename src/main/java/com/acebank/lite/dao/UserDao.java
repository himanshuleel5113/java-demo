package com.acebank.lite.dao;

import com.acebank.lite.models.AccountRecoveryDTO;
import com.acebank.lite.models.LoginResult;
import com.acebank.lite.models.User;

public interface UserDao {
    LoginResult login(int accountNo, String password);
    LoginResult loginByEmail(String email, String password);
    boolean changePassword(int accountNo, String oldPassword, String newPassword);
    boolean updatePasswordByAccountNo(int accountNo, String newPassword);
    User getDetails(int accountNo);
    AccountRecoveryDTO getRecoveryDetails(String email);
    boolean registerUser(User user, int accountNo);
    User getUserByEmail(String email);
    boolean checkEmailExists(String email);
    boolean checkAadhaarExists(String aadhaar);
    boolean updateFailedLogins(String email, int attempts, java.time.LocalDateTime lockedUntil, String status);
}
