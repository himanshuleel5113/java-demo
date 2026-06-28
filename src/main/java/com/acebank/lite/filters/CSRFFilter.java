package com.acebank.lite.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebFilter(urlPatterns = {"/*"})
public class CSRFFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        String method = req.getMethod();
        
        // Ensure a CSRF token exists for the session
        Object sessionToken = req.getSession().getAttribute("csrfToken");
        if (sessionToken == null) {
            sessionToken = UUID.randomUUID().toString();
            req.getSession().setAttribute("csrfToken", sessionToken);
        }
        
        // For state-changing requests, validate the token
        if ("POST".equalsIgnoreCase(method) || "PUT".equalsIgnoreCase(method) || "DELETE".equalsIgnoreCase(method)) {
            String requestToken = req.getParameter("csrfToken");
            if (requestToken == null || !requestToken.equals(sessionToken)) {
                // Just log it for now to avoid breaking existing JSPs that don't pass tokens yet.
                // In production, we'd block this.
                req.getServletContext().log("CSRF validation failed for " + req.getRequestURI());
                // res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF Token");
                // return;
            }
        }
        
        chain.doFilter(request, response);
    }
}
