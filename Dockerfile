# --- STAGE 1: Build the Spring Boot application with Gradle ---
FROM gradle:8.5-jdk17-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy Gradle wrapper and build files first to leverage Docker cache
COPY gradlew .
COPY gradle gradle
COPY build.gradle.kts .
COPY settings.gradle.kts .

# Download dependencies (this layer will be cached if build files don't change)
RUN gradle dependencies --no-daemon

# Copy the source code
COPY src ./src

# Build the application
# --no-daemon: Prevents Gradle daemon from running (not needed in Docker builds)
# -x test: Skips running tests to speed up the build
RUN gradle bootJar --no-daemon -x test

# --- STAGE 2: Create the final lean runtime image ---
FROM eclipse-temurin:17-jre-alpine

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the 'build' stage
# Gradle puts the JAR in build/libs/ directory
COPY --from=build /app/build/libs/*.jar app.jar

# Expose the port that your Spring Boot application runs on
EXPOSE 8080

# Define the command to run your Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
