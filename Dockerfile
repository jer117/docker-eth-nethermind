# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0-noble AS build

# renovate: datasource=github-releases depName=nethermindEth/nethermind
ARG VERSION=1.33.1

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    libsnappy-dev \
    build-essential

# Clone and build Nethermind
RUN git clone --branch=${VERSION} https://github.com/NethermindEth/nethermind.git \
    && cd nethermind/src/Nethermind \
    && dotnet publish Nethermind.Runner -c Release -o /publish --sc false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0-noble

# Set the working directory
WORKDIR /nethermind

# Copy the build output from the build stage
COPY --from=build /publish .

# Define the entrypoint
ENTRYPOINT ["./nethermind"]