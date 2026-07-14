package com.acebank.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;
import java.util.Set;

/**
 * Routes the Services hub to its JSP view. Bills, Loans, Settings and Help each
 * have their own data-backed servlet; Services is a navigation hub whose links
 * point at those real routes. Access is gated by AuthFilter.
 */
@WebServlet({"/services"})
public class ViewServlet extends HttpServlet {

    private static final Set<String> KNOWN = Set.of("services");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String page = req.getServletPath().substring(1); // strip leading '/'
        if (!KNOWN.contains(page)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/" + page + ".jsp").forward(req, resp);
    }
}
