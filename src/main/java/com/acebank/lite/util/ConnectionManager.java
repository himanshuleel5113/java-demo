package com.acebank.lite.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.apache.ibatis.jdbc.ScriptRunner;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Logger;

public final class ConnectionManager {

    private static HikariDataSource dataSource;
    private static boolean isSchemaInitialized = false;
    static final Logger log = Logger.getLogger(ConnectionManager.class.getName());

    private ConnectionManager() {}

    private static synchronized void initDataSource() throws SQLException {
        if (dataSource != null) {
            return;
        }
        
        try {
            String url = ConfigLoader.getProperty(ConfigKeys.DB_URL);
            String user = ConfigLoader.getProperty(ConfigKeys.DB_USER);
            String pass = ConfigLoader.getProperty(ConfigKeys.DB_PWD);
            String driverName = ConfigLoader.getProperty(ConfigKeys.DB_MYSQL_DRIVER);

            if (url == null || user == null || pass == null) {
                throw new SQLException("Database configuration missing. Check application-dev.properties");
            }

            Class.forName(driverName); // Ensure driver is loaded

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(url);
            config.setUsername(user);
            config.setPassword(pass);
            config.setDriverClassName(driverName);
            
            // Pool configuration
            config.setMaximumPoolSize(20);
            config.setMinimumIdle(5);
            config.setIdleTimeout(300000);
            config.setConnectionTimeout(20000);
            config.setMaxLifetime(1200000);

            dataSource = new HikariDataSource(config);
            log.info("HikariCP Connection Pool initialized for: " + url);

            // Run schema init on startup
            if (!isSchemaInitialized) {
                try (Connection conn = dataSource.getConnection()) {
                    runInitScript(conn);
                    isSchemaInitialized = true;
                }
            }

        } catch (ClassNotFoundException e) {
            log.severe("JDBC Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found", e);
        } catch (Exception e) {
            log.severe("Failed to initialize connection pool: " + e.getMessage());
            throw new SQLException("Could not initialize connection pool", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            initDataSource();
        }
        return dataSource.getConnection();
    }

    private static void runInitScript(Connection conn) {
        String scriptPath = ConfigLoader.getProperty(ConfigKeys.DB_SCRIPT_PATH);
        if (scriptPath == null || scriptPath.isEmpty()) {
            log.warning("No script path configured, skipping schema initialization");
            return;
        }

        String normalizedPath = scriptPath.startsWith("/") ? scriptPath : "/" + scriptPath;
        log.info("Attempting to run schema script from: " + normalizedPath);

        try (InputStream is = ConnectionManager.class.getResourceAsStream(normalizedPath)) {
            if (is == null) {
                log.warning("Schema script not found at: " + normalizedPath);
                log.warning("Please create tables manually in MySQL");
                return;
            }

            ScriptRunner runner = new ScriptRunner(conn);
            runner.setLogWriter(null);
            runner.setErrorLogWriter(null);
            runner.setStopOnError(false);
            runner.setThrowWarning(false);
            runner.setAutoCommit(true);
            // Run statement-by-statement (split on ';'). sendFullScript(true) sent the whole
            // multi-statement file as ONE JDBC call, which fails unless the URL enables
            // allowMultiQueries — that is why the schema never actually got created on startup.
            runner.setSendFullScript(false);

            log.info("Executing schema script...");
            runner.runScript(new BufferedReader(new InputStreamReader(is)));
            log.info("Database schema script executed successfully");

            // Verify tables were created
            try (var stmt = conn.createStatement(); var rs = stmt.executeQuery("SHOW TABLES")) {
                log.info("Tables in database:");
                while (rs.next()) {
                    log.info("  - " + rs.getString(1));
                }
            }

        } catch (Exception e) {
            log.severe("Schema initialization error: " + e.getMessage());
            log.severe("Please create tables manually in MySQL");
        }
    }
}