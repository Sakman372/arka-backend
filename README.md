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
