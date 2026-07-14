package com.acebank.web;

import com.acebank.dao.LoanDao;
import com.acebank.model.Loan;
import com.acebank.security.SessionKeys;
import com.acebank.service.LoanService;
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

@WebServlet("/loans")
public class LoansServlet extends HttpServlet {

    private final LoanDao loans = new LoanDao();
    private final LoanService loanService = new LoanService();
    private static final SimpleDateFormat FMT = new SimpleDateFormat("dd MMM yyyy");

    private static final Map<String, String> LABEL = Map.of(
            "HOME", "Home Loan", "CAR", "Car Loan",
            "PERSONAL", "Personal Loan", "EDUCATION", "Education Loan");

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

        BigDecimal amount, rate;
        int tenure;
        try {
            amount = new BigDecimal(req.getParameter("amount").trim());
            rate = new BigDecimal(req.getParameter("rate").trim());
            tenure = Integer.parseInt(req.getParameter("tenureMonths").trim());
        } catch (Exception e) {
            req.setAttribute("error", "Enter a valid amount, rate and tenure.");
            render(req, resp);
            return;
        }

        LoanService.Result result = loanService.apply(userId, accountNo,
                req.getParameter("loanType"), amount, rate, tenure, WebUtil.clientIp(req));

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

        LoanDao.Summary s = loans.summaryForUser(userId);
        req.setAttribute("loanCount", s.count());
        req.setAttribute("totalOutstanding", Money.inr(s.outstanding()));
        req.setAttribute("totalEmi", Money.inr(s.totalEmi()));
        req.setAttribute("totalPaid", Money.inr(s.totalPaid()));

        List<Map<String, Object>> rows = new ArrayList<>();
        for (Loan l : loans.findByUser(userId)) {
            Map<String, Object> r = new LinkedHashMap<>();
            r.put("name", LABEL.getOrDefault(l.loanType(), l.loanType()));
            r.put("ref", l.loanRef());
            r.put("outstanding", Money.inr(l.outstanding()));
            r.put("emi", Money.inr(l.emiAmount()));
            r.put("nextDue", l.nextDueDate() == null ? "-" : FMT.format(l.nextDueDate()));
            r.put("progress", l.progressPercent());
            r.put("active", "ACTIVE".equals(l.status()));
            rows.add(r);
        }
        req.setAttribute("loans", rows);
        req.getRequestDispatcher("/WEB-INF/views/loans.jsp").forward(req, resp);
    }
}
