package com.arka.inventory.service;
import com.arka.inventory.model.Product;
import com.arka.inventory.model.StockHistory;
import com.arka.inventory.repository.ProductRepository;
import com.arka.inventory.repository.StockHistoryRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
@Service
public class ProductService {
  private final ProductRepository productRepository;
  private final StockHistoryRepository historyRepository;
  public ProductService(ProductRepository productRepository, StockHistoryRepository historyRepository){
    this.productRepository = productRepository;
    this.historyRepository = historyRepository;
  }
  public Product create(Product p){
    if(p.getPrice().doubleValue() < 0) throw new IllegalArgumentException("Price cannot be negative");
    if(p.getStock() < 0) throw new IllegalArgumentException("Stock cannot be negative");
    return productRepository.save(p);
  }
  @Transactional
  public Product updateStock(Long productId, int delta, String reason){
    Product prod = productRepository.findById(productId).orElseThrow(() -> new IllegalArgumentException("Product not found"));
    int newStock = prod.getStock() + delta;
    if(newStock < 0) throw new IllegalArgumentException("Stock cannot be negative");
    prod.setStock(newStock);
    productRepository.save(prod);
    StockHistory h = new StockHistory();
    h.setProductId(productId);
    h.setQtyChange(delta);
    h.setReason(reason);
    h.setTimestamp(Instant.now());
    historyRepository.save(h);
    return prod;
  }
  public Optional<Product> findById(Long id){ return productRepository.findById(id); }
  public List<Product> listAll(){ return productRepository.findAll(); }
  public List<Product> lowStock(Integer threshold) { return productRepository.findByStockLessThan(threshold); }
}
