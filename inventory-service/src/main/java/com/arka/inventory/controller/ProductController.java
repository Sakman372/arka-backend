package com.arka.inventory.controller;
import com.arka.inventory.model.Product;
import com.arka.inventory.service.ProductService;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import java.net.URI;
import java.util.List;
@RestController
@RequestMapping("/api/products")
public class ProductController {
  private final ProductService productService;
  public ProductController(ProductService productService){ this.productService = productService; }
  @PostMapping
  public ResponseEntity<Product> create(@Validated @RequestBody Product p){
    Product created = productService.create(p);
    return ResponseEntity.created(URI.create("/api/products/" + created.getId())).body(created);
  }
  @GetMapping
  public List<Product> list(){ return productService.listAll(); }
  @GetMapping("/{id}")
  public ResponseEntity<Product> get(@PathVariable Long id){
    return productService.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }
  @PutMapping("/{id}/stock")
  public ResponseEntity<?> updateStock(@PathVariable Long id, @RequestParam int delta, @RequestParam(required=false) String reason){
    try{
      Product updated = productService.updateStock(id, delta, reason == null ? "manual" : reason);
      return ResponseEntity.ok(updated);
    }catch(IllegalArgumentException ex){
      return ResponseEntity.badRequest().body(ex.getMessage());
    }
  }
  @GetMapping("/low-stock")
  public List<Product> lowStock(@RequestParam(defaultValue = "10") Integer threshold){
    return productService.lowStock(threshold);
  }
}
