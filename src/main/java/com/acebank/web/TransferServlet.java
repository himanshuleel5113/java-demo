package com.acebank.web;

import com.acebank.dao.AccountDao;
import com.acebank.security.SessionKeys;
import com.acebank.service.TransferService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/transfer")
public class TransferServlet extends HttpServlet {

    private final AccountDao accounts = new AccountDao();
    private final TransferService transfers = new TransferService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        populateFrom(req);
        req.getRequestDispatcher("/WEB-INF/views/transfer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute(SessionKeys.USER_ID);
        long fromNo = (long) req.getSession().getAttribute(SessionKeys.ACCOUNT_NO);

        long toNo;
        BigDecimal amount;
        try {
            toNo = Long.parseLong(req.getParameter("toAccount").trim());
            amount = new BigDecimal(req.getParameter("amount").trim());
        } catch (Exception e) {
            req.setAttribute("error", "Enter a valid account number and amount.");
            populateFrom(req);
            req.getRequestDispatcher("/WEB-INF/views/transfer.jsp").forward(req, resp);
            return;
        }

        TransferService.Result result = transfers.transfer(
                userId, fromNo, toNo, amount, req.getParameter("remarks"), WebUtil.clientIp(req));

        if (result.success()) {
            req.setAttribute("success", result.message() + " Ref: " + result.reference());
        } else {
            req.setAttribute("error", result.message());
        }
        populateFrom(req);
        req.getRequestDispatcher("/WEB-INF/views/transfer.jsp").forward(req, resp);
    }

    private void populateFrom(HttpServletRequest req) {
        int userId = (int) req.getSession().getAttribute(SessionKeys.USER_ID);
        long fromNo = (long) req.getSession().getAttribute(SessionKeys.ACCOUNT_NO);
        accounts.balanceOf(fromNo).ifPresent(bal -> req.setAttribute("fromBalance", Money.inr(bal)));
        req.setAttribute("fromAccountNo", fromNo);
    }
}
