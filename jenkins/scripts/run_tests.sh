#!/bin/bash
echo "Checking for Maven installation..."

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "Maven not found. Installing Maven..."
    # Install Maven using yum
    sudo yum install maven -y
fi

echo "Running tests..."
# Run tests and periodically write to the log file
mvn test | while IFS= read -r line; do
    echo "$line"
    sleep 1 # Add a small delay to ensure log output
done