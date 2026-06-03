# Stage 1: Build the application using Maven
FROM maven:3.8.5-openjdk-8 AS build
WORKDIR /app

# Copy the source code and configuration files
COPY pom.xml .
COPY src ./src
COPY WebContent ./WebContent

# Package the application into a .war file
RUN mvn clean package -DskipTests

# Stage 2: Deploy the .war file to Apache Tomcat
FROM tomcat:9.0-jdk8-openjdk-slim

# Remove default Tomcat webapps to save space and avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the compiled .war file from the build stage into Tomcat's deployment folder
# Note: Renaming it to ROOT.war makes it accessible at the root URL (/) instead of (/CoverageWebApplication)
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Inform Railway of the port Tomcat listens on
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
