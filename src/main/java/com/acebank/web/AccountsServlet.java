package com.acebank.web;

import com.acebank.dao.AccountDao;
import com.acebank.model.Account;
import com.acebank.security.SessionKeys;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/accounts")
public class AccountsServlet extends HttpServlet {

    private final AccountDao accounts = new AccountDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute(SessionKeys.USER_ID);
        List<Account> accts = accounts.findByUser(userId);
        BigDecimal total = accts.stream().map(Account::balance).reduce(BigDecimal.ZERO, BigDecimal::add);

        List<Map<String, Object>> rows = new ArrayList<>();
        int i = 0;
        String[] variants = {"acct-blue", "acct-green", "acct-amber", "acct-purple"};
        String[] icons = {"ic-blue", "ic-green", "ic-amber", "ic-purple"};
        for (Account a : accts) {
            Map<String, Object> r = new LinkedHashMap<>();
            r.put("name", "SAVINGS".equals(a.accountType()) ? "Savings Account" : "Current Account");
            r.put("number", String.valueOf(a.accountNo()));
            r.put("balance", Money.inr(a.balance()));
            r.put("ifsc", "ACBK0" + String.format("%06d", a.accountNo() % 1000000));
            r.put("variant", variants[i % variants.length]);
            r.put("icon", icons[i % icons.length]);
            rows.add(r);
            i++;
        }
        req.setAttribute("accountRows", rows);
        req.setAttribute("totalBalance", Money.inr(total));
        req.getRequestDispatcher("/WEB-INF/views/accounts.jsp").forward(req, resp);
    }
}
