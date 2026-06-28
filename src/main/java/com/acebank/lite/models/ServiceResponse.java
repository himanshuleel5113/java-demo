package com.acebank.lite.models;

/**
 * Generic service-layer response carrier.
 *
 * <p>Holds a success flag, a human-readable message and an optional typed
 * payload. Construct via the {@link #success} / {@link #error} factories rather
 * than the canonical constructor.
 *
 * @param <T> type of the data payload (use {@code Void} when there is none)
 */
public record ServiceResponse<T>(boolean success, String message, T data) {

    public static <T> ServiceResponse<T> success(T data, String message) {
        return new ServiceResponse<>(true, message, data);
    }

    public static <T> ServiceResponse<T> success(String message) {
        return new ServiceResponse<>(true, message, null);
    }

    public static <T> ServiceResponse<T> error(String message) {
        return new ServiceResponse<>(false, message, null);
    }
}
