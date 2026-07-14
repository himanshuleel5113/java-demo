package com.acebank.security;

import org.mindrot.jbcrypt.BCrypt;

/**
 * BCrypt password hashing (work factor 12). Verification is constant-time
 * within BCrypt itself, mitigating timing attacks.
 */
public final class PasswordHasher {

    private static final int COST = 12;

    private PasswordHasher() {}

    public static String hash(String plain) {
        return BCrypt.hashpw(plain, BCrypt.gensalt(COST));
    }

    public static boolean verify(String plain, String hash) {
        if (plain == null || hash == null || hash.isEmpty()) return false;
        try {
            return BCrypt.checkpw(plain, hash);
        } catch (IllegalArgumentException e) {
            return false; // malformed stored hash
        }
    }
}
