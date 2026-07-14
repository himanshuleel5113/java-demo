package com.acebank.service;

import com.acebank.model.User;

/** Outcome of a login/signup attempt. */
public record AuthResult(boolean success, String message, User user) {
    public static AuthResult ok(User u)            { return new AuthResult(true, "OK", u); }
    public static AuthResult fail(String message)  { return new AuthResult(false, message, null); }
}
