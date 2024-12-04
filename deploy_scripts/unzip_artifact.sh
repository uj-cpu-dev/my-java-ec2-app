#!/bin/bash

echo "Unzipping artifact..."

# Define paths
ARTIFACT_ZIP="/home/ec2-user/app/*.zip"
TARGET_DIR="/home/ec2-user/app/"

# Ensure the target directory exists
mkdir -p "$TARGET_DIR"

# Extract the contents
if [ -f "$ARTIFACT_ZIP" ]; then
    echo "Extracting $ARTIFACT_ZIP to $TARGET_DIR..."
    unzip -o "$ARTIFACT_ZIP" -d "$TARGET_DIR"
    if [ $? -eq 0 ]; then
        echo "Extraction completed successfully!"
    else
        echo "Failed to extract $ARTIFACT_ZIP."
        exit 1
    fi
else
    echo "File not found: $ARTIFACT_ZIP"
    exit 1
fi
