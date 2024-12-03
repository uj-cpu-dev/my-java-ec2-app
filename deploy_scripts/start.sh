#!/bin/bash
# Example start script to start the Java application
echo "Starting the application..."
nohup java -jar /home/ec2-user/app/*.jar > /home/ec2-user/app/app.log 2>&1 &
