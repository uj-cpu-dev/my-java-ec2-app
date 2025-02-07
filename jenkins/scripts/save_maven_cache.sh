#!/bin/bash
echo "Saving Maven cache..."
mkdir -p ${MAVEN_CACHE_DIR}
cp -r .m2/repository/* ${MAVEN_CACHE_DIR}/