package com.acebank.web;

import com.acebank.dao.UserDao;
import com.acebank.model.User;
import com.acebank.security.SessionKeys;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final UserDao users = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = (String) req.getSession().getAttribute(SessionKeys.USER_EMAIL);
        long accountNo = (long) req.getSession().getAttribute(SessionKeys.ACCOUNT_NO);
        User u = users.findByEmail(email).orElse(null);
        if (u != null) {
            req.setAttribute("pName", u.fullName());
            req.setAttribute("pEmail", u.email());
            req.setAttribute("pPhone", u.phone() == null || u.phone().isBlank() ? "Not provided" : u.phone());
            req.setAttribute("pRole", u.isAdmin() ? "Administrator" : "Premium Customer");
        }
        req.setAttribute("pCustomerId", "ACB" + String.format("%08d", accountNo % 100000000));
        req.setAttribute("pAccount", accountNo);
        req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
    }
}
