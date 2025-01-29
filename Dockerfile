FROM public.ecr.aws/lambda/java:17.2024.11.22.15

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "/app/app.jar"]