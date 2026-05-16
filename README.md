---
title: WaygonWay
emoji: 🎟️
colorFrom: blue
colorTo: indigo
sdk: docker
pinned: false
---

# WaygonWay Ticket Reservation System

WaygonWay is a robust, enterprise-grade microservices-based ticket reservation platform. It is engineered for high scalability, fault tolerance, and secure transaction handling.

## Architecture Overview

The system utilizes a microservices architecture to ensure modularity and ease of maintenance. All external communication is routed through a centralized API Gateway.

### Component Services

- API Gateway (Port 8080): Serves as the primary entry point, handling request routing, security policies, and hosting the web interface.
- Auth Admin Service (Port 8081): Manages identity providers, JWT-based authentication, and administrative user control.
- Booking API Service (Port 8082): Contains the core business logic for event management, transport logistics, and customer support.
- Database Service (Port 8083): Optimized for data-intensive operations and generic persistence layers.

## Technical Specifications

- Backend Framework: Java 17 with Spring Boot 3.x and Spring Cloud.
- Frontend Framework: React with Vite and TypeScript.
- Persistence Layer: MongoDB Atlas (Document-based storage).
- Security: Stateless JWT authentication and TLS-encrypted communication.
- Infrastructure: Docker-ready for containerized deployment across cloud providers.

## Getting Started

### System Requirements

- Java Development Kit (JDK) 17 or higher
- Node.js runtime 18.x or higher
- Apache Maven 3.8+
- Docker (optional for containerization)

### Local Development Setup

1. Clone the repository to your local environment.
2. Execute the integrated build script:
   ./build_all.cmd
3. Launch the microservice cluster:
   ./run_all.cmd

### Docker Deployment

To initialize the entire stack using Docker Compose:
docker-compose up --build

The gateway service will be available at http://localhost:8080.

## API Specification

All service endpoints are exposed through the API Gateway:

- Authentication: /api/v1/auth
- Administrative Tasks: /api/v1/admin
- Booking Operations: /api/v1/bookings
- Event Management: /api/v1/events
- Transport Logistics: /api/v1/transport

## Deployment on Hugging Face

This platform is optimized for Hugging Face Spaces.

1. Initialize a new Docker Space on Hugging Face.
2. Synchronize the repository contents.
3. Configure the following Environment Secrets:
   - MONGODB_URI: Database connection string.
   - JWT_SECRET: Security token signature key.
4. The system will automatically build and deploy the consolidated container.

## Project Structure

- api-gateway/: Edge service and frontend distribution.
- auth-admin-service/: Identity and access management.
- booking-api-service/: Core business logic.
- database-service/: Data persistence utilities.
- frontend-service/: React-based user interface.
- shared-config/: Centralized configuration management.
