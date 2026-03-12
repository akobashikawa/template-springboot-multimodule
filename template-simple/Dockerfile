# --- STAGE 1: Build ---
FROM maven:3.9-eclipse-temurin-21-alpine AS build
WORKDIR /app

# Copiar el pom y descargar dependencias (para aprovechar el cache de Docker)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar el código y compilar
COPY src ./src
# Aquí Maven inyecta la versión @project.version@ en el yml
RUN mvn clean package -DskipTests

# --- STAGE 2: Run ---
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Crear usuario no-root por seguridad
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copiar el JAR desde la etapa de build
# El wildcard * asegura que tome el JAR sin importar el nombre exacto
COPY --from=build /app/target/*.jar app.jar

# Crear volumen para configuración externa
VOLUME /app/config

# Exponer el puerto estándar de Spring Boot
EXPOSE 8080

# Ejecutar la aplicación
# Usamos -Dspring.config.location para priorizar la carpeta /config externa
ENTRYPOINT ["java", "-Dspring.config.location=optional:classpath:/,optional:file:/app/config/", "-jar", "app.jar"]