package com.acebank.lite.controllers;

import com.acebank.lite.models.Beneficiary;
import com.acebank.lite.models.ServiceResponse;
import com.acebank.lite.service.BeneficiaryService;
import com.acebank.lite.service.BeneficiaryServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/Beneficiaries")
public class BeneficiaryServlet extends HttpServlet {
    private BeneficiaryService beneficiaryService;

    @Override
    public void init() throws ServletException {
        this.beneficiaryService = new BeneficiaryServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        int accountNumber = (Integer) session.getAttribute("accountNumber");
        List<Beneficiary> beneficiaries = beneficiaryService.getBeneficiaries(accountNumber);
        
        request.setAttribute("beneficiariesList", beneficiaries);
        request.getRequestDispatcher("/Beneficiaries.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        int ownerAccount = (Integer) session.getAttribute("accountNumber");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String account = request.getParameter("accountNumber");
            String bankName = request.getParameter("bankName");
            String ifscCode = request.getParameter("ifscCode");
            String nickname = request.getParameter("nickname");

            ServiceResponse<Beneficiary> result = beneficiaryService.addBeneficiary(ownerAccount, account, name, bankName, ifscCode, nickname);
            
            if (result.success()) {
                request.getSession().setAttribute("successMessage", result.message());
            } else {
                request.getSession().setAttribute("errorMessage", result.message());
            }
        } else if ("delete".equals(action)) {
            try {
                long id = Long.parseLong(request.getParameter("id"));
                ServiceResponse<Void> result = beneficiaryService.removeBeneficiary(id, ownerAccount);
                if (result.success()) {
                    request.getSession().setAttribute("successMessage", result.message());
                } else {
                    request.getSession().setAttribute("errorMessage", result.message());
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Invalid beneficiary ID.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/Beneficiaries");
    }
}
