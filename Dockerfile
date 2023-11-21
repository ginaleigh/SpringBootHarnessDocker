FROM sapmachine as build
RUN apt-get update && apt-get install -y curl git unzip zip
RUN curl -s "https://get.sdkman.io" | bash
RUN /bin/bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install springboot"
RUN git clone https://github.com/spring-io/initializr /initializr
WORKDIR /initializr
CMD ["./mvnw", "spring-boot:run"]
RUN ./mvnw package


FROM sapmachine
COPY --from=build /initializr/target/SpringBootHarnessDocker-0.0.1-SNAPSHOT.jar /app/spring-boot-application.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/spring-boot-application.jar"]

#Base image, install tools, initialize SDKman & install springboot, clone initializr project from
#github, run SB project(in container), build app using maven - second stage build from JAR file, expose 8080 execute JAR file to run
#spring boot application