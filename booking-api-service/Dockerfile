# Stage 1: Build
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY booking-api-service/pom.xml booking-api-service/
COPY auth-admin-service/pom.xml auth-admin-service/
COPY api-gateway/pom.xml api-gateway/
COPY database-service/pom.xml database-service/
COPY frontend-service/pom.xml frontend-service/
RUN mvn dependency:go-offline -B
COPY booking-api-service/src booking-api-service/src
RUN mvn package -pl booking-api-service -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/booking-api-service/target/booking-api-service-1.0.0.jar app.jar
EXPOSE 10000
ENTRYPOINT ["java", \
  "-XX:TieredStopAtLevel=1", \
  "-XX:+UseSerialGC", \
  "-Xmx256m", \
  "-Djava.security.egd=file:/dev/./urandom", \
  "-jar", "app.jar"]
