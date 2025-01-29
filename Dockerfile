FROM amazoncorretto:17.0.7-alpine

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "/app/app.jar"]