package com.acebank.lite.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter(urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_PATHS = Arrays.asList(
            "/Login.jsp", "/SignUp.jsp", "/index.jsp", "/ForgotPassword.jsp",
            "/ResetPassword.jsp", "/VerifyOTP.jsp", "/error.jsp", "/Forgot",
            "/VerifyOTP", "/ResetPassword", "/signup", "/Login"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getServletPath();
        String contextPath = httpRequest.getContextPath();

        if (path.startsWith("/assets/") || path.startsWith("/css/") || path.startsWith("/js/")) {
            chain.doFilter(request, response);
            return;
        }

        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("accountNumber") != null);

        if (isLoggedIn) {
            String role = (String) session.getAttribute("role");
            if (path.startsWith("/admin") && !"ADMIN".equals(role)) {
                httpResponse.sendRedirect(contextPath + "/Home.jsp?error=Access+Denied");
                return;
            }
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(contextPath + "/Login.jsp?error=Please+login+first");
        }
    }

    private boolean isPublicPath(String path) {
        for (String publicPath : PUBLIC_PATHS) {
            if (path.endsWith(publicPath) || path.equals(publicPath)) {
                return true;
            }
        }
        return false;
    }
}