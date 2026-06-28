package com.acebank.lite.controllers;

import com.acebank.lite.models.FixedDeposit;
import com.acebank.lite.models.ServiceResponse;
import com.acebank.lite.service.FixedDepositService;
import com.acebank.lite.service.FixedDepositServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/FixedDeposits")
public class FixedDepositServlet extends HttpServlet {
    private FixedDepositService fdService;

    @Override
    public void init() throws ServletException {
        this.fdService = new FixedDepositServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        int accountNumber = (Integer) session.getAttribute("accountNumber");
        List<FixedDeposit> fds = fdService.getFixedDeposits(accountNumber);
        
        request.setAttribute("fdList", fds);
        request.getRequestDispatcher("/FixedDeposit.jsp").forward(request, response);
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
                double amount = Double.parseDouble(request.getParameter("amount"));
                int tenure = Integer.parseInt(request.getParameter("tenure"));
                
                ServiceResponse<FixedDeposit> result = fdService.openFD(accountNumber, amount, tenure);
                if (result.success()) {
                    request.getSession().setAttribute("successMessage", result.message());
                } else {
                    request.getSession().setAttribute("errorMessage", result.message());
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid amount or tenure.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/FixedDeposits");
    }
}
