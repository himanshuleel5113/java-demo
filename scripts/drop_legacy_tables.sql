-- ============================================================
-- OPTIONAL one-time cleanup: drops the legacy (com.acebank.lite)
-- UPPERCASE tables from a database that hosted the old app.
--
-- !! DESTRUCTIVE — deletes all old demo data. Run manually in
-- !! your DB console only if the new deploy logs show
-- !! "Unknown column" errors (case-insensitive MySQL reused the
-- !! old tables). On case-sensitive servers this is not needed;
-- !! the new app creates its own lowercase tables alongside.
--
-- The new app recreates its schema automatically on next boot.
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS KYC_DOCUMENTS;
DROP TABLE IF EXISTS COMPLAINTS;
DROP TABLE IF EXISTS BILL_PAYMENTS;
DROP TABLE IF EXISTS RECURRING_DEPOSITS;
DROP TABLE IF EXISTS FIXED_DEPOSITS;
DROP TABLE IF EXISTS CARD_REQUESTS;
DROP TABLE IF EXISTS SCHEDULED_TRANSFERS;
DROP TABLE IF EXISTS BENEFICIARIES;
DROP TABLE IF EXISTS OTP_STORE;
DROP TABLE IF EXISTS NOTIFICATIONS;
DROP TABLE IF EXISTS TRANSACTIONS;
DROP TABLE IF EXISTS LOAN_APPLICATIONS;
DROP TABLE IF EXISTS LOGIN_ATTEMPTS;
DROP TABLE IF EXISTS AUDIT_LOG;
DROP TABLE IF EXISTS ACCOUNTS;
DROP TABLE IF EXISTS USERS;
SET FOREIGN_KEY_CHECKS = 1;
