FROM mcr.microsoft.com/dotnet/sdk:8.0-noble AS build

# renovate: datasource=github-releases depName=nethermindEth/nethermind
ARG BUILD_TARGET_VERSION=1.28.0

# set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    libsnappy-dev \
    build-essential

# Fork repo and build
RUN git clone --branch=${BUILD_TARGET_VERSION} https://github.com/NethermindEth/nethermind.git \
    && cd nethermind/src/Nethermind \
    && dotnet publish Nethermind.Runner -c Release -o /publish --sc false

# Create a new stage with a smaller runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0-noble

# Set the working directory
WORKDIR /nethermind

# Copy the build output from the build stage
COPY --from=build /publish .

# Define the entrypoint
ENTRYPOINT ["./nethermind"]
