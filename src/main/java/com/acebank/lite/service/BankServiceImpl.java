package com.acebank.lite.service;

import com.acebank.lite.dao.AccountDao;
import com.acebank.lite.dao.AccountDaoImpl;
import com.acebank.lite.dao.TransactionDao;
import com.acebank.lite.dao.TransactionDaoImpl;
import com.acebank.lite.dao.UserDao;
import com.acebank.lite.dao.UserDaoImpl;
import com.acebank.lite.models.*;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.MailUtil;
import com.acebank.lite.util.PasswordUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;
import java.util.logging.Logger;

public class BankServiceImpl implements BankService {

    private static final Logger log = Logger.getLogger(BankServiceImpl.class.getName());

    private final UserDao userDao = new UserDaoImpl();
    private final AccountDao accountDao = new AccountDaoImpl();
    private final TransactionDao transactionDao = new TransactionDaoImpl();
    private static final BigDecimal DAILY_LIMIT = new BigDecimal("50000.00");
    private static final int MAX_FAILED_ATTEMPTS = 5;
    private static final int LOCK_MINUTES = 15;

    @Override
    public Optional<LoginResult> authenticate(int accountNo, String plainPassword) throws SQLException {
        User user = userDao.getDetails(accountNo);
        if (user == null) {
            return Optional.empty();
        }

        LocalDateTime now = LocalDateTime.now();

        // Account is within an active lock window — refuse even a correct password.
        if (user.lockedUntil() != null && now.isBefore(user.lockedUntil())) {
            log.warning("Login blocked: account " + accountNo + " locked until " + user.lockedUntil());
            return Optional.of(new LoginResult(false,
                    "Account temporarily locked due to failed attempts. Try again later.",
                    accountNo, null, null, null, null, null));
        }

        // A previously-expired lock resets the failure count for this attempt.
        boolean lockExpired = user.lockedUntil() != null && !now.isBefore(user.lockedUntil());
        int priorAttempts = lockExpired ? 0
                : (user.failedLoginAttempts() != null ? user.failedLoginAttempts() : 0);

        if (PasswordUtil.checkPassword(plainPassword, user.passwordHash())) {
            // Clear any prior failure state on successful login.
            if (priorAttempts > 0 || !"ACTIVE".equals(user.status())) {
                userDao.updateFailedLogins(user.email(), 0, null, "ACTIVE");
            }

            LoginResult result = new LoginResult(true, "Success", accountNo, user.firstName(),
                    user.lastName(), user.email(), user.role(), accountDao.getBalance(accountNo));

            String message = "New login to your account at " +
                    new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date());
            NotificationService.addNotification(accountNo, message, "INFO");
            return Optional.of(result);
        }

        // Wrong password — record the failure and lock once the threshold is hit.
        int attempts = priorAttempts + 1;
        LocalDateTime lockUntil = null;
        String status = "ACTIVE";
        if (attempts >= MAX_FAILED_ATTEMPTS) {
            lockUntil = now.plusMinutes(LOCK_MINUTES);
            status = "LOCKED";
            log.warning("Account " + accountNo + " locked after " + attempts + " failed login attempts.");
        }
        userDao.updateFailedLogins(user.email(), attempts, lockUntil, status);
        return Optional.empty();
    }

    @Override
    public boolean changePassword(int accountNo, String oldPlain, String newPlain) throws SQLException {
        return userDao.changePassword(accountNo, oldPlain, newPlain);
    }

    @Override
    public boolean processDeposit(int accountNo, BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }

        boolean success = accountDao.deposit(accountNo, amount);
        if (success) {
            transactionDao.logTransaction(null, accountNo, amount, "DEPOSIT", "Self Deposit", java.util.UUID.randomUUID().toString());
            String message = String.format("₹ %,.2f has been deposited to your account", amount);
            NotificationService.addNotification(accountNo, message, "DEPOSIT");
            log.info("Deposit successful for account: " + accountNo);
        }
        return success;
    }

    @Override
    public String withdraw(int accountNo, BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return "Invalid amount. Please enter amount greater than 0.";
        }

        BigDecimal currentBalance = accountDao.getBalance(accountNo);
        if (currentBalance == null || currentBalance.compareTo(amount) < 0) {
            return "Insufficient balance. Your current balance is ₹" + (currentBalance != null ? currentBalance : 0);
        }

        BigDecimal alreadyWithdrawn = transactionDao.getDailyWithdrawalTotal(accountNo);
        BigDecimal projectedTotal = alreadyWithdrawn.add(amount);

        if (projectedTotal.compareTo(DAILY_LIMIT) > 0) {
            BigDecimal remaining = DAILY_LIMIT.subtract(alreadyWithdrawn);
            return "Daily withdrawal limit exceeded. You can withdraw ₹" + remaining + " more today.";
        }

        boolean success = accountDao.withdraw(accountNo, amount);

        if (success) {
            transactionDao.logTransaction(accountNo, null, amount, "WITHDRAWAL", "ATM/Self Withdrawal", java.util.UUID.randomUUID().toString());
            String message = String.format("₹ %,.2f has been withdrawn from your account", amount);
            NotificationService.addNotification(accountNo, message, "WITHDRAWAL");
            log.info("Withdrawal successful: ₹" + amount + " from account " + accountNo);
            return "SUCCESS";
        } else {
            return "Transaction failed. Please try again.";
        }
    }

    @Override
    public Optional<LoginResult> registerUser(User user) {
        int accountNumber = ThreadLocalRandom.current().nextInt(10000000, 99999999);
        String secureHash = PasswordUtil.hashPassword(user.passwordHash());

        User secureUser = new User(
                user.userId(), user.firstName(), user.lastName(),
                user.aadhaarNo(), user.email(), secureHash, user.role(), user.phone(),
                user.dateOfBirth(), user.address(), user.panNo(), "ACTIVE",
                0, null, false, null, null,
                user.createdAt(), user.updatedAt()
        );

        boolean isSaved = userDao.registerUser(secureUser, accountNumber);

        if (isSaved) {
            sendWelcomeEmail(secureUser, accountNumber);

            String message = "Welcome to AceBank! Your account has been created successfully.";
            NotificationService.addNotification(accountNumber, message, "INFO");

            return Optional.of(new LoginResult(
                    true, "Success", accountNumber,
                    secureUser.firstName(),
                    secureUser.lastName(),
                    secureUser.email(),
                    secureUser.role(),
                    BigDecimal.ZERO
            ));
        }
        return Optional.empty();
    }

    @Override
    public boolean isEmailRegistered(String email) {
        return userDao.checkEmailExists(email);
    }

    @Override
    public boolean isAadhaarRegistered(String aadhaarNo) {
        return userDao.checkAadhaarExists(aadhaarNo);
    }

    private void sendWelcomeEmail(User user, int accNo) {
        String subject = "Welcome to AceBank";
        String msg = String.format("""
            Dear %s,
            
            Welcome to AceBank! Your account has been created successfully.
            
            Account Details:
            - Account Number: %d
            - Account Type: Savings
            - Opening Balance: ₹0.00
            
            Important Information:
            • Your account is now active
            • You can start depositing money immediately
            • For security, never share your password
            
            Keep this information safe.
            
            Best regards,
            The AceBank Team""",
                user.firstName(), accNo);
        try {
            MailUtil.sendMail(user.email(), subject, msg);
        } catch (Exception e) {
            log.warning("Email failed to send, but account was created.");
        }
    }

    @Override
    public BigDecimal getBalance(int accountNo) {
        return accountDao.getBalance(accountNo);
    }

    @Override
    public List<Transaction> getTransactionHistory(int accountNo) {
        return transactionDao.getTransactions(accountNo, 50, 0);
    }

    @Override
    public ServiceResponse<Void> processTransfer(int fromAcc, int toAcc, BigDecimal amount) {
        if (fromAcc == toAcc) {
            return ServiceResponse.error("You cannot transfer money to your own account.");
        }

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return ServiceResponse.error("Please enter a valid amount greater than zero.");
        }

        Account recipient = accountDao.getAccount(toAcc);
        if (recipient == null) {
            return ServiceResponse.error("Recipient account number " + toAcc + " not found.");
        }

        BigDecimal currentBalance = accountDao.getBalance(fromAcc);
        if (currentBalance == null || currentBalance.compareTo(amount) < 0) {
            return ServiceResponse.error("Insufficient balance. Your current balance is ₹" + (currentBalance != null ? currentBalance : 0));
        }

        // Debit + credit run in a single DB transaction (atomic, no partial state).
        boolean transferred = accountDao.transfer(fromAcc, toAcc, amount);
        if (transferred) {
            transactionDao.logTransaction(fromAcc, toAcc, amount, "TRANSFER", "Online Transfer", java.util.UUID.randomUUID().toString());

            String senderMessage = String.format("₹ %,.2f transferred to account XXXX%d",
                    amount, toAcc % 10000);
            NotificationService.addNotification(fromAcc, senderMessage, "TRANSFER");

            String recipientMessage = String.format("Received ₹ %,.2f from account XXXX%d",
                    amount, fromAcc % 10000);
            NotificationService.addNotification(toAcc, recipientMessage, "TRANSFER");

            log.info("Transfer Successful: ₹" + amount + " from " + fromAcc + " to " + toAcc);
            return ServiceResponse.success("Transfer Successful!");
        }

        return ServiceResponse.error("Transfer could not be processed. Please try again.");
    }

    @Override
    public boolean recoverAccount(String email) {
        try {
            log.info("Attempting to recover account for email: " + email);
            AccountRecoveryDTO details = userDao.getRecoveryDetails(email);

            if (details != null) {
                String subject = "AceBank - Account Recovery Request";
                String msg = String.format(
                        "Dear %s %s,\n\n" +
                                "We received a request to recover your AceBank account.\n\n" +
                                "Account Details:\n" +
                                "----------------\n" +
                                "Account Number: %d\n" +
                                "Account Holder: %s %s\n\n" +
                                "Next Steps:\n" +
                                "-----------\n" +
                                "1. If you forgot your password, please visit our website and use the 'Change Password' feature.\n" +
                                "2. For security reasons, we cannot email your password.\n" +
                                "3. If you didn't request this recovery, please contact our support immediately.\n\n" +
                                "Stay safe,\n" +
                                "The AceBank Security Team",
                        details.firstName(), details.lastName(),
                        details.accountNo(),
                        details.firstName(), details.lastName());

                boolean emailSent = MailUtil.sendMail(email, subject, msg);

                if (emailSent) {
                    log.info("Recovery email sent successfully to: " + email);
                    NotificationService.addNotification(details.accountNo(), "Account recovery email sent to " + email, "INFO");
                    return true;
                } else {
                    log.severe("Failed to send recovery email to: " + email);
                    return false;
                }
            } else {
                log.warning("No account found for email: " + email);
                return false;
            }
        } catch (Exception e) {
            log.severe("Error in recoverAccount for email: " + email + " - " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean applyForLoan(String firstName, String email, String loanType) {
        String subject = "Loan Application Received - AceBank";
        String body = String.format("""
            Dear %s,
            
            Thank you for applying for a %s loan with AceBank.
            
            Application Status: UNDER REVIEW
            Expected Response Time: 24-48 hours
            
            What happens next?
            1. Our loan officer will review your application
            2. You'll receive a call for verification
            3. Final decision will be communicated via email
            
            Required Documents (keep ready):
            • Identity Proof (Aadhar/PAN)
            • Address Proof
            • Income Documents
            • Bank Statements (last 6 months)
            
            We appreciate your interest in AceBank.
            
            Best regards,
            Loan Department
            AceBank""",
                firstName, loanType);

        try {
            MailUtil.sendMail(email, subject, body);
            // In full implementation, this should also log to LoanDao.
            return true;
        } catch (Exception e) {
            log.severe("Failed to send loan confirmation email: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Optional<AccountRecoveryDTO> getRecoveryDetails(String email) throws SQLException {
        AccountRecoveryDTO details = userDao.getRecoveryDetails(email);
        return details != null ? Optional.of(details) : Optional.empty();
    }

    @Override
    public AdminDashboardStats getAdminStats() {
        // Single round-trip: real top-line numbers for the admin overview.
        String sql = "SELECT " +
                "(SELECT COUNT(*) FROM USERS WHERE ROLE='CUSTOMER') AS totalUsers, " +
                "(SELECT COUNT(*) FROM ACCOUNTS) AS totalAccounts, " +
                "(SELECT COALESCE(SUM(BALANCE),0) FROM ACCOUNTS) AS totalDeposits, " +
                "(SELECT COALESCE(SUM(AMOUNT),0) FROM LOAN_APPLICATIONS WHERE STATUS='PENDING') AS totalLoans, " +
                "(SELECT COUNT(*) FROM COMPLAINTS WHERE STATUS IN ('OPEN','IN_PROGRESS')) AS pendingComplaints, " +
                "(SELECT COUNT(*) FROM KYC_DOCUMENTS WHERE STATUS='PENDING') AS pendingKYC";
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return new AdminDashboardStats(
                        rs.getInt("totalUsers"),
                        rs.getInt("totalAccounts"),
                        rs.getBigDecimal("totalDeposits"),
                        rs.getBigDecimal("totalLoans"),
                        rs.getInt("pendingComplaints"),
                        rs.getInt("pendingKYC"));
            }
        } catch (SQLException e) {
            log.severe("Error loading admin stats: " + e.getMessage());
        }
        return new AdminDashboardStats(0, 0, BigDecimal.ZERO, BigDecimal.ZERO, 0, 0);
    }

    @Override
    public java.util.List<AdminCustomerView> listCustomers() {
        java.util.List<AdminCustomerView> list = new java.util.ArrayList<>();
        String sql = com.acebank.lite.util.QueryLoader.get("admin.list_customers");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(new AdminCustomerView(
                        rs.getInt("USER_ID"),
                        rs.getString("FIRST_NAME"),
                        rs.getString("LAST_NAME"),
                        rs.getString("EMAIL"),
                        rs.getString("PHONE"),
                        rs.getString("STATUS"),
                        rs.getTimestamp("CREATED_AT") != null ? rs.getTimestamp("CREATED_AT").toLocalDateTime() : null,
                        rs.getInt("ACCOUNT_NO"),
                        rs.getBigDecimal("BALANCE"),
                        rs.getString("ACC_STATUS")));
            }
        } catch (SQLException e) {
            log.severe("Error listing customers: " + e.getMessage());
        }
        return list;
    }

    @Override
    public java.util.List<Transaction> getRecentTransactions(int limit) {
        java.util.List<Transaction> list = new java.util.ArrayList<>();
        String sql = com.acebank.lite.util.QueryLoader.get("admin.recent_transactions");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new Transaction(
                            rs.getInt("ID"),
                            rs.getObject("SENDER_ACCOUNT") != null ? rs.getInt("SENDER_ACCOUNT") : null,
                            rs.getObject("RECEIVER_ACCOUNT") != null ? rs.getInt("RECEIVER_ACCOUNT") : null,
                            rs.getBigDecimal("AMOUNT"),
                            rs.getString("TX_TYPE"),
                            null,
                            rs.getString("STATUS"),
                            rs.getString("REFERENCE_NO"),
                            rs.getTimestamp("CREATED_AT") != null ? rs.getTimestamp("CREATED_AT").toLocalDateTime() : null));
                }
            }
        } catch (SQLException e) {
            log.severe("Error loading recent transactions: " + e.getMessage());
        }
        return list;
    }

    @Override
    public java.util.List<AdminLoanView> listLoanApplications() {
        java.util.List<AdminLoanView> list = new java.util.ArrayList<>();
        String sql = com.acebank.lite.util.QueryLoader.get("admin.list_loans");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String name = (rs.getString("FIRST_NAME") + " " + rs.getString("LAST_NAME")).trim();
                list.add(new AdminLoanView(
                        rs.getInt("ID"),
                        rs.getInt("ACCOUNT_NO"),
                        name,
                        rs.getString("EMAIL"),
                        rs.getString("LOAN_TYPE"),
                        rs.getBigDecimal("AMOUNT"),
                        rs.getInt("TENURE"),
                        rs.getString("PURPOSE"),
                        rs.getString("STATUS"),
                        rs.getTimestamp("APPLIED_AT") != null ? rs.getTimestamp("APPLIED_AT").toLocalDateTime() : null));
            }
        } catch (SQLException e) {
            log.severe("Error listing loan applications: " + e.getMessage());
        }
        return list;
    }

    @Override
    public boolean reviewLoan(int loanId, String decision, int reviewerAccountNo) {
        // Only allow the two valid terminal states.
        if (!"APPROVED".equals(decision) && !"REJECTED".equals(decision)) {
            return false;
        }
        String sql = com.acebank.lite.util.QueryLoader.get("admin.update_loan_status");
        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, decision);
            stmt.setInt(2, reviewerAccountNo);
            stmt.setInt(3, loanId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            log.severe("Error reviewing loan " + loanId + ": " + e.getMessage());
        }
        return false;
    }
}