# Base image
FROM sapmachine as build

# Install necessary packages
RUN apt-get update && apt-get install -y curl git unzip zip

# Install SDKMAN and tools using SDKMAN
RUN curl -s "https://get.sdkman.io" | bash && \
    bash -c "source \"$HOME/.sdkman/bin/sdkman-init.sh\" && sdk install springboot && sdk install maven"

# Add SDKMAN's spring and maven to PATH
ENV PATH="$PATH:/root/.sdkman/candidates/springboot/current/bin:/root/.sdkman/candidates/maven/current/bin"

# Copy the entrypoint script to the container
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /docker-entrypoint.sh

# Set the entrypoint script as the entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
