package com.acebank.web;

import com.acebank.dao.ServiceRequestDao;
import com.acebank.model.ServiceRequest;
import com.acebank.security.SessionKeys;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet("/help")
public class HelpServlet extends HttpServlet {

    private final ServiceRequestDao requests = new ServiceRequestDao();
    private static final SimpleDateFormat FMT = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    private static final Set<String> CATEGORIES =
            Set.of("Transactions", "Accounts", "Cards", "Profile", "Other");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        render(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute(SessionKeys.USER_ID);

        String subject = trim(req.getParameter("subject"));
        String category = trim(req.getParameter("category"));
        String message = trim(req.getParameter("message"));

        if (subject.isEmpty()) {
            req.setAttribute("error", "Please describe your issue in the subject.");
        } else {
            if (!CATEGORIES.contains(category)) category = "Other";
            String ticket = "SR-" + Long.toHexString(System.nanoTime()).toUpperCase().substring(0, 8);
            requests.insert(userId, ticket, subject, category, message.isEmpty() ? null : message);
            req.setAttribute("success", "Request " + ticket + " raised. Our team will get back to you.");
        }
        render(req, resp);
    }

    private void render(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute(SessionKeys.USER_ID);

        List<Map<String, Object>> rows = new ArrayList<>();
        for (ServiceRequest sr : requests.findByUser(userId)) {
            Map<String, Object> r = new LinkedHashMap<>();
            r.put("ticket", sr.ticketNo());
            r.put("subject", sr.subject());
            r.put("category", sr.category());
            r.put("status", label(sr.status()));
            r.put("statusClass", statusClass(sr.status()));
            r.put("updated", sr.updatedAt() == null ? "" : FMT.format(sr.updatedAt()));
            rows.add(r);
        }
        req.setAttribute("requests", rows);
        req.getRequestDispatcher("/WEB-INF/views/help.jsp").forward(req, resp);
    }

    private static String label(String status) {
        return switch (status) {
            case "IN_PROGRESS" -> "In Progress";
            case "RESOLVED"    -> "Resolved";
            case "CLOSED"      -> "Closed";
            default            -> status;
        };
    }

    private static String statusClass(String status) {
        return switch (status) {
            case "RESOLVED" -> "pill-green";
            case "CLOSED"   -> "pill-gray";
            default         -> "pill-amber";
        };
    }

    private static String trim(String s) { return s == null ? "" : s.trim(); }
}
