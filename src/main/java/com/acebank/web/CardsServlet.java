package com.acebank.web;

import com.acebank.dao.CardDao;
import com.acebank.model.Card;
import com.acebank.security.SessionKeys;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/cards")
public class CardsServlet extends HttpServlet {

    private final CardDao cards = new CardDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute(SessionKeys.USER_ID);

        List<Map<String, Object>> rows = new ArrayList<>();
        for (Card c : cards.listByUser(userId)) {
            Map<String, Object> r = new LinkedHashMap<>();
            r.put("type", c.cardType());
            r.put("network", c.network());
            r.put("masked", "**** **** **** " + c.last4());
            r.put("holder", c.holder() == null ? "" : c.holder().toUpperCase());
            r.put("expiry", c.expiry());
            r.put("status", "ACTIVE".equals(c.status()) ? "Active" : "Blocked");
            r.put("statusClass", "ACTIVE".equals(c.status()) ? "pill-green" : "pill-rose");
            r.put("variant", "CREDIT".equals(c.cardType()) ? "credit" : "debit");
            r.put("limit", Money.inr(c.dailyLimit()));
            rows.add(r);
        }
        req.setAttribute("cards", rows);
        req.getRequestDispatcher("/WEB-INF/views/cards.jsp").forward(req, resp);
    }
}
