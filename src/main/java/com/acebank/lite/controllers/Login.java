package com.acebank.lite.controllers;

import java.io.IOException;
import java.io.Serial;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import com.acebank.lite.models.LoginResult;
import com.acebank.lite.models.Transaction;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.logging.Logger;


@WebServlet(name = "Login", urlPatterns = "/Login")
public class Login extends HttpServlet {
    private static final Logger log = Logger.getLogger("Login");

    @Serial
    private static final long serialVersionUID = 1L;

    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accStr = request.getParameter("accountNumber");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        try {
            int accountNo = Integer.parseInt(accStr);

            LoginResult details = bankService.authenticate(accountNo, password).orElse(null);

            if (details != null && details.success()) {
                HttpSession session = request.getSession(true);

                // Populate Session Attributes
                session.setAttribute("accountNumber", accountNo);
                session.setAttribute("firstName", details.firstName());
                session.setAttribute("lastName", details.lastName());
                session.setAttribute("email", details.email());
                session.setAttribute("role", details.role());
                session.setAttribute("balance", details.balance());

                // Fetch Transaction History
                List<Transaction> statement = bankService.getTransactionHistory(accountNo);
                session.setAttribute("transactionDetailsList", statement);

                // Handle "Remember Me" Cookie
                if (rememberMe != null) {
                    Cookie cookie = new Cookie("rememberedAccount", String.valueOf(accountNo));
                    cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                    cookie.setPath("/");
                    response.addCookie(cookie);
                }

                log.info("User " + accountNo + " logged in successfully.");
                response.sendRedirect(request.getContextPath() + "/home");

            } else {
                log.warning("Authentication failed for account: " + accStr);
                String reason = (details != null && details.message() != null && !details.message().isBlank())
                        ? details.message()
                        : "Invalid account number or password";
                response.sendRedirect("Login.jsp?error=" + URLEncoder.encode(reason, StandardCharsets.UTF_8));
            }

        } catch (Exception e) {
            log.severe("Login Error: " + e.getMessage());
            response.sendRedirect("Login.jsp?error=" + URLEncoder.encode("Something went wrong. Please try again.", StandardCharsets.UTF_8));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Login.jsp");
    }
}
