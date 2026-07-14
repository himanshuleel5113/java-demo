-- ============================================================
-- AceBank — secure core schema (idempotent, non-destructive)
-- Runs on startup: CREATE TABLE IF NOT EXISTS only, never drops.
-- ============================================================

CREATE TABLE IF NOT EXISTS users (
    id                    INT AUTO_INCREMENT PRIMARY KEY,
    first_name            VARCHAR(80)  NOT NULL,
    last_name             VARCHAR(80)  NOT NULL,
    email                 VARCHAR(190) NOT NULL UNIQUE,
    phone                 VARCHAR(20),
    password_hash         VARCHAR(72)  NOT NULL,          -- BCrypt hash
    role                  ENUM('CUSTOMER','ADMIN') NOT NULL DEFAULT 'CUSTOMER',
    status                ENUM('ACTIVE','LOCKED','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    failed_login_attempts INT NOT NULL DEFAULT 0,
    locked_until          TIMESTAMP NULL,
    created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_users_email (email)
);

CREATE TABLE IF NOT EXISTS accounts (
    account_no   BIGINT PRIMARY KEY,
    user_id      INT NOT NULL,
    account_type ENUM('SAVINGS','CURRENT') NOT NULL DEFAULT 'SAVINGS',
    balance      DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    status       ENUM('ACTIVE','BLOCKED','CLOSED') NOT NULL DEFAULT 'ACTIVE',
    version      INT NOT NULL DEFAULT 0,                  -- optimistic lock
    created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_accounts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_accounts_user (user_id)
);

CREATE TABLE IF NOT EXISTS transactions (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    sender_account   BIGINT NULL,
    receiver_account BIGINT NULL,
    amount           DECIMAL(18,2) NOT NULL,
    tx_type          ENUM('TRANSFER','DEPOSIT','WITHDRAWAL') NOT NULL,
    status           ENUM('COMPLETED','FAILED') NOT NULL DEFAULT 'COMPLETED',
    remark           VARCHAR(255),
    reference_no     VARCHAR(40),
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tx_sender   FOREIGN KEY (sender_account)   REFERENCES accounts(account_no),
    CONSTRAINT fk_tx_receiver FOREIGN KEY (receiver_account) REFERENCES accounts(account_no),
    INDEX idx_tx_sender (sender_account),
    INDEX idx_tx_receiver (receiver_account),
    INDEX idx_tx_created (created_at)
);

-- Cards issued against an account (holder name is derived from the owner user)
CREATE TABLE IF NOT EXISTS cards (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_no    BIGINT NOT NULL,
    card_type     ENUM('DEBIT','CREDIT') NOT NULL DEFAULT 'DEBIT',
    network       ENUM('VISA','MASTERCARD') NOT NULL DEFAULT 'VISA',
    last4         CHAR(4) NOT NULL,
    expiry        CHAR(5) NOT NULL,                 -- MM/YY
    status        ENUM('ACTIVE','BLOCKED') NOT NULL DEFAULT 'ACTIVE',
    daily_limit   DECIMAL(18,2) NOT NULL DEFAULT 100000.00,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cards_account FOREIGN KEY (account_no) REFERENCES accounts(account_no) ON DELETE CASCADE,
    INDEX idx_cards_account (account_no)
);

-- Brute-force tracking (per IP + account)
CREATE TABLE IF NOT EXISTS login_attempts (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    email       VARCHAR(190),
    ip_address  VARCHAR(45) NOT NULL,
    success     BOOLEAN NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_login_ip (ip_address),
    INDEX idx_login_created (created_at)
);

-- Immutable audit trail for sensitive actions
CREATE TABLE IF NOT EXISTS audit_log (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NULL,
    action      VARCHAR(80) NOT NULL,
    details     VARCHAR(500),
    ip_address  VARCHAR(45),
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_audit_user (user_id),
    INDEX idx_audit_created (created_at)
);

-- Loans held by a customer (EMI amortised; outstanding falls as EMIs are paid)
CREATE TABLE IF NOT EXISTS loans (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id        INT NOT NULL,
    account_no     BIGINT NOT NULL,
    loan_ref       VARCHAR(24) NOT NULL UNIQUE,
    loan_type      ENUM('HOME','CAR','PERSONAL','EDUCATION') NOT NULL DEFAULT 'PERSONAL',
    principal      DECIMAL(18,2) NOT NULL,
    outstanding    DECIMAL(18,2) NOT NULL,
    interest_rate  DECIMAL(5,2) NOT NULL,
    tenure_months  INT NOT NULL,
    emi_amount     DECIMAL(18,2) NOT NULL,
    next_due_date  DATE NULL,
    status         ENUM('ACTIVE','CLOSED') NOT NULL DEFAULT 'ACTIVE',
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_loans_user    FOREIGN KEY (user_id)    REFERENCES users(id)           ON DELETE CASCADE,
    CONSTRAINT fk_loans_account FOREIGN KEY (account_no) REFERENCES accounts(account_no) ON DELETE CASCADE,
    INDEX idx_loans_user (user_id)
);

-- Bill payments (each successful payment also books a WITHDRAWAL transaction)
CREATE TABLE IF NOT EXISTS bill_payments (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    account_no    BIGINT NOT NULL,
    category      VARCHAR(40) NOT NULL,
    biller        VARCHAR(120) NOT NULL,
    consumer_no   VARCHAR(60) NOT NULL,
    nickname      VARCHAR(120) NULL,
    amount        DECIMAL(18,2) NOT NULL,
    status        ENUM('SUCCESS','FAILED') NOT NULL DEFAULT 'SUCCESS',
    reference_no  VARCHAR(40),
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bills_user    FOREIGN KEY (user_id)    REFERENCES users(id)           ON DELETE CASCADE,
    CONSTRAINT fk_bills_account FOREIGN KEY (account_no) REFERENCES accounts(account_no) ON DELETE CASCADE,
    INDEX idx_bills_user (user_id),
    INDEX idx_bills_created (created_at)
);

-- Customer support tickets (raised from Help & Support)
CREATE TABLE IF NOT EXISTS service_requests (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    ticket_no     VARCHAR(24) NOT NULL UNIQUE,
    subject       VARCHAR(160) NOT NULL,
    category      ENUM('Transactions','Accounts','Cards','Profile','Other') NOT NULL DEFAULT 'Other',
    message       VARCHAR(1000),
    status        ENUM('IN_PROGRESS','RESOLVED','CLOSED') NOT NULL DEFAULT 'IN_PROGRESS',
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sr_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_sr_user (user_id)
);

-- Seed users/accounts are created in Java (DataSeeder) with runtime-computed
-- BCrypt hashes, so the demo credentials are always valid:
--   admin@acebank.com / Admin@123   (ADMIN,    account 10000001)
--   demo@acebank.com  / Demo@1234   (CUSTOMER, account 20000001)
