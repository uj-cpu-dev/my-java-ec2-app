FROM public.ecr.aws/amazoncorretto/amazoncorretto:17-arm64

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "/app/app.jar"]