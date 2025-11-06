package com.arka.notification.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {
  private static final Logger log = LoggerFactory.getLogger(NotificationController.class);

  @PostMapping("/send")
  public ResponseEntity<?> send(@RequestBody Map<String,Object> payload){
    // Placeholder: in production implement SES / SNS send
    log.info("Received notification request: {}", payload);
    // Example: payload contains type, orderId, email...
    return ResponseEntity.accepted().body(Map.of("status","queued"));
  }
}