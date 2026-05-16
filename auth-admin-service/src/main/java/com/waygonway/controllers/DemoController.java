package com.waygonway.controllers;

import com.waygonway.models.ApiResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/demo")
@CrossOrigin(origins = "*", maxAge = 3600)
public class DemoController {

    
    @GetMapping("/public")
    public ResponseEntity<ApiResponse<Map<String, Object>>> publicEndpoint() {
        Map<String, Object> data = new HashMap<>();
        data.put("message", "This is a public endpoint");
        data.put("service", "auth-admin-service");
        data.put("timestamp", LocalDateTime.now());
        data.put("requiresAuth", false);

        ApiResponse<Map<String, Object>> response = ApiResponse.success("Public endpoint accessed successfully", data);
        response.addMeta("accessedAt", LocalDateTime.now().toString());
        response.addMeta("publicAccess", true);

        return ResponseEntity.ok(response);
    }

    
    @GetMapping("/hello")
    public ResponseEntity<ApiResponse<String>> hello() {
        return ResponseEntity.ok(
                ApiResponse.success("Hello from WaygonWay Auth Admin Service!", "Service is running")
        );
    }

    
    @GetMapping("/system-info")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getSystemInfo() {
        Map<String, Object> systemInfo = new HashMap<>();
        systemInfo.put("service", "auth-admin-service");
        systemInfo.put("version", "1.0.0");
        systemInfo.put("javaVersion", System.getProperty("java.version"));
        systemInfo.put("osName", System.getProperty("os.name"));
        systemInfo.put("osVersion", System.getProperty("os.version"));
        systemInfo.put("timestamp", LocalDateTime.now());

        Runtime runtime = Runtime.getRuntime();
        Map<String, Object> memoryInfo = new HashMap<>();
        memoryInfo.put("maxMemory", runtime.maxMemory() / (1024 * 1024) + " MB");
        memoryInfo.put("totalMemory", runtime.totalMemory() / (1024 * 1024) + " MB");
        memoryInfo.put("freeMemory", runtime.freeMemory() / (1024 * 1024) + " MB");
        systemInfo.put("memoryInfo", memoryInfo);

        ApiResponse<Map<String, Object>> response = ApiResponse.success("System information retrieved", systemInfo);
        response.addMeta("retrievedAt", LocalDateTime.now().toString());

        return ResponseEntity.ok(response);
    }

    
    @GetMapping("/db-test")
    public ResponseEntity<ApiResponse<Map<String, Object>>> testDatabase() {
        try {
            Map<String, Object> dbInfo = new HashMap<>();
            dbInfo.put("status", "connected");
            dbInfo.put("database", "MongoDB");
            dbInfo.put("connectionTime", LocalDateTime.now());
            dbInfo.put("testResult", "success");

            ApiResponse<Map<String, Object>> response = ApiResponse.success("Database connection test successful", dbInfo);
            response.addMeta("testedAt", LocalDateTime.now().toString());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            Map<String, Object> errorInfo = new HashMap<>();
            errorInfo.put("status", "failed");
            errorInfo.put("error", e.getMessage());
            errorInfo.put("testTime", LocalDateTime.now());

            return ResponseEntity.badRequest().body(
                    ApiResponse.error("Database connection failed", errorInfo.toString())
            );
        }
    }

    
    @GetMapping("/status")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getServiceStatus() {
        Map<String, Object> status = new HashMap<>();
        status.put("service", "auth-admin-service");
        status.put("status", "running");
        status.put("uptime", "Service is healthy");
        status.put("endpoints", new String[]{
                "/auth/login", "/auth/register", "/auth/validate",
                "/admin/users", "/admin/statistics", "/demo/public"
        });
        status.put("timestamp", LocalDateTime.now());

        ApiResponse<Map<String, Object>> response = ApiResponse.success("Service status retrieved", status);
        response.addMeta("statusCheckedAt", LocalDateTime.now().toString());
        response.addMeta("healthCheck", "passed");

        return ResponseEntity.ok(response);
    }
}
