---
title: WaygonWay
emoji: 🚀
colorFrom: blue
colorTo: indigo
sdk: docker
pinned: false
---

# WaygonWay - Ticket Reservation System 🎫

WaygonWay is a modern, microservices-based ticket reservation system designed for high scalability and reliability. It provides a comprehensive platform for booking events, managing user authentication, and performing administrative tasks.

## 🏗️ Architecture Overview

The project is built using a microservices architecture, with several independent services communicating through an API Gateway.

### Services:

- **[API Gateway](file:///d:/Projects/WaygonWay/api-gateway)** (Port 8080): The primary entry point for all client requests. It handles routing, global CORS configuration, and hosts the integrated React frontend in production.
- **[Auth Admin Service](file:///d:/Projects/WaygonWay/auth-admin-service)** (Port 8081): Manages user authentication (JWT-based), registration, and administrative user management tasks.
- **[Booking API Service](file:///d:/Projects/WaygonWay/booking-api-service)** (Port 8082): Handles all booking-related logic, including event management, transport scheduling, and support.
- **[Database Service](file:///d:/Projects/WaygonWay/database-service)** (Port 8083): A dedicated service for data-intensive operations and generic database access.
- **[Frontend Service](file:///d:/Projects/WaygonWay/frontend-service)**: A modern React application that provides a responsive and user-friendly interface.

## 🛠️ Technology Stack

- **Backend**: Java 17, [Spring Boot 3.1.5](https://spring.io/projects/spring-boot), [Spring Cloud 2022.0.4](https://spring.io/projects/spring-cloud).
- **Frontend**: [React](https://reactjs.org/) (Vite), Node.js.
- **Database**: [MongoDB](https://www.mongodb.com/) (hosted on Atlas).
- **Security**: JWT (JSON Web Tokens) for secure, stateless authentication.
- **Containerization**: [Docker](https://www.docker.com/) and Docker Compose for easy deployment.

## 🚀 Getting Started

### Prerequisites

- **Java 17** or higher
- **Node.js 18** or higher
- **Maven 3.8+**
- **Docker** (optional, for containerized execution)

### How to Run (Local Development)

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd WaygonWay
    ```

2.  **Build all services**:
    Use the provided batch script to build all Java services and the React frontend:
    ```bash
    ./build_all.cmd
    ```
    *This script builds Maven jars and copies the frontend production build to the API Gateway.*

3.  **Run all services**:
    After building, start the entire system with:
    ```bash
    ./run_all.cmd
    ```
    *This will start each service in a separate window.*

### How to Run (Docker)

To run the entire stack using Docker Compose:
```bash
docker-compose up --build
```
The API Gateway will be accessible at `http://localhost:8080`.

## 📡 API Endpoints (via Gateway)

All API requests should be directed to the Gateway at `http://localhost:8080`.

- **Authentication**: `/api/v1/auth/**`
- **Admin (Users)**: `/api/v1/admin/users/**`
- **Bookings**: `/api/v1/bookings/**`
- **Events**: `/api/v1/events/**`
- **Transport**: `/api/v1/transport/**`

## 📂 Project Structure

```text
WaygonWay/
├── api-gateway/           # Spring Cloud Gateway & Frontend Host
├── auth-admin-service/    # User & Admin Management
├── booking-api-service/   # Booking Core Logic
├── database-service/      # Data Utility Service
├── frontend-service/      # React Frontend Application
├── shared-config/         # Common Configuration files
├── docker-compose.yml     # Docker Orchestration
├── build_all.cmd          # Automated Build Script
├── run_all.cmd            # Automated Start Script
└── Dockerfile             # Consolidated HF Deployment
```

## 🤗 Hugging Face Deployment

This project is optimized for deployment on **Hugging Face Spaces** using Docker. All services run consolidated in a single Space for maximum stability and free-tier efficiency.

### Deployment Steps:

1.  **Create a New Space**: Go to Hugging Face, click "New Space", and select **Docker** as the SDK.
2.  **Upload Files**: Upload the entire repository (including `Dockerfile` and `start.sh`) to the Space.
3.  **Configure Secrets**: Go to **Settings > Variables and secrets** in your Space and add the following:
    - `MONGODB_URI`: Your MongoDB Atlas connection string.
    - `JWT_SECRET`: A secure random string for tokens.
    - `STRIPE_SECRET_KEY`: (Optional) Your Stripe secret key.
4.  **Wait for Build**: Hugging Face will automatically build the image and start the services.

The application will be available at `https://<your-username>-<space-name>.hf.space`.


