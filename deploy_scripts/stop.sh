#!/bin/bash

# Load environment variables
source /home/ec2-user/.bash_profile

# Find the process running the JAR file
echo "Stopping the application..."
pid=$(pgrep -f 'java -jar /home/ec2-user/app/target/my-java-ec2-app-0.0.1-SNAPSHOT.jar')

if [ -n "$pid" ]; then
  echo "Found process ID: $pid. Terminating..."
  kill -9 $pid
  echo "Application stopped successfully."
else
  echo "No running application process found."
fi
