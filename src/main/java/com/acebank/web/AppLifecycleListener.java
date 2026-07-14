package com.acebank.web;

import com.acebank.db.Database;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;

/** Initialises the DB pool + schema at startup and closes it on shutdown. */
@WebListener
public class AppLifecycleListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try (Connection ignored = Database.getConnection()) {
            sce.getServletContext().log("AceBank: database ready");
        } catch (Exception e) {
            sce.getServletContext().log("AceBank: database init failed - " + e.getMessage(), e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        Database.shutdown();
    }
}
