package com.waygonway.gateway.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.web.reactive.error.ErrorWebExceptionHandler;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.nio.charset.StandardCharsets;

@Component
@Order(-2)
public class GatewayExceptionHandler implements ErrorWebExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GatewayExceptionHandler.class);

    @Override
    public Mono<Void> handle(ServerWebExchange exchange, Throwable ex) {
        logger.error("Gateway Error: {} - URI: {}", ex.getMessage(), exchange.getRequest().getURI());
        
        if (ex instanceof java.net.ConnectException || ex instanceof java.net.SocketTimeoutException) {
            logger.error("Connectivity Issue: The downstream service might be down or unreachable.");
        }

        byte[] bytes = String.format("{\"status\": 500, \"error\": \"Internal Server Error\", \"message\": \"%s\"}", 
                                   ex.getMessage().replace("\"", "'")).getBytes(StandardCharsets.UTF_8);
        
        DataBuffer buffer = exchange.getResponse().bufferFactory().wrap(bytes);
        exchange.getResponse().setStatusCode(HttpStatus.INTERNAL_SERVER_ERROR);
        exchange.getResponse().getHeaders().setContentType(MediaType.APPLICATION_JSON);
        
        return exchange.getResponse().writeWith(Mono.just(buffer));
    }
}
