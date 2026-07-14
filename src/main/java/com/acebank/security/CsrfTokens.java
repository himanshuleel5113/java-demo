package com.acebank.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.security.SecureRandom;
import java.util.Base64;

/**
 * Synchronizer-token-pattern CSRF protection. A random token is bound to the
 * session and must accompany every state-changing (POST) request.
 */
public final class CsrfTokens {

    public static final String SESSION_ATTR = "csrfToken";
    public static final String FIELD = "_csrf";
    private static final SecureRandom RNG = new SecureRandom();

    private CsrfTokens() {}

    /** Returns the session's token, generating one on first use. */
    public static String get(HttpSession session) {
        String token = (String) session.getAttribute(SESSION_ATTR);
        if (token == null) {
            byte[] buf = new byte[32];
            RNG.nextBytes(buf);
            token = Base64.getUrlEncoder().withoutPadding().encodeToString(buf);
            session.setAttribute(SESSION_ATTR, token);
        }
        return token;
    }

    /** Constant-time comparison of the submitted token against the session token. */
    public static boolean isValid(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        String expected = (String) session.getAttribute(SESSION_ATTR);
        String actual = req.getParameter(FIELD);
        if (expected == null || actual == null) return false;
        return constantTimeEquals(expected, actual);
    }

    private static boolean constantTimeEquals(String a, String b) {
        if (a.length() != b.length()) return false;
        int r = 0;
        for (int i = 0; i < a.length(); i++) r |= a.charAt(i) ^ b.charAt(i);
        return r == 0;
    }
}
