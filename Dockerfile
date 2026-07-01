# Multi-stage Dockerfile for building and running the ace-bank-lite webapp
# - Build stage uses Maven + JDK 21 to create the WAR
# - Runtime stage installs Tomcat 11 and deploys the generated WAR

FROM maven:3.9.5-eclipse-temurin-21 AS build
WORKDIR /app

# copy only the files needed for build first to leverage Docker cache
COPY pom.xml ./
COPY src ./src

# package the application (skip tests in CI/local build to speed up)
RUN mvn -B -DskipTests package

FROM eclipse-temurin:21-jre

ENV CATALINA_HOME=/opt/tomcat
ENV PATH=${CATALINA_HOME}/bin:${PATH}

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl tar ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Tomcat 11 (specific version pinned)
ARG TOMCAT_VERSION=11.0.21
RUN curl -fsSL https://archive.apache.org/dist/tomcat/tomcat-11/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -o /tmp/tomcat.tar.gz \
    && mkdir -p /opt \
    && tar -xzf /tmp/tomcat.tar.gz -C /opt \
    && mv /opt/apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} \
    && rm /tmp/tomcat.tar.gz

# remove default webapps to avoid unnecessary examples being served
RUN rm -rf ${CATALINA_HOME}/webapps/*

# Copy built WAR from the build stage.
# Deployed as ROOT.war so the app is served at "/" (e.g. https://<host>/Login.jsp)
# instead of under the "/ace-bank-lite" context path, which made the root URL 404.
COPY --from=build /app/target/*.war ${CATALINA_HOME}/webapps/ROOT.war

EXPOSE 8080

# Use catalina.sh from Tomcat to run the server in foreground
CMD ["catalina.sh", "run"]

