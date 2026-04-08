# Stage 1: Build the React Frontend
FROM node:20-alpine AS frontend-build
WORKDIR /app
COPY frontend-service/react-app/package*.json ./
RUN npm install
COPY frontend-service/react-app/ ./
RUN npm run build

# Stage 2: Build the Java API Gateway
FROM maven:3.8.4-openjdk-17 AS backend-build
WORKDIR /app
# Copy the parent pom and all module poms first for better caching
COPY pom.xml .
COPY api-gateway/pom.xml api-gateway/
COPY auth-admin-service/pom.xml auth-admin-service/
COPY booking-api-service/pom.xml booking-api-service/
COPY database-service/pom.xml database-service/
COPY frontend-service/pom.xml frontend-service/

# Build dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY api-gateway/src api-gateway/src

# Copy frontend build to api-gateway static resources
COPY --from=frontend-build /app/dist /app/api-gateway/src/main/resources/static

# Build the gateway
RUN mvn package -pl api-gateway -DskipTests

# Stage 3: Runtime
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=backend-build /app/api-gateway/target/api-gateway-1.0.0.jar app.jar
EXPOSE 10000
ENTRYPOINT ["java", \
  "-XX:TieredStopAtLevel=1", \
  "-XX:+UseSerialGC", \
  "-Xmx256m", \
  "-Djava.security.egd=file:/dev/./urandom", \
  "-jar", "app.jar"]
