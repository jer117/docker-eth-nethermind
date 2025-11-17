# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0-noble AS build

# renovate: datasource=github-releases depName=nethermindEth/nethermind
ARG VERSION=1.35.2

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    libsnappy-dev \
    build-essential \
    unzip

# Download nethermind binary
ADD https://github.com/NethermindEth/nethermind/releases/download/${VERSION}/nethermind-${VERSION}-faa9b9e6-linux-arm64.zip ./

# Extract nethermind binary
RUN unzip "nethermind-${VERSION}-faa9b9e6-linux-arm64.zip" && \
    chmod +x nethermind && \
    rm -f "nethermind-${VERSION}-faa9b9e6-linux-arm64.zip"

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0-noble

# Set the working directory
WORKDIR /nethermind

# Copy the build output from the build stage
COPY --from=build /app .

# Define the entrypoint
ENTRYPOINT ["./nethermind"]