package com.acebank.web;

import com.acebank.dao.TransactionDao;
import com.acebank.model.Transaction;
import com.acebank.security.SessionKeys;
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

@WebServlet("/transactions")
public class TransactionsServlet extends HttpServlet {

    private final TransactionDao txDao = new TransactionDao();
    private static final SimpleDateFormat FMT = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        long primary = (long) req.getSession().getAttribute(SessionKeys.ACCOUNT_NO);
        List<Transaction> list = txDao.recentForAccount(primary, 50);

        BigDecimal credits = BigDecimal.ZERO, debits = BigDecimal.ZERO;
        List<Map<String, Object>> rows = new ArrayList<>();
        for (Transaction t : list) {
            boolean credit = t.receiverAccount() != null && t.receiverAccount() == primary;
            if (credit) credits = credits.add(t.amount()); else debits = debits.add(t.amount());
            Map<String, Object> r = new LinkedHashMap<>();
            r.put("desc", describe(t, credit));
            r.put("date", t.createdAt() == null ? "" : FMT.format(t.createdAt()));
            r.put("ref", t.referenceNo() == null ? "" : t.referenceNo());
            r.put("type", t.txType());
            r.put("credit", credit);
            r.put("amount", (credit ? "+ ₹" : "- ₹") + Money.inr(t.amount()));
            rows.add(r);
        }
        req.setAttribute("txRows", rows);
        req.setAttribute("primaryMasked", Money.maskAccount(primary));
        req.setAttribute("totalCredits", "+ ₹" + Money.inr(credits));
        req.setAttribute("totalDebits", "- ₹" + Money.inr(debits));
        req.setAttribute("netBalance", "+ ₹" + Money.inr(credits.subtract(debits)));
        req.setAttribute("txCount", rows.size());
        req.getRequestDispatcher("/WEB-INF/views/transactions.jsp").forward(req, resp);
    }

    private String describe(Transaction t, boolean credit) {
        return switch (t.txType()) {
            case "DEPOSIT"    -> t.remark() != null ? t.remark() : "Deposit";
            case "WITHDRAWAL" -> t.remark() != null ? t.remark() : "Withdrawal";
            default -> credit
                    ? "Received from " + Money.maskAccount(t.senderAccount() == null ? 0 : t.senderAccount())
                    : "Transfer to " + Money.maskAccount(t.receiverAccount() == null ? 0 : t.receiverAccount());
        };
    }
}
