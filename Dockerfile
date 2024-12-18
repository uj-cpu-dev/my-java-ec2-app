# Accept Java version as a build argument with a default value
ARG JAVA_VERSION=17
FROM eclipse-temurin:${JAVA_VERSION}-jre-slim

# Set the working directory
WORKDIR /app

# Copy the application JAR into the container
# Assuming the JAR name is provided as an argument or standardized
ARG APP_JAR=*.jar
COPY target/${APP_JAR} app.jar

# Expose the application's port
EXPOSE 8080

# Define the entry point for running the application
ENTRYPOINT ["java", "-jar", "app.jar"]
