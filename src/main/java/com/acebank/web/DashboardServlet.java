package com.acebank.web;

import com.acebank.dao.AccountDao;
import com.acebank.dao.TransactionDao;
import com.acebank.model.Account;
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

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final AccountDao accounts = new AccountDao();
    private final TransactionDao txDao = new TransactionDao();
    private static final SimpleDateFormat FMT = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute(SessionKeys.USER_ID);
        long primaryNo = (long) req.getSession().getAttribute(SessionKeys.ACCOUNT_NO);

        List<Account> accts = accounts.findByUser(userId);
        BigDecimal total = accts.stream().map(Account::balance).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal primaryBal = accts.stream()
                .filter(a -> a.accountNo() == primaryNo).map(Account::balance)
                .findFirst().orElse(BigDecimal.ZERO);

        // Build EL-friendly rows (records aren't accessible from JSP EL).
        List<Map<String, Object>> rows = new ArrayList<>();
        for (Transaction t : txDao.recentForAccount(primaryNo, 5)) {
            boolean credit = t.receiverAccount() != null && t.receiverAccount() == primaryNo;
            Map<String, Object> r = new LinkedHashMap<>();
            r.put("title", describe(t, primaryNo, credit));
            r.put("date", t.createdAt() == null ? "" : FMT.format(t.createdAt()));
            r.put("amount", (credit ? "+ ₹" : "- ₹") + Money.inr(t.amount()));
            r.put("credit", credit);
            rows.add(r);
        }

        req.setAttribute("totalBalance", Money.inr(total));
        req.setAttribute("primaryBalance", Money.inr(primaryBal));
        req.setAttribute("primaryMasked", Money.maskAccount(primaryNo));
        req.setAttribute("recentTx", rows);
        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }

    private String describe(Transaction t, long primary, boolean credit) {
        return switch (t.txType()) {
            case "DEPOSIT"    -> "Cash Deposit";
            case "WITHDRAWAL" -> "Cash Withdrawal";
            default -> credit
                    ? "Received from " + Money.maskAccount(t.senderAccount() == null ? 0 : t.senderAccount())
                    : "Transfer to " + Money.maskAccount(t.receiverAccount() == null ? 0 : t.receiverAccount());
        };
    }
}
