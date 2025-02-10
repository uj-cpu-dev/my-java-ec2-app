# Use Amazon Linux as the builder base image to install Maven
FROM public.ecr.aws/amazonlinux/amazonlinux:2023 as builder

# Install required dependencies
RUN yum install -y maven java-17-amazon-corretto

# Set the working directory
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Download dependencies and build the application
RUN mvn clean install -DskipTests

# Use the ARM64 Amazon Corretto 17 base image for runtime
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17-arm64

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "/app/app.jar"]