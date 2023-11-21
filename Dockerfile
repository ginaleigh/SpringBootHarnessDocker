#Base image
FROM sapmachine as build

# Install necessary packages
RUN apt-get update && apt-get install -y curl git unzip zip

# Install SDKMAN and Spring Boot CLI using SDKMAN
RUN curl -s "https://get.sdkman.io" | bash
RUN /bin/bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install springboot 3.1.5"

# Project files in the build context, copy them into the image
COPY . /SpringBootHarnessDocker
WORKDIR /SpringBootHarnessDocker

# Find jar in project
RUN find . -name '*.jar' -print

# Clone Spring repo
RUN git clone https://github.com/spring-io/initializr /initializr

#Base and build of final image
FROM sapmachine
COPY --from=build /SpringBootHarnessDocker/target/SpringBootHarnessDocker-0.0.1-SNAPSHOT.jar /app/spring-boot-application.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/spring-boot-application.jar"]


