# Stage 1: Build the React Frontend
FROM node:20-alpine AS frontend-build
WORKDIR /app
COPY frontend-service/react-app/package*.json ./
RUN npm install
COPY frontend-service/react-app/ ./
RUN npm run build

# Stage 2: Build all Java Services
FROM maven:3.8.4-openjdk-17 AS backend-build
WORKDIR /app
# Copy poms first for caching
COPY pom.xml .
COPY api-gateway/pom.xml api-gateway/
COPY auth-admin-service/pom.xml auth-admin-service/
COPY booking-api-service/pom.xml booking-api-service/
COPY database-service/pom.xml database-service/
COPY frontend-service/pom.xml frontend-service/

# Build dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY . .

# Copy frontend build to api-gateway static resources so it's bundled in the jar
COPY --from=frontend-build /app/dist api-gateway/src/main/resources/static/

# Build all modules
RUN mvn package -DskipTests

# Stage 3: Runtime
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Install bash for the startup script
RUN apk add --no-cache bash

# Copy the 4 service jars
COPY --from=backend-build /app/api-gateway/target/api-gateway-*.jar gateway.jar
COPY --from=backend-build /app/auth-admin-service/target/auth-admin-service-*.jar auth.jar
COPY --from=backend-build /app/booking-api-service/target/booking-api-service-*.jar booking.jar
COPY --from=backend-build /app/database-service/target/database-service-*.jar database.jar

# Copy the startup script
COPY start.sh .
RUN chmod +x start.sh

# Expose the Gateway port (Hugging Face default)
EXPOSE 7860

# Environment variables for internal communication
ENV PORT=7860
ENV AUTH_SERVICE_URL=http://localhost:8081
ENV BOOKING_SERVICE_URL=http://localhost:8082
ENV DATABASE_SERVICE_URL=http://localhost:8083

CMD ["./start.sh"]
