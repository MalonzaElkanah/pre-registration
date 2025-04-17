#### Stage 1: Build the application
FROM openjdk:11 as build

WORKDIR /app

# Copy only what you need for the build
# Will copy the .git folder into the image — though better left out for security and size - It required by the maven pipeline.
COPY pre-registration /app/pre-registration
COPY .git /app/.git
COPY .github /app/.github


# Install Maven
RUN apt-get update && apt-get install -y maven

WORKDIR /app/pre-registration

# Prepare dependencies (cache-friendly)
RUN mvn dependency:go-offline -B

# Build the application
RUN mvn clean install -DskipTests=true -Dmaven.javadoc.skip=true -Dgpg.skip=true

#### Stage 2: Run the application
FROM openjdk:11-jre

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/pre-registration/pre-registration-application-service/target/pre-registration-application-service-1.2.0.1.jar app.jar

EXPOSE 9090

CMD ["java", "-Dspring.profiles.active=default", "-Dspring.cloud.config.uri=http://config-server:8888", "-jar", "app.jar"]
