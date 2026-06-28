package com.acebank.lite.util;

import org.yaml.snakeyaml.Yaml;

import java.io.InputStream;
import java.util.Map;

public class QueryLoader {
    private static final Map<String, Object> queries;
    private static final String QUERIES_FILE_PATH = "sql/queries.yaml";

    static {
        try (InputStream in = QueryLoader.class.getClassLoader().getResourceAsStream(QUERIES_FILE_PATH)) {
            if (in == null) throw new RuntimeException(QUERIES_FILE_PATH + " not found in resources!");
            queries = new Yaml().load(in);
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize QueryLoader", e);
        }
    }

    @SuppressWarnings("unchecked")
    public static String get(String path) {
        String[] keys = path.split("\\.");
        Object current = queries;
        for (String key : keys) {
            if (current instanceof Map) {
                current = ((Map<String, Object>) current).get(key);
            } else {
                return null;
            }
        }
        return current instanceof String ? (String) current : null;
    }

    /**
     * Null-safe lookup. Returns the configured query for {@code path}, or
     * {@code null} when it is not present so callers can fall back to an inline
     * default.
     */
    public static String getQuery(String path) {
        return get(path);
    }
}