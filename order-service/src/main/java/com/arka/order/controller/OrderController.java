package com.arka.order.controller;
import com.arka.order.model.Order;
import com.arka.order.service.OrderService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("/api/orders")
public class OrderController {
  private final OrderService orderService;
  public OrderController(OrderService orderService){ this.orderService = orderService; }
  @PostMapping
  public ResponseEntity<?> create(@RequestBody Order order){
    try {
      Order o = orderService.createOrder(order);
      return ResponseEntity.status(201).body(o);
    } catch (RuntimeException ex){
      return ResponseEntity.status(409).body(ex.getMessage());
    }
  }
}
