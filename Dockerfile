#### Stage 1: Build the application
FROM openjdk:11 as build

# Set the current working directory inside the image
WORKDIR /app

# Copy project folders
COPY pre-registration pre-registration
COPY .github .github
COPY .git .git


# Install Maven
RUN apt-get update && apt-get install -y maven
# RUN mvn -version

WORKDIR /app/pre-registration

RUN ls -la

# Run mvn clean install -Dgpg.skip=true
# Run mvn clean install -Dgpg.skip=true -DskipTests=true

RUN mvn clean install -DskipTests=true -Dmaven.javadoc.skip=true -Dgpg.skip=true

# Run java -Dspring.profiles.active=<profile> -Dspring.cloud.config.uri=<config-url> -Dspring.cloud.config.label=<config-label> -jar <jar-name>.jar
# Run java -Dspring.profiles.active=<profile> -jar <jar-name>.jar

WORKDIR /app/pre-registration/pre-registration-application-service

RUN java -Dspring.profiles.active=default -jar target/pre-registration-application-service-1.2.0.1.jar

