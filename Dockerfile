# Use the ARM64 Amazon Corretto 17 base image
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17-arm64 as builder

# Install Maven
RUN yum install -y maven

# Set the working directory
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Download dependencies and build the application
RUN mvn clean install -DskipTests

# Run tests
RUN mvn test

# Use a minimal runtime image
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17-arm64

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "/app/app.jar"]