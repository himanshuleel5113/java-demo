package com.acebank.lite.controllers;

import com.acebank.lite.util.ConfigKeys;
import com.acebank.lite.util.ConfigLoader;
import com.acebank.lite.util.ConnectionManager;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Lightweight DB diagnostics endpoint: GET /health/db
 *
 * Reports whether the app can actually reach its database, which schema it landed
 * in, how many tables exist, and whether the admin seed is present — the exact
 * information the login/signup servlets swallow behind a generic error message.
 *
 * SECURITY: prints NO credentials (only the masked host from the JDBC URL). It is a
 * temporary deployment aid — remove it once the deployment is confirmed healthy.
 */
@WebServlet(name = "HealthDbServlet", urlPatterns = "/health/db")
public class HealthDbServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("=== AceBank DB Health Check ===");
        out.println("db.url (host only) : " + maskUrl(ConfigLoader.getProperty(ConfigKeys.DB_URL)));
        out.println("db.user set        : " + (ConfigLoader.getProperty(ConfigKeys.DB_USER) != null));
        out.println("db.password set    : " + (ConfigLoader.getProperty(ConfigKeys.DB_PWD) != null));
        out.println("driver             : " + ConfigLoader.getProperty(ConfigKeys.DB_MYSQL_DRIVER, "com.mysql.cj.jdbc.Driver"));
        out.println();

        try (Connection conn = ConnectionManager.getConnection()) {
            out.println("CONNECTION         : OK");
            out.println("DB product         : " + conn.getMetaData().getDatabaseProductName()
                    + " " + conn.getMetaData().getDatabaseProductVersion());

            try (Statement st = conn.createStatement()) {
                try (ResultSet rs = st.executeQuery("SELECT DATABASE()")) {
                    if (rs.next()) out.println("current schema     : " + rs.getString(1));
                }

                int tableCount = 0;
                StringBuilder tables = new StringBuilder();
                try (ResultSet rs = st.executeQuery("SHOW TABLES")) {
                    while (rs.next()) {
                        tableCount++;
                        tables.append("  - ").append(rs.getString(1)).append('\n');
                    }
                }
                out.println("table count        : " + tableCount);
                out.print(tables);

                // Is the admin seed present?
                try (ResultSet rs = st.executeQuery(
                        "SELECT COUNT(*) FROM ACCOUNTS WHERE ACCOUNT_NO = 10000001")) {
                    if (rs.next()) {
                        out.println("admin account 10000001 present : " + (rs.getInt(1) > 0));
                    }
                }
            }

            out.println();
            out.println("RESULT             : HEALTHY");

        } catch (Throwable t) {
            out.println("CONNECTION         : FAILED");
            out.println();
            out.println("=== Real error (root cause the login page hides) ===");
            Throwable cur = t;
            int depth = 0;
            while (cur != null && depth < 8) {
                out.println("[" + depth + "] " + cur.getClass().getName() + ": " + cur.getMessage());
                cur = cur.getCause();
                depth++;
            }
        }
    }

    /** Show only the host:port/db of the JDBC URL, never user/password query params. */
    private static String maskUrl(String url) {
        if (url == null) return "NOT SET";
        int q = url.indexOf('?');
        return q >= 0 ? url.substring(0, q) : url;
    }
}
