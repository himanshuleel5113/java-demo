package com.acebank.web.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Applies hardening headers to every response. Registered site-wide so even
 * public pages (landing, login) are protected against clickjacking, MIME
 * sniffing, and content injection.
 *
 * <p>The Content-Security-Policy is intentionally strict: scripts and styles
 * load only from our own origin (plus Google Fonts for the type stack), which
 * is why the app ships self-contained CSS/SVG instead of relying on a CDN
 * framework.</p>
 */
@WebFilter(urlPatterns = "/*")
public class SecurityHeadersFilter implements Filter {

    private static final String CSP = String.join("; ",
            "default-src 'self'",
            "base-uri 'self'",
            "frame-ancestors 'none'",
            "form-action 'self'",
            "img-src 'self' data:",
            "script-src 'self'",
            "style-src 'self' https://fonts.googleapis.com",
            "font-src 'self' https://fonts.gstatic.com",
            "object-src 'none'");

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletResponse res = (HttpServletResponse) response;

        res.setHeader("Content-Security-Policy", CSP);
        res.setHeader("X-Content-Type-Options", "nosniff");
        res.setHeader("X-Frame-Options", "DENY");
        res.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        res.setHeader("Permissions-Policy", "geolocation=(), microphone=(), camera=()");
        // Tell browsers to stick to HTTPS once the app is served over TLS.
        res.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");

        chain.doFilter(request, response);
    }
}
