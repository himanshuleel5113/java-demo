package com.acebank.lite.controllers;

import com.acebank.lite.models.CardRequest;
import com.acebank.lite.models.ServiceResponse;
import com.acebank.lite.service.CardService;
import com.acebank.lite.service.CardServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/Cards")
public class CardServlet extends HttpServlet {
    private CardService cardService;

    @Override
    public void init() throws ServletException {
        this.cardService = new CardServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        int accountNumber = (Integer) session.getAttribute("accountNumber");
        List<CardRequest> cards = cardService.getCardsForAccount(accountNumber);
        
        request.setAttribute("cardsList", cards);
        request.getRequestDispatcher("/CardServices.jsp").forward(request, response);
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

        if ("request".equals(action)) {
            String cardType = request.getParameter("cardType"); // e.g. "DEBIT_VISA" or "CREDIT_MASTERCARD"
            if(cardType == null || cardType.isEmpty()) cardType = "DEBIT_VISA";

            ServiceResponse<CardRequest> result = cardService.requestNewCard(accountNumber, cardType);
            if (result.success()) {
                request.getSession().setAttribute("successMessage", result.message());
            } else {
                request.getSession().setAttribute("errorMessage", result.message());
            }
        } else if ("toggleBlock".equals(action)) {
            try {
                long cardId = Long.parseLong(request.getParameter("cardId"));
                boolean blockStatus = Boolean.parseBoolean(request.getParameter("blockStatus")); // true to block, false to unblock
                
                ServiceResponse<Void> result = cardService.toggleCardBlock(cardId, accountNumber, blockStatus);
                if (result.success()) {
                    request.getSession().setAttribute("successMessage", result.message());
                } else {
                    request.getSession().setAttribute("errorMessage", result.message());
                }
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", "Invalid request.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/Cards");
    }
}
