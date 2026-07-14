package com.acebank.service;

import com.acebank.dao.AccountDao;
import com.acebank.dao.AuditDao;
import com.acebank.dao.UserDao;
import com.acebank.model.User;
import com.acebank.security.PasswordHasher;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.Optional;
import java.util.regex.Pattern;

/**
 * Authentication and registration. Enforces:
 *  - BCrypt verification (generic error message — no user enumeration)
 *  - account lockout after N failed attempts
 *  - per-IP rate limiting against brute force
 *  - audit logging of every attempt
 */
public class AuthService {

    private static final int MAX_ATTEMPTS = 5;
    private static final int LOCK_MINUTES = 15;
    private static final int IP_LIMIT = 20;         // failures / window
    private static final int IP_WINDOW_MIN = 15;
    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");

    private final UserDao users = new UserDao();
    private final AccountDao accounts = new AccountDao();
    private final com.acebank.dao.CardDao cards = new com.acebank.dao.CardDao();
    private final AuditDao audit = new AuditDao();

    public AuthResult login(String email, String password, String ip) {
        email = email == null ? "" : email.trim().toLowerCase();

        if (audit.recentFailuresByIp(ip, IP_WINDOW_MIN) >= IP_LIMIT) {
            audit.recordLoginAttempt(email, ip, false);
            return AuthResult.fail("Too many attempts. Please try again later.");
        }

        Optional<User> found = users.findByEmail(email);
        // Generic failure to avoid leaking whether the email exists.
        if (found.isEmpty()) {
            audit.recordLoginAttempt(email, ip, false);
            return AuthResult.fail("Invalid email or password.");
        }
        User u = found.get();

        if ("LOCKED".equals(u.status()) && u.lockedUntil() != null
                && u.lockedUntil().toInstant().isAfter(Instant.now())) {
            audit.recordLoginAttempt(email, ip, false);
            return AuthResult.fail("Account locked. Try again after " + LOCK_MINUTES + " minutes.");
        }
        if ("SUSPENDED".equals(u.status())) {
            return AuthResult.fail("Account suspended. Contact support.");
        }

        if (!PasswordHasher.verify(password, u.passwordHash())) {
            int attempts = u.failedLoginAttempts() + 1;
            Timestamp lockUntil = attempts >= MAX_ATTEMPTS
                    ? Timestamp.from(Instant.now().plusSeconds(LOCK_MINUTES * 60L)) : null;
            users.recordFailedLogin(u.id(), attempts, lockUntil);
            audit.recordLoginAttempt(email, ip, false);
            audit.log(u.id(), "LOGIN_FAILED", "attempt " + attempts, ip);
            return AuthResult.fail("Invalid email or password.");
        }

        users.resetLoginState(u.id());
        audit.recordLoginAttempt(email, ip, true);
        audit.log(u.id(), "LOGIN_SUCCESS", null, ip);
        return AuthResult.ok(u);
    }

    public AuthResult signup(String firstName, String lastName, String email,
                             String phone, String password, String ip) {
        firstName = safe(firstName); lastName = safe(lastName);
        email = email == null ? "" : email.trim().toLowerCase();

        if (firstName.isEmpty() || lastName.isEmpty()) return AuthResult.fail("Please enter your full name.");
        if (!EMAIL.matcher(email).matches())           return AuthResult.fail("Please enter a valid email address.");
        String pwError = passwordPolicyError(password);
        if (pwError != null)                            return AuthResult.fail(pwError);
        if (users.emailExists(email))                   return AuthResult.fail("An account with this email already exists.");

        int userId = users.insert(firstName, lastName, email, safe(phone),
                PasswordHasher.hash(password), "CUSTOMER");
        long accountNo = accounts.nextAccountNo();
        accounts.insert(accountNo, userId, BigDecimal.ZERO);
        // Issue a default debit card so the new customer's Cards page shows their own details.
        String acc = String.valueOf(accountNo);
        cards.insert(accountNo, "DEBIT", "VISA", acc.substring(acc.length() - 4), "12/30",
                new BigDecimal("100000.00"));
        audit.log(userId, "SIGNUP", "account " + accountNo, ip);

        return users.findByEmail(email).map(AuthResult::ok)
                .orElse(AuthResult.fail("Registration failed. Please try again."));
    }

    /**
     * Changes the logged-in user's password. Verifies the current password,
     * enforces the same policy as signup, and rejects reusing the old one.
     */
    public AuthResult changePassword(int userId, String currentPw, String newPw, String confirmPw, String ip) {
        Optional<User> found = users.findById(userId);
        if (found.isEmpty()) return AuthResult.fail("User not found.");
        User u = found.get();

        if (!PasswordHasher.verify(currentPw, u.passwordHash()))
            return AuthResult.fail("Your current password is incorrect.");
        if (newPw == null || !newPw.equals(confirmPw))
            return AuthResult.fail("New password and confirmation do not match.");
        String pwError = passwordPolicyError(newPw);
        if (pwError != null) return AuthResult.fail(pwError);
        if (PasswordHasher.verify(newPw, u.passwordHash()))
            return AuthResult.fail("New password must be different from the current one.");

        users.updatePassword(userId, PasswordHasher.hash(newPw));
        audit.log(userId, "PASSWORD_CHANGE", null, ip);
        return AuthResult.ok(u);
    }

    /** Password policy: >= 8 chars, at least one upper, one lower, one digit. */
    public static String passwordPolicyError(String pw) {
        if (pw == null || pw.length() < 8) return "Password must be at least 8 characters.";
        boolean upper = false, lower = false, digit = false;
        for (char ch : pw.toCharArray()) {
            if (Character.isUpperCase(ch)) upper = true;
            else if (Character.isLowerCase(ch)) lower = true;
            else if (Character.isDigit(ch)) digit = true;
        }
        if (!(upper && lower && digit))
            return "Password needs an uppercase letter, a lowercase letter, and a number.";
        return null;
    }

    private static String safe(String s) { return s == null ? "" : s.trim(); }
}
