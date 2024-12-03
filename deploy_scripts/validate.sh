#!/bin/bash

# Load the environment variables
source /home/ec2-user/.bash_profile

# Change to the application directory
cd /home/ec2-user/app/target

# Check if the JAR file exists
if [ -f "my-java-ec2-app-0.0.1-SNAPSHOT.jar" ]; then
  echo "JAR file found. Attempting to access the application..."

  # Start the application (replace with your actual startup command)
  java -jar my-java-ec2-app-0.0.1-SNAPSHOT.jar &

  # Allow some time for the application to start
  sleep 10

  # Check if the application is running on port 8080
  curl --silent --fail http://localhost:8080 && echo "Application is running!" || echo "Failed to access application on port 8080."
else
  echo "JAR file not found in /home/ec2-user/app/target."
  exit 1
fi
