#!/bin/bash
echo "Checking for Maven installation..."

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "Maven not found. Installing Maven..."
    # Install Maven (for Ubuntu/Debian)
    sudo apt update
    sudo apt install maven -y
fi

echo "Running tests..."
mvn test