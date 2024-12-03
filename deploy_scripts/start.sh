#!/bin/bash
# Script to start the Java application

JAR_FILE="/home/ec2-user/app/target/my-java-ec2-app-0.0.1-SNAPSHOT.jar"
LOG_FILE="/home/ec2-user/app/app.log"

# Check if the JAR file exists
if [ -f "$JAR_FILE" ]; then
  echo "Found JAR file: $JAR_FILE. Starting the application..."

  # Start the application in the background and redirect logs
  nohup java -jar "$JAR_FILE" > "$LOG_FILE" 2>&1 &

  # Allow some time for the application to start
  sleep 10

  # Check if the application is running on port 8080 (or your app's port)
  if curl --silent --fail http://localhost:8080; then
    echo "Application started successfully and is accessible!"
  else
    echo "Application failed to start or is not accessible. Check the logs at $LOG_FILE."
    exit 1
  fi
else
  echo "JAR file not found: $JAR_FILE. Cannot start application."
  exit 1
fi
