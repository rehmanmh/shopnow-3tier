# ShopNow — 3-Tier E-commerce App

A real 3-tier architecture built as the sample application for a real-time DevOps CI/CD project:

**GitHub → Jenkins → Docker Hub → AWS EKS → Prometheus/Grafana → OpenTelemetry/Jaeger**

```
┌─────────────────────┐      ┌──────────────────────┐      ┌──────────────┐
│  Tier 1: Presentation │ ---> │ Tier 2: Business Logic│ ---> │ Tier 3: Data │
│  Java Spring Boot      │      │  Node.js / Express     │      │  PostgreSQL   │
│  + Thymeleaf (port 8080)│      │  REST API (port 4000)  │      │  (port 5432)  │
└─────────────────────┘      └──────────────────────┘      └──────────────┘
```

## Project Structure

```
shopnow-3tier/
├── frontend-java/        # Tier 1 - Spring Boot + Thymeleaf, renders HTML
│   ├── pom.xml
│   └── src/main/java/com/shopnow/frontend/
│       ├── controller/    # ProductController - handles / and /product/{id}
│       ├── service/       # ProductService - calls backend REST API
│       ├── model/         # Product DTO
│       └── config/        # RestTemplate bean
├── backend-node/          # Tier 2 - Express REST API, business logic
│   ├── package.json
│   ├── .env.example
│   └── src/
│       ├── server.js
│       ├── routes/products.js
│       └── db/pool.js     # Postgres connection pool
├── database/
│   └── init.sql           # Schema + seed data for the products table
└── README.md
```

## Run locally (all 3 tiers, no Docker yet)

### 1. Database tier
```bash
sudo service postgresql start
sudo -u postgres psql -c "CREATE USER shopnow WITH PASSWORD 'shopnow_pass';"
sudo -u postgres psql -c "CREATE DATABASE shopnow_db OWNER shopnow;"
psql -U shopnow -d shopnow_db -h localhost -f database/init.sql
```

### 2. Backend tier (Node.js)
```bash
cd backend-node
cp .env.example .env
npm install
npm start
```
Verify: `curl http://localhost:4000/health` and `curl http://localhost:4000/api/products`

### 3. Frontend tier (Java Spring Boot)
```bash
cd frontend-java
mvn spring-boot:run
```
Open: http://localhost:8080

The frontend reads the backend URL from `backend.api.baseurl` (env var `BACKEND_API_URL`, defaults to `http://localhost:4000`) — this is what we'll point at a Kubernetes service name later once it's deployed to EKS.

## Health checks (for later k8s probes)

| Tier | Endpoint |
|---|---|
| Frontend | `http://localhost:8080/actuator/health` |
| Backend | `http://localhost:4000/health` |
| Database | `pg_isready -U shopnow -d shopnow_db` |
