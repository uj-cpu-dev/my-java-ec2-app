#!/bin/bash

# Load environment variables
source /home/ec2-user/.bash_profile

# Change to the target directory where the JAR file is located
cd /home/ec2-user/app/target

# Check if the JAR file exists
if [ -f "my-java-ec2-app-0.0.1-SNAPSHOT.jar" ]; then
  echo "Starting the application..."

  # Start the application in the background
  nohup java -jar my-java-ec2-app-0.0.1-SNAPSHOT.jar > /home/ec2-user/app/app.log 2>&1 &

  # Allow some time for the application to start
  sleep 10

  # Check if the application is running on port 8080
  if curl --silent --fail http://localhost:8080; then
    echo "Application started successfully and is accessible!"
  else
    echo "Application started but is not accessible. Check the logs for more details."
    exit 1
  fi
else
  echo "JAR file not found in /home/ec2-user/app/target."
  exit 1
fi
