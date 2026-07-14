# ---- Build stage: compile the WAR with Maven + JDK 21 ----
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -q -B -DskipTests package

# ---- Runtime stage: Tomcat 11 on JDK 21 ----
FROM tomcat:11.0-jdk21-temurin
# Serve the app at the root context (https://host:8080/) instead of /acebank
RUN rm -rf ${CATALINA_HOME}/webapps/*
COPY --from=build /app/target/acebank.war ${CATALINA_HOME}/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
