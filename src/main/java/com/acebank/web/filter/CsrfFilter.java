package com.acebank.web.filter;

import com.acebank.security.CsrfTokens;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Rejects any POST/PUT/DELETE that doesn't carry a valid CSRF token matching
 * the one bound to the session. Safe (idempotent) methods pass through.
 */
@WebFilter(urlPatterns = "/*")
public class CsrfFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String method = request.getMethod();
        boolean mutating = "POST".equals(method) || "PUT".equals(method) || "DELETE".equals(method);

        if (mutating && !CsrfTokens.isValid(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
            return;
        }
        chain.doFilter(req, res);
    }
}
