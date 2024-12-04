#!/bin/bash
PORT=8080


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

# Make all deploy scripts executable
echo "Setting permissions for all deploy scripts..."
chmod +x /home/ec2-user/app/deploy_scripts/*.sh
chmod +x deploy_scripts/*.sh

chmod 755 /home/ec2-user/app/deploy_scripts/check_java_version.sh
chmod 755 /home/ec2-user/app/deploy_scripts/stop.sh
chmod 755 /home/ec2-user/app/deploy_scripts/start.sh
chmod 755 /home/ec2-user/app/deploy_scripts/validate.sh

echo "All scripts are now executable."
