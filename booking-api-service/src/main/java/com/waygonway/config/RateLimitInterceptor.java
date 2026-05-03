package com.waygonway.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@Component
public class RateLimitInterceptor implements HandlerInterceptor {

    private final ConcurrentHashMap<String, AtomicInteger> requestCounts = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, Long> timestamps = new ConcurrentHashMap<>();

    // 300 requests per minute per real client IP
    private static final int MAX_REQUESTS = 300;
    private static final long TIME_WINDOW_MS = 60_000L;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // Resolve real client IP: honour X-Real-IP first, then X-Forwarded-For, then socket address.
        // This is critical when the service sits behind the API gateway — without this, ALL users
        // share one rate-limit bucket (the gateway's own IP).
        String ip = resolveClientIp(request);

        long currentTime = System.currentTimeMillis();

        timestamps.putIfAbsent(ip, currentTime);
        requestCounts.putIfAbsent(ip, new AtomicInteger(0));

        // Reset window when the time window has elapsed for this IP
        long windowStart = timestamps.get(ip);
        if (currentTime - windowStart > TIME_WINDOW_MS) {
            timestamps.put(ip, currentTime);
            requestCounts.get(ip).set(0);
        }

        int count = requestCounts.get(ip).incrementAndGet();
        if (count > MAX_REQUESTS) {
            long resetInSeconds = (TIME_WINDOW_MS - (currentTime - timestamps.get(ip))) / 1000;
            response.setStatus(HttpStatus.TOO_MANY_REQUESTS.value());
            response.setHeader("Retry-After", String.valueOf(Math.max(resetInSeconds, 1)));
            response.setHeader("X-RateLimit-Limit", String.valueOf(MAX_REQUESTS));
            response.setHeader("X-RateLimit-Remaining", "0");
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Too Many Requests\",\"message\":\"Rate limit exceeded. Please try again later.\"}");
            return false;
        }

        // Attach informational headers so clients can self-throttle
        response.setHeader("X-RateLimit-Limit", String.valueOf(MAX_REQUESTS));
        response.setHeader("X-RateLimit-Remaining", String.valueOf(MAX_REQUESTS - count));

        return true;
    }

    /**
     * Resolves the real end-user IP address.
     * Priority: X-Real-IP → first value in X-Forwarded-For → socket remote address.
     */
    private String resolveClientIp(HttpServletRequest request) {
        String realIp = request.getHeader("X-Real-IP");
        if (realIp != null && !realIp.isBlank()) {
            return realIp.trim();
        }

        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.isBlank()) {
            // X-Forwarded-For may be a comma-separated list; the first entry is the originating client
            return forwardedFor.split(",")[0].trim();
        }

        return request.getRemoteAddr();
    }
}
