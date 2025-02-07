#!/bin/bash
echo "Restoring Maven cache..."
if [ -d "${MAVEN_CACHE_DIR}" ]; then
    echo "Maven cache found. Restoring..."
    cp -r ${MAVEN_CACHE_DIR} .
else
    echo "No Maven cache found. Skipping..."
fi