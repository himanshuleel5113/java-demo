package com.acebank.lite.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

@WebFilter(urlPatterns = {"/*"})
public class RateLimitingFilter implements Filter {

    private static final int MAX_REQUESTS_PER_MINUTE = 100;
    private final ConcurrentHashMap<String, RequestInfo> requestCounts = new ConcurrentHashMap<>();

    private static class RequestInfo {
        int count;
        long windowStart;
        
        RequestInfo() {
            this.count = 1;
            this.windowStart = System.currentTimeMillis();
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Apply rate limiting primarily on dynamic paths
        String path = req.getRequestURI();
        if (path.endsWith(".jsp") || !path.contains(".")) {
            String ip = req.getRemoteAddr();
            RequestInfo info = requestCounts.computeIfAbsent(ip, k -> new RequestInfo());
            
            synchronized(info) {
                long now = System.currentTimeMillis();
                if (now - info.windowStart > 60000) {
                    info.count = 1;
                    info.windowStart = now;
                } else {
                    info.count++;
                    if (info.count > MAX_REQUESTS_PER_MINUTE) {
                        res.setStatus(429); // Too Many Requests
                        res.getWriter().write("Too many requests. Please try again later.");
                        return;
                    }
                }
            }
        }

        chain.doFilter(request, response);
    }
}
