package com.acebank.web;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Formats amounts with Indian digit grouping, e.g. 120450.75 -> "1,20,450.75".
 * Implemented manually so the output is identical regardless of the JVM's
 * bundled locale data.
 */
public final class Money {

    private Money() {}

    public static String inr(BigDecimal amount) {
        if (amount == null) amount = BigDecimal.ZERO;
        amount = amount.setScale(2, RoundingMode.HALF_UP);
        boolean negative = amount.signum() < 0;
        String plain = amount.abs().toPlainString();      // e.g. "120450.75"
        int dot = plain.indexOf('.');
        String intPart = plain.substring(0, dot);
        String decPart = plain.substring(dot + 1);
        return (negative ? "-" : "") + groupIndian(intPart) + "." + decPart;
    }

    private static String groupIndian(String n) {
        int len = n.length();
        if (len <= 3) return n;
        String last3 = n.substring(len - 3);
        String rest = n.substring(0, len - 3);
        StringBuilder sb = new StringBuilder();
        int i = rest.length();
        while (i > 2) {                                   // groups of two from the right
            sb.insert(0, "," + rest.substring(i - 2, i));
            i -= 2;
        }
        sb.insert(0, rest.substring(0, i));
        return sb + "," + last3;
    }

    public static String maskAccount(long accountNo) {
        String s = String.valueOf(accountNo);
        return s.length() <= 4 ? s : "**** " + s.substring(s.length() - 4);
    }
}
