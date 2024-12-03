#!/bin/bash
# Example stop script to stop the application
echo "Stopping the application..."
pkill -f 'java -jar /home/ec2-user/app/*.jar'  # Adjust this based on how your app is running
