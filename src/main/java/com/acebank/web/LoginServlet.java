package com.acebank.web;

import com.acebank.dao.AccountDao;
import com.acebank.model.Account;
import com.acebank.model.User;
import com.acebank.security.CsrfTokens;
import com.acebank.security.SessionKeys;
import com.acebank.service.AuthResult;
import com.acebank.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AuthService auth = new AuthService();
    private final AccountDao accounts = new AccountDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s != null && s.getAttribute(SessionKeys.USER_ID) != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        CsrfTokens.get(req.getSession(true)); // ensure a token exists for the form
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("username");
        String password = req.getParameter("password");

        AuthResult result = auth.login(email, password, WebUtil.clientIp(req));
        if (!result.success()) {
            req.setAttribute("error", result.message());
            req.setAttribute("email", email);
            CsrfTokens.get(req.getSession(true));
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        User user = result.user();
        long accountNo = accounts.findPrimaryByUser(user.id())
                .map(Account::accountNo).orElse(0L);
        WebUtil.establishSession(req, user, accountNo);

        String dest = user.isAdmin() ? "/admin/dashboard" : "/dashboard";
        resp.sendRedirect(req.getContextPath() + dest);
    }
}
