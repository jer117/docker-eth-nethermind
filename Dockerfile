# Packages the official Nethermind linux-arm64 release into an image.
#
# The download stage runs on the build machine's own platform, so building the arm64
# image on an x86 CI runner needs no emulation. BuildKit checks the release zip against
# SHA256 below and fails the build on mismatch.
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/runtime-deps:10.0-noble AS download

# renovate: datasource=github-releases depName=NethermindEth/nethermind
ARG VERSION=2.2.2
# Short commit hash in the release asset name, and the asset's sha256 as shown on the release page:
# https://github.com/NethermindEth/nethermind/releases/tag/2.2.2
ARG COMMIT=be201120
ARG SHA256=e7fe1dc3a104ef4ba4656a803802598d60c33490f6104cea53900d5a8bcde496

RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/*

ADD --checksum=sha256:${SHA256} \
    https://github.com/NethermindEth/nethermind/releases/download/${VERSION}/nethermind-${VERSION}-${COMMIT}-linux-arm64.zip \
    /tmp/nethermind.zip

RUN mkdir /nethermind && \
    unzip -q /tmp/nethermind.zip -d /nethermind && \
    chmod +x /nethermind/nethermind

# The release is a self-contained .NET 10 single-file build, so the image only needs the
# native dependencies, not a .NET runtime. Its bundled RocksDB needs glibc >= 2.35.
FROM mcr.microsoft.com/dotnet/runtime-deps:10.0-noble

WORKDIR /nethermind

COPY --from=download /nethermind .

ENTRYPOINT ["./nethermind"]
