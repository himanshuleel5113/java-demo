package com.acebank.lite.controllers;

import com.acebank.lite.models.BillPayment;
import com.acebank.lite.models.ServiceResponse;
import com.acebank.lite.service.BillPaymentService;
import com.acebank.lite.service.BillPaymentServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/BillPayments")
public class BillPaymentServlet extends HttpServlet {
    private BillPaymentService billPaymentService;

    @Override
    public void init() throws ServletException {
        this.billPaymentService = new BillPaymentServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        int accountNumber = (Integer) session.getAttribute("accountNumber");
        List<BillPayment> bills = billPaymentService.getBillPayments(accountNumber);
        
        request.setAttribute("billsList", bills);
        request.getRequestDispatcher("/BillPayments.jsp").forward(request, response);
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

        if ("pay".equals(action)) {
            try {
                String billerCategory = request.getParameter("category");
                String billerName = request.getParameter("billerName");
                String consumerNumber = request.getParameter("consumerNumber");
                double amount = Double.parseDouble(request.getParameter("amount"));
                
                ServiceResponse<BillPayment> result = billPaymentService.payBill(accountNumber, billerName, billerCategory, amount, consumerNumber);
                if (result.success()) {
                    request.getSession().setAttribute("successMessage", result.message());
                } else {
                    request.getSession().setAttribute("errorMessage", result.message());
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid amount.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/BillPayments");
    }
}
