package com.acebank.lite.controllers;

import com.acebank.lite.models.RecurringDeposit;
import com.acebank.lite.models.ServiceResponse;
import com.acebank.lite.service.RecurringDepositService;
import com.acebank.lite.service.RecurringDepositServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/RecurringDeposits")
public class RecurringDepositServlet extends HttpServlet {
    private RecurringDepositService rdService;

    @Override
    public void init() throws ServletException {
        this.rdService = new RecurringDepositServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        int accountNumber = (Integer) session.getAttribute("accountNumber");
        List<RecurringDeposit> rds = rdService.getRecurringDeposits(accountNumber);
        
        request.setAttribute("rdList", rds);
        request.getRequestDispatcher("/RecurringDeposit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        int accountNumber = (Integer) session.getAttribute("accountNumber");
        String action = request.getParameter("action");

        if ("open".equals(action)) {
            try {
                double monthlyAmount = Double.parseDouble(request.getParameter("monthlyAmount"));
                int tenure = Integer.parseInt(request.getParameter("tenure"));
                
                ServiceResponse<RecurringDeposit> result = rdService.openRD(accountNumber, monthlyAmount, tenure);
                if (result.success()) {
                    request.getSession().setAttribute("successMessage", result.message());
                } else {
                    request.getSession().setAttribute("errorMessage", result.message());
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid amount or tenure.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/RecurringDeposits");
    }
}
