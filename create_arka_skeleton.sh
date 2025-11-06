#!/usr/bin/env bash
set -e
ROOT_DIR="$(pwd)"
echo "Generando estructura ARKA en $ROOT_DIR"

# Crea carpetas
mkdir -p eureka-server/src/main/java/com/arka/eureka eureka-server/src/main/resources
mkdir -p gateway/src/main/java/com/arka/gateway gateway/src/main/resources
mkdir -p inventory-service/src/main/java/com/arka/inventory/{controller,service,model,repository} inventory-service/src/main/resources
mkdir -p order-service/src/main/java/com/arka/order/{controller,service,model,clients,repository} order-service/src/main/resources
mkdir -p auth-service notification-service catalog-bff-web catalog-bff-mobile review-service terraform .github/workflows

# README
cat > README.md <<'EOF'
# ARKA Backend - Microservices (Spring Boot)

Proyecto microservicios para ARKA (distribuidora de accesorios para PC).

Servicios incluidos:
- eureka-server (Service Discovery)
- gateway (Spring Cloud Gateway)
- inventory-service (Productos, stock, historial)
- order-service (Órdenes, saga orquestada simple)
- auth-service (JWT básico)
- notification-service (SES/SNS placeholders)
- catalog-bff-web, catalog-bff-mobile (BFF skeleton)
- review-service (MongoDB)
- docker-compose para desarrollo local
- terraform/ (skeleton para AWS infra)
- .github/workflows (CI skeleton)
EOF

# .gitignore
cat > .gitignore <<'EOF'
target/
*.log
*.tmp
*.class
.idea/
.vscode/
*.iml
docker-compose.override.yml
.DS_Store
EOF

# docker-compose (simplificado)
cat > docker-compose.yml <<'EOF'
version: '3.8'
services:
  postgres-inventory:
    image: postgres:14
    environment:
      POSTGRES_DB: inventorydb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"

  postgres-order:
    image: postgres:14
    environment:
      POSTGRES_DB: orderdb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5433:5432"

  mongo:
    image: mongo:6
    ports:
      - "27017:27017"
EOF

# Terraform skeleton
cat > terraform/main.tf <<'EOF'
# Terraform skeleton - completa variables y módulos según tu VPC
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
# Añade recursos: RDS, ECR, ECS, SQS, SNS, S3, Lambda...
EOF

# Simple sample Java files (Eureka and Gateway mains)
cat > eureka-server/src/main/java/com/arka/eureka/EurekaServerApplication.java <<'EOF'
package com.arka.eureka;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(EurekaServerApplication.class, args);
    }
}
EOF

cat > eureka-server/src/main/resources/application.yml <<'EOF'
server:
  port: 8761

eureka:
  instance:
    hostname: localhost
  client:
    register-with-eureka: false
    fetch-registry: false
    service-url:
      defaultZone: http://localhost:8761/eureka/
EOF

cat > gateway/src/main/java/com/arka/gateway/GatewayApplication.java <<'EOF'
package com.arka.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class GatewayApplication {
  public static void main(String[] args) {
    SpringApplication.run(GatewayApplication.class, args);
  }
}
EOF

cat > gateway/src/main/resources/application.yml <<'EOF'
server:
  port: 8080

spring:
  cloud:
    gateway:
      routes:
        - id: inventory
          uri: lb://inventory-service
          predicates:
            - Path=/api/products/**

        - id: orders
          uri: lb://order-service
          predicates:
            - Path=/api/orders/**

eureka:
  client:
    service-url:
      defaultZone: http://localhost:8761/eureka/
EOF

# Minimal sample for inventory and orders (main classes, one controller/service each)
cat > inventory-service/src/main/java/com/arka/inventory/InventoryApplication.java <<'EOF'
package com.arka.inventory;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class InventoryApplication {
  public static void main(String[] args) {
    SpringApplication.run(InventoryApplication.class, args);
  }
}
EOF

cat > inventory-service/src/main/resources/application.yml <<'EOF'
server:
  port: 8081

spring:
  datasource:
    url: jdbc:postgresql://postgres-inventory:5432/inventorydb
    username: postgres
    password: postgres
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true

eureka:
  client:
    service-url:
      defaultZone: http://eureka:8761/eureka/
EOF

cat > order-service/src/main/java/com/arka/order/OrderApplication.java <<'EOF'
package com.arka.order;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableDiscoveryClient
@EnableFeignClients
public class OrderApplication {
  public static void main(String[] args){
    SpringApplication.run(OrderApplication.class, args);
  }
}
EOF

cat > order-service/src/main/resources/application.yml <<'EOF'
server:
  port: 8082

spring:
  datasource:
    url: jdbc:postgresql://postgres-order:5432/orderdb
    username: postgres
    password: postgres
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true

eureka:
  client:
    service-url:
      defaultZone: http://eureka:8761/eureka/
EOF

echo "Archivos generados. Revisa, añade más archivos según necesites."