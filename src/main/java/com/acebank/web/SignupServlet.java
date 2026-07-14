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

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

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
        CsrfTokens.get(req.getSession(true));
        req.getRequestDispatcher("/WEB-INF/views/signup.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        AuthResult result = auth.signup(
                req.getParameter("firstName"), req.getParameter("lastName"),
                req.getParameter("email"), req.getParameter("phone"),
                req.getParameter("password"), WebUtil.clientIp(req));

        if (!result.success()) {
            req.setAttribute("error", result.message());
            CsrfTokens.get(req.getSession(true));
            req.getRequestDispatcher("/WEB-INF/views/signup.jsp").forward(req, resp);
            return;
        }

        User user = result.user();
        long accountNo = accounts.findPrimaryByUser(user.id()).map(Account::accountNo).orElse(0L);
        WebUtil.establishSession(req, user, accountNo);
        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}
