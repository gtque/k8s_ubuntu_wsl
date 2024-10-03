FROM maven:3-eclipse-temurin-17 as prepare
# Either supply credentials or substitute the entire settings file prior to running `docker build`
# for gradle, mimic properties file by adding properties as environment variables following the pattern: ORG_GRADLE_PROJECT_<propertyname>=value
WORKDIR /project
ARG MODULE="server"
ARG DOCLEAN=""
ARG SIGNING_KEY_ID
ARG SIGNING_KEY_PASSWORD
ARG PUBLIC_KEY_ID
ENV ORG_GRADLE_PROJECT_signing.keyId="${SIGNING_KEY_ID}"
ENV ORG_GRADLE_PROJECT_signing.password="${SIGNING_KEY_PASSWORD}"
ENV ORG_GRADLE_PROJECT_signing.secretKeyRingFile="./gradle/secring.gpg"
ENV ORG_GRADLE_PROJECT_public.key.id="${PUBLIC_KEY_ID}"
#COPY gradlew *.gradle gradle.* ./
#COPY gradle ./gradle
#COPY .gradle ./.gradle
#RUN ./gradlew --version
COPY . .

FROM prepare as build
#RUN ./gradlew $DOCLEAN ${MODULE}:copyAllDependencies --no-daemon
#RUN ./gradlew ${MODULE}:build --no-daemon

FROM build as package
#RUN ./gradlew ${MODULE}:jar --no-daemon

FROM package as publish
ARG REPO='snapshots'
ARG NEXUS_BASE_REPO_URL='https://nexus.onedatascan.io/nexus/content/repositories'
ARG ARTIFACT_ID='*'
ARG POM_VERSION='*'
ARG MODULE_VERSION=${POM_VERSION}

FROM eclipse-temurin:17-jre as image
ARG MODULE="splerk"
ARG JAVA_OPTS=""
ARG BUILD_VERSION=0.1.17.0-SNAPSHOT
ENV _JAVA_OPTS=${JAVA_OPTS}
ENV _PORTS=8080
RUN groupadd appgroup && \
    useradd -G appgroup appuser
COPY modules/${MODULE}/build/libs/*.jar /opt/
RUN mv /opt/${MODULE}-${BUILD_VERSION}.jar /opt/app.jar
RUN chown appuser:appgroup /opt/*.jar
WORKDIR /opt
RUN ls -al
USER appuser
EXPOSE ${_PORTS}
ENTRYPOINT exec java -cp '/opt/*' $_JAVA_OPTS -jar /opt/app.jar
