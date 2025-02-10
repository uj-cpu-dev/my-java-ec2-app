#!/bin/bash
set -e  # Exit on error

echo "Saving Maven cache..."

# Ensure the .m2/repository directory exists and is not empty
if [ -d ".m2/repository" ] && [ -n "$(ls -A .m2/repository)" ]; then
    echo "Maven repository found. Saving cache..."
    mkdir -p "${MAVEN_CACHE_DIR}"
    cp -r .m2/repository/* "${MAVEN_CACHE_DIR}/"
    echo "Maven cache saved to ${MAVEN_CACHE_DIR}."
else
    echo "Warning: .m2/repository directory is missing or empty. No cache to save."
    exit 0  # Exit gracefully without failing the pipeline
fi