FROM debian:bullseye-slim

WORKDIR /app

RUN apt-get update && apt-get install -y openjdk-17-jdk && rm -rf /var/lib/apt/lists/*

COPY target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "/app/app.jar"]