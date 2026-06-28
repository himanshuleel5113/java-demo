package com.acebank.lite.controllers;

import com.acebank.lite.dao.LoanDao;
import com.acebank.lite.dao.LoanDaoImpl;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import com.acebank.lite.service.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Logger;

import java.io.IOException;
import java.math.BigDecimal;


@WebServlet("/Loan")
public class Loan extends HttpServlet {
    private static final Logger log = Logger.getLogger("Loan");
    private static final long serialVersionUID = 1L;
    private final BankService bankService = new BankServiceImpl();
    private final LoanDao loanDao = new LoanDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        int accountNumber = (int) session.getAttribute("accountNumber");
        String firstName = (String) session.getAttribute("firstName");
        String email = (String) session.getAttribute("email");

        String loanType = request.getParameter("loanType");
        String amountStr = request.getParameter("amount");
        String tenureStr = request.getParameter("tenure");
        String purpose = request.getParameter("purpose");

        // Validate inputs
        if (loanType == null || loanType.isEmpty()) {
            response.sendRedirect("Loan.jsp?error=Please+select+a+loan+type");
            return;
        }

        BigDecimal amount;
        int tenure;

        try {
            amount = new BigDecimal(amountStr);
            tenure = Integer.parseInt(tenureStr.split(" ")[0]); // Extract number from "5 Years"
        } catch (Exception e) {
            response.sendRedirect("Loan.jsp?error=Invalid+amount+or+tenure");
            return;
        }

        try {
            // Insert loan application into database
            boolean success = loanDao.applyForLoan(accountNumber, loanType, amount, tenure, purpose);

            if (success) {
                // Send confirmation email
                bankService.applyForLoan(firstName, email, loanType);

                // Add notification
                String message = "Your " + loanType.toLowerCase() + " loan application has been submitted successfully.";
                NotificationService.addNotification(accountNumber, message, "LOAN");

                log.info("Loan application submitted for account: " + accountNumber + ", Type: " + loanType);
                response.sendRedirect(request.getContextPath() + "/home?msg=Loan+application+submitted+successfully");
            } else {
                response.sendRedirect("Loan.jsp?error=Application+failed.+Please+try+again");
            }
        } catch (Exception e) {
            log.severe("Loan application error: " + e.getMessage());
            response.sendRedirect("Loan.jsp?error=System+error.+Please+try+again");
        }
    }
}
