#!/bin/bash
# Example check for Java 17 (Amazon Corretto)
echo "Checking Java version..."
java_version=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')

if [[ "$java_version" == "17"* ]]; then
  echo "Java 17 is installed: $java_version"
else
  echo "Java 17 is not installed. Please install Java 17 Amazon Corretto." >&2
  exit 1
fi
