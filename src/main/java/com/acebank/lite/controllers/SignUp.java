package com.acebank.lite.controllers;

import com.acebank.lite.models.LoginResult;
import com.acebank.lite.models.User;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Logger;

import java.io.IOException;
import java.io.Serial;
import java.util.ArrayList;
import java.util.Optional;


@WebServlet("/signup")  // Keep this as lowercase - we'll match form to this
public class SignUp extends HttpServlet {
    private static final Logger log = Logger.getLogger("SignUp");
    @Serial
    private static final long serialVersionUID = 1L;

    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Extract Data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String aadharStr = request.getParameter("aadharNumber");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        log.info("SignUp attempt for email: " + email);

        // Validation
        if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                aadharStr == null || aadharStr.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {

            log.warning("SignUp failed: Missing required fields");
            response.sendRedirect("SignUp.jsp?error=All+fields+are+required");
            return;
        }

        // Validate Aadhar (12 digits)
        if (!aadharStr.matches("\\d{12}")) {
            log.warning("SignUp failed: Invalid Aadhar number");
            response.sendRedirect("SignUp.jsp?error=Invalid+Aadhar+number");
            return;
        }

        String normalizedEmail = email.trim().toLowerCase();
        String normalizedAadhaar = aadharStr.trim();

        try {
            // Give the user an ACCURATE reason instead of a blanket "email may already exist".
            if (bankService.isEmailRegistered(normalizedEmail)) {
                log.warning("SignUp failed: email already registered - " + normalizedEmail);
                response.sendRedirect("SignUp.jsp?error=This+email+is+already+registered.+Please+log+in+instead.");
                return;
            }
            if (bankService.isAadhaarRegistered(normalizedAadhaar)) {
                log.warning("SignUp failed: aadhaar already registered");
                response.sendRedirect("SignUp.jsp?error=This+Aadhaar+number+is+already+registered.");
                return;
            }

            // Role must be a valid USERS.ROLE enum value ('CUSTOMER' | 'ADMIN'); "USER" was invalid
            // and made every insert fail under MySQL strict mode.
            User newUser = new User(null, firstName.trim(), lastName.trim(), normalizedAadhaar, normalizedEmail, password, "CUSTOMER", null, null, null, null, "ACTIVE", 0, null, false, null, null, java.time.LocalDateTime.now(), java.time.LocalDateTime.now());

            // 3. Call Service to handle logic
            Optional<LoginResult> resultOpt = bankService.registerUser(newUser);

            if (resultOpt.isPresent()) {
                var details = resultOpt.get();
                HttpSession session = request.getSession();

                // 4. Set Session Attributes
                session.setAttribute("accountNumber", details.accountNumber());
                session.setAttribute("firstName", details.firstName());
                session.setAttribute("lastName", details.lastName());
                session.setAttribute("email", details.email());
                session.setAttribute("balance", details.balance());
                session.setAttribute("transactionDetailsList", new ArrayList<>());

                log.info("User registered successfully: " + details.accountNumber());
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                log.warning("SignUp failed for email: " + email);
                response.sendRedirect("SignUp.jsp?error=Registration+could+not+be+completed.+Please+try+again.");
            }

        } catch (Exception e) {
            log.severe("SignUp Servlet Error: " + e.getMessage());
            response.sendRedirect("SignUp.jsp?error=System+error.+Please+try+again.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Redirect GET requests to the signup page
        response.sendRedirect("SignUp.jsp");
    }
}
