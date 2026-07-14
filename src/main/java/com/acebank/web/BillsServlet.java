package com.acebank.web;

import com.acebank.dao.AccountDao;
import com.acebank.dao.BillPaymentDao;
import com.acebank.model.BillPayment;
import com.acebank.security.SessionKeys;
import com.acebank.service.BillPaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/bills")
public class BillsServlet extends HttpServlet {

    private final AccountDao accounts = new AccountDao();
    private final BillPaymentDao bills = new BillPaymentDao();
    private final BillPaymentService payments = new BillPaymentService();
    private static final SimpleDateFormat FMT = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        render(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute(SessionKeys.USER_ID);
        long accountNo = (long) req.getSession().getAttribute(SessionKeys.ACCOUNT_NO);

        BigDecimal amount;
        try {
            amount = new BigDecimal(req.getParameter("amount").trim());
        } catch (Exception e) {
            req.setAttribute("error", "Enter a valid amount.");
            render(req, resp);
            return;
        }

        BillPaymentService.Result result = payments.pay(userId, accountNo,
                req.getParameter("category"), req.getParameter("biller"),
                req.getParameter("consumerNo"), req.getParameter("nickname"),
                amount, WebUtil.clientIp(req));

        if (result.success()) {
            req.setAttribute("success", result.message() + " Ref: " + result.reference());
        } else {
            req.setAttribute("error", result.message());
        }
        render(req, resp);
    }

    private void render(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute(SessionKeys.USER_ID);
        long accountNo = (long) req.getSession().getAttribute(SessionKeys.ACCOUNT_NO);

        accounts.balanceOf(accountNo).ifPresent(bal -> req.setAttribute("balance", Money.inr(bal)));

        List<Map<String, Object>> rows = new ArrayList<>();
        for (BillPayment b : bills.recentForUser(userId, 8)) {
            Map<String, Object> r = new LinkedHashMap<>();
            r.put("category", b.category());
            r.put("biller", b.biller());
            r.put("consumerNo", b.consumerNo());
            r.put("amount", Money.inr(b.amount()));
            r.put("date", b.createdAt() == null ? "" : FMT.format(b.createdAt()));
            r.put("statusOk", "SUCCESS".equals(b.status()));
            rows.add(r);
        }
        req.setAttribute("history", rows);
        req.getRequestDispatcher("/WEB-INF/views/bills.jsp").forward(req, resp);
    }
}
