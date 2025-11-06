package com.arka.order.service;
import com.arka.order.clients.InventoryClient;
import com.arka.order.model.Order;
import com.arka.order.model.OrderItem;
import com.arka.order.repository.OrderRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.Instant;
@Service
public class OrderService {
  private final OrderRepository orderRepository;
  private final InventoryClient inventoryClient;
  public OrderService(OrderRepository orderRepository, InventoryClient inventoryClient){
    this.orderRepository = orderRepository;
    this.inventoryClient = inventoryClient;
  }
  @Transactional
  public Order createOrder(Order order){
    order.setStatus("PENDING");
    order.setCreatedAt(Instant.now());
    double total = 0;
    if(order.getItems() != null){
      for(OrderItem it : order.getItems()) total += it.getQuantity() * it.getPrice();
    }
    order.setTotal(total);
    Order saved = orderRepository.save(order);
    try {
      if(saved.getItems() != null){
        for(OrderItem it : saved.getItems()){
          inventoryClient.updateStock(it.getProductId(), - it.getQuantity(), "reserve-order-" + saved.getId());
        }
      }
      saved.setStatus("CONFIRMED");
      orderRepository.save(saved);
    } catch (Exception ex) {
      if(saved.getItems() != null){
        for(OrderItem it : saved.getItems()){
          try { inventoryClient.updateStock(it.getProductId(), it.getQuantity(), "compensate-order-" + saved.getId()); }
          catch(Exception e){}
        }
      }
      saved.setStatus("CANCELLED");
      orderRepository.save(saved);
      throw new RuntimeException("Reservation failed: " + ex.getMessage());
    }
    return saved;
  }
}
