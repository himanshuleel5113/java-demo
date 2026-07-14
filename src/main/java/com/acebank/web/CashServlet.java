package com.acebank.web;

import com.acebank.dao.AccountDao;
import com.acebank.security.SessionKeys;
import com.acebank.service.CashService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

/** Handles both /deposit and /withdraw with a shared simple form. */
@WebServlet({"/deposit", "/withdraw"})
public class CashServlet extends HttpServlet {

    private final AccountDao accounts = new AccountDao();
    private final CashService cash = new CashService();

    private boolean isDeposit(HttpServletRequest req) { return req.getServletPath().equals("/deposit"); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        render(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute(SessionKeys.USER_ID);
        long acc = (long) req.getSession().getAttribute(SessionKeys.ACCOUNT_NO);
        BigDecimal amount;
        try { amount = new BigDecimal(req.getParameter("amount").trim()); }
        catch (Exception e) { req.setAttribute("error", "Enter a valid amount."); render(req, resp); return; }

        CashService.Result r = isDeposit(req)
                ? cash.deposit(userId, acc, amount, WebUtil.clientIp(req))
                : cash.withdraw(userId, acc, amount, WebUtil.clientIp(req));
        req.setAttribute(r.success() ? "success" : "error", r.message());
        render(req, resp);
    }

    private void render(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        long acc = (long) req.getSession().getAttribute(SessionKeys.ACCOUNT_NO);
        accounts.balanceOf(acc).ifPresent(b -> req.setAttribute("balance", Money.inr(b)));
        req.setAttribute("mode", isDeposit(req) ? "Deposit" : "Withdraw");
        req.setAttribute("action", isDeposit(req) ? "deposit" : "withdraw");
        req.setAttribute("accountNo", acc);
        req.getRequestDispatcher("/WEB-INF/views/cash.jsp").forward(req, resp);
    }
}
