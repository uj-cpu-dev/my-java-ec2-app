# Accept Java version as a build argument with a default value
ARG JAVA_VERSION=17

# Use the Java version to build the base image
FROM eclipse-temurin:${JAVA_VERSION}-jdk

# Set the working directory
WORKDIR /app

# Copy the application JAR file
COPY target/*.jar app.jar

# Command to run the application
CMD ["java", "-jar", "app.jar"]