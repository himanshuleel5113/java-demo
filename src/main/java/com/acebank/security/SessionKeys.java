package com.acebank.security;

/** Names of attributes stored on the authenticated HttpSession. */
public final class SessionKeys {
    public static final String USER_ID     = "userId";
    public static final String USER_NAME   = "userName";
    public static final String USER_EMAIL  = "userEmail";
    public static final String ROLE        = "role";
    public static final String ACCOUNT_NO  = "accountNo";
    public static final String INITIALS    = "initials";
    public static final String FIRST_NAME  = "firstName";
    private SessionKeys() {}
}
