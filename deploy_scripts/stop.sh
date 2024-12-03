#!/bin/bash
# Example stop script to stop the application

JAR_FILE="/home/ec2-user/app/target/my-java-ec2-app-0.0.1-SNAPSHOT.jar"

# Check if the JAR file exists
if [ -f "$JAR_FILE" ]; then
  echo "Found JAR file: $JAR_FILE. Stopping the application..."
  pkill -f "java -jar $JAR_FILE"  # Stop the Java process running the JAR file
else
  echo "JAR file not found: $JAR_FILE. Cannot stop application."
fi
