#!/bin/bash

echo "Starting WaygonWay Services Consolidated..."

# 1. Start Database Service (Port 8083)
echo "Launching Database Service on port 8083..."
java -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -Xmx384m -jar database.jar --server.port=8083 > database.log 2>&1 &
DB_PID=$!

# 2. Start Auth Service (Port 8081)
echo "Launching Auth Service on port 8081..."
java -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -Xmx384m -jar auth.jar --server.port=8081 > auth.log 2>&1 &
AUTH_PID=$!

# 3. Start Booking Service (Port 8082)
echo "Launching Booking Service on port 8082..."
java -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -Xmx384m -jar booking.jar --server.port=8082 > booking.log 2>&1 &
BOOKING_PID=$!

# Wait a few seconds for backends to initialize
sleep 10

# 4. Start API Gateway (Port 7860 - Public)
echo "Launching API Gateway on port 7860..."
java -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -Xmx512m -jar gateway.jar --server.port=7860 --AUTH_SERVICE_URL=http://localhost:8081 --BOOKING_SERVICE_URL=http://localhost:8082 > gateway.log 2>&1 &
GATEWAY_PID=$!

echo "All services launched. Monitoring..."

# Keep the container alive and pipe logs to stdout
# Tailing all logs so user can see them in HF console
tail -f gateway.log auth.log booking.log database.log &

# Wait for the gateway process (main process)
wait $GATEWAY_PID
