#!/bin/bash
JAR_FILE="/home/ec2-user/app/target/my-java-ec2-app-0.0.1-SNAPSHOT.jar"
LOG_FILE="/home/ec2-user/app/app.log"
PORT=8080

# Check if port is in use
if sudo netstat -tuln | grep -q ":$PORT"; then
  echo "Port $PORT is in use. Stopping the process..."
  PID=$(sudo netstat -tuln | grep ":$PORT" | awk '{print $7}' | cut -d '/' -f 1)
  sudo kill -9 "$PID"
  echo "Stopped process $PID."
fi

# Start the application
if [ -f "$JAR_FILE" ]; then
  echo "Found JAR file: $JAR_FILE. Starting the application..."
  nohup java -jar "$JAR_FILE" > "$LOG_FILE" 2>&1 &

  sleep 10

  # Verify application is running
  curl --silent --fail http://localhost:$PORT
  if [ $? -eq 0 ]; then
    echo "Application started successfully and is accessible on port $PORT!"
  else
    echo "Application failed to start or is not accessible. Check logs at $LOG_FILE."
    exit 1
  fi
else
  echo "JAR file not found: $JAR_FILE. Cannot start application."
  exit 1
fi
