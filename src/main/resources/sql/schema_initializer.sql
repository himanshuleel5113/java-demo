-- ============================================================
-- AceBank Lite v2.0 — Full Schema Initializer (idempotent, NON-destructive)
-- ============================================================
-- This script is safe to run on every application startup:
--   * It only CREATEs tables that do not already exist (CREATE TABLE IF NOT EXISTS).
--   * It NEVER drops tables, so existing customer data is preserved across restarts.
-- To perform a clean reset (drop + recreate), do the DROPs manually first
-- (see README) and then run this script.

-- NOTE: No "CREATE DATABASE / USE himdata" here on purpose. The target database is
-- whatever the JDBC URL connects to (e.g. jdbc:mysql://host:3306/<db>). On managed
-- cloud MySQL (Railway, Aiven, Clever Cloud, ...) the DB name is fixed and you often
-- lack CREATE DATABASE rights; forcing "USE himdata" would create the tables in the
-- wrong schema and the app would then find no tables. Staying in the connected DB
-- keeps this portable across local and cloud deployments.

-- ============================================================
-- 1. USERS
-- ============================================================
CREATE TABLE IF NOT EXISTS USERS (
    USER_ID         INT AUTO_INCREMENT PRIMARY KEY,
    FIRST_NAME      VARCHAR(255) NOT NULL,
    LAST_NAME       VARCHAR(255) NOT NULL,
    AADHAAR_NO      VARCHAR(12) UNIQUE NOT NULL,
    EMAIL           VARCHAR(255) UNIQUE NOT NULL,
    PASSWORD_HASH   VARCHAR(255) NOT NULL,
    ROLE            ENUM('CUSTOMER', 'ADMIN') DEFAULT 'CUSTOMER',
    PHONE           VARCHAR(15),
    DATE_OF_BIRTH   DATE,
    ADDRESS         TEXT,
    PAN_NO          VARCHAR(10),
    STATUS          ENUM('ACTIVE', 'LOCKED', 'SUSPENDED') DEFAULT 'ACTIVE',
    FAILED_LOGIN_ATTEMPTS INT DEFAULT 0,
    LOCKED_UNTIL    TIMESTAMP NULL,
    TWO_FA_ENABLED  BOOLEAN DEFAULT FALSE,
    TWO_FA_SECRET   VARCHAR(64),
    PROFILE_PHOTO   VARCHAR(512),
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_users_email (EMAIL),
    INDEX idx_users_status (STATUS),
    INDEX idx_users_role (ROLE)
);

-- ============================================================
-- 2. ACCOUNTS
-- ============================================================
CREATE TABLE IF NOT EXISTS ACCOUNTS (
    ACCOUNT_NO      INT PRIMARY KEY,
    USER_ID         INT NOT NULL,
    ACCOUNT_TYPE    ENUM('SAVINGS', 'CHECKING', 'LOAN') DEFAULT 'SAVINGS',
    BALANCE         DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    STATUS          ENUM('ACTIVE', 'BLOCKED', 'CLOSED') DEFAULT 'ACTIVE',
    VERSION         INT DEFAULT 0,
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
    INDEX idx_accounts_user (USER_ID),
    INDEX idx_accounts_status (STATUS)
);

-- ============================================================
-- 3. LOAN_APPLICATIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS LOAN_APPLICATIONS (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    ACCOUNT_NO      INT NOT NULL,
    LOAN_TYPE       VARCHAR(50) NOT NULL,
    AMOUNT          DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    TENURE          INT NOT NULL DEFAULT 1,
    PURPOSE         TEXT,
    STATUS          ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    REVIEWED_BY     INT,
    REVIEW_NOTES    TEXT,
    APPLIED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    REVIEWED_AT     TIMESTAMP NULL,
    FOREIGN KEY (ACCOUNT_NO) REFERENCES ACCOUNTS(ACCOUNT_NO) ON DELETE CASCADE,
    FOREIGN KEY (REVIEWED_BY) REFERENCES USERS(USER_ID),
    INDEX idx_loan_account (ACCOUNT_NO),
    INDEX idx_loan_status (STATUS)
);

-- ============================================================
-- 4. TRANSACTIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS TRANSACTIONS (
    ID               INT AUTO_INCREMENT PRIMARY KEY,
    SENDER_ACCOUNT   INT NULL,
    RECEIVER_ACCOUNT INT NULL,
    AMOUNT           DECIMAL(15, 2) NOT NULL,
    TX_TYPE          ENUM('TRANSFER', 'DEPOSIT', 'WITHDRAWAL') NOT NULL,
    REMARK           VARCHAR(255),
    STATUS           ENUM('COMPLETED', 'PENDING', 'FAILED') DEFAULT 'COMPLETED',
    REFERENCE_NO     VARCHAR(36),
    CREATED_AT       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SENDER_ACCOUNT) REFERENCES ACCOUNTS(ACCOUNT_NO),
    FOREIGN KEY (RECEIVER_ACCOUNT) REFERENCES ACCOUNTS(ACCOUNT_NO),
    INDEX idx_tx_sender (SENDER_ACCOUNT),
    INDEX idx_tx_receiver (RECEIVER_ACCOUNT),
    INDEX idx_tx_type (TX_TYPE),
    INDEX idx_tx_created (CREATED_AT),
    INDEX idx_tx_reference (REFERENCE_NO)
);

-- ============================================================
-- 5. NOTIFICATIONS (persistent — replaces in-memory store)
-- ============================================================
CREATE TABLE IF NOT EXISTS NOTIFICATIONS (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    ACCOUNT_NO      INT NOT NULL,
    MESSAGE         TEXT NOT NULL,
    TYPE            VARCHAR(30) NOT NULL DEFAULT 'INFO',
    IS_READ         BOOLEAN DEFAULT FALSE,
    ICON            VARCHAR(100),
    ACTION_LINK     VARCHAR(255),
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ACCOUNT_NO) REFERENCES ACCOUNTS(ACCOUNT_NO) ON DELETE CASCADE,
    INDEX idx_notif_account (ACCOUNT_NO),
    INDEX idx_notif_read (IS_READ),
    INDEX idx_notif_created (CREATED_AT)
);

-- ============================================================
-- 6. OTP_STORE (persistent — replaces in-memory store)
-- ============================================================
CREATE TABLE IF NOT EXISTS OTP_STORE (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    EMAIL           VARCHAR(255) NOT NULL,
    OTP_HASH        VARCHAR(255) NOT NULL,
    ACCOUNT_NO      INT,
    PURPOSE         ENUM('PASSWORD_RESET', 'LOGIN_2FA', 'TRANSACTION') DEFAULT 'PASSWORD_RESET',
    EXPIRES_AT      TIMESTAMP NOT NULL,
    VERIFIED        BOOLEAN DEFAULT FALSE,
    ATTEMPTS        INT DEFAULT 0,
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_otp_email (EMAIL),
    INDEX idx_otp_expires (EXPIRES_AT)
);

-- ============================================================
-- 7. BENEFICIARIES
-- ============================================================
CREATE TABLE IF NOT EXISTS BENEFICIARIES (
    ID                  INT AUTO_INCREMENT PRIMARY KEY,
    OWNER_ACCOUNT       INT NOT NULL,
    BENEFICIARY_ACCOUNT INT NOT NULL,
    BENEFICIARY_NAME    VARCHAR(255) NOT NULL,
    BANK_NAME           VARCHAR(255) DEFAULT 'AceBank',
    IFSC_CODE           VARCHAR(11) DEFAULT 'ACEB0000001',
    NICKNAME            VARCHAR(100),
    IS_ACTIVE           BOOLEAN DEFAULT TRUE,
    CREATED_AT          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OWNER_ACCOUNT) REFERENCES ACCOUNTS(ACCOUNT_NO) ON DELETE CASCADE,
    UNIQUE KEY uk_beneficiary (OWNER_ACCOUNT, BENEFICIARY_ACCOUNT),
    INDEX idx_benef_owner (OWNER_ACCOUNT)
);

-- ============================================================
-- 8. SCHEDULED_TRANSFERS
-- ============================================================
CREATE TABLE IF NOT EXISTS SCHEDULED_TRANSFERS (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    FROM_ACCOUNT    INT NOT NULL,
    TO_ACCOUNT      INT NOT NULL,
    AMOUNT          DECIMAL(15, 2) NOT NULL,
    SCHEDULE_TYPE   ENUM('ONE_TIME', 'DAILY', 'WEEKLY', 'MONTHLY') NOT NULL,
    NEXT_EXECUTION  TIMESTAMP NOT NULL,
    LAST_EXECUTED   TIMESTAMP NULL,
    STATUS          ENUM('ACTIVE', 'PAUSED', 'COMPLETED', 'FAILED') DEFAULT 'ACTIVE',
    REMARK          VARCHAR(255),
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (FROM_ACCOUNT) REFERENCES ACCOUNTS(ACCOUNT_NO) ON DELETE CASCADE,
    FOREIGN KEY (TO_ACCOUNT) REFERENCES ACCOUNTS(ACCOUNT_NO),
    INDEX idx_sched_from (FROM_ACCOUNT),
    INDEX idx_sched_next (NEXT_EXECUTION),
    INDEX idx_sched_status (STATUS)
);

-- ============================================================
-- 9. CARD_REQUESTS
-- ============================================================
CREATE TABLE IF NOT EXISTS CARD_REQUESTS (
    ID                  INT AUTO_INCREMENT PRIMARY KEY,
    ACCOUNT_NO          INT NOT NULL,
    CARD_TYPE           ENUM('DEBIT', 'CREDIT', 'ATM') NOT NULL,
    REQUEST_TYPE        ENUM('NEW', 'REPLACEMENT', 'BLOCK', 'UNBLOCK') NOT NULL,
    STATUS              ENUM('PENDING', 'APPROVED', 'REJECTED', 'ISSUED', 'BLOCKED') DEFAULT 'PENDING',
    CARD_NUMBER_MASKED  VARCHAR(19),
    IS_BLOCKED          BOOLEAN DEFAULT FALSE,
    REASON              TEXT,
    REVIEWED_BY         INT,
    CREATED_AT          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ACCOUNT_NO) REFERENCES ACCOUNTS(ACCOUNT_NO) ON DELETE CASCADE,
    FOREIGN KEY (REVIEWED_BY) REFERENCES USERS(USER_ID),
    INDEX idx_card_account (ACCOUNT_NO),
    INDEX idx_card_status (STATUS)
);

-- ============================================================
-- 10. FIXED_DEPOSITS
-- ============================================================
CREATE TABLE IF NOT EXISTS FIXED_DEPOSITS (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    ACCOUNT_NO      INT NOT NULL,
    AMOUNT          DECIMAL(15, 2) NOT NULL,
    INTEREST_RATE   DECIMAL(5, 2) NOT NULL,
    TENURE_MONTHS   INT NOT NULL,
    MATURITY_DATE   DATE NOT NULL,
    MATURITY_AMOUNT DECIMAL(15, 2) NOT NULL,
    STATUS          ENUM('ACTIVE', 'MATURED', 'CLOSED', 'PREMATURE_CLOSED') DEFAULT 'ACTIVE',
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ACCOUNT_NO) REFERENCES ACCOUNTS(ACCOUNT_NO) ON DELETE CASCADE,
    INDEX idx_fd_account (ACCOUNT_NO),
    INDEX idx_fd_status (STATUS),
    INDEX idx_fd_maturity (MATURITY_DATE)
);

-- ============================================================
-- 11. RECURRING_DEPOSITS
-- ============================================================
CREATE TABLE IF NOT EXISTS RECURRING_DEPOSITS (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    ACCOUNT_NO      INT NOT NULL,
    MONTHLY_AMOUNT  DECIMAL(15, 2) NOT NULL,
    INTEREST_RATE   DECIMAL(5, 2) NOT NULL,
    TENURE_MONTHS   INT NOT NULL,
    TOTAL_DEPOSITED DECIMAL(15, 2) DEFAULT 0.00,
    MATURITY_AMOUNT DECIMAL(15, 2) NOT NULL,
    STATUS          ENUM('ACTIVE', 'MATURED', 'CLOSED') DEFAULT 'ACTIVE',
    NEXT_DEBIT_DATE DATE NOT NULL,
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ACCOUNT_NO) REFERENCES ACCOUNTS(ACCOUNT_NO) ON DELETE CASCADE,
    INDEX idx_rd_account (ACCOUNT_NO),
    INDEX idx_rd_status (STATUS)
);

-- ============================================================
-- 12. BILL_PAYMENTS
-- ============================================================
CREATE TABLE IF NOT EXISTS BILL_PAYMENTS (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    ACCOUNT_NO      INT NOT NULL,
    BILLER_NAME     VARCHAR(255) NOT NULL,
    BILLER_CATEGORY ENUM('ELECTRICITY', 'WATER', 'GAS', 'INTERNET', 'MOBILE', 'DTH', 'INSURANCE', 'OTHER') NOT NULL,
    AMOUNT          DECIMAL(15, 2) NOT NULL,
    REFERENCE_NO    VARCHAR(36),
    CONSUMER_NO     VARCHAR(50),
    STATUS          ENUM('COMPLETED', 'PENDING', 'FAILED') DEFAULT 'COMPLETED',
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ACCOUNT_NO) REFERENCES ACCOUNTS(ACCOUNT_NO) ON DELETE CASCADE,
    INDEX idx_bill_account (ACCOUNT_NO),
    INDEX idx_bill_category (BILLER_CATEGORY)
);

-- ============================================================
-- 13. COMPLAINTS
-- ============================================================
CREATE TABLE IF NOT EXISTS COMPLAINTS (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    ACCOUNT_NO      INT NOT NULL,
    TICKET_NO       VARCHAR(20) UNIQUE NOT NULL,
    SUBJECT         VARCHAR(255) NOT NULL,
    DESCRIPTION     TEXT NOT NULL,
    CATEGORY        ENUM('TRANSACTION', 'ACCOUNT', 'CARD', 'LOAN', 'TECHNICAL', 'OTHER') NOT NULL,
    STATUS          ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') DEFAULT 'OPEN',
    PRIORITY        ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') DEFAULT 'MEDIUM',
    RESOLUTION      TEXT,
    ASSIGNED_TO     INT,
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ACCOUNT_NO) REFERENCES ACCOUNTS(ACCOUNT_NO) ON DELETE CASCADE,
    FOREIGN KEY (ASSIGNED_TO) REFERENCES USERS(USER_ID),
    INDEX idx_complaint_account (ACCOUNT_NO),
    INDEX idx_complaint_status (STATUS),
    INDEX idx_complaint_ticket (TICKET_NO)
);

-- ============================================================
-- 14. AUDIT_LOG
-- ============================================================
CREATE TABLE IF NOT EXISTS AUDIT_LOG (
    ID              BIGINT AUTO_INCREMENT PRIMARY KEY,
    ACCOUNT_NO      INT,
    USER_ID         INT,
    ACTION          VARCHAR(100) NOT NULL,
    DETAILS         TEXT,
    IP_ADDRESS      VARCHAR(45),
    USER_AGENT      VARCHAR(512),
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_audit_account (ACCOUNT_NO),
    INDEX idx_audit_user (USER_ID),
    INDEX idx_audit_action (ACTION),
    INDEX idx_audit_created (CREATED_AT)
);

-- ============================================================
-- 15. KYC_DOCUMENTS
-- ============================================================
CREATE TABLE IF NOT EXISTS KYC_DOCUMENTS (
    ID              INT AUTO_INCREMENT PRIMARY KEY,
    ACCOUNT_NO      INT NOT NULL,
    DOCUMENT_TYPE   ENUM('AADHAAR', 'PAN', 'PASSPORT', 'VOTER_ID', 'DRIVING_LICENSE', 'ADDRESS_PROOF', 'PHOTO') NOT NULL,
    FILE_NAME       VARCHAR(255) NOT NULL,
    FILE_PATH       VARCHAR(512) NOT NULL,
    FILE_SIZE       BIGINT,
    MIME_TYPE       VARCHAR(100),
    STATUS          ENUM('PENDING', 'VERIFIED', 'REJECTED') DEFAULT 'PENDING',
    VERIFIED_BY     INT,
    REJECTION_REASON TEXT,
    VERIFIED_AT     TIMESTAMP NULL,
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ACCOUNT_NO) REFERENCES ACCOUNTS(ACCOUNT_NO) ON DELETE CASCADE,
    FOREIGN KEY (VERIFIED_BY) REFERENCES USERS(USER_ID),
    INDEX idx_kyc_account (ACCOUNT_NO),
    INDEX idx_kyc_status (STATUS)
);

-- ============================================================
-- 16. LOGIN_ATTEMPTS
-- ============================================================
CREATE TABLE IF NOT EXISTS LOGIN_ATTEMPTS (
    ID              BIGINT AUTO_INCREMENT PRIMARY KEY,
    ACCOUNT_NO      INT,
    IP_ADDRESS      VARCHAR(45) NOT NULL,
    SUCCESS         BOOLEAN NOT NULL,
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_login_account (ACCOUNT_NO),
    INDEX idx_login_ip (IP_ADDRESS),
    INDEX idx_login_created (CREATED_AT)
);

-- ============================================================
-- Seed: default admin user
--   Login account number : 10000001
--   Password             : Admin@123   (BCrypt hash below, verified against jbcrypt)
-- ------------------------------------------------------------
-- ENABLED so a fresh cloud deployment has a working admin to log in with.
-- The WHERE NOT EXISTS guards make both inserts safe to run on every startup.
-- Change the password from the app after first login.
-- ============================================================
INSERT INTO USERS (FIRST_NAME, LAST_NAME, AADHAAR_NO, EMAIL, PASSWORD_HASH, ROLE, PHONE, STATUS)
SELECT 'Admin', 'AceBank', '000000000000', 'admin@acebank.com',
       '$2a$12$5VtGBJuV.BF.oSdgdc9Aweu/HfX0SKHYnIfUk5ayIxRqQ77cqzeEe',
       'ADMIN', '+919999999999', 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM USERS WHERE EMAIL = 'admin@acebank.com');

INSERT INTO ACCOUNTS (ACCOUNT_NO, USER_ID, ACCOUNT_TYPE, BALANCE, STATUS)
SELECT 10000001, (SELECT USER_ID FROM USERS WHERE EMAIL = 'admin@acebank.com'), 'SAVINGS', 1000000.00, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM ACCOUNTS WHERE ACCOUNT_NO = 10000001);
