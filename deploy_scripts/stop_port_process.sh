#!/bin/bash

PORT=8080  # Define the port you want to check

echo "Checking if port $PORT is in use..."

if sudo netstat -tuln | grep -q ":$PORT"; then
  echo "Port $PORT is in use. Stopping the process..."

  # Extract PID using `lsof` instead of `netstat`
  PID=$(sudo lsof -t -i :$PORT)

  if [ -n "$PID" ]; then
    sudo kill -9 "$PID"
    echo "Stopped process $PID using port $PORT."
  else
    echo "Failed to identify the process using port $PORT."
    exit 1
  fi
else
  echo "Port $PORT is not in use. Proceeding with installation..."
fi
