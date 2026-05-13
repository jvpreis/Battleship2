# ===== BUILD STAGE =====
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copiar ficheiros Maven
COPY pom.xml .

# Download dependências (melhora cache)
RUN mvn dependency:go-offline

# Copiar código fonte
COPY src ./src

# Build da aplicação
RUN mvn clean package -DskipTests

# ===== RUNTIME STAGE =====
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copiar o JAR gerado
COPY --from=build /app/target/*.jar app.jar

# Executar aplicação Java consola
ENTRYPOINT ["java", "-jar", "app.jar"]
