#!/bin/bash

# Ensure the CodeDeploy variables are available (e.g., APP_NAME and VERSION)
if [[ -z "$APP_NAME" || -z "$VERSION" ]]; then
  echo "APP_NAME or VERSION not set. Please ensure these values are passed."
  exit 1
fi

# Check the Java version
echo "Checking Java version..."
java_version=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')
echo "Java version: $java_version"

# Ensure the Java version is 17 or above (for Java 17 specifically)
if [[ "$java_version" < "17" ]]; then
  echo "Java version is less than 17, please install Java 17 or above."
  exit 1  # Exit if Java version is not correct
else
  echo "Java version is $java_version. Proceeding with deployment..."
fi

# Extract application files from the ZIP archive
echo "Extracting application files..."
unzip -o /home/ec2-user/app/$APP_NAME-$VERSION.zip -d /home/ec2-user/app/  # Extract the ZIP file

# Set execute permissions on the deploy scripts
chmod +x /home/ec2-user/app/deploy_scripts/*.sh  # Make deploy scripts executable

# Set execute permissions on the .jar files
chmod 755 /home/ec2-user/app/target/*.jar  # Add execute permission to the JAR

echo "Files extracted and permissions set."