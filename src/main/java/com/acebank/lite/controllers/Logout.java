package com.acebank.lite.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Logger;

import java.io.IOException;
import java.io.Serial;

/**
 * Servlet implementation class Logout
 */

@WebServlet(name = "Logout", urlPatterns = "/Logout")
public class Logout extends HttpServlet {
    private static final Logger log = Logger.getLogger("Logout");
    @Serial
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Destroys the session
        }
        response.sendRedirect("index.jsp?msg=logged_out");
    }
}


