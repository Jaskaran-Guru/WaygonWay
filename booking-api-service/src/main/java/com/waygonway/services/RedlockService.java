package com.waygonway.services;

import org.springframework.stereotype.Service;
import java.time.Duration;


@Service
public class RedlockService {

    
    public boolean acquireLock(String lockKey, Duration timeoutDuration) {
        
        return true;
    }

    
    public void releaseLock(String lockKey) {
        
    }
}
