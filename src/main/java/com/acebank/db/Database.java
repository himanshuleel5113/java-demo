package com.acebank.db;

import com.acebank.config.AppConfig;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Single HikariCP-backed connection pool for the whole app. Initialises the
 * schema once on first use. All data access goes through {@link #getConnection()}
 * and uses PreparedStatements — no string-concatenated SQL anywhere.
 */
public final class Database {

    private static final Logger log = LoggerFactory.getLogger(Database.class);
    private static volatile HikariDataSource ds;

    private Database() {}

    public static Connection getConnection() throws SQLException {
        return dataSource().getConnection();
    }

    private static HikariDataSource dataSource() throws SQLException {
        HikariDataSource local = ds;
        if (local != null) return local;
        synchronized (Database.class) {
            if (ds == null) {
                ds = build();
                initSchema();
            }
            return ds;
        }
    }

    private static HikariDataSource build() throws SQLException {
        try {
            Class.forName(AppConfig.dbDriver());
            HikariConfig cfg = new HikariConfig();
            cfg.setJdbcUrl(AppConfig.dbUrl());
            cfg.setUsername(AppConfig.dbUser());
            cfg.setPassword(AppConfig.dbPassword());
            cfg.setMaximumPoolSize(15);
            cfg.setMinimumIdle(3);
            cfg.setConnectionTimeout(15_000);
            cfg.setPoolName("acebank-pool");
            log.info("Initialising DB pool for {}", AppConfig.dbUrl());
            return new HikariDataSource(cfg);
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC driver not found: " + AppConfig.dbDriver(), e);
        }
    }

    /** Runs db/schema.sql statement-by-statement, then seeds demo data. */
    private static void initSchema() {
        String sql = readResource("/db/schema.sql");
        if (sql == null) { log.warn("schema.sql not found on classpath"); return; }
        try (Connection c = ds.getConnection()) {
            for (String stmt : splitStatements(sql)) {
                try (Statement s = c.createStatement()) { s.execute(stmt); }
            }
            log.info("Schema initialised");
            DataSeeder.seed(c);
        } catch (SQLException e) {
            log.error("Schema initialisation failed: {}", e.getMessage(), e);
        }
    }

    private static List<String> splitStatements(String sql) {
        List<String> out = new ArrayList<>();
        StringBuilder cur = new StringBuilder();
        for (String line : sql.split("\n")) {
            String trimmed = line.trim();
            if (trimmed.startsWith("--") || trimmed.isEmpty()) continue;
            cur.append(line).append('\n');
            if (trimmed.endsWith(";")) {
                String s = cur.toString().trim();
                out.add(s.substring(0, s.length() - 1)); // drop trailing ';'
                cur.setLength(0);
            }
        }
        return out;
    }

    private static String readResource(String path) {
        try (InputStream in = Database.class.getResourceAsStream(path)) {
            if (in == null) return null;
            try (BufferedReader r = new BufferedReader(new InputStreamReader(in, StandardCharsets.UTF_8))) {
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = r.readLine()) != null) sb.append(line).append('\n');
                return sb.toString();
            }
        } catch (Exception e) {
            return null;
        }
    }

    public static void shutdown() {
        if (ds != null) { ds.close(); ds = null; }
    }
}
