package com.my_java_ec2_app.my_java_ec2_app;

import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.context.annotation.Configuration;

@Configuration
public class CustomHealthIndicator implements HealthIndicator {

    @Override
    public Health health() {
        // Check your service health here (e.g., DB connection, etc.)
        boolean isHealthy = true; // Example check

        if (isHealthy) {
            return Health.up().withDetail("Custom Health Check", "Service is healthy").build();
        } else {
            return Health.down().withDetail("Custom Health Check", "Service is unhealthy").build();
        }
    }
    
}
