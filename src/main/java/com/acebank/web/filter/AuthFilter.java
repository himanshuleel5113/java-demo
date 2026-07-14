package com.acebank.web.filter;

import com.acebank.security.SessionKeys;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

/**
 * Gate for authenticated areas. Any request under the app routes requires a
 * valid session; admin routes additionally require the ADMIN role. Unauthorised
 * users are redirected to login (or 403 for role violations).
 */
@WebFilter(urlPatterns = {
        "/dashboard", "/accounts", "/transfer", "/deposit", "/withdraw",
        "/bills", "/cards", "/transactions", "/loans", "/services",
        "/profile", "/settings", "/help", "/admin/*"
})
public class AuthFilter implements Filter {

    private static final Set<String> ADMIN_PREFIX = Set.of("/admin");

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        boolean loggedIn = session != null && session.getAttribute(SessionKeys.USER_ID) != null;

        if (!loggedIn) {
            response.sendRedirect(request.getContextPath() + "/login?next="
                    + request.getServletPath());
            return;
        }

        String path = request.getServletPath();
        if (path.startsWith("/admin")) {
            Object role = session.getAttribute(SessionKeys.ROLE);
            if (!"ADMIN".equals(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admins only");
                return;
            }
        }
        chain.doFilter(req, res);
    }
}
