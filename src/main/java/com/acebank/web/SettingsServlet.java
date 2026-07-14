package com.acebank.web;

import com.acebank.security.SessionKeys;
import com.acebank.service.AuthResult;
import com.acebank.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {

    private final AuthService auth = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/settings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute(SessionKeys.USER_ID);

        AuthResult result = auth.changePassword(userId,
                req.getParameter("currentPassword"),
                req.getParameter("newPassword"),
                req.getParameter("confirmPassword"),
                WebUtil.clientIp(req));

        if (result.success()) {
            req.setAttribute("success", "Password changed successfully.");
        } else {
            req.setAttribute("error", result.message());
            req.setAttribute("openPassword", true); // keep the change-password panel open
        }
        req.getRequestDispatcher("/WEB-INF/views/settings.jsp").forward(req, resp);
    }
}
