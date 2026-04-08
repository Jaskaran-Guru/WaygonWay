package com.waygonway.services;

import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
public class PaymentService {

    @Value("${stripe.secret.key}")
    private String stripeSecretKey;

    @PostConstruct
    public void init() {
        Stripe.apiKey = stripeSecretKey;
    }

    /**
     * Creates a Stripe PaymentIntent or simulates it if missing actual key.
     * @param amount The amount to charge (in dollars, will be converted to cents)
     * @param currency The currency string e.g. "usd"
     * @return A map containing status and clientSecret
     */
    public Map<String, Object> createPaymentIntent(Double amount, String currency) {
        if (stripeSecretKey == null || stripeSecretKey.contains("placeholder") || stripeSecretKey.trim().isEmpty()) {
            return simulatePayment(amount);
        }

        try {
            PaymentIntentCreateParams params = PaymentIntentCreateParams.builder()
                    .setAmount((long) (amount * 100)) // Stripe amounts are in cents
                    .setCurrency(currency)
                    .setAutomaticPaymentMethods(
                        PaymentIntentCreateParams.AutomaticPaymentMethods.builder()
                            .setEnabled(true)
                            .build()
                    )
                    .build();

            PaymentIntent intent = PaymentIntent.create(params);
            
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("status", "PAYMENT_INTENT_CREATED");
            responseData.put("clientSecret", intent.getClientSecret());
            responseData.put("paymentIntentId", intent.getId());
            return responseData;
        } catch (StripeException e) {
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("status", "FAILED");
            errorMap.put("message", e.getMessage());
            return errorMap;
        }
    }

    private Map<String, Object> simulatePayment(Double amount) {
        System.out.println("[SIMULATION] Creating payment intent for $" + amount);
        try { Thread.sleep(500); } catch (InterruptedException ignore) {}

        String mockClientSecret = "pi_mock_" + UUID.randomUUID().toString().replace("-", "") + "_secret_mock";
        String mockIntentId = "pi_mock_" + UUID.randomUUID().toString().replace("-", "");
        
        return Map.of(
            "status", "PAYMENT_INTENT_CREATED",
            "clientSecret", mockClientSecret,
            "paymentIntentId", mockIntentId,
            "simulation", true
        );
    }
}
