package com.acebank.lite.controllers;

import com.acebank.lite.models.*;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.java.Log;

import java.io.IOException;
import java.io.Serial;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.logging.Level;

@Log
@WebServlet("/home")
public class Home extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;
    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("accountNumber") == null) {
            log.warning("Unauthorized access attempt to /home");
            response.sendRedirect(request.getContextPath() + "/Login.jsp?error=" + encodeParam("Please login first"));
            return;
        }

        try {
            int accountNumber = (int) session.getAttribute("accountNumber");

            // Refresh session data
            BigDecimal balance = bankService.getBalance(accountNumber);
            List<Transaction> transactions = bankService.getTransactionHistory(accountNumber);

            session.setAttribute("balance", balance != null ? balance : BigDecimal.ZERO);
            session.setAttribute("transactionDetailsList", transactions != null ? transactions : List.of());

            log.info("Loading dashboard for account: " + accountNumber);

            request.getRequestDispatcher("/WEB-INF/views/Home.jsp").forward(request, response);

        } catch (Exception e) {
            log.log(Level.SEVERE, "Error loading dashboard", e);
            response.sendRedirect(request.getContextPath() + "/GenericError.html");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp?error=" + encodeParam("Please login first"));
            return;
        }

        int accountNumber = (int) session.getAttribute("accountNumber");
        String depositAmtStr = request.getParameter("deposit");
        String toAccountStr = request.getParameter("toAccount");
        String toAmountStr = request.getParameter("toAmount");
        String withdrawFlag = request.getParameter("withdraw");
        String withdrawAmount = request.getParameter("withdrawAmount");

        String redirectUrl = request.getContextPath() + "/home";

        try {
            // --- ACTION 1: DEPOSIT ---
            if (depositAmtStr != null && !depositAmtStr.trim().isEmpty()) {
                BigDecimal amount = new BigDecimal(depositAmtStr);
                boolean status = bankService.processDeposit(accountNumber, amount);
                if (status) {
                    log.info("Deposit successful for account: " + accountNumber);
                    redirectUrl += "?msg=" + encodeParam("Deposit successful");

                    // Refresh balance
                    BigDecimal newBalance = bankService.getBalance(accountNumber);
                    session.setAttribute("balance", newBalance);

                    // Refresh transactions
                    List<Transaction> transactions = bankService.getTransactionHistory(accountNumber);
                    session.setAttribute("transactionDetailsList", transactions);
                } else {
                    redirectUrl += "?error=" + encodeParam("Deposit failed");
                }
            }
            // --- ACTION 2: WITHDRAW ---
            else if (withdrawFlag != null && withdrawAmount != null && !withdrawAmount.trim().isEmpty()) {
                BigDecimal amount = new BigDecimal(withdrawAmount);
                String result = bankService.withdraw(accountNumber, amount);
                log.info("Withdrawal result for account " + accountNumber + ": " + result);

                if ("SUCCESS".equals(result)) {
                    redirectUrl += "?msg=" + encodeParam("Withdrawal successful");

                    // Refresh balance
                    BigDecimal newBalance = bankService.getBalance(accountNumber);
                    session.setAttribute("balance", newBalance);

                    // Refresh transactions
                    List<Transaction> transactions = bankService.getTransactionHistory(accountNumber);
                    session.setAttribute("transactionDetailsList", transactions);
                } else {
                    redirectUrl += "?error=" + encodeParam(result);
                }
            }
            // --- ACTION 3: TRANSFER ---
            else if (toAccountStr != null && toAmountStr != null && !toAccountStr.trim().isEmpty()) {
                int recipientAcc = Integer.parseInt(toAccountStr);
                BigDecimal amount = new BigDecimal(toAmountStr);
                ServiceResponse serviceResponse = bankService.processTransfer(accountNumber, recipientAcc, amount);

                if (serviceResponse.success()) {
                    redirectUrl += "?msg=" + encodeParam("Transfer successful");

                    // Refresh balance
                    BigDecimal newBalance = bankService.getBalance(accountNumber);
                    session.setAttribute("balance", newBalance);

                    // Refresh transactions
                    List<Transaction> transactions = bankService.getTransactionHistory(accountNumber);
                    session.setAttribute("transactionDetailsList", transactions);
                } else {
                    redirectUrl += "?error=" + encodeParam(serviceResponse.message());
                }
            }

        } catch (NumberFormatException e) {
            log.log(Level.WARNING, "Number format error", e);
            redirectUrl += "?error=" + encodeParam("Invalid amount format");
        } catch (Exception e) {
            log.log(Level.SEVERE, "Transaction Error", e);
            redirectUrl += "?error=" + encodeParam("Transaction could not be completed");
        }

        response.sendRedirect(redirectUrl);
    }

    private String encodeParam(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}