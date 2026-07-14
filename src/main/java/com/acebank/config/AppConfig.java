package com.acebank.config;

import java.io.InputStream;
import java.util.Properties;

/**
 * Central configuration. Values resolve in this order:
 *   1. environment variable (e.g. DB_URL)      — preferred for deployment
 *   2. application.properties on the classpath  — local dev (git-ignored)
 *   3. hard default
 * No secrets are ever committed; only application.properties.template is.
 */
public final class AppConfig {

    private static final Properties PROPS = new Properties();

    static {
        try (InputStream in = AppConfig.class.getResourceAsStream("/application.properties")) {
            if (in != null) PROPS.load(in);
        } catch (Exception ignored) {
            // absent in deployment — env vars take over
        }
    }

    private AppConfig() {}

    /** Look up a key by env var (KEY_LIKE_THIS) then properties (key.like.this). */
    public static String get(String propKey, String def) {
        String envKey = propKey.toUpperCase().replace('.', '_');
        String v = System.getenv(envKey);
        if (v == null || v.isBlank()) v = PROPS.getProperty(propKey);
        return (v == null || v.isBlank()) ? def : v.trim();
    }

    public static String dbUrl()      { return get("db.url", "jdbc:mysql://localhost:3306/acebank"); }
    public static String dbUser()     { return get("db.user", "root"); }
    public static String dbPassword() { return get("db.password", ""); }
    public static String dbDriver()   { return get("db.driver", "com.mysql.cj.jdbc.Driver"); }
}
