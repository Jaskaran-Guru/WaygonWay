package com.waygonway.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ApiGatewayApplication {
    public static void main(String[] args) {
        
        System.setProperty("reactor.netty.http.server.accessLogEnabled", "true");
        
        System.setProperty("sun.net.spi.nameservice.nameservers", "8.8.8.8,1.1.1.1"); 
        
        SpringApplication.run(ApiGatewayApplication.class, args);
    }
}
