package com.acebank.web;

import com.acebank.model.User;
import com.acebank.security.CsrfTokens;
import com.acebank.security.SessionKeys;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/** Small helpers shared by servlets. */
public final class WebUtil {

    private WebUtil() {}

    /** Best-effort client IP, honouring a single proxy hop. */
    public static String clientIp(HttpServletRequest req) {
        String xff = req.getHeader("X-Forwarded-For");
        if (xff != null && !xff.isBlank()) return xff.split(",")[0].trim();
        return req.getRemoteAddr();
    }

    /**
     * Establishes an authenticated session. A brand-new session is created
     * (old one invalidated) to defeat session-fixation attacks.
     */
    public static void establishSession(HttpServletRequest req, User user, long accountNo) {
        HttpSession old = req.getSession(false);
        if (old != null) old.invalidate();
        HttpSession s = req.getSession(true);
        s.setAttribute(SessionKeys.USER_ID, user.id());
        s.setAttribute(SessionKeys.USER_NAME, user.fullName());
        s.setAttribute(SessionKeys.USER_EMAIL, user.email());
        s.setAttribute(SessionKeys.ROLE, user.role());
        s.setAttribute(SessionKeys.ACCOUNT_NO, accountNo);
        s.setAttribute(SessionKeys.FIRST_NAME, user.firstName());
        s.setAttribute(SessionKeys.INITIALS, initials(user));
        // Seed a CSRF token immediately so the new (post-login) session's forms
        // carry a valid token — otherwise the first state-changing POST would 403.
        CsrfTokens.get(s);
    }

    private static String initials(User user) {
        String f = user.firstName() == null || user.firstName().isBlank() ? "" : user.firstName().substring(0, 1);
        String l = user.lastName()  == null || user.lastName().isBlank()  ? "" : user.lastName().substring(0, 1);
        String i = (f + l).toUpperCase();
        return i.isBlank() ? "U" : i;
    }
}
