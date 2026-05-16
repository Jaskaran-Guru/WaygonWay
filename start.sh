

echo "Starting WaygonWay Services Consolidated..."


echo "Launching Database Service on port 8083..."
java -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -Xmx384m -jar database.jar --server.port=8083 > database.log 2>&1 &
DB_PID=$!


echo "Launching Auth Service on port 8081..."
java -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -Xmx384m -jar auth.jar --server.port=8081 > auth.log 2>&1 &
AUTH_PID=$!


echo "Launching Booking Service on port 8082..."
java -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -Xmx384m -jar booking.jar --server.port=8082 > booking.log 2>&1 &
BOOKING_PID=$!


sleep 10


echo "Launching API Gateway on port 7860..."
java -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -Xmx512m -jar gateway.jar --server.port=7860 --AUTH_SERVICE_URL=http://localhost:8081 --BOOKING_SERVICE_URL=http://localhost:8082 > gateway.log 2>&1 &
GATEWAY_PID=$!

echo "All services launched. Monitoring..."



tail -f gateway.log auth.log booking.log database.log &


wait $GATEWAY_PID
